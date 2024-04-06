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

    <form action="rough2.jsp" method="post">
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
                    String url = "jdbc:mysql://localhost:3306/queenscorner";
                    String user = "root";
                    String dbpassword = "";

                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection connection = DriverManager.getConnection(url, user, dbpassword);

                        String query = "SELECT price FROM menu_items WHERE item_name = ?";
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
