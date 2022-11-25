<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ include file="jdbc.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<!DOCTYPE html>
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

    <!--------------->
    <!-- Product ---->
    <!--------------->
    <%
        String albumId = request.getParameter("albumId");
        if (albumId == null) albumId = "1";

        getConnection();

        con.createStatement().execute("use orders;");

        PreparedStatement stmt = con.prepareStatement("SELECT albumId, albumName, albumPrice, albumImageURL, albumArtist, albumYear, genreName FROM album JOIN genre ON album.genreId = genre.genreId WHERE albumId = ?");
        stmt.setString(1, albumId);

        ResultSet result = stmt.executeQuery();
        String albumName = "", albumImageURL = "", albumArtist = "", albumYear = "", genreName = "";
        double albumPrice = 0;
        NumberFormat currFormat = NumberFormat.getCurrencyInstance();

        if (result.next()) {
            albumName = result.getString("albumName");
            albumPrice = result.getDouble("albumPrice");
            albumImageURL = result.getString("albumImageURL");
            albumArtist = result.getString("albumArtist");
            albumYear = result.getString("albumYear");
            genreName = result.getString("genreName");
        }

        closeConnection();
    %>
    <div class="product-name">
      <h1><%= albumName %></h1>
    </div>
      <div class="product">
        <img src="<%= albumImageURL %>" width="300px" />
        <div class="album-information">
          <p><h2>Artist:</h2><%= albumArtist %></p>
          <p><h2>Year:</h2><%= albumYear %></p>
          <p><h2>Genre:</h2><%= genreName %></p>
          <p><h2>Price:</h2><%= currFormat.format(albumPrice) %></p>
        </div>
      </div>
      <% if (albumId.equals("7")) { %>
      <div class="product"><img width=10px alt="Latte Picture" src="displayImage.jsp?id=<%= albumId %>"/></div>
      <% } %>
      <div class="end-cart-options">
        <a href="addcart.jsp?id=1&name=Currents&price=34.99"><h1>Add to Cart</h1></a>
        <h2>//</h2>
        <a href="index.jsp"><h1>Continue Shopping</h1></a>
      </div>
  </body>
</html>
