<%@ page import="java.sql.*" %>
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
            <li><a href="account.jsp">Account</a></li>
          </ul>
        </nav>
        <a href="cart.jsp">
          <img src="Assets/shopping-cart.png" width="40px" height="40px" />
        </a>
      </div>
    </div>

    <!--------------------->
    <!-- ACCOUNT (login) -->
    <!--------------------->
    <div class="login-container">
      <h1>Sign In Here</h1>
      <form method="get" action="<%="accountverification.jsp?redirect=" + (request.getParameter("redirect") != null ? request.getParameter("redirect") : "index.jsp") %>" class="login-form">
        <%
          String invalid = request.getParameter("invalid");
          if (invalid != null && invalid.equals("true"))
            out.println("<h3 style=\"color:red; margin-bottom:5px;\">Invalid login information</h3>");
        %>
        <input type="text" name="userid" placeholder="Username" required />
        <input type="password" name="pass" placeholder="Password" required />
        <button type="submit" class="login-button">Login</button>
      </form>
    </div>
  </body>
</html>