<%@ page import="java.sql.*" %>
<%@ page import="java.util.Scanner" %>
<%@ page import="java.io.File" %>
<%@ include file="jdbc.jsp" %>

<%

// Check if user is logged in
if (session.getAttribute("customerId") == null) {
    response.sendRedirect("account.jsp?redirect=resetdatabase.jsp");
    return; // So that no attempt is made to run the rest of the file
} 

getConnection();
                    
String fileName = "/usr/local/tomcat/webapps/shop/ddl/orderdb_sql.ddl";

try
{
    // Drop the database
    con.createStatement().execute("USE master; ALTER DATABASE orders SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE orders;");

    // Create statement
    Statement stmt = con.createStatement();
    
    Scanner scanner = new Scanner(new File(fileName));
    // Read commands separated by ;
    scanner.useDelimiter(";");
    while (scanner.hasNext()) {
        String command = scanner.next();
        if (command.trim().equals("") || command.trim().equals("go"))
            continue;
        try
        {
            stmt.execute(command);
        }
        catch (Exception e) {
            out.print(e);
        }
    }	 
    scanner.close();
} catch (Exception e) {
    out.print(e);
}  

response.sendRedirect("admin.jsp");

%>