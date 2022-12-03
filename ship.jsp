<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
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
<div class="order-info">

<%
	// TODO: Get order id
	String orderId = request.getParameter("orderId");
	if (orderId == null) {
		// It was not redirected from order.jsp
		response.sendRedirect("index.jsp");
		return;
	} else {
		boolean success = true;
		String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
		String uid = "sa";
		String pw = "304#sa#pw";

		try (Connection con = DriverManager.getConnection(url, uid, pw);) {
			con.setAutoCommit(false);
			String sql = "SELECT * FROM orderalbum JOIN album ON orderalbum.albumId = album.albumId WHERE orderId=?";
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(orderId));
			ResultSet rs = pstmt.executeQuery();
			ArrayList<String[]> orderAlbums = new ArrayList<String[]>();
			while (rs.next()) {
				String sql_inner = "SELECT quantity FROM albuminventory WHERE albumId=?";
				PreparedStatement pstmt_inner = con.prepareStatement(sql_inner);
				pstmt_inner.setString(1, rs.getString("albumId"));
				ResultSet rs_inner = pstmt_inner.executeQuery();
				boolean hasRows = rs_inner.next();
				if (!hasRows) {
					// The order can't be proccesed because of NO inventory. Rollback
					con.rollback();
					out.println("<div class=\"heading\"><h3>Shipment cannot be processed. No inventory for \"" + rs.getString("albumName") + "\". Please visit back again :)</h3></div>");
					success = false;
					break;
				}
				if (rs_inner.getInt(1) >= rs.getInt("quantity")) {
					// Then the order can be placed. Insert into to shipment relation
					String sql_ship = "INSERT INTO shipment(shipmentDate, shipmentDESC, warehouseId) VALUES (?, ?, ?)";
					PreparedStatement pstmt_ship = con.prepareStatement(sql_ship);
					pstmt_ship.setDate(1, new java.sql.Date(System.currentTimeMillis()));
					pstmt_ship.setString(2, "ADDED SHIPMENT OF THIS PRODICT");
					pstmt_ship.setInt(3, 1);
					pstmt_ship.executeUpdate();

					// Subtracting the quatity of the products in order from the quatity in the inventory
					String sql_sub = "UPDATE albuminventory SET quantity=? WHERE albumId=?";
					PreparedStatement pstmt_sub = con.prepareStatement(sql_sub);
					pstmt_sub.setInt(1, rs_inner.getInt(1) - rs.getInt("quantity"));
					pstmt_sub.setString(2, rs.getString("albumId"));
					pstmt_sub.executeUpdate();
					orderAlbums.add(new String[]{rs.getInt("albumId") + "", rs.getInt("quantity") + "", rs_inner.getInt("quantity") + "", rs_inner.getInt("quantity") - rs.getInt("quantity") + ""});
				} else {
					// The order can't be proccesed because of insufficient inventory. Rollback
					con.rollback();
					out.println("<div class=\"heading\"><h3>Shipment cannot be processed. Insufficient inventroy for album Id:" + rs.getString("albumName") + ". Please visit back again :)</h3></div>");
					success = false;
					break;
				}
			}
			if (success) {
				con.commit();
				out.println("<table id=\"order-info\"><tr><th>Ordered Product</th><th>Qty</th><th>Previous Inventory</th><th>New Inventory</th></tr>");
				for (String[] album : orderAlbums)
					out.println(String.format("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>", album[0], album[1], album[2], album[3]));
				out.println("</table>");
			}
			con.setAutoCommit(true);
		}
	}
%>   
</table>
</div>                    				
<br>
<div class="heading" style="font-size:18px"><a href="index.jsp">Back to Main Page</a></div>

</body>
</html>
