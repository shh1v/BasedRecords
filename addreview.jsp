<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.text.NumberFormat" %>
<%
// Get the current list of products

try
    {	// Load driver class
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    }
catch (java.lang.ClassNotFoundException e)
    {
    out.println("ClassNotFoundException: " +e);
    }

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

// Retrive the data sent fromt he previous page
String albumId = request.getParameter("albumId");
String rating = request.getParameter("rating");
String title = request.getParameter("title");
String review = request.getParameter("review");
String message = null;
// If the user ius not logged in
if (session.getAttribute("customerId") == null) {
    response.sendRedirect("account.jsp?redirect=product.jsp?albumId=" + albumId);
    return; // So that no attempt is made to run the rest of the file
}
// Check is the customer has purchased the product or not.
boolean hasPurchased = false, hasReviewed = false;

try (Connection con = DriverManager.getConnection(url, uid, pw)) {
    String SQL = "SELECT * FROM ordersummary JOIN orderalbum ON ordersummary.orderId=orderalbum.orderId WHERE ordersummary.customerId=? AND albumId=?";
    PreparedStatement pstmt = con.prepareStatement(SQL);
    pstmt.setString(1, String.valueOf(session.getAttribute("customerId")));
    pstmt.setString(2, albumId);
    ResultSet rslt = pstmt.executeQuery();
    if (rslt.next()) {
        hasPurchased = true;
    }

    SQL = "SELECT * FROM review WHERE customerId=? AND albumId=?";
    pstmt = con.prepareStatement(SQL);
    pstmt.setString(1, String.valueOf(session.getAttribute("customerId")));
    pstmt.setString(2, albumId);
    rslt = pstmt.executeQuery();
    if (rslt.next()) {
        hasReviewed = true;
    }
}
if (!hasPurchased) {
    message = "You must have already purchased the order to write a review.";
}
else if (hasReviewed) {
    message = "You have already witten a review for this product.";
}
else {
    // Get DateTime
    LocalDateTime myDateObj = LocalDateTime.now(ZoneId.of("America/Vancouver"));
    DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    String reviewDate = myDateObj.format(myFormatObj);

    // Add the review of the customer
    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
        String SQL = "INSERT INTO review(customerId, albumId, reviewRating, reviewDate, reviewTitle, reviewComment) VALUES(?, ?, ?, ?, ?, ?)";
        PreparedStatement pstmt = con.prepareStatement(SQL);
        pstmt.setString(1, String.valueOf(session.getAttribute("customerId")));
        pstmt.setString(2, albumId);
        pstmt.setString(3, rating);
        pstmt.setString(4, reviewDate);
        pstmt.setString(5, title);
        pstmt.setString(6, review);
        pstmt.executeUpdate();
    }
}
String redirectURL = String.format("product.jsp?albumId=%s&message=%s", albumId, message == null ? "Review successfully submitted" : message);
response.sendRedirect(redirectURL);
%>