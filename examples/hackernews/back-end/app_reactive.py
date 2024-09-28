from flask import Flask, g, json, request
import sqlite3
import requests

REACTIVE_SERVICE_URL = 'http://localhost:3587/v1'

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
CORS(app)

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
    public_key = request.headers['X-Reactive-Auth']

    if public_key:
        # Create reactive request for the reactive resource `posts`,
        # limited to 10 results.
        reactive_request_id = requests.post(
            REACTIVE_SERVICE_URL + f'/reactive/posts',
            params = {
                'limit': 10
            },
            headers = {
                'X-Reactive-Auth': public_key,
            }
        ).content

        # Get the initial data, which will be returned to the client
        # along with a reactive request token for subscribing to
        # further updates.
        diff = requests.get(REACTIVE_SERVICE_URL +
                            f'/collections/{reactive_request_id}/diff/0').json()

        tick = diff['tick']
        return diff['data'], { 'X-Reactive-Request-Id': f'{reactive_request_id}:{tick}' }

    else:
        # If the client didn't set the `X-Reactive-Auth` header, they
        # are not interested in reactive updates for this query, so we
        # just respond with the current values.
        posts = requests.get(f'/collections/{reactive_request_id}').json()

    return json.jsonify(res)

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
    user_id = get_current_user().id

    db = get_db()
    cur = db.cursor()
    cur.execute(f"INSERT INTO upvotes(post_id, user_id) VALUES({post_id}, {user_id})")
    upvote_id = cur.lastrowid
    db.commit()

    # Write into the reactive input collection.
    requests.post(
        REACTIVE_SERVICE_URL + f'/upvotes',
        params = {
            'id': upvote_id,
            'post_id': post_id,
            'user_id': user_id,
        }
    )

    return "ok", 200
