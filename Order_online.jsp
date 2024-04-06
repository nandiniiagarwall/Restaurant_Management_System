<%-- 
    Document   : dinein22
    Created on : 8 Mar, 2024, 3:14:22 PM
    Author     : RCTI
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmation</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
            color: #333;
            margin: 0;
            padding: 0;
            text-align: center;
        }

        h2 {
            background-color: #333;
            color: white;
            padding: 10px;
        }

        a {
            background-color: #333;
            color: white;
            padding: 10px;
            text-decoration: none;
            border-radius: 5px;
            margin-bottom: 20px;
            display: inline-block;
        }

        form {
            max-width: 600px;
            margin: 0 auto;
            background-color: beige;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: left;
        }

        label {
            display: block;
            margin-bottom: 10px;
            font-size: 16px;
        }

        input[type="text"],
        textarea {
            width: 100%;
            padding: 8px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
        }

        h3 {
            color: #333;
            margin-top: 20px;
        }

        p {
            margin: 5px 0;
        }

        input[type="submit"] {
            background-color: #a76e3c; /* Darker brown */
            color: black;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        input[type="submit"]:hover {
            background-color: #764c29;
        }
    </style>
</head>
<body>
   
    <h2>Order Confirmation</h2>
     <a href="menu_online.jsp">Menu</a>

    <form action="Online_confirm.jsp" method="post">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" required><br><br>

        <label for="address">Address:</label>
        <textarea id="address" name="address" required></textarea><br><br>

        <!-- Display selected items and quantities -->
        <h3>Selected Items:</h3>
        <%
            double totalBill = 0.0;
            String[] selectedItems = request.getParameterValues("selected_items[]");
            String[] quantities = request.getParameterValues("quantity[]");

            if (selectedItems != null && quantities != null) {
                for (int i = 0; i < selectedItems.length; i++) {
                    String itemName = selectedItems[i];
                    int quantity = Integer.parseInt(quantities[i]);

                    // Retrieve item price from the database
                    String url = "jdbc:mysql://localhost:3306/mysql?zeroDateTimeBehavior=convertToNull";
                String user = "root";
                String dbpassword = "";

                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection connection = DriverManager.getConnection(url, user, dbpassword);

                        String query = "SELECT price FROM queenscorner.menu_items WHERE item_name = ?";
                        PreparedStatement preparedStatement = connection.prepareStatement(query);
                        preparedStatement.setString(1, itemName);

                        ResultSet resultSet = preparedStatement.executeQuery();

                        if (resultSet.next()) {
                            double itemPrice = resultSet.getDouble("price");
                            totalBill += itemPrice * quantity;

                            // Display the item name, quantity, and subtotal
                            %>
                            <p><%= itemName %> - Quantity: <%= quantity %>, Subtotal: <%= itemPrice * quantity %></p>
                            <%
                        }

                        resultSet.close();
                        preparedStatement.close();
                        connection.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        %>

        <!-- Display total bill -->
        <h3>Total Bill: <%= totalBill %></h3>

        <input type="submit" value="Confirm Order">
        
    </form>
</body>
</html>