<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

String id = request.getParameter("id");
String newqty = request.getParameter("quantity");

// Updating the quantity of the product in the list
ArrayList<Object> product = (ArrayList<Object>) productList.get(id);
product.set(3, new Integer(newqty));
session.setAttribute("productList", productList);
%>
<jsp:forward page="cart.jsp" />