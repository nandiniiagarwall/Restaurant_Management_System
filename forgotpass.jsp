<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page trimDirectiveWhitespaces="true" %>

<%
    // Database connection parameters
    String url = "jdbc:mysql://localhost:3306/mysql?zeroDateTimeBehavior=convertToNull";
    String user = "root";
    String dbpassword = "";

    // Define variables
    String email = "";
    String securityQuestion = "";
    String securityAnswer = "";
    String newPassword = "";
    boolean passwordResetSuccessful = false;
    boolean formSubmitted = request.getMethod().equalsIgnoreCase("post");

    // Error message
    String errorMessage = "";

    // If form is submitted, process the request
    if (formSubmitted) {
        email = request.getParameter("email");
        securityQuestion = request.getParameter("security_question");
        securityAnswer = request.getParameter("security_answer");
        newPassword = request.getParameter("new_password");

        // JDBC variables
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // Register JDBC driver
            Class.forName("com.mysql.jdbc.Driver");

            // Open a connection
            conn = DriverManager.getConnection(url, user, dbpassword);

            // Execute SQL query to retrieve security question and answer
            String sql = "SELECT security_question, security_answer FROM queenscorner.customers WHERE email=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            rs = pstmt.executeQuery();

            // Check if the email exists
            if (rs.next()) {
                String storedSecurityQuestion = rs.getString("security_question");
                String storedSecurityAnswer = rs.getString("security_answer");

                // Check if the provided security question and answer match the stored values
                if (!securityQuestion.equals(storedSecurityQuestion) || !securityAnswer.equals(storedSecurityAnswer)) {
                    errorMessage = "Incorrect security question or answer. Please try again.";
                } else {
                    // Update password if security answer matches
                    sql = "UPDATE queenscorner.customers SET password=? WHERE email=?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, newPassword);
                    pstmt.setString(2, email);
                    int rowsAffected = pstmt.executeUpdate();

                    if (rowsAffected > 0) {
                        passwordResetSuccessful = true;
                    }
                }
            }
        } catch (SQLException se) {
            // Handle errors for JDBC
            se.printStackTrace();
            out.println("SQL State: " + se.getSQLState() + "<br>");
            out.println("Error Code: " + se.getErrorCode() + "<br>");
            out.println("Message: " + se.getMessage() + "<br>");
        } catch (Exception e) {
            // Handle other exceptions
            e.printStackTrace();
            out.println("Error: " + e.getMessage() + "<br>");
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException se) {
                se.printStackTrace();
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Password Reset</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background-image: url('background_image.jpg');
            background-size: cover;
            background-repeat: no-repeat;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .container {
            background-color: rgba(255, 255, 255, 0.8);
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 400px;
            width: 100%;
        }

        .error-message {
            color: red;
            margin-bottom: 20px;
        }

        label, input, select, button {
            display: block;
            margin-bottom: 20px;
            width: 100%;
            box-sizing: border-box;
        }

        .button-container {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }

        .button-container button {
            width: 48%;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Password Reset</h2>
        <% if (passwordResetSuccessful) { %>
            <p>Password reset successful! <a href="LoginC.html">Login</a> with your new password.</p>
        <% } else { %>
            <% if (!errorMessage.isEmpty()) { %>
                <p class="error-message"><%= errorMessage %></p>
            <% } %>
            <form action="forgotpass.jsp" method="post">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required>

                <label for="security_question">Security Question:</label>
                <select id="security_question" name="security_question" required>
                    <option value="">Select a security question</option>
                    <option value="What is your mother's maiden name?">What is your mother's maiden name?</option>
                    <option value="What is the name of your first pet?">What is the name of your first pet?</option>
                    <!-- Add more options as needed -->
                </select>

                <label for="security_answer">Security Answer:</label>
                <input type="text" id="security_answer" name="security_answer" required>

                <label for="new_password">New Password:</label>
                <input type="password" id="new_password" name="new_password" required>

                <div class="button-container">
                    <button type="submit">Reset Password</button>
                    <button onclick="goToHomePage()">Go Back to Home Page</button>
                </div>
            </form>
        <% } %>
    </div>
    <script>
        function goToHomePage() {
            window.location.href = "Home.html";
        }
    </script>
</body>
</html>
