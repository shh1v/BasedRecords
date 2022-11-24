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

    <!--------------------->
    <!-- CUSTOMER (INFO) -->
    <!--------------------->
    <% 
        String customerId = "default";
        // Check if user is logged in
        if (session.getAttribute("customerId") == null) {
            response.sendRedirect("account.jsp?redirect=customer.jsp");
            return; // So that no attempt is made to run the rest of the file
        } else {
            customerId = String.valueOf(session.getAttribute("customerId"));
        }
    %>
      
    <!-- What to display if user is logged in -->
    <div class="customer">
      <div class="customer-table">
        <h1>Your Profile:</h1>
        <table id="profile">
            <%
                getConnection();

                Statement database = con.createStatement();
                database.execute("use orders;");

                PreparedStatement stmt = con.prepareStatement("SELECT firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid FROM customer WHERE customerId = ?");
                stmt.setString(1, customerId);

                ResultSet result = stmt.executeQuery();

                String firstName = "", lastName = "", email = "", phonenum = "", address = "", city = "", state = "", postalCode = "", country = "", userid = "";
                if (result.next()) {
                    firstName = result.getString("firstName");
                    lastName = result.getString("lastName");
                    email = result.getString("email");
                    phonenum = result.getString("phonenum");
                    address = result.getString("address");
                    city = result.getString("city");
                    state = result.getString("state");
                    postalCode = result.getString("postalCode");
                    country = result.getString("country");
                    userid = result.getString("userid");
                }

                closeConnection();
            %>
            <tr>
                <th>ID</th>
                <td><%=customerId%></td>
            </tr>
            <tr>
                <th>First Name</th>
                <td><%=firstName%></td>
            </tr>
            <tr>
                <th>Last Name</th>
                <td><%=lastName%></td>
            </tr>
            <tr>
                <th>Email</th>
                <td><%=email%></td>
            </tr>
            <tr>
                <th>Phone Number</th>
                <td><%=phonenum%></td>
            </tr>
            <tr>
                <th>Address</th>
                <td><%=address%></td>
            </tr>
            <tr>
                <th>City</th>
                <td><%=city%></td>
            </tr>
            <tr>
                <th>State</th>
                <td><%=state%></td>
            </tr>
            <tr>
                <th>Postal Code</th>
                <td><%=postalCode%></td>
            </tr>
            <tr>
                <th>Country</th>
                <td><%=country%></td>
            </tr>
            <tr>
                <th>User ID</th>
                <td><%=userid%></td>
            </tr>
        </table>
    </div>
  </body>
</html>
