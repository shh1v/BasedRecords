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
            <li><a href="account.jsp"><%= session.getAttribute("userid") == null ? "Login" : session.getAttribute("userid") %></a></li>
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
    <% String userid = (String) session.getAttribute("userid"); %>
      
    <% if (userid == null) { %>  <!-- What to display if user is not logged in -->
    <div class="login">
      <h1>Sign In Here</h1>
      <div class="login-container">
        <form method="get" action="accountverification.jsp" class="login-form">
          <%
            String invalid = request.getParameter("invalid");
            if (invalid != null && invalid.equals("true"))
              out.println("<h3 style=\"color:red; margin-bottom:5px;\">Invalid login information</h3>");
          %>
          <input type="text" name="userid" placeholder="Username" required />
          <input type="password" name="pass" placeholder="Password" required />
          <input type="hidden" name="redirect" value="<%=request.getParameter("redirect") != null ? request.getParameter("redirect") : "account.jsp" %>"/>
          <button type="submit" class="login-button">Login</button>
          <div class="signup-link">
            Don't have an account? <a href="<%="signup.jsp?redirect=" + (request.getParameter("redirect") != null ? request.getParameter("redirect") : "account.jsp")%>">Sign up</a>!
          </div>
        </form>
      </div>
    </div>
    
    <% } else { %>  <!-- What to display if user is logged in -->

    <div class="login-header">
      <h1>Logged in as: <%=userid%></h1>
    </div>
    <div class="logged-in">
      <div class="login-actions">
        <form method="get" action="accountverification.jsp">
          <div class="end-cart-options">
            <a href="customer.jsp"><h1>Customer</h1></a>
            <h2>//</h2>
            <a href="admin.jsp"><h1>Admin Area</h1></a>
          </div>
          <input type="hidden" name="logout" value="" />
          <input type="hidden" name="redirect" value="account.jsp" />
          <button type="submit" class="login-button">Logout</button>
        </form>
      </div>
    </div>

    <% } %>
  </body>
</html>
