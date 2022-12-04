<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8" %>
<!DOCTYPE html>
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
	<link href="https://fonts.googleapis.com/css2?family=Lato:wght@300;400;700;900&display=swap"
		rel="stylesheet" />
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
					<li><a href="account.jsp">
							<%= session.getAttribute("userid")==null ? "Login" :
								session.getAttribute("userid") %>
						</a></li>
				</ul>
			</nav>
			<a href="cart.jsp">
				<img src="Assets/shopping-cart.png" width="40px" height="40px" />
			</a>
		</div>
	</div>

				<div class="heading">
					<h1>Order List</h1>
					<br>
				</div>

<% //Note: Forces loading of SQL Server driver
try { // Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	}
catch (java.lang.ClassNotFoundException e) {
		out.println("ClassNotFoundException: " +e);
	}

		// Useful code for formatting currency values:
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		// out.println(currFormat.format(5.0);  // Prints $5.00

		// User id, password, and server information
		String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
		String uid="sa";
		String pw="304#sa#pw";
		try ( Connection con=DriverManager.getConnection(url, uid, pw);
			Statement stmt=con.createStatement(); ) { // Write query to retrieve all order summary records
			String sql="Select ordersummary.orderId,ordersummary.customerId,customer.firstName,customer.lastName,ordersummary.totalAmount from ordersummary join customer on ordersummary.customerId=customer.customerId";
			ResultSet rst=stmt.executeQuery(sql);
			while(rst.next()) {
				out.println("<div class=\"products\"><table id=\"records\"><tr><th>OrderId</th><th>Customer Id</th><th>Customer Name</th><th> Total Amount </th></tr>");
				out.println("<tr><td>"+rst.getString(1)+"</td>"+"<td>"+rst.getString(2)+"</td>"+"<td>"+rst.getString(3)+ rst.getString(4)+ "</td>"+"<td>"+currFormat.format(rst.getDouble(5))+"</td></tr>");
				out.println("<tr><td colspan=4><table border=\"1\" style=\"width:100%\"><tr><th>Product Id</th><th>Quantity</th><th>Price </th></tr>");
				String sql2="Select orderalbum.albumId, quantity, albumPrice from orderalbum join album on orderalbum.albumId=album.albumId where orderId=? ";
				PreparedStatement pstmt=con.prepareStatement(sql2);
				pstmt.setString(1, rst.getString(1));
				ResultSet rs=pstmt.executeQuery();

				while(rs.next()) {
					out.println("<tr><td>"+rs.getString(1)+"</td><td>"+rs.getString(2)+"</td><td>" + currFormat.format(rs.getDouble(3))+"</td></tr>");
				}
				out.println("</table></td></tr>");
				out.println("<tr><td><h4><a href=\"ship.jsp?orderId=" + rst.getString(1) + " \">Ship Now</a></h4></td></tr>");
				out.println("</table></div>");
			}
		} catch (SQLException ex) {
			out.println(ex);
		}
%>

			</body>

			</html>