<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
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
            <li><a href="index.jsp">Shop</a></li>
            <li><a href="order.jsp">Orders</a></li>
            <li><a href="account.jsp">Account</a></li>
          </ul>
        </nav>
        <a href="cart.jsp">
          <img src="Assets/shopping-cart.png" width="40px" height="40px" />
        </a>
      </div>
    </div>

    <!--------------------->
    <!-- ORDER SUMMARIES -->
    <!--------------------->

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
            <td>1</td>
            <td>1</td>
            <td>Louis Lascelles-Palys</td>
            <td>$34.99</td>
          </tr>
        </table>
      </div>
      <!-- ORDER INFO -->
      <div class="order-info">
        <table id="order-info">
          <!-- Header -->
          <tr>
            <th>Product ID</th>
            <th>Quantity</th>
            <th>Price</th>
          </tr>
          <!-- Values -->
          <tr>
            <td>4</td>
            <td>1</td>
            <td>$34.99</td>
          </tr>
        </table>
      </div>
    </div>
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
