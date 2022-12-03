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
      // Save and load in search and filter
      String filter = request.getParameter("filter");
      String name = request.getParameter("productName");

      if (filter == null && name != null) {
        filter = (String) session.getAttribute("filter");
        session.setAttribute("productName", name);
      }
      if (name == null && filter != null) {
        name = (String) session.getAttribute("productName");
        session.setAttribute("filter", filter);
      }
      if (name == null && filter == null) {
        session.setAttribute("productName", null);
        session.setAttribute("filter", null);
      }

      name = name == null ? "" : name; 
      filter = filter == null ? "" : filter; 
    %>

    <!---------------->
    <!-- SEARCH BAR -->
    <!---------------->
    <div class="search">
      <form method="get" action="index.jsp" class="search-bar">
        <input type="text" placeholder="Search our records" name="productName" value="<%= name %>" />
        <button type="submit"><img src="Assets/search-icon.png" /></button>
      </form>
    </div>

    <!------------>
    <!-- FILTER -->
    <!------------>
    <div class="filter">
      <h1>Filter by genre:</h1>
      <form method="get" action="index.jsp">
      <select name="filter" id="genre">
    <%
      // Add a filter that filters nothing
      out.println("<option value=\"\"" + (filter.equals("") ? " selected " : "") + ">Select Filter</option>");
      
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
        String SQL = "SELECT genreName FROM genre";
        PreparedStatement pstmt = con.prepareStatement(SQL);
        ResultSet rslt = pstmt.executeQuery();
        while (rslt.next()) {
          String filter1 = rslt.getString(1);
          out.println("<option value=\"" + filter1 + "\"" + (filter1.equals(filter) ? " selected " : "" ) + ">" + filter1 + "</option>");
        }
      }
      %>
      </select>
      <button type="submit">Apply Filter</button>
      </form>
    </div>
    <!--------------------->
    <!-- PRODUCTS (Shop) -->
    <!--------------------->
    <!-- Listing all the products from the database-->
    <%
    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
      /* productId, productName, ArtistName, Genre, Price */
      String SQL = "SELECT album.albumId, albumName, albumArtist, genreName, albumPrice, albumImageURL, SUM(quantity) AS totalOrders FROM album JOIN genre ON album.genreId = genre.genreId LEFT JOIN orderalbum ON album.albumId = orderalbum.albumId";
      if (!name.equals("")) {
        SQL += " WHERE albumName LIKE ?";
        if (!filter.equals("")) {
          SQL += " AND genreName LIKE ?";
        }
      }
      if (name.equals("") && !filter.equals("")) {
        SQL += " WHERE genreName LIKE ?";
      }

      SQL += " GROUP BY album.albumId, albumName, albumArtist, genreName, albumPrice, albumImageURL ORDER BY totalOrders DESC";
      
      PreparedStatement pstmt = con.prepareStatement(SQL);
      if (!name.equals("")) {
        pstmt.setString(1, "%" + name + "%");
      }
      if (!filter.equals("")) {
        pstmt.setString(!name.equals("") ? 2 : 1, "%" + filter + "%");
      }
      ResultSet rslt = pstmt.executeQuery();
      boolean hasRows = false;

      // Get the logged in user's most purchased genre
      String mostPurchasedGenre = "";
      if (session.getAttribute("customerId") != null) {
        String SQL2 = "SELECT TOP 1 genreName FROM ordersummary o JOIN orderalbum o2 ON o.orderId = o2.orderId JOIN album a ON a.albumId = o2.albumId JOIN genre g ON g.genreId = a.genreId WHERE customerId = ? GROUP BY g.genreId, genreName ORDER BY SUM(quantity) DESC";
        PreparedStatement pstmt2 = con.prepareStatement(SQL2);
        pstmt2.setString(1, session.getAttribute("customerId").toString());
        ResultSet rslt2 = pstmt2.executeQuery();
        if (rslt2.next()) {
          mostPurchasedGenre = rslt2.getString("genreName");
        }
      }

      while (rslt.next()) {
        if (!hasRows) {
          hasRows = true;
          out.println("<div class=\"products\"><table id=\"records\"><tr><th>Album Cover</th><th>Record Name</th><th>Artist</th><th>Genre</th><th>Price</th><th>Add to cart</th></tr>");
        }
        out.println(String.format("<tr><td><a href=\"product.jsp?albumId=%s\"><img src=\"%s\" width=100px></a></td><td><a href=\"product.jsp?albumId=%s\" title=\"%s\">%s<span style=\"color:yellow\">%s</span></a></td><td>%s</td><td>%s</td><td>%s</td><td align=\"center\"><a href=\"addcart.jsp?id=%s&name=%s&price=%s\"><img src=\"Assets/shopping-cart-with-plus.png\" width=\"40px\" height=\"40px\"/></a></td></tr>", rslt.getString(1), rslt.getString(6), rslt.getString(1), (rslt.getString("genreName").equals(mostPurchasedGenre) ? "Recommended" : ""), rslt.getString(2), (rslt.getString("genreName").equals(mostPurchasedGenre) ? " ⭐" : ""), rslt.getString(3), rslt.getString(4), NumberFormat.getCurrencyInstance().format(rslt.getDouble(5)) , rslt.getString(1), rslt.getString(2), rslt.getString(5)));
      }
      out.println("</table></div>");
    }
    %>
  </body>
</html>
