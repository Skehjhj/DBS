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

connection = odbc.connect(connection_string)
cursor = connection.cursor()
cursor.execute('SELECT * FROM Study')
for row in cursor.fetchall():
    print(row)