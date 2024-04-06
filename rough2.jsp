<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmation</title>
</head>
<body>
    <h2>Order Confirmation</h2>

    <%-- Retrieve customer details from the previous page --%>
    <% String name = request.getParameter("name");
       String address = request.getParameter("address");
    %>

    <%-- Save the order details in the database --%>
    <% 
       // Connect to the database
       String url = "jdbc:mysql://localhost:3306/mysql?zeroDateTimeBehavior=convertToNull";
       String user = "root";
       String dbpassword = "";

       try {
           Class.forName("com.mysql.jdbc.Driver");
           Connection connection = DriverManager.getConnection(url, user, dbpassword);

           // Insert customer details into the orders table
           String insertOrderQuery = "INSERT INTO roughwork.orders (customer_name, address) VALUES (?, ?)";
           PreparedStatement insertOrderStatement = connection.prepareStatement(insertOrderQuery);
           insertOrderStatement.setString(1, name);
           insertOrderStatement.setString(2, address);
           insertOrderStatement.executeUpdate();

           // Retrieve the order ID
           String getOrderIDQuery = "SELECT LAST_INSERT_ID() AS order_id";
           PreparedStatement getOrderIDStatement = connection.prepareStatement(getOrderIDQuery);
           ResultSet resultSet = getOrderIDStatement.executeQuery();
           int orderID = 0;
           if (resultSet.next()) {
               orderID = resultSet.getInt("order_id");
           }

           // Insert order items into the order_items table
           String[] selectedItems = request.getParameterValues("selected_items[]");
           String[] quantities = request.getParameterValues("quantity[]");

           if (selectedItems != null && quantities != null) {
               for (int i = 0; i < selectedItems.length; i++) {
                   String itemName = selectedItems[i];
                   int quantity = Integer.parseInt(quantities[i]);

                   String insertOrderItemQuery = "INSERT INTO roughwork.order_items (order_id, item_name, quantity) VALUES (?, ?, ?)";
                   PreparedStatement insertOrderItemStatement = connection.prepareStatement(insertOrderItemQuery);
                   insertOrderItemStatement.setInt(1, orderID);
                   insertOrderItemStatement.setString(2, itemName);
                   insertOrderItemStatement.setInt(3, quantity);
                   insertOrderItemStatement.executeUpdate();
               }
           }

           // Close database connections
           resultSet.close();
           insertOrderStatement.close();
           getOrderIDStatement.close();
           connection.close();

           // Display confirmation message
    %>
           <h3>Order Confirmed!</h3>
           <p>Your order has been confirmed. Thank you for choosing us!</p>
    <%
       } catch (Exception e) {
           e.printStackTrace();
    %>
           <h3>Error</h3>
           <p>An error occurred while processing your order. Please try again later.</p>
    <%
       }
    %>
</body>
</html>
