<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Processing</title>
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
</head>
<body>
   

    <div id="messageDiv"></div> <!-- Hidden div for displaying messages -->

    <%
        // Database connection parameters
        String url = "jdbc:mysql://localhost:3306/queenscorner";
        String user = "root";
        String dbpassword = "";

        // Get form parameters
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = DriverManager.getConnection(url, user, dbpassword);

            // Create a PreparedStatement to query the database
            String query = "SELECT * FROM QUEENSCORNER.CUSTOMERS WHERE email=? AND password=?";
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, email);
            preparedStatement.setString(2, password);

            // Execute the query
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                // User found, login successful
                String name = resultSet.getString("name");
                session.setAttribute("name", name);
    %>
                <script>
                    document.getElementById('messageDiv').innerHTML = " <h1>Welcome to our Restaurant!</h1><br>Login Successful. Welcome, <%= email %>! <br> Wait for few Seconds...";
                    
                    document.getElementById('messageDiv').style.display = 'block'; // Show the message
                    setTimeout(function() {
                        window.location.replace("Home.html");
                    }, 3000); // Redirect after 3 seconds
                </script>
    <%
            } else {
                // User not found, login failed
    %>
                <script>
                    document.getElementById('messageDiv').innerHTML = "Login Failed. Invalid email or password.<br> Please try again.";
                    document.getElementById('messageDiv').style.display = 'block'; // Show the message
                    setTimeout(function() {
                        window.location.replace("LoginC.html");
                    }, 3000); // Redirect after 3 seconds
                </script>
    <%
            }

            // Close resources
            resultSet.close();
            preparedStatement.close();
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
    %>
            <script>
                document.getElementById('messageDiv').innerHTML = "An error occurred. Please try again later.";
                document.getElementById('messageDiv').style.display = 'block'; // Show the message
                setTimeout(function() {
                    window.location.replace("LoginC.html");
                }, 3000); // Redirect after 3 seconds
            </script>
    <%
        }
    %>
</body>
</html>