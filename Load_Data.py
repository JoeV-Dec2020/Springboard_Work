import os
import sys
import mysql.connector

def get_db_connection():
    connection = None
    try:
        connection = mysql.connector.connect(user='root',
                                             password='JPV123_mysql',
                                             host='localhost',
                                             port='3306',
                                             database='data_pipeline')
    except Exception as error:
        print("Error while connecting to database for job tracker", error)
    return connection

def load_third_party(connection, file_path_csv):
    cursor = connection.cursor()

    # [Iterate through the CSV file and execute insert statement]
    infile = open(file_path_csv, 'r')
    if infile.mode == 'r':
        for inline in infile:
            inline = inline.strip('\n')
            db_rec = inline.split(',')

            insert_stmt = (
                "INSERT INTO ticket_sales(ticket_id, trans_date, event_id, event_name, "
                "event_date, event_type, event_city, customer_id, price, num_tickets) "
                "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)")
            cursor.execute(insert_stmt, db_rec)

        infile.close()
    
    connection.commit()
    cursor.close()
    return

def query_popular_tickets(connection):
    # Get the most popular ticket in the past month
    sql_statement =  "select event_name, sum(num_tickets) tot_tkts from ticket_sales "
    sql_statement += "group by event_name order by sum(num_tickets) desc"
    cursor = connection.cursor()
    cursor.execute(sql_statement)
    records = cursor.fetchall()
    cursor.close()
    return records

file_path = 'C:\\Python\\Springboard\\MiniProjs\\DataPipeline_MiniProj\\third_party_sales.csv'
load_third_party(get_db_connection(),file_path)

pop_events = query_popular_tickets(get_db_connection())
print('\nHere are the most popular tickets in the past month:')
for each_event in pop_events:
    print("- " + each_event[0])
print('\n')

