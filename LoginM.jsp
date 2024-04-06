<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Processing</title>
</head>
<body>
    <%
            
        String url = "jdbc:mysql://localhost:3306/mysql?zeroDateTimeBehavior=convertToNull";
        String user = "root";
        String dbpassword = "";

       
        
       
        String email = request.getParameter("email");
        String password = request.getParameter("password");
       
        
        
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = DriverManager.getConnection(url, user, dbpassword);

            // Create a PreparedStatement to query the database
            String query = "SELECT * FROM queenscorner.manager WHERE email=? AND password=?";
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, email);
            preparedStatement.setString(2, password);

            // Execute the query
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                
    %>
<center><h2>Login Successful</h2>
                <p>Welcome, <%= email %>!</p>
                <a href="ManagerHome.html">Go to Home Page</a></center>
    <%
            } else {
                
    %>
                <h2>Login Failed</h2>
                <p>Invalid Email Id or password. Please try again.</p>
    <%
            }

            // Close resources
            resultSet.close();
            preparedStatement.close();
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
    %>
            <h2>Error</h2>
            <p>An error occurred. Please try again later.</p>
    <%
        }
    %>
</body>
</html>