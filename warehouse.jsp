<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<html>
<head> <title> Warehouse </title> </head>
<body>

    <%
    String filter = request.getParameter("filter");
    String name = request.getParameter("warehouseName");
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
        <form method="get" action="warehouse.jsp" class="search-bar">
          <input type="text" placeholder="Search our records" name="productName" value="<%= name %>" />
          <button type="submit"><img src="Assets/search-icon.png" /></button>
        </form>
      </div>

    <!------------>
    <!-- FILTER -->
    <!------------>  

    <div class="filter">
      <h1>Filter by genre:</h1>
      <form method="get" action="warehouse.jsp">
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
        String SQL = "SELECT warehouseName FROM warehouse";
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

  <%
    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
      /* productId, productName, ArtistName, Genre, Price */
      String SQL = "SELECT warehouse.warehouseId,warehouse.warehouseName,albuminventory.albumId,quantity from warehouse join albuminventory on warehouse.warehouseId=albuminventory.warehouseId";
      if (!name.equals("")) {
        SQL += " WHERE warehouseName LIKE ?";
        if (!filter.equals("")) {
          SQL += " AND warehouseName LIKE ?";
        }
      }
      if (name.equals("") && !filter.equals("")) {
        SQL += " WHERE warehouseName LIKE ?";
      }
      PreparedStatement pstmt = con.prepareStatement(SQL);
      if (!name.equals("")) {
        pstmt.setString(1, "%" + name + "%");
      }
      if (!filter.equals("")) {
        pstmt.setString(!name.equals("") ? 2 : 1, "%" + filter + "%");
      }
      ResultSet rslt = pstmt.executeQuery();
      boolean hasRows = false;
      while (rslt.next()) {
        if (!hasRows) {
          hasRows = true;
          out.println("<div class=\"products\"><table id=\"records\"><tr><th>warehouse Id</th><th>Warehouse Name</th><th>Album id </th><th>quantity</th></tr>");
          }
          out.println(String.format("<tr><td> "+ rslt.getString(1)+"</td>" +"<td>"+rslt.getString(2)+"</td>"+"<td>"+rslt.getString(3)+"</td>"+rslt.getString(4)+"</td></tr>"));
        }
        out.println("</table></div>");
      }
      %>
</body>
</html>