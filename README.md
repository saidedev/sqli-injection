# Types of SQL Injection
- In-band SQLi (Classic SQLi)
- Error-based SQLi
- Union-based SQLi
- Inferential SQLi (Blind SQLi)
- Boolean-based (content-based) Blind SQLi
- Time-based Blind SQLi
- Out-of-band SQLi



ummary Table: Types of SQL Injection
Type	Description
1. In-band SQLi	Attack and response happen in the same channel
1.1 Error-Based SQLi	Uses database errors to reveal information
1.2 Union-Based SQLi	Uses UNION operator to retrieve data from different tables
2. Blind SQLi	No visible response; relies on indirect indicators
2.1 Boolean-Based SQLi	Uses TRUE or FALSE conditions to infer information
2.2 Time-Based SQLi	Uses database delays to determine query execution
3. Out-of-band SQLi	Extracts data via external methods like DNS or HTTP requests
3.1 DNS-Based Exfiltration	Sends data to an external server via DNS requests
3.2 HTTP-Based Exfiltration	Uses HTTP requests to send data to an attacker-controlled server
4. Second-Order SQLi	Payload is stored and executed later
5. Stored SQLi	SQL code is stored in the database and executed when another user loads it
6. Login Bypass SQLi	Injecting SQL into login forms to bypass authentication
7. Batched SQLi	Running multiple queries in a single request
8. Hybrid SQLi	Combining multiple SQLi techniques for enhanced attack efficiency
Concl
