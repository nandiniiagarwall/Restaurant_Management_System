<%-- 
    Document   : logout
    Created on : 22 Mar, 2024, 1:27:25 AM
    Author     : RCTI
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Logout Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .container {
            text-align: center;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }

        h1 {
            color: #333;
            margin-bottom: 20px;
        }

        button {
            background-color: blue;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: skyblue;
        }
    </style>
    <script>
        function confirmLogout() {
            var confirmation = confirm("Are you sure you want to logout?");
            if (confirmation) {
                // Redirect to logout process
                logout();
            }
        }

        function logout() {
            // Invalidate the session to log out the user
            <% session.invalidate(); %>
            // Display message in a dialog box
            alert("You have been logged out successfully!");
            // Redirect to login page or any other page
            window.location.href = "Home1.html"; // Replace with your login page or any other page
        }
    </script>
</head>
<body>
    
    <div class="container">
        <h1>Logout from the website..??</h1>
        <button onclick="confirmLogout()">Logout</button>
    </div>
</body>
</html>