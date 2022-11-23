<%@ page import="java.sql.*" %>
<%@ page import="java.util.Scanner" %>
<%@ page import="java.io.File" %>
<%@ include file="jdbc.jsp" %>

<html>
    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Load Database - Based Records</title>
        <!-- Stylesheet -->
        <link rel="stylesheet" href="styles.css" />
        <!-- Font links -->
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
        <link
        href="https://fonts.googleapis.com/css2?family=Lato:wght@300;400;700;900&display=swap"
        rel="stylesheet"
        />
    </head>
    <body>
        <!-------------------------------->
        <!-- HEADER (Logo & Navigation) -->
        <!-------------------------------->
        <div class="header">
            <div class="navbar">
                <div class="logo">
                <a href="index.jsp">
                    <img src="Assets/Based Records Logo.png" width="400px" />
                </a>
                </div>
                <nav>
                <ul>
                    <li><a href="index.jsp">Home</a></li>
                    <li><a href="index.jsp#records">Shop</a></li>
                    <li><a href="listorder.jsp">Orders</a></li>
                    <li><a href="account.jsp"><%= session.getAttribute("userid") == null ? "Login" : session.getAttribute("userid") %></a></li>
                </ul>
                </nav>
                <a href="cart.jsp">
                <img src="Assets/shopping-cart.png" width="40px" height="40px" />
                </a>
            </div>
        </div>
        <%
            out.println("<h1 class=\"heading\">Connecting to database.</h1><br><br><div style=\"width:60%; margin-left:20%\">");

            getConnection();
                    
            String fileName = "/usr/local/tomcat/webapps/shop/ddl/orderdb_sql.ddl";

            try
            {
                // Create statement
                Statement stmt = con.createStatement();
                
                Scanner scanner = new Scanner(new File(fileName));
                // Read commands separated by ;
                scanner.useDelimiter(";");
                while (scanner.hasNext())
                {
                    String command = scanner.next();
                    if (command.trim().equals("") || command.trim().equals("go"))
                        continue;
                    // out.print(command+"<br>");        // Uncomment if want to see commands executed
                    try
                    {
                        stmt.execute(command);
                    }
                    catch (Exception e)
                    {	// Keep running on exception.  This is mostly for DROP TABLE if table does not exist.
                        out.println("<h4 style=\"color:red; text-align:left;\">"+e+"</h4>");
                    }
                }	 
                scanner.close();
                
                out.print("</div><div class=\"heading\"><br><br><h1>Database loaded.</h1>");
                out.println("<h1><a href=\"index.jsp\"><u>Start Shopping</u></a></h1><br><br><br></div>");
            }
            catch (Exception e)
            {
                out.print(e);
            }  
        %>
    </body>
</html> 
