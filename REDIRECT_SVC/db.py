import sqlite3
conn = sqlite3.connect("/data/urls.db", check_same_thread=False)
cursor = conn.cursor()

def get_url(code):
    cursor.execute("SELECT long_url FROM urls WHERE code=?", (code,))
    result = cursor.fetchone()
    return result[0] if result else None
