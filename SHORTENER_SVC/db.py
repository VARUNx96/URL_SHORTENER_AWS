import sqlite3

conn = sqlite3.connect("../urls.db",check_same_thread = False)
cursor = conn.cursor()

cursor.execute("""
CREATE TABLE IF NOT EXISTS urls (
               code TEXT PRIMARY KEY,
               long_url TEXT
               )""")
conn.commit()
def save_url(code, long_url):
    cursor.execute("INSERT INTO urls (code, long_url) VALUES (?,?)", (code, long_url))
    conn.commit()