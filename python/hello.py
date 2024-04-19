from flask import Flask, render_template
import pypyodbc as odbc
DRIVER_NAME = 'SQL Server'
SERVER_NAME = 'DANGKHOACOMPUTE'
DATABASE_NAME = 'lms_tmp'

connection_string = f"""
    DRIVER={{{DRIVER_NAME}}};
    SERVER={SERVER_NAME};
    DATABASE={DATABASE_NAME};
    Trusted_Connection=yes;
"""
app = Flask(__name__)
@app.route("/")
@app.route("/")
def hello_world():
    connection = odbc.connect(connection_string)
    cursor = connection.cursor()
    cursor.execute('SELECT * FROM dbo.Student')
    rows = cursor.fetchall()

    # Construct a list of dictionaries for each row
    student_data = []
    for row in rows:
        student_data.append({
            'id': row[0],
            'date_join': row[1],
            'program': row[2],
            'major': row[3],
        })

    # Render the HTML template and pass the student data
    return render_template('video.html', students=student_data)
    
    
