from flask import Flask, render_template
import pypyodbc as odbc
DRIVER_NAME = 'SQL Server'
SERVER_NAME = 'DESKTOP-AOS1TRG'
DATABASE_NAME = 'lms'

connection_string = f"""
    DRIVER={{{DRIVER_NAME}}};
    SERVER={SERVER_NAME};
    DATABASE={DATABASE_NAME};
    Trusted_Connection=yes;
"""
app = Flask(__name__)
@app.route("/")
def hello_world():
    connection = odbc.connect(connection_string)
    cursor = connection.cursor()
    cursor.execute('SELECT * FROM dbo.Student')
    rows = cursor.fetchall()

    # Construct a list of dictionaries for each row
    professor_data = []
    for row in rows:
        professor_data.append({
            'id': row[0],
            'date_join': row[1],
            'degree': row[2],
        })

    # Render the HTML template and pass the student data
    return render_template('hello.html', professors=professor_data)
    
    
