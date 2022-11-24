<%@ page import="java.sql.*" %>
<html>
<head>
<title>Customer info</title>
</head>
<body> 
<% 
String customerId;
if (session.getAttribute("customerId") == null) {
    response.sendRedirect("account.jsp?redirect=order.jsp");
    return; // So that no attempt is made to run the rest of the file
} else {
    customerId = String.valueOf(session.getAttribute("customerId"));
}

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";
try
( Connection con = DriverManager.getConnection(url, uid, pw);
Statement stmt = con.createStatement(); ) {

String sql = "SELECT * from customer where customerId=?";
PreparedStatement pstmt=con.prepareStatement(sql);
pstmt.setString(1,customerId);
ResultSet rs=pstmt.executeQuery();
rs.next();
out.println("<table border=2>");
 out.println("<tr><td>"+"Customer Id"+"</td>" +"<td>"+rs.getString(1)+"</td></tr>"); 
 out.println("<tr><td>"+"First Name"+"</td>" +"<td>"+rs.getString(2)+"</td></tr>"); 
 out.println("<tr><td>"+"Last name"+"</td>" +"<td>"+rs.getString(3)+"</td></tr>"); 
 out.println("<tr><td>"+"email"+"</td>" +"<td>"+rs.getString(4)+"</td></tr>"); 
 out.println("<tr><td>"+"phone number "+"</td>" +"<td>"+rs.getString(5)+"</td></tr>"); 
 out.println("<tr><td>"+"address"+"</td>" +"<td>"+rs.getString(6)+"</td></tr>"); 
 out.println("<tr><td>"+"City"+"</td>" +"<td>"+rs.getString(7)+"</td></tr>"); 
 out.println("<tr><td>"+"State"+"</td>" +"<td>"+rs.getString(8)+"</td></tr>"); 
 out.println("<tr><td>"+"Postal code "+"</td>" +"<td>"+rs.getString(9)+"</td></tr>"); 
 out.println("<tr><td>"+"Country"+"</td>" +"<td>"+rs.getString(10)+"</td></tr>"); 
 out.println("<tr><td>"+"User id "+"</td>" +"<td>"+rs.getString(11)+"</td></tr>"); 

 out.println("</table>");
} 
catch (SQLException ex)
 { 
     out.println(ex); 
    }
%>
</body>
</html>