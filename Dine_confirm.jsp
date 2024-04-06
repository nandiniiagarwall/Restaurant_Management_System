<%-- 
    Document   : processorder22
    Created on : 8 Mar, 2024, 3:16:43 PM
    Author     : RCTI
--%>

<%@page import="java.sql.*"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%--<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>--%>

<%-- Retrieve customer details from the previous page --%>
<%
   String name = request.getParameter("name");
   String tableno = request.getParameter("tableno");
   // Get the current date and time
   Date currentDate = new Date();
   SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   String formattedDate = dateFormat.format(currentDate);

%>
<style>body {
            background-color: #f9f3ed; /* Light beige background */
            font-family: 'Arial', sans-serif; /* Common restaurant font */
            margin: 0;
            padding: 0;
        }

        #messageDiv {
            display: none;
            background-color: #ffd699; /* Light orange background */
            color: #8b4513; /* Saddle brown text color */
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
            text-align: center;
        }

        h1 {
            color: #8b0000; /* Dark red header */
            text-align: center;
        }</style>
<div id="messageDiv"></div>
<script>
    document.getElementById('messageDiv').innerHTML = " <h1>Ypur order is confirmed!Thanks for choosing us! <br> Wait for few Seconds...";
                    
                    document.getElementById('messageDiv').style.display = 'block'; // Show the message
                    setTimeout(function() {
                        window.location.replace("Home.html");
                    }, 3000);</script>
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
       String insertOrderQuery = "INSERT INTO ROUGHWORK.ORDERSD (customer_name, tableno) VALUES (?, ?)";
       PreparedStatement insertOrderStatement = connection.prepareStatement(insertOrderQuery, Statement.RETURN_GENERATED_KEYS);
       insertOrderStatement.setString(1, name);
       insertOrderStatement.setString(2, tableno);
       insertOrderStatement.executeUpdate();

       // Retrieve the order ID
       ResultSet generatedKeys = insertOrderStatement.getGeneratedKeys();
       int orderID = 0;
       if (generatedKeys.next()) {
           orderID = generatedKeys.getInt(1);
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
                insertOrderItemStatement.close(); // Close the statement after execution

                 }
               }

       // Close database connections
       generatedKeys.close();
       insertOrderStatement.close();
       connection.close();

       // Display confirmation message
%>
       
<%
   } catch (Exception e) {
       e.printStackTrace();
%>
       <h3>Error</h3>
       <p>An error occurred while processing your order. Please try again later.</p>
<%
   }
%>