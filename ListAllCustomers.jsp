<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Based Records</title>
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
  <!-------------------------------->
  <!-- HEADER (Logo & Navigation) -->
  <!-------------------------------->
  <body>
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
    // Check if user is logged in
    if (session.getAttribute("customerId") == null) {
        response.sendRedirect("account.jsp?redirect=listallcustomers.jsp");
        return; // So that no attempt is made to run the rest of the file
    }

    getConnection();

    Statement database = con.createStatement();
    database.execute("use orders;");


    String sql = "SELECT * FROM customer";
    ResultSet rst = database.executeQuery(sql);

    out.println("<div class = \"list-all-customers\"><table id=\"records\">");

    out.println("<tr> <th>Customer id  </th> <th>First name</th><th>Last name</th><th>email</th><th>phone number </th> <th>address</th><th>city</th><th>state</th><th>postalCode</th><th>country</th><th>userid</th></tr>");

    while(rst.next()){
        out.println("<tr>"+"<td>"+rst.getString(1)+"</td>" +"<td>"+rst.getString(2)+"</td>" +"<td>"+rst.getString(3)+"</td>" +"<td>"+rst.getString(4)+"</td>" +"<td>"+rst.getString(5)+"</td>" +"<td>"+rst.getString(6)+"</td>" +"<td>"+rst.getString(7)+"</td>" +"<td>"+rst.getString(8)+"</td>"+"<td>"+rst.getString(9)+"</td>"+"<td>"+rst.getString(10)+"</td>" +"<td>"+rst.getString(11)+ "</td>  </tr>");
    }
    out.println("</table></div>");
    closeConnection();
    %>
  </body>
  </html>
