from flask import Flask, g, json, request
import sqlite3

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
    db = get_db()
    cur = db.execute(
        """SELECT id, title, url, body,
        (SELECT name FROM users WHERE id=posts.author_id LIMIT 1) as author,
        (SELECT COUNT(id) FROM upvotes WHERE post_id=posts.id) as upvotes
        FROM posts ORDER BY upvotes DESC"""
    )
    res = [
        format_post(post)
        for post in cur.fetchall()
    ]
    cur.close()

    return json.jsonify(res)

@app.post("/posts")
def create_post():
    params = request.json
    title = params['title']
    url = params['url']
    body = params['body']

    db = get_db()
    db.execute(f"INSERT INTO posts(title, url, body) VALUES('{title}', '{url}', '{body}')")
    db.commit()

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
    db = get_db()
    db.execute(f"INSERT INTO upvotes(post_id) VALUES({post_id})")
    db.commit()

    return "ok", 200
