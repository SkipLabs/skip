from flask import Flask, g, json, request
import sqlite3
import requests

REACTIVE_SERVICE_URL = 'http://localhost:8080/v1'

DATABASE = 'database.db'


def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect(DATABASE)
    return db

def init_db():
    with app.app_context():
        db = get_db()
        with app.open_resource('schema.sql', mode='r') as f:
            db.cursor().executescript(f.read())
        db.commit()


app = Flask(__name__)

# Required for local testing.
from flask_cors import CORS
CORS(app, expose_headers=["Skip-Reactive-Response-Token"])

@app.teardown_appcontext
def close_connection(exception):
    db = getattr(g, '_database', None)
    if db is not None:
        db.close()

def format_post(post):
    return {
        "id": post[0],
        "title": post[1],
        "url": post[2],
        "body": post[3],
        "author": post[4],
        "upvotes": post[5]
    }

@app.get("/")
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


    headers = {}
    # If the client didn't set the `Skip-Reactive-Auth` header, they
    # are not interested in reactive updates for this query, so we
    # just respond with the current values.
    if 'Skip-Reactive-Auth' in request.headers:
        headers['Skip-Reactive-Auth'] = request.headers['Skip-Reactive-Auth']
    # Get the initial data, which will be returned to the client
    # along with a reactive request token for subscribing to
    # further updates.
    resp = requests.get(
        REACTIVE_SERVICE_URL + f'/posts',
        params = {
            'limit': 10
        },
        headers = headers
    )

    # The reactive service returns an array of (id, values) where
    # values is an array of objects. Here, as in most cases, the
    # values consists of a single object (which already contains the
    # `id` key).
    posts = resp.json()[0][1]

    resp_headers = {}
    if 'Skip-Reactive-Auth' in request.headers:
        resp_headers['Skip-Reactive-Response-Token'] = resp.headers['Skip-Reactive-Response-Token']

    return posts, resp_headers

@app.post("/posts")
def create_post():
    params = request.json
    title = params['title']
    url = params['url']
    body = params['body']

    db = get_db()
    cur = db.cursor()
    cur.execute(f"INSERT INTO posts(title, url, body) VALUES('{title}', '{url}', '{body}')")
    post_id = cur.lastrowid
    db.commit()

    # Write into the reactive input collection.
    requests.post(
        REACTIVE_SERVICE_URL + f'/posts',
        params = { **params, 'id': post_id }
    )

    return "ok", 200

@app.get("/posts/<int:post_id>")
def get_post(post_id):
    db = get_db()

    cur = db.execute(f"""SELECT id, title, url, body,
    (SELECT name FROM users WHERE id=posts.author_id LIMIT 1) as author,
    (SELECT COUNT(id) FROM upvotes WHERE post_id=posts.id) as upvotes
    FROM posts WHERE id={post_id}""")
    res = format_post(cur.fetchone())
    cur.close()

    return json.jsonify(res)

@app.post("/posts/<int:post_id>/upvotes")
def upvote_post(post_id):
    # TODO
    # user_id = get_current_user().id
    user_id = 0

    db = get_db()
    cur = db.cursor()
    cur.execute(f"INSERT INTO upvotes(post_id, user_id) VALUES({post_id}, {user_id})")
    upvote_id = cur.lastrowid
    db.commit()

    # Write into the reactive input collection.
    requests.put(
        REACTIVE_SERVICE_URL + f'/upvotes/{upvote_id}',
        headers = { 'Content-Type': 'application/json' },
        data = json.dumps([{
            'id': upvote_id,
            'post_id': post_id,
            'user_id': user_id,
        }])
    )

    return "ok", 200
