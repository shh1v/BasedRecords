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
<title>YOUR NAME Grocery Shipment Processing</title>
</head>
<body>
<%
	// TODO: Get order id
	String orderId = String.valueOf(request.getParameter("orderId"));
	if (orderId == null) {
		// It was not redirected from order.jsp
	} else {
		boolean success = true;
		String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
		String uid = "sa";
		String pw = "304#sa#pw";

		try (Connection con = DriverManager.getConnection(url, uid, pw);) {
			con.setAutoCommit(false);
			String sql = "SELECT * FROM orderalbum WHERE orderId=?";
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(orderId));
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				String sql_inner = "SELECT quantity FROM albuminventory WHERE albumId=?";
				PreparedStatement pstmt_inner = con.prepareStatement(sql_inner);
				pstmt_inner.setString(1, rs.getString(2));
				ResultSet rs_inner = pstmt_inner.executeQuery();
				rs_inner.next();
				if (rs_inner.getInt(1) > rs.getInt(3)) {
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
					pstmt_sub.setInt(1, rs_inner.getInt(1) - rs.getInt(3));
					pstmt_sub.setString(2, rs.getString(2));
					pstmt_sub.executeUpdate();
					out.println(String.format("Ordered Product: %d, Qty: %d, Previous Inventory: %d, New Inventory: %d\n", rs.getInt(1), rs.getInt(3), rs_inner.getInt(1), rs_inner.getInt(1) - rs.getInt(3)));
				} else {
					// The order can't be proccesed because of insufficient inventory. Rollback
					con.rollback();
					out.println("Shipment not done. Insufficient inventroy for album Id:" + rs.getString(2));
					success = false;
					break;
				}
				if (success)
					con.commit();
				con.setAutoCommit(true);
			}
		}
	}
          
	// TODO: Check if valid order id
	
	// TODO: Start a transaction (turn-off auto-commit)
	
	// TODO: Retrieve all items in order with given id
	// TODO: Create a new shipment record.
	// TODO: For each item verify sufficient quantity available in warehouse 1.
	// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
	
	// TODO: Auto-commit should be turned back on
%>                       				

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>
