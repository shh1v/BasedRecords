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
    <!-- ACCOUNT (create account) -->
    <!--------------------->

    <div class="create-account">
      <h1>Create Account</h1>
      <div class="login-container">
        <form method="get" action="addcustomer.jsp" class="login-form">
            <%
            String invalid = request.getParameter("invalid");
            if (invalid != null)
                out.println("<h3 style=\"color:red; margin-bottom:5px;\">Invalid login information: " + request.getParameter("invalid") + "</h3>");
            %>
            <input type="text" name="userid" placeholder="Username" required />
            <input type="password" name="pass" placeholder="Password" required />
            <input type="text" name="firstName" placeholder="First Name" required />
            <input type="text" name="lastName" placeholder="Last Name" required />
            <input type="text" name="email" placeholder="Email" required />
            <input type="text" name="phone" placeholder="Phone Number" required />
            <input type="text" name="address" placeholder="Address" required />
            <input type="text" name="city" placeholder="City" required />
            <select style="text-align:left;margin-top:5px;margin-bottom:0px" type="text" name="state" placeholder="State" required>
              <%
                getConnection();

                con.createStatement().execute("USE orders");

                PreparedStatement ps = con.prepareStatement("SELECT DISTINCT state FROM stateTax");
                ResultSet states = ps.executeQuery();

                while (states.next()) {
                    out.println("<option value=\"" + states.getString("state") + "\">" + states.getString("state") + "</option>");
                }
              %>
            </select>
            <input type="text" name="postalCode" placeholder="Postal Code" required />
            <select style="text-align:left;margin-top:5px;margin-bottom:0px" type="text" name="country" placeholder="Country" required >
              <%
                PreparedStatement ps2 = con.prepareStatement("SELECT DISTINCT country FROM stateTax");
                ResultSet countries = ps2.executeQuery();

                while (countries.next()) {
                    out.println("<option value=\"" + countries.getString("country") + "\">" + countries.getString("country") + "</option>");
                }

                closeConnection();
              %>
            </select>
            <input type="hidden" name="redirect" value="<%=request.getParameter("redirect") != null ? request.getParameter("redirect") : "account.jsp" %>"/>
            <button type="submit" class="login-button">Create Account</button>
        </form>
    </div>
    </div>
    </body>
</html>