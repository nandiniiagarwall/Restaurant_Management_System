<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>South Indian</title>
    <style>
        body {
    font-family: 'Comic Sans MS', sans-serif;
    background-image: url('menusi.jpg');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
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
.South-container {
    width: 600px;
    padding: 20px;
    background-color: rgba(255, 255, 255, 0.3);
    border-radius: 10px;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.3);
    color: black;
    text-align: left;
    margin: 0 auto; /* Center the container horizontally */
}

.South-item {
    width: 90%; /* Adjust the width as needed */
    height: 15px; /* Adjust the height as needed */
    margin-bottom: 20px;
    padding: 10px;
    background-color: #f8f8f8;
    border-radius: 8px;
    transition: background-color 0.3s ease;
    display: flex; /* Make the item a flex container */
    justify-content: space-between; /* Align item name and price at each end */
    align-items: center; /* Align items vertically */
}

.South-name {
    font-weight: bold;
    text-align: left;
    margin: 0; /* Reset margin to avoid extra spacing */
}

.South-price {
    font-weight: bold;
    color: black;
    margin: 0; /* Reset margin to avoid extra spacing */
}

.item {
    margin-bottom: 10px;
}

.item h3,
.item p {
    margin: 0; /* Reset margin to avoid extra spacing */
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

        String query = "SELECT item_name, price FROM menu_items where mc_id=003";
        PreparedStatement preparedStatement = connection.prepareStatement(query);

        ResultSet resultSet = preparedStatement.executeQuery();

        %>
        <div class="South-container">
            <center><h2>South Indian</h2></center>
        
        <%
        while (resultSet.next()) {
            String itemName = resultSet.getString("item_name");
            double itemPrice = resultSet.getDouble("price");
        %>
        <div class="South-item">
                
                <h3><%= itemName %></h3>
                <p> <%= itemPrice %></p>
            </div>
            <%
        
        
        
        
    %>
        <%
        }
        %>
        
        
        </div>
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
</body>
</html>
