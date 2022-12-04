<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
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


    <!--------------------->
    <!-- CUSTOMER (INFO) -->
    <!--------------------->
    <% 
        // Check if user is logged in
        if (session.getAttribute("customerId") == null) {
            response.sendRedirect("account.jsp?redirect=admin.jsp");
            return; // So that no attempt is made to run the rest of the file
        }
    %>
      
    <!-- What to display if user is logged in -->
    <div class="heading">
			<h1>Administrators Sales Report by Day</h1>
			<br>
		</div>
    <div class="products">
        <table id="records">
            <tr>
                <th>Order Date</th>
                <th>Total Order Amount</th>
            </tr>
            <%
                NumberFormat currFormat = NumberFormat.getCurrencyInstance();

                getConnection();

                Statement stmt = con.createStatement();
                stmt.execute("use orders;");

                // Get order info
                ResultSet result = stmt.executeQuery("SELECT YEAR(orderDate) AS year, MONTH(orderDate) AS month, DAY(orderDate) AS day, SUM(totalAmount) AS amountSold FROM ordersummary GROUP BY YEAR(orderDate), MONTH(orderDate), DAY(orderDate) ORDER BY 1, 2, 3;");
                while (result.next()) {
                    String orderDate = result.getString("year") + "-" + result.getString("month") + "-" + result.getString("day");
                    String amountSold = currFormat.format(result.getDouble("amountSold"));
                    out.println("<tr><td>" + orderDate + "</td><td>" + amountSold + "</td></tr>");
                }

            %>
           
        </table>
    </div>
    <div class="end-cart-options">
      <a href="ListAllCustomers.jsp"><h1>List All Customers</h1></a>

   <h2>//</h2>
            <a href="resetdatabase.jsp"><h1>Reset Database</h1></a>
    
      </div>

    
  </body>
</html>
