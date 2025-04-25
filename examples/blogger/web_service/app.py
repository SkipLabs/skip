from flask import Flask, json, request, redirect, jsonify
import psycopg2
import requests
import os
import jwt
from datetime import datetime, timedelta, timezone
from functools import wraps
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def get_db():
    conn = psycopg2.connect(
        host="blogger_db",
        user="postgres",
        password="change_me",
    )

    return conn


app = Flask(__name__)

# JWT Configuration
JWT_SECRET = os.environ.get("JWT_SECRET", "your-secret-key-here")  # In production, use a secure secret
JWT_ALGORITHM = "HS256"
JWT_EXPIRATION = timedelta(hours=24)


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


def format_post(post):
    return {
        "id": post[0],
        "title": post[1],
        "content": post[2],
        "status": post[4],
        "published_at": post[5],
        "author": {
            "name": post[3],  # username from users table
            "email": post[6],  # email from users table
        },
    }


def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        if "Authorization" in request.headers:
            auth_header = request.headers["Authorization"]
            if auth_header.startswith("Bearer "):
                token = auth_header.split(" ")[1]
                logger.info(f"Token found in request: {token[:10]}...")
        
        if not token:
            logger.warning("No token found in request")
            return jsonify({"message": "Token is missing"}), 401
        
        try:
            data = jwt.decode(token, JWT_SECRET, algorithms=[JWT_ALGORITHM])
            current_user = {
                "user_id": data["user_id"],
                "name": data["name"],
                "email": data["email"]
            }
            logger.info(f"Token validated for user: {current_user['name']}")
        except jwt.ExpiredSignatureError:
            logger.warning("Token has expired")
            return jsonify({"message": "Token has expired"}), 401
        except jwt.InvalidTokenError:
            logger.warning("Invalid token")
            return jsonify({"message": "Invalid token"}), 401
        
        return f(current_user, *args, **kwargs)
    return decorated


@app.post("/login")
def login():
    data = request.json
    username = data.get("username")
    logger.info(f"Login attempt for user: {username}")
    
    with get_db() as db:
        with db.cursor() as cur:
            cur.execute(
                "SELECT id, username, email, password_hash FROM users WHERE LOWER(username) = LOWER(%s) AND password_hash = %s",
                (username, data.get("password")),
            )
            if cur.rowcount < 1:
                logger.warning(f"Invalid credentials for user: {username}")
                return jsonify({"message": "Invalid credentials"}), 401
            user = cur.fetchone()
            logger.info(f"User authenticated: {user[1]}")

    token_data = {
        "user_id": user[0],
        "name": user[1],
        "email": user[2],
        "exp": datetime.now(timezone.utc) + JWT_EXPIRATION
    }
    token = jwt.encode(token_data, JWT_SECRET, algorithm=JWT_ALGORITHM)
    logger.info(f"Token generated for user: {user[1]}")

    return jsonify({
        "token": token,
        "user": {
            "user_id": user[0],
            "name": user[1],
            "email": user[2]
        }
    })


@app.get("/session")
@token_required
def get_session(current_user):
    logger.info(f"Session requested for user: {current_user['name']}")
    return jsonify(current_user)


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
        return jsonify(formatted_posts)


@app.post("/posts")
@token_required
def create_post(current_user):
    params = request.json
    title = params["title"]
    content = params["content"]
    status = params.get("status", "draft")
    author_id = current_user["user_id"]

    with get_db() as db:
        with db.cursor() as cur:
            cur.execute(
                "INSERT INTO posts(title, content, status, author_id) VALUES(%s, %s, %s, %s)",
                (title, content, status, author_id),
            )
            db.commit()

    return jsonify({"message": "Post created successfully"}), 201


@app.delete("/posts/<int:post_id>")
@token_required
def delete_post(current_user, post_id):
    with get_db() as db:
        with db.cursor() as cur:
            # Check if the post belongs to the current user
            cur.execute("SELECT author_id FROM posts WHERE id = %s", (post_id,))
            if cur.rowcount < 1:
                return jsonify({"message": "Post not found"}), 404
            post = cur.fetchone()
            if post[0] != current_user["user_id"]:
                return jsonify({"message": "Unauthorized"}), 403
            
            cur.execute("DELETE FROM posts WHERE id = %s", (post_id,))
            db.commit()
    return jsonify({"message": "Post deleted successfully"}), 200


@app.put("/posts/<int:post_id>")
@token_required
def update_post(current_user, post_id):
    params = request.json
    title = params["title"]
    content = params["content"]
    status = params.get("status")

    with get_db() as db:
        with db.cursor() as cur:
            # Check if the post belongs to the current user
            cur.execute("SELECT author_id FROM posts WHERE id = %s", (post_id,))
            if cur.rowcount < 1:
                return jsonify({"message": "Post not found"}), 404
            post = cur.fetchone()
            if post[0] != current_user["user_id"]:
                return jsonify({"message": "Unauthorized"}), 403
            
            cur.execute(
                "UPDATE posts SET title = %s, content = %s, status = %s WHERE id = %s",
                (title, content, status, post_id),
            )
            db.commit()

    return jsonify({"message": "Post updated successfully"}), 200


@app.get("/healthcheck")
def healthcheck():
    return "ok", 200
