<%@ page import="java.sql.*" %>
<%
    String logout = request.getParameter("logout");
    if (logout != null) {
        session.setAttribute("customerId", null);
        session.setAttribute("userid", null);
        response.sendRedirect("account.jsp");
        return;
    }
    String userid = request.getParameter("userid");
    String pass = request.getParameter("pass");

    if (userid != null) {
        //Note: Forces loading of SQL Server driver
        try {	// Load driver class
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (java.lang.ClassNotFoundException e) {
            out.println("ClassNotFoundException: " +e);
        }

        // User id, password, and server information
        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String uid = "sa";
        String pw = "304#sa#pw";
        try ( Connection con = DriverManager.getConnection(url, uid, pw); ) {
            PreparedStatement stmt = con.prepareStatement("SELECT password, customerId FROM customer WHERE userid = ?");
            stmt.setString(1,userid);
            ResultSet result = stmt.executeQuery();
            String actualPass = null;
            int id = 0;
            while (result.next()) {
                actualPass = result.getString(1);
                id = result.getInt("customerId");
            }

            if (actualPass != null && pass.equals(actualPass)) {
                // If they entered the right password
                session.setAttribute("customerId", id);
                session.setAttribute("userid", userid);
                String redirect = request.getParameter("redirect");
                response.sendRedirect(redirect != null ? redirect : "account.jsp");
            } else {
                // If they entered the wrong password
                response.sendRedirect("account.jsp?invalid=true&redirect=" + request.getParameter("redirect"));
            }
        }
    }
%>