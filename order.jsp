<%@ page import="java.sql.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html lang="en">
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

    <!------------------------------------>
    <!-- MOVE DATA TO AND FROM DATABASE -->
    <!------------------------------------>

    <%
        // Global variable that we need while constructing the tables
        String orderId = "default", customerId = "default", customerName = "default";
        double totalAmount = 0, finalAmount = 0, tax = 0;;
        boolean displayOrder = true;


        // Check if user is logged in
        if (session.getAttribute("customerId") == null) {
            response.sendRedirect("account.jsp?redirect=order.jsp");
            return; // So that no attempt is made to run the rest of the file
        } else {
            customerId = String.valueOf(session.getAttribute("customerId"));
        }

        // User id, password, and server information
        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String uid = "sa";
        String pw = "304#sa#pw";

        //Note: Forces loading of SQL Server driver
        try {	// Load driver class
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (java.lang.ClassNotFoundException e) {
            out.println("ClassNotFoundException: " +e);
        }

        Connection con = null;
        try {
          con = DriverManager.getConnection(url, uid, pw);
        } catch (SQLException e) {
          out.println("SQLException: " + e);
        }
          
        HashMap<String, ArrayList<Object>> order = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

        NumberFormat currFormat = NumberFormat.getCurrencyInstance();

        if (order == null || order.size() == 0) {
            displayOrder = false;
        } else {
              // Get DateTime
              LocalDateTime myDateObj = LocalDateTime.now(ZoneId.of("America/Vancouver"));
              DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
              String orderDate = myDateObj.format(myFormatObj);

              // Address info
              String address="", city="", state="", postalCode="", country="";
          
              PreparedStatement stmt = con.prepareStatement("SELECT firstName, lastName, address, city, state, postalCode, country FROM customer WHERE customerId = ?");
              stmt.setString(1, customerId);
              ResultSet result = stmt.executeQuery();
              if (result.next()) {
                  customerName = result.getString("firstName") + " " + result.getString("lastName");
                  address = result.getString("address");
                  city = result.getString("city");
                  state = result.getString("state");
                  postalCode = result.getString("postalCode");
                  country = result.getString("country");
              }

              // Insert new ordersummary entry
              stmt = con.prepareStatement("INSERT INTO ordersummary(orderDate, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry, customerId) VALUES (?, ?, ?, ?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS);
              stmt.setString(1, orderDate);
              stmt.setString(2, address);
              stmt.setString(3, city);
              stmt.setString(4, state);
              stmt.setString(5, postalCode);
              stmt.setString(6, country);
              stmt.setString(7, customerId);

              stmt.executeUpdate();

              // Find orderId
              ResultSet generatedKeys = stmt.getGeneratedKeys();
              if (generatedKeys.next()) {
                  orderId = String.valueOf(generatedKeys.getInt(1));
              }

              // Add each ordered product to the orderalbum table
              stmt = con.prepareStatement("INSERT INTO orderalbum VALUES (?, ?, ?, ?)");
              for (String album : order.keySet()) {
                  stmt.setString(1, orderId);
                  stmt.setString(2, (String) order.get(album).get(0)); // AlbumId
                  int quantity = (int) order.get(album).get(3);
                  stmt.setInt(3, quantity); // Quantity
                  Double price = Double.parseDouble( (String) order.get(album).get(2));
                  stmt.setDouble(4, price); // Price
                  stmt.executeUpdate();

                  totalAmount += price * quantity;
              }

              // Add tax
              stmt = con.prepareStatement("SELECT taxRate FROM customer c JOIN stateTax s ON c.country = s.country AND c.state = s.state WHERE customerId = ?");
              stmt.setString(1, customerId);
              ResultSet taxTable = stmt.executeQuery();

              if (taxTable.next())
                  tax = totalAmount * taxTable.getDouble("taxRate");

              finalAmount = totalAmount + tax;

              // Update ordersummary with totalAmount
              stmt = con.prepareStatement("UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?");
              stmt.setDouble(1, totalAmount);
              stmt.setString(2, orderId);
              stmt.executeUpdate();
            }

        // Clear order from session history
        session.setAttribute("productList", null);
    %>

    <!--------------------->
    <!-- ORDER SUMMARIES -->
    <!--------------------->

    <% if (displayOrder) { %>

        <div class="heading">
            <h1>Order Placed!</h1>
        </div>
    
        <div class="summary">
            <!-- CUSTOMER INFO -->
            <div class="customer-info">
                <table id="customer-info">
                <!-- Header -->
                <tr>
                    <th>Order ID</th>
                    <th>Customer ID</th>
                    <th>Customer Name</th>
                    <th>Tax</th>
                    <th>Total Amount</th>
                </tr>
                <!-- Values -->
                <tr>
                    <td><%=orderId%></td>
                    <td><%=customerId%></td>
                    <td><%=customerName%></td>
                    <td><%=currFormat.format(tax)%></td>
                    <td><%=currFormat.format(finalAmount)%></td>
                </tr>
                </table>
            </div>
            
            <!-- ORDER INFO -->
            <div class="order-info">
                <table id="order-info">
                    <!-- Header -->
                    <tr>
                        <th>Album ID</th>
                        <th>Album Name</th>
                        <th>Quantity</th>
                        <th>Price Each</th>
                        <th>Sub Total</th>
                    </tr>
                    <!-- Values -->
                    <%
                        for (String album : order.keySet()) {
                            ArrayList<Object> productInfo = order.get(album);
                            out.println("<tr>");
                                out.println("<td>" + productInfo.get(0) + "</td>");
                                out.println("<td>" + productInfo.get(1) + "</td>");
                                out.println("<td>" + productInfo.get(3) + "</td>");
                                out.println("<td>" + currFormat.format(Double.parseDouble((String) productInfo.get(2))) + "</td>");
                                out.println("<td>" + currFormat.format(Double.parseDouble((String) productInfo.get(2)) * ((Integer)productInfo.get(3)).intValue()) + "</td>");
                            out.println("</tr>");
                        }
                    %>
                </table>
                </div>
                <div class="heading">
                  <br><h1>Shipping Address</h1><br>
                      <%
                          Statement database = con.createStatement();
                          database.execute("use orders;");

                          PreparedStatement stmt = con.prepareStatement("SELECT firstName, lastName, address, city, state, postalCode, country FROM customer WHERE customerId = ?");
                          stmt.setString(1, customerId);

                          ResultSet result = stmt.executeQuery();

                          String firstName = "", lastName = "", address = "", city = "", state = "", postalCode = "", country = "";
                          if (result.next()) {
                              firstName = result.getString("firstName");
                              lastName = result.getString("lastName");
                              address = result.getString("address");
                              city = result.getString("city");
                              state = result.getString("state");
                              postalCode = result.getString("postalCode");
                              country = result.getString("country");
                          }

                          try {
                            con.close();
                          } catch (Exception e) {
                            e.printStackTrace();
                          }
                      %>
                <p><%=firstName%> <%=lastName%></p>
                <p><%=address%></p>
                <p><%=city%>, <%=state%> <%=postalCode%></p>
                <p><%=country%></p>
              </div>
              <div class="end-cart-options">
                <br>
                <a href=<%="ship.jsp?orderId=" + orderId%>><h2>Ship the order</h2></a>
              </div>
        </div>
    
    <% } else { %>

        <div>
            <h1 class="warning">Your cart is empty</h1>
        </div>
    
    <% } %>
  </body>
</html>