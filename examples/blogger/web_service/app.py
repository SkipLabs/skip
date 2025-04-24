from flask import Flask, json, request, session, redirect
import secrets
import psycopg2
import requests
import os


def get_db():
    conn = psycopg2.connect(
        host="blogger_db",
        user="postgres",
        password="change_me",
    )

    return conn


app = Flask(__name__)

app.secret_key = b"53cr37_changeme"


SKIP_WRITE_URL = (
    "http://blogger_skip_leader:8081/v1"
    if "DISTRIBUTED_MODE" in os.environ
    else "http://blogger_reactive_service:8081/v1"
)
SKIP_READ_URL = (
    "http://blogger_skip_followers:8081/v1"
    if "DISTRIBUTED_MODE" in os.environ
    else "http://blogger_reactive_service:8081/v1"
)


@app.before_request
def ensure_session_cookie():
    if "session_id" not in session:
        session["session_id"] = secrets.token_urlsafe(32)


def format_post(post):
    return {
        "id": post[0],
        "title": post[1],
        "content": post[2],
        "status": post[4],
        "published_at": post[5],
        "author": {
            "name": post[3],  # username from users table
            "email": post[6]  # email from users table
        }
    }


@app.post("/login")
def login():
    with get_db() as db:
        with db.cursor() as cur:
            res = cur.execute(
                "SELECT id, username, email FROM users WHERE LOWER(email) = LOWER(%s)",
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

    session["user_id"] = user_session["user_id"]

    return user_session


@app.post("/logout")
def logout():
    del session["user_id"]
    return "ok", 200


@app.get("/posts")
def posts_index():
    if "text/event-stream" in request.accept_mimetypes:
        resp = requests.post(
            f"{SKIP_READ_URL}/streams/posts",
            json={
                "limit": 10,
            },
        )
        uuid = resp.text
        return redirect(f"/streams/{uuid}", code=307)
    else:
        resp = requests.post(
            f"{SKIP_READ_URL}/snapshot/posts",
            json={
                "limit": 10,
            },
        )
        posts = resp.json()[0][1]
        # Format each post to match the expected structure
        formatted_posts = [format_post(post) for post in posts]
        return formatted_posts


@app.post("/posts")
def create_post():
    if "user_id" not in session:
        return "Unauthorized", 401
    params = request.json
    title = params["title"]
    content = params["content"]
    status = params.get("status", "draft")
    author_id = session["user_id"]

    with get_db() as db:
        with db.cursor() as cur:
            cur.execute(
                "INSERT INTO posts(title, content, status, author_id) VALUES(%s, %s, %s, %s)",
                (title, content, status, author_id),
            )
            db.commit()

    return "ok", 200


@app.delete("/posts/<int:post_id>")
def delete_post(post_id):
    with get_db() as db:
        with db.cursor() as cur:
            cur.execute("DELETE FROM posts WHERE id = %s", (post_id,))
            db.commit()
    return "ok", 200


@app.put("/posts/<int:post_id>")
def update_post(post_id):
    params = request.json
    title = params["title"]
    content = params["content"]
    status = params.get("status")

    with get_db() as db:
        with db.cursor() as cur:
            cur.execute(
                "UPDATE posts SET title = %s, content = %s, status = %s WHERE id = %s",
                (title, content, status, post_id),
            )
            db.commit()

    return "ok", 200


@app.get("/healthcheck")
def healthcheck():
    return "ok", 200


@app.get("/session")
def get_session():
    if "user_id" not in session:
        return "{}", 200
    with get_db() as db:
        with db.cursor() as cur:
            res = cur.execute(
                "SELECT id, username, email FROM users WHERE id = %s",
                (session["user_id"],),
            )
            if cur.rowcount < 1:
                return "{}", 200
            user = cur.fetchone()
            return json.dumps({
                "user_id": user[0],
                "name": user[1],
                "email": user[2],
            }), 200
