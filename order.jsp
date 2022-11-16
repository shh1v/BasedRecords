<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.LocalDateTime" %>
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
            <li><a href="account.jsp">Account</a></li>
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
        double totalAmount = 0;
        boolean displayOrder = true;

        // Check if user is logged in
        customerId = String.valueOf(session.getAttribute("userid"));
        if (customerId == null)
            response.sendRedirect("account.jsp?redirect=order.jsp");

        // User id, password, and server information
        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String uid = "sa";
        String pw = "304#sa#pw";

        HashMap<String, ArrayList<Object>> order = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

        NumberFormat currFormat = NumberFormat.getCurrencyInstance();

        if (order == null || order.size() == 0) {
            displayOrder = false;
        } else {
            // Calculate total 
            for (String album : order.keySet()) {
                ArrayList<Object> product = order.get(album);
                totalAmount += Double.parseDouble((String) product.get(2)) * ((Integer)product.get(3)).intValue();
            }

            // Get DateTime
            LocalDateTime myDateObj = LocalDateTime.now();
            DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            String orderDate = myDateObj.format(myFormatObj);

            // Address info
            String address="", city="", state="", postalCode="", country="";
            try (Connection con = DriverManager.getConnection(url, uid, pw)) {
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
                stmt = con.prepareStatement("INSERT INTO ordersummary(orderDate, totalAmount, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry, customerId) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
                stmt.setString(1, orderDate);
                stmt.setDouble(2, totalAmount);
                stmt.setString(3, address);
                stmt.setString(4, city);
                stmt.setString(5, state);
                stmt.setString(6, postalCode);
                stmt.setString(7, country);
                stmt.setString(8, customerId);

                stmt.executeUpdate();

                // Find orderId
                stmt = con.prepareStatement("SELECT orderId FROM ordersummary WHERE customerId = ? AND orderDate = ? AND totalAmount = ?");
                stmt.setString(1, customerId);
                stmt.setString(2, orderDate);
                stmt.setDouble(3, totalAmount);
                
                result = stmt.executeQuery();
                if (result.next()) {
                    orderId = result.getString("orderId");
                }
            }
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
                    <th>Total Amount</th>
                </tr>
                <!-- Values -->
                <tr>
                    <td><%=orderId%></td>
                    <td><%=customerId%></td>
                    <td><%=customerName%></td>
                    <td><%=currFormat.format(totalAmount)%></td>
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
        </div>
    
    <% } else { %>

        <div>
            <h1 class="warning">Your cart is empty</h1>
        </div>
    
    <% } %>

    <% 
    // Get customer id
    String custId = request.getParameter("customerId");
    @SuppressWarnings({"unchecked"})
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    // Determine if valid customer id was entered
    // Determine if there are products in the shopping cart
    // If either are not true, display an error message

    // Make connection

    // Save order information to database


      /*
      // Use retrieval of auto-generated keys.
      PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);			
      ResultSet keys = pstmt.getGeneratedKeys();
      keys.next();
      int orderId = keys.getInt(1);
      */

    // Insert each item into OrderProduct table using OrderId from previous INSERT

    // Update total amount for order record

    // Here is the code to traverse through a HashMap
    // Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price

    /*
      Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
      while (iterator.hasNext())
      { 
        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
        ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
        String productId = (String) product.get(0);
            String price = (String) product.get(2);
        double pr = Double.parseDouble(price);
        int qty = ( (Integer)product.get(3)).intValue();
                ...
      }
    */

    // Print out order summary

    // Clear cart if order placed successfully
    %>
  </body>
</html>