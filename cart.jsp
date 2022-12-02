<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
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

    <!--------------------->
    <!-- SHOPPING CART ---->
    <!--------------------->
    <%
    // Get the current list of products
    @SuppressWarnings({"unchecked"})
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    if (productList == null)
    {	out.println("<H1 class=\"heading\">Your shopping cart is empty!</H1>");
      productList = new HashMap<String, ArrayList<Object>>();
    }
    else
    {
      NumberFormat currFormat = NumberFormat.getCurrencyInstance();

      out.println("<h1 class=\"cart\" style=\"color: white\">Your Shopping Cart</h1>");
      out.print("<div class=\"cart\"><table id=\"cart\"><tr><th>Product Id</th><th>Product Name</th><th>Price</th><th>Quantity</th><th>Subtotal</th><th>Remove</th>");

      double total = 0;
      Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
      while (iterator.hasNext()) 
      {	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
        ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
        if (product.size() < 4)
        {
          out.println("Expected product with four entries. Got: "+product);
          continue;
        }
        // Setting the product ID and product Name
        out.print("<tr><td>"+product.get(0)+"</td>");
        out.print("<td>"+product.get(1)+"</td>");

        Object price = product.get(2);
        Object itemqty = product.get(3);
        double pr = 0;
        int qty = 0;
        
        try
        {
          pr = Double.parseDouble(price.toString());
        }
        catch (Exception e)
        {
          out.println("Invalid price for product: "+product.get(0)+" price: "+price);
        }
        try
        {
          qty = Integer.parseInt(itemqty.toString());
        }
        catch (Exception e)
        {
          out.println("Invalid quantity for product: "+product.get(0)+" quantity: "+qty);
        }		

        out.print("<td align=\"right\">"+currFormat.format(pr)+"</td>");
        out.print("<td align=\"right\"><form method=\"get\" action=\"updateItem.jsp\"><input type=\"hidden\" id=\"id\" name=\"id\" value=" + product.get(0).toString() + "><input type=\"number\" min=1 name=\"quantity\" value=\"" + qty + "\"/><button type=\"submit\" value=\"Submit\">Update Quantity</button></form></td>");

        out.print("<td align=\"right\">"+currFormat.format(pr*qty)+"</td>");
        out.print("<td align=\"center\"><a href=\"removeItem.jsp?id=" + product.get(0) + "\"><img src=\"Assets/trash-can.png\" width=\"40px\" height=\"40px\"/></a></td></tr>");

        out.println("</tr>");
        total = total +pr*qty;
        
      }
      out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
          +"<td align=\"right\">"+currFormat.format(total)+"</td></tr>");
      out.println("</table></div>");
    }
    %>
    <div class="end-cart-options">
      <a href="order.jsp"><h1>Checkout</h1></a>
      <h2>//</h2>
      <a href="index.jsp"><h1>Continue Shopping</h1></a>
    </div>
  </body>
</html>
