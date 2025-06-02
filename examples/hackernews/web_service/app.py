from flask import Flask, json, request, session, redirect
import secrets
import psycopg2
import requests
import random
import time
import os

SKIP_CONTROL_URL = os.environ.get("SKIP_CONTROL_URL")

PG_HOST = os.environ.get("PG_HOST", "db")
PG_PORT = int(os.environ.get("PG_PORT", 5432))
PG_DATABASE = os.environ.get("PG_DATABASE", "postgres")
PG_USER = os.environ.get("PG_USER", "postgres")
PG_PASSWORD = os.environ.get("PG_PASSWORD", "change_me")


def get_db():
    conn = psycopg2.connect(
        host=PG_HOST,
        port=PG_PORT,
        user=PG_USER,
        password=PG_PASSWORD,
        dbname=PG_DATABASE,
    )
    return conn


app = Flask(__name__)
app.secret_key = b"53cr37_changeme"


@app.before_request
def ensure_session_cookie():
    if "session_id" not in session:
        session["session_id"] = secrets.token_urlsafe(32)


def format_post(post):
    return {
        "id": post[0],
        "title": post[1],
        "url": post[2],
        "body": post[3],
        "author": post[4],
        "upvotes": post[5],
    }


@app.post("/login")
def login():
    with get_db() as db:
        with db.cursor() as cur:
            res = cur.execute(
                "SELECT id, name, email FROM users WHERE LOWER(email) = LOWER(%s)",
                (request.json["email"],),
            )
            if cur.rowcount < 1:
                return "Unauthorized", 401
            user = cur.fetchone()

    user_session = {
        "user_id": user[0],
        "name": user[1],
        "email": user[2],
    }

    # Store the user_id in the Flask session to avoid a round-trip when upvoting.
    session["user_id"] = user_session["user_id"]

    # TODO: Error handling.
    requests.patch(
        f"{SKIP_CONTROL_URL}/inputs/sessions",
        json=[[session["session_id"], [user_session]]],
    )

    return user_session


@app.post("/logout")
def logout():
    requests.patch(
        f"{SKIP_CONTROL_URL}/inputs/sessions",
        json=[[session["session_id"], []]],
    )

    del session["user_id"]

    return "ok", 200


@app.get("/session")
def user_session():
    if "text/event-stream" in request.accept_mimetypes:
        resp = requests.post(
            f"{SKIP_CONTROL_URL}/streams/sessions",
            json={
                "session_id": session["session_id"],
            },
        )
        uuid = resp.text

        return redirect(f"/streams/{uuid}", code=307)

    else:
        resp = requests.post(
            f"{SKIP_CONTROL_URL}/snapshot/sessions",
            json={
                "session_id": session["session_id"],
            },
        )

        return resp.json()[0][1]


@app.get("/posts")
def posts_index():
    # # Non-reactive version:
    # db = get_db()
    # cur = db.execute(
    #     """SELECT id, title, url, body,
    #     (SELECT name FROM users WHERE id=posts.author_id LIMIT 1) as author,
    #     (SELECT COUNT(id) FROM upvotes WHERE post_id=posts.id) as upvotes
    #     FROM posts ORDER BY upvotes DESC"""
    # )
    # res = [
    #     format_post(post)
    #     for post in cur.fetchall()
    # ]
    # cur.close()

    # return json.jsonify(res)

    if "text/event-stream" in request.accept_mimetypes:
        resp = requests.post(
            f"{SKIP_CONTROL_URL}/streams/posts",
            json={
                "limit": 10,
                "session_id": session["session_id"],
            },
            # headers={
            #     "Authorization": session['session_id'],
            # },
        )
        uuid = resp.text
        return redirect(f"/streams/{uuid}", code=307)

    else:
        resp = requests.post(
            f"{SKIP_CONTROL_URL}/snapshot/posts",
            json={
                "limit": 10,
                "session_id": session["session_id"],
            },
        )

        # The reactive service returns an array of (id, values) where
        # values is an array of objects. Here, as in many cases, the
        # values consists of a single object (which already contains
        # the `id` key).
        return resp.json()[0][1]


@app.post("/posts")
def create_post():
    if "user_id" not in session:
        return "Unauthorized", 401
    params = request.json
    title = params["title"]
    url = params["url"]
    body = params["body"]
    author_id = session["user_id"]

    with get_db() as db:
        with db.cursor() as cur:
            cur.execute(
                "INSERT INTO posts(title, url, body, author_id) VALUES(%s, %s, %s, %s)",
                (title, url, body, author_id),
            )
            db.commit()

    return "ok", 200


@app.delete("/posts/<int:post_id>")
def delete_post(post_id):
    with get_db() as db:
        with db.cursor() as cur:
            # Get all upvote IDs related to the post.
            cur.execute("SELECT id FROM upvotes WHERE post_id = %s", (post_id,))
            upvote_ids = [row[0] for row in cur.fetchall()]

            # Delete upvotes related to the post.
            cur.execute("DELETE FROM upvotes WHERE post_id = %s", (post_id,))
            # Delete the post.
            cur.execute("DELETE FROM posts WHERE id = %s", (post_id,))
            db.commit()
    return "ok", 200


@app.put("/posts/<int:post_id>")
def update_post(post_id):
    params = request.json
    title = params["title"]
    url = params["url"]
    body = params["body"]

    with get_db() as db:
        with db.cursor() as cur:
            cur.execute(
                "UPDATE posts SET title = %s, url = %s, body = %s WHERE id = %s",
                (title, url, body, post_id),
            )
            db.commit()

    return "ok", 200


@app.put("/posts/<int:post_id>/upvotes")
def upvote_post(post_id):
    if "user_id" not in session:
        return "Unauthorized", 401

    user_id = session["user_id"]
    with get_db() as db:
        with db.cursor() as cur:
            cur.execute(
                "SELECT * FROM upvotes WHERE post_id = %s AND user_id = %s",
                (post_id, user_id),
            )
            if cur.rowcount > 0:
                return "ok", 200
            cur.execute(
                "INSERT INTO upvotes(post_id, user_id) VALUES(%s, %s)",
                (post_id, user_id),
            )
            db.commit()

    return "ok", 200


@app.delete("/posts/<int:post_id>/upvotes")
def deupvote_post(post_id):
    if "user_id" not in session:
        return "Unauthorized", 401

    with get_db() as db:
        with db.cursor() as cur:
            cur.execute(
                "DELETE FROM upvotes WHERE post_id = %s AND user_id = %s",
                (post_id, session["user_id"]),
            )
            db.commit()

    return "ok", 200


@app.get("/healthcheck")
def healthcheck():
    return "ok", 200


@app.post("/simulate_activity")
def simulate_activity():
    with get_db() as db:
        with db.cursor() as cur:
            cur.execute("SELECT id FROM posts")
            post_ids = [x[0] for x in cur.fetchall()]

            for i in range(1000):
                post_id = random.choice(post_ids)
                for j in range(random.randrange(20)):
                    user_id = random.randint(0, 1000)
                    cur.execute(
                        "INSERT INTO upvotes(user_id, post_id) VALUES (%s, %s)",
                        (user_id, post_id),
                    )
                    db.commit()
                time.sleep(1)

    return "ok", 200
