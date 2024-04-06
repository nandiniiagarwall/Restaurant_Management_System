<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Menu</title>
    <style>
        body {
    font-family: 'Garamond', 'Times New Roman', serif;
    background-color: #f8f1e5; /* Creamy background color */
    margin: 0;
    padding: 0;
}
        .item {
            margin-bottom: 10px;
        }
        .header {
        background-color: peru;
        color: #fff;
        text-align: left;
        padding: 5px;
    }
    .header img {
        max-width:2%;
        height: 2%;
        cursor: pointer; 
    }
        .item h3, .item p {
            display: inline-block;
            margin: 0;
        }
        .item h3 {
            margin-right: 10px;
        }
    </style>
</head>
<body>
<%
    String url = "jdbc:mysql://localhost:3306/queenscorner";
    String user = "root";
    String dbpassword = "";  
    
    boolean updatedSuccessfully = false; // Flag to track if any item was updated
    boolean deletedSuccessfully = false; // Flag to track if any item was deleted
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection connection = DriverManager.getConnection(url, user, dbpassword);

        if (request.getMethod().equals("POST")) {
            String updateButton = request.getParameter("updateButton");
            String deleteButton = request.getParameter("deleteButton");

            if (deleteButton != null && deleteButton.equals("Delete")) {
                String[] selectedItems = request.getParameterValues("selected_items");
                if (selectedItems != null) {
                    for (String itemName : selectedItems) {
                        String deleteQuery = "DELETE FROM menu_items WHERE item_name = ?";
                        PreparedStatement deleteStatement = connection.prepareStatement(deleteQuery);
                        deleteStatement.setString(1, itemName);
                        int rowsAffected = deleteStatement.executeUpdate();
                        if (rowsAffected > 0) {
                            deletedSuccessfully = true; // Set flag to true if at least one item is deleted
                        }
                        deleteStatement.close();
                    }
                }
            }
            
            if (updateButton != null && updateButton.equals("Update")) {
                String itemNameToUpdate = request.getParameter("item_name_to_update");
                if (itemNameToUpdate != null && !itemNameToUpdate.isEmpty()) {
                    String newItemName = request.getParameter("new_item_name");
                    double newPrice = Double.parseDouble(request.getParameter("new_price"));

                    String updateQuery = "UPDATE menu_items SET item_name = ?, price = ? WHERE item_name = ?";
                    PreparedStatement updateStatement = connection.prepareStatement(updateQuery);
                    updateStatement.setString(1, newItemName);
                    updateStatement.setDouble(2, newPrice);
                    updateStatement.setString(3, itemNameToUpdate);

                    int rowsAffectedUpdate = updateStatement.executeUpdate();
                    if (rowsAffectedUpdate > 0) {
                        updatedSuccessfully = true; // Set flag to true if at least one item is updated
                    }
                    updateStatement.close();
                }
            }
        }

        String query = "SELECT item_name, price FROM menu_items";
        PreparedStatement preparedStatement = connection.prepareStatement(query);
        ResultSet resultSet = preparedStatement.executeQuery();
    %>
    <center>
        <h2>Our Menu</h2>
        <form method="post">
            <%
                while (resultSet.next()) {
                    String itemName = resultSet.getString("item_name");
                    double itemPrice = resultSet.getDouble("price");
            %>
            <div class="header">
    <a href='Home.html'><img src="homepage.png" alt="Your Image"></a>
</div>
            <div class="item">
                <input type="checkbox" name="selected_items" value="<%= itemName %>">
                <h3><%= itemName %></h3>
                <p>Price: <%= itemPrice %></p>
            </div>
            <%
                }
            %>
            <div>
                <label for="item_name_to_update">Item to Update:</label>
                <input type="text" id="item_name_to_update" name="item_name_to_update"><br>
                <label for="new_item_name">New Item Name:</label>
                <input type="text" id="new_item_name" name="new_item_name"><br>
                <label for="new_price">New Price:</label>
                <input type="text" id="new_price" name="new_price"><br>
                <input type="submit" value="Update" name="updateButton">
                <input type="submit" value="Delete" name="deleteButton">
            </div>
            <% if (updatedSuccessfully) { %>
                <p>Item(s) updated successfully.</p>
            <% } %>
            <% if (deletedSuccessfully) { %>
                <p>Item(s) deleted successfully.</p>
            <% } %>
        </form>
    </center>
    <%
        resultSet.close();
        preparedStatement.close();
        connection.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
</body>
</html>