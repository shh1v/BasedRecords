<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery Order List</title>
</head>
<body>

<h1>Order List</h1>

<%
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Useful code for formatting currency values:
 NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);  // Prints $5.00

// User id, password, and server information
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";
try
( Connection con = DriverManager.getConnection(url, uid, pw);
Statement stmt = con.createStatement(); )
{
// Write query to retrieve all order summary records
String sql= "Select ordersummary.orderId,ordersummary.customerId,customer.firstName,customer.lastName,ordersummary.totalAmount from ordersummary join customer on ordersummary.customerId=customer.customerId";
ResultSet rst = stmt.executeQuery(sql);
out.println("<table border=\"1\"><tr><th>OrderId</th><th>Customer Id</th><th>Customer Name</th><th> Total Amount </th></tr>");
while(rst.next()){
	out.println("<tr><td>"+rst.getString(1)+"</td>"+"<td>"+rst.getString(2)+"</td>"+"<td>"+rst.getString(3)+ " "+rst.getString(4)+ "</td>"+"<td>"+currFormat.format(rst.getDouble(5))+"</td>"+"</tr>");
		out.println("<tr><td><table border=\"1\"><tr><th>Product Id</th><th>Quantity</th><th>Price </th></tr>");
			String sql2="Select albumId, quantity, albumPrice from orderalbum where orderId=? ";
			PreparedStatement pstmt=con.prepareStatement(sql2);
			pstmt.setString(1, rst.getString(1));
			ResultSet rs=pstmt.executeQuery();
			while(rs.next()){
				out.println("<tr><td>"+rs.getString(1)+"</td>"+"<td>"+rs.getString(2)+"</td>"+"<td>"+currFormat.format(rs.getDouble(3))+"</td>"+"</tr>");
}
out.println("</table></td></tr>");

}
out.println("</table>");


// For each order in the ResultSet

	// Print out the order summary information
	// Write a query to retrieve the products in the order
	//   - Use a PreparedStatement as will repeat this query many times
	// For each product in the order
		// Write out product information 

// Close connection
}
catch (SQLException ex) { out.println(ex); }
%>

</body>
</html>

