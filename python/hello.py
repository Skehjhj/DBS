from flask import Flask, render_template, request, redirect
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
    cursor.execute("""SELECT ProfID, name, Degree, mail, DoB, sex, password
                  From Professor
                  JOIN UserTable
                  ON Professor.ProfID = UserTable.userID""")
    rows = cursor.fetchall()

    # Construct a list of dictionaries for each row
    professor_data = []
    for row in rows:
        professor_data.append({
            'id': row[0],
            'name': row[1],
            'degree': row[2],
            'mail': row[3],
            'dob': row[4],
            'gender': row[5],
        })

    # Render the HTML template and pass the student data
    return render_template('hello.html', professors=professor_data)

@app.route("/update", methods=["POST"])
def update_professor():
    if request.method == "POST":
        # Retrieve data from the form
        prof_id = request.form["prof_id"]
        new_name = request.form["new_name"]
        new_degree = request.form["new_degree"]
        new_mail = request.form["new_mail"]
        new_dob = request.form["new_dob"]
        new_gender = request.form["new_gender"]

        # Connect to the database
        connection = odbc.connect(connection_string)
        cursor = connection.cursor()

        # Execute SQL query to update the record
        cursor.execute("""
            UPDATE Professor
            SET name = ?,
                Degree = ?,
                mail = ?,
                DoB = ?,
                sex = ?
            WHERE ProfID = ?
        """, (new_name, new_degree, new_mail, new_dob, new_gender, prof_id))
        
        # Commit the transaction
        connection.commit()

        # Close the cursor and connection
        cursor.close()
        connection.close()

        # Redirect to the home page to reload the HTML template with updated data
        return redirect("/")
