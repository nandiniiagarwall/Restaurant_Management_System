<%-- 
    Document   : processorder22
    Created on : 8 Mar, 2024, 3:16:43 PM
    Author     : RCTI
--%>

<%@page import="java.sql.*"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>

<style>
    body {
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
    }
</style>

<div id="messageDiv"></div>

<%
   String name = request.getParameter("name");
   String address = request.getParameter("address");
   String formattedDate = ""; // Initialize formattedDate to handle potential errors

   try {
       Date currentDate = new Date();
       SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
       formattedDate = dateFormat.format(currentDate);
   } catch (Exception e) {
       e.printStackTrace();
   }
%>

<%
   Connection connection = null;
   PreparedStatement insertOrderStatement = null;

   try {
       String url = "jdbc:mysql://localhost:3306/mysql?zeroDateTimeBehavior=convertToNull";
       String user = "root";
       String dbpassword = ""; 

       Class.forName("com.mysql.jdbc.Driver");
       connection = DriverManager.getConnection(url, user, dbpassword);

       String insertOrderQuery = "INSERT INTO ROUGHWORK.ORDERS (customer_name, address, order_date) VALUES (?, ?, ?)";
       insertOrderStatement = connection.prepareStatement(insertOrderQuery, Statement.RETURN_GENERATED_KEYS);
       insertOrderStatement.setString(1, name);
       insertOrderStatement.setString(2, address);
       insertOrderStatement.setString(3, formattedDate);
       insertOrderStatement.executeUpdate();

       ResultSet generatedKeys = insertOrderStatement.getGeneratedKeys();
       int orderID = 0;
       if (generatedKeys.next()) {
           orderID = generatedKeys.getInt(1);
       }

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
               insertOrderItemStatement.close();
           }
       }

       generatedKeys.close();
       insertOrderStatement.close();
       connection.close();

%>
       <script>
           document.getElementById('messageDiv').innerHTML = "<h1>Your order is confirmed! Thanks for choosing us! <br> Wait for a few seconds...</h1>";
           document.getElementById('messageDiv').style.display = 'block'; // Show the message
           setTimeout(function() {
               window.location.replace("Home.html");
           }, 3000);
       </script>
<%
   } catch (Exception e) {
       e.printStackTrace();
%>
       <h3>Error</h3>
       <p>An error occurred while processing your order. Please try again later.</p>
<%
   } finally {
       try {
           if (insertOrderStatement != null) insertOrderStatement.close();
           if (connection != null) connection.close();
       } catch (SQLException ex) {
           ex.printStackTrace();
       }
   }
%>
