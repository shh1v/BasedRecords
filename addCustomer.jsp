<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>
<form method="get" action="addcustomer.jsp" class="login-form">
            <%
            String invalid = request.getParameter("invalid");
            if (invalid != null && invalid.equals("true"))
                out.println("<h3 style=\"color:red; margin-bottom:5px;\">Invalid login information</h3>");
            %>
            <input type="text" name="userid" placeholder="Username" required />
            <input type="password" name="pass" placeholder="Password" required />
            <input type="text" name="firstName" placeholder="First Name" required />
            <input type="text" name="lastName" placeholder="Last Name" required />
            <input type="text" name="email" placeholder="Email" required />
            <input type="text" name="phone" placeholder="Phone Number" required />
            <input type="text" name="address" placeholder="Address" required />
            <input type="text" name="city" placeholder="City" required />
            <input type="text" name="state" placeholder="State" required />
            <input type="text" name="postalCode" placeholder="Postal Code" required />
            <input type="text" name="country" placeholder="Country" required />
            <input type="hidden" name="redirect" value="<%=request.getParameter("redirect") != null ? request.getParameter("redirect") : "account.jsp" %>"/>
            <button type="submit" class="login-button">Create Account</button>
        </form>
<%

String userid = "", pass = "", firstName = "", lastName = "", email = "", phone = "", address = "", city = "", state = "", postalCode = "", country = "";

if (request.getParameter("userid") != null) {
    userid = request.getParameter("userid");
    pass = request.getParameter("pass");
    firstName = request.getParameter("firstName");
    lastName = request.getParameter("lastName");
    email = request.getParameter("email");
    phone = request.getParameter("phone");
    address = request.getParameter("address");
    city = request.getParameter("city");
    state = request.getParameter("state");
    postalCode = request.getParameter("postalCode");
    country = request.getParameter("country");
}

getConnection();

con.createStatement().execute("use orders;");

PreparedStatement ps = con.prepareStatement("insert into customer values(?,?,?,?,?,?,?,?,?,?,?)");
ps.setString(1, userid);
ps.setString(2, pass);
ps.setString(3, firstName);
ps.setString(4, lastName);
ps.setString(5, email);
ps.setString(6, phone);
ps.setString(7, address);
ps.setString(8, city);
ps.setString(9, state);
ps.setString(10, postalCode);
ps.setString(11, country);

ps.executeUpdate();

closeConnection();

response.sendRedirect(request.getParameter("redirect") != null ? request.getParameter("redirect") : "account.jsp");


%>