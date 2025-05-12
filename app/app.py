from flask import Flask, jsonify
import psycopg2
import os

app = Flask(__name__)

@app.route('/')
def index():
    return jsonify({"message": "Welcome to the Flask App"})

@app.route('/data')
def get_data():
    conn = psycopg2.connect(
        dbname=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        host=os.getenv("DB_HOST")
    )
    cur = conn.cursor()
    cur.execute("SELECT * FROM sample_table LIMIT 10")
    data = cur.fetchall()
    cur.close()
    conn.close()
    return jsonify(data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)