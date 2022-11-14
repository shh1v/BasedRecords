<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
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
          <a href="index.html">
            <img src="Assets/Based Records Logo.png" width="400px" />
          </a>
        </div>
        <nav>
          <ul>
            <li><a href="index.html">Home</a></li>
            <li><a href="#records">Shop</a></li>
            <li><a href="orders.html">Orders</a></li>
            <li><a href="account.html">Account</a></li>
          </ul>
        </nav>
        <a href="cart.html">
          <img src="Assets/shopping-cart.png" width="40px" height="40px" />
        </a>
      </div>
    </div>

    <!---------------->
    <!-- SEARCH BAR -->
    <!---------------->
    <div class="search">
      <form method="get" action="http://localhost/shop/index.jsp" class="search-bar">
        <input type="text" placeholder="Search our records" name="productName" />
        <button type="submit"><img src="Assets/search-icon.png" /></button>
      </form>
    </div>

    <!------------>
    <!-- FILTER -->
    <!------------>

    <div class="filter">
      <h1>Filter by genre:</h1>
      <select name="genre" id="genre">
        <option value="indie-alternative">Indie/Alternative</option>
        <option value="heavy-metal">Heavy Metal</option>
        <option value="rap">Rap</option>
        <option value="pop-rock">Pop Rock</option>
        <option value="uk-garage">UK Garage</option>
        <option value="hip-hop">Hip Hop</option>
        <option value="pop">Pop</option>
        <option value="rock">Rock</option>
        <option value="rnb-soul">R&B/Soul</option>
        <option value="reggae">Reggae</option>
      </select>
    </div>
    <!--------------------->
    <!-- PRODUCTS (Shop) -->
    <!--------------------->
    <!-- Listing all the products from the database-->
    <%
    String name = request.getParameter("productName");
    name = name == null ? "" : name; 

    try
    {	// Load driver class
      Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    }
    catch (java.lang.ClassNotFoundException e)
    {
      out.println("ClassNotFoundException: " +e);
    }
    // User id, password, and server information
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
      /* productId, productName, ArtistName, Genre, Price */
      String SQL = "SELECT albumId, albumName, albumArtist, genreName, albumPrice FROM album JOIN genre ON album.genreId = genre.genreId";
      if (!name.equals("")) {
        SQL += " WHERE albumName LIKE ?";
      }
      PreparedStatement pstmt = con.prepareStatement(SQL);
      if (!name.equals("")) {
        pstmt.setString(1, "%" + name + "%");
      }
      ResultSet rslt = pstmt.executeQuery();
      boolean hasRows = false;
      while (rslt.next()) {
        if (!hasRows) {
          hasRows = true;
          out.println("<div class=\"products\"><table id=\"records\"><tr><th>Record Name</th><th>Artist</th><th>Genre</th><th>Price</th><th>Add to cart</th></tr>");
        }
        out.println(String.format("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td align=\"center\"><a href=\"addcart.jsp?id=%s&name=%s&price=%s\"><img src=\"Assets/shopping-cart-with-plus.png\" width=\"40px\" height=\"40px\"/></a></td></tr>", rslt.getString(2), rslt.getString(3), rslt.getString(4), NumberFormat.getCurrencyInstance().format(rslt.getDouble(5)) , rslt.getString(1), rslt.getString(2), rslt.getString(5)));
      }
      out.println("</table></div>");
    }
    %>
  </body>
</html>
