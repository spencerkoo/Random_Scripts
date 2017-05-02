# This script assumes that the total_sales SQL query returns a list of dictionaries
# so this is the Python script to find the difference in sales from week to week for
# each kiosk instead of the SQL

# Assuming the list of dictionaries will be organized in such a manner:
# each dictionary contains the keys 'kiosk_id', 'date', 'sales', and each item in
# the list represents one row of the query's table (i.e. a different week and a
# different kiosk)

# Function that takes in two dictioanries and returns a dictionary of the differences
# The difference will be from future week to earlier week
def sales_diff(week1, week2):
    # create empty dictionary
    diff = {}
    diff["kiosk_id"] = week1["kiosk_id"]
    diff["date1"] = week1["date"]
    diff["date2"] = week2["date"]
    diff["sales_diff"] = week2["sales"] - week1["sales"]
    return diff

# Differences is a list of difference which can be printed out
for i in differences:
    print i