<%-- 
    Document   : ourland22
    Created on : 8 Mar, 2024, 3:12:44 PM
    Author     : RCTI
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu</title>
    <style>
    body {
    font-family: 'Garamond', 'Times New Roman', serif;
    background-color: #f8f1e5; /* Creamy background color */
    margin: 0;
    padding: 0;
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
header1 {
    background-color: #764c29; /* Rich brown */
    color: #f8f1e5; /* Creamy white */
    text-align: center;
    padding: 1em;
    font-size: 1.5em;
}

main {
    max-width: 800px;
    margin: 20px auto;
    background-color: #f5f5f5; /* Light gray background */
    padding: 20px;
    border-radius: 10px; /* Rounded corners for a classy look */
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
}

.item {
    border: 1px solid #ccc;
    border-radius: 5px;
    padding: 15px;
    margin-bottom: 20px;
    background-color: #eae2d2; /* Light beige */
    display: flex;
    align-items: center;
}

.item input[type="checkbox"] {
    margin-right: 15px;
}

.item h3, .item p {
    margin: 0;
     display: inline-block;
}

.item h3 {
    font-size: 1.5em;
    color: #764c29; /* Rich brown */
}

.item p {
    margin-left: auto;
    margin-right: 20px;
    color: #555;
    font-size: 1.2em;
}

.item input[type="number"] {
    width: 50px;
    padding: 8px;
    font-size: 1.2em;
}

input[type="submit"] {
    background-color: #a76e3c; /* Darker brown */
    color: #f8f1e5;
    padding: 12px 20px;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-size: 1.2em;
}

input[type="submit"]:hover {
    background-color: #764c29; /* Lighter brown on hover */
}
</style>
</head>
<body>
    <div class="header">
    <a href='Home.html'><img src="homepage.png" alt="Your Image"></a>
</div>
<%
                String url = "jdbc:mysql://localhost:3306/queenscorner";
                String user = "root";
                String dbpassword = ""; 
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection connection = DriverManager.getConnection(url, user, dbpassword);

        String query = "SELECT item_name, price FROM menu_items";
        PreparedStatement preparedStatement = connection.prepareStatement(query);

        ResultSet resultSet = preparedStatement.executeQuery();

        %>
<center><h2>MENU ITEMS</h2><h5>SELECT THE ITEMS AND QUANTITY</h5></center>
<main> 
<center><form id="orderForm" method="post" action="Order_online.jsp">
        <div class="heading">
           <h3>
                
                <span style="color: black; margin-right: 550px;">Item Name</span>
                
                <span style="color: black; margin-right: 10px;">Price</span>
                
                <span style="color: black;">Quantity</span>
            </h3>
        </div>
        <%
        while (resultSet.next()) {
            String itemName = resultSet.getString("item_name");
            double itemPrice = resultSet.getDouble("price");
        %>
            <div class="item">
                <input type="hidden" name="item_names[]" value="<%= itemName %>">
                <input type="checkbox" name="selected_items[]" value="<%= itemName %>">
                <h3><%= itemName %></h3>
                <p><%= itemPrice %></p>
                <input type="number" name="quantity[]" value="1" min="1" onchange="updateQuantity(this)">
            </div>
        <%
        }
        %>
        <input type="submit" value="Proceed to Order">
        
        </form>
        </center>
    
    <%
        resultSet.close();
        preparedStatement.close();
        connection.close();
    } catch (Exception e) {
        e.printStackTrace();
    %>
        
    <%
        
    }
%>

<script>
    // Function to update the corresponding quantity based on user input
    function updateQuantity(input) {
        var checkbox = input.previousElementSibling.previousElementSibling;
        if (!checkbox.checked) {
            return; // Exit function if the checkbox is not checked
        }
        var newValue = parseInt(input.value); // Parse the input value as an integer
        if (isNaN(newValue) || newValue < 1) {
            input.value = 1; // Set quantity to 1 if the input value is not a valid number or less than 1
        }
    }
</script>

</body>
</html>