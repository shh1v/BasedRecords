<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>
<html>
<head><title>List all customers</title></head>
<body>
<%

getConnection();

Statement database = con.createStatement();
database.execute("use orders;");


String sql = "SELECT * FROM customer";
ResultSet rst = database.executeQuery(sql);
out.println("<table border =3 > <tr> <th>Customer id  </th> <th>First name</th><th>Last name</th><th>email</th><th>phone number </th> <th>address</th><th>city</th><th>state</th><th>postalCode</th><th>country</th><th>userid</th></tr>");
while(rst.next()){
  
    out.println("<tr>"+"<td>"+rst.getString(1)+"</td>" +"<td>"+rst.getString(2)+"</td>" +"<td>"+rst.getString(3)+"</td>" +"<td>"+rst.getString(4)+"</td>" +"<td>"+rst.getString(5)+"</td>" +"<td>"+rst.getString(6)+"</td>" +"<td>"+rst.getString(7)+"</td>" +"<td>"+rst.getString(8)+"</td>"+"<td>"+rst.getString(9)+"</td>"+"<td>"+rst.getString(10)+"</td>" +"<td>"+rst.getString(11)+ "</td>  </tr>");
}
out.println("</table>");
closeConnection();
%>
</body>
</html>