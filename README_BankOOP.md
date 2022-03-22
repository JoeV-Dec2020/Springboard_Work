BankObject is a menu driven application that can be used to view, add, modify, and delete Customer, Employee, and Account records.

The application uses the following files to store data and log messages related to the operation of the application:
~./data/acct_info.dat
~./data/cust_info.dat
~./data/emp_info.dat
~./log/bank_system.log

To use the application, unzip the BankObject.zip file in the directory you wish to run the application.
Unzipping the file will create or utilize the ./data and ./log directories.

Running BankObject.py using the ~./python.exe application you have on your system.
The BankObject.py application is contained in the one module and it will give access to all functionality.

Note:  The View functionality for each object type will return the message "No data to select from!" until data is added.
       Prior to being able to add account data, at least one customer must be created to be able to select the account's customer.
