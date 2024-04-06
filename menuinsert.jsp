<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add New Menu Item</title>
    
</head>
<body>
    
    <style>body {
        font-family: 'Garamond', 'Times New Roman', serif;
        background-color: #f8f1e5;; /* Set the background color to green */
        color: black;
        font-size: 10px;
        border-radius: 15px;
        font-weight: normal;
        font-size: 12pt;
        font-family: Lobster,sans-serif;
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
    }</style>
        
<%
    // Database connection parameters
    String url = "jdbc:mysql://localhost:3306/queenscorner";
    String username = "root";
    String password = "";

    // Dropdown options for menu category
    String[] categories = {"001", "002", "003", "004", "005", "006"};

    // Form submission handling
    if (request.getMethod().equals("POST")) {
        String itemName = request.getParameter("itemName");
        double price = Double.parseDouble(request.getParameter("price"));
        String category = request.getParameter("category");

        Connection conn = null;
        PreparedStatement statement = null;

        try {
            // Connect to the database
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url, username, password);

            // Prepare SQL statement to insert new menu item
            String sql = "INSERT INTO menu_items (item_name, price, mc_id) VALUES (?, ?, ?)";
            statement = conn.prepareStatement(sql);
            statement.setString(1, itemName);
            statement.setDouble(2, price);
            statement.setString(3, category);

            // Execute the SQL statement
            int rowsInserted = statement.executeUpdate();
            if (rowsInserted > 0) {
                out.println("<p>Menu item added successfully!</p>");
            } else {
                out.println("<p>Failed to add menu item.</p>");
            }
        } catch (ClassNotFoundException e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } catch (SQLException e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (statement != null) {
                    statement.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                out.println("<p>Error closing database resources: " + ex.getMessage() + "</p>");
                ex.printStackTrace();
            }
        }
    }
%>
<div class="header">
    <a href='Home.html'><img src="homepage.png" alt="Your Image"></a>
</div>
<center><h2>Add New Menu Item</h2>
<form method="post" action="">
    <label for="itemName">Item Name:</label><br>
    <input type="text" id="itemName" name="itemName" required><br><br>
    <label for="price">Price:</label><br>
    <input type="number" id="price" name="price" step="0.01" required><br><br>
    <label for="category">Category:</label><br>
    <select id="category" name="category">
        <% for (String cat : categories) { %>
            <option value="<%= cat %>"><%= cat %></option>
        <% } %>
    </select><br><br>
    <input type="submit" value="Add Item">
</form>
</center>
</body>
</html>
