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
        String message = request.getParameter("message");
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
      <!-- Adding an option to review a product -->
      <div class="review">
        <h2>Add a review for this product</h2>
      </div>
        <%
        if (message != null && !message.equals("")) {
          out.println("<div class=\"review\"><h5 style=\"color: red\">**" + message + "</h5></div>");
        }
        %>
      <div class="review">
        <form method="get" action="addreview.jsp">

          <div class="rating">
            <input id="star5" name="rating" type="radio" value="5" class="radio-btn hide" />
            <label for="star5">☆</label>
            <input id="star4" name="rating" type="radio" value="4" class="radio-btn hide" />
            <label for="star4">☆</label>
            <input id="star3" name="rating" type="radio" value="3" class="radio-btn hide" />
            <label for="star3">☆</label>
            <input id="star2" name="rating" type="radio" value="2" class="radio-btn hide" />
            <label for="star2">☆</label>
            <input id="star1" name="rating" type="radio" value="1" class="radio-btn hide" />
            <label for="star1">☆</label>
            <div class="clear"></div>
            </div>
        
          <input id="headline" type="text" placeholder="Add a headline" name="title"/>

          <textarea id="details" placeholder="Write your review" rows = "5" cols = "60" name = "review"></textarea>

          <input type="hidden" name= "albumId" value=<%= albumId %>>
          <button type="submit" class="submit-button">Submit</button>
        </form>
      </div>
      <!-- View all the past reviews -->
      <div class="previous-reviews-header">
        <h2>Previous Reviews</h2>
      </div>
      <!-- Start of the reviews -->
      <div class="previous-reviews">
        <%
        String SQL = "SELECT * FROM review JOIN customer on review.customerId = customer.customerId WHERE albumId=?";
        PreparedStatement pstmt = con.prepareStatement(SQL);
        pstmt.setString(1, albumId);
        ResultSet rslt = pstmt.executeQuery();
        
        while (rslt.next()) {
          String customerName = String.format("%s %s", rslt.getString("firstName"), rslt.getString("lastName"));
          int reviewRating = rslt.getInt("reviewRating");
          StringBuilder RatingString = new StringBuilder();
          for (int i = 0 ; i < reviewRating ; i++) {
            RatingString.append("⭐");
          }
          for (int i = reviewRating ; i < 5 ; i++) {
            RatingString.append("✰");
          }

          out.println("<table>");

          String reviewTitle = rslt.getString("reviewTitle");
          String reviewDesc = rslt.getString("reviewComment");
          out.println("<tr><td>" + customerName + "</td></tr>");
          out.println("<tr><td>" + RatingString.toString() + "</td></tr>");
          out.println("<tr><td>" + reviewTitle + "</td></tr>");
          out.println("<tr><td>" + reviewDesc + "</td></tr>");

          out.println("</table>");
          
        }
        
        closeConnection();
        %>
      </div>  

      <% if (albumId.equals("7")) { %>
      <div class="product"><img width=10px alt="Latte Picture" src="displayImage.jsp?id=<%= albumId %>"/></div>
      <% } %>
      <div class="end-cart-options">
        <a href="<%= String.format("addcart.jsp?id=%s&name=%s&price=%s",albumId, albumName, albumPrice) %>"><h1>Add to Cart</h1></a>
        <h2>//</h2>
        <a href="index.jsp"><h1>Continue Shopping</h1></a>
      </div>
  </body>
</html>