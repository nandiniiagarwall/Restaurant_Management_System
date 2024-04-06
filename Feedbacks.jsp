
<%@ page import="java.text.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<%
    // Database connection parameters
    String url = "jdbc:mysql://localhost:3306/queenscorner";
                String user = "root";
                String dbpassword = ""; 

    // Get form parameters
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String rating = request.getParameter("rating");
    String comment = request.getParameter("comment");

    // Check if the email ends with "@gmail.com"
    if (!email.endsWith("@gmail.com")) {
%>
    <div style='text-align:center; padding:20px;'>Invalid email format. Please enter a valid Gmail address. <a href="Feedback.html">Go back</a></div>
<%
    } else {
        // JDBC variables
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        boolean submissionSuccessful = false;

        try {
            // Register JDBC driver
            Class.forName("com.mysql.jdbc.Driver");

            // Open a connection
            conn = DriverManager.getConnection(url, user, dbpassword);

            // Execute SQL query with PreparedStatement to insert feedback
            String sqlInsert = "INSERT INTO FEEDBACKS (name, email, rating, comment) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sqlInsert);
            pstmt.setString(1, name);
            pstmt.setString(2, email);
            pstmt.setString(3, rating);
            pstmt.setString(4, comment);

            int rowsAffected = pstmt.executeUpdate();

            // Check if insertion was successful
            if (rowsAffected > 0) {
                submissionSuccessful = true;
            } else {
                System.out.println("No rows affected during submission.");
            }

        } catch (SQLException se) {
            se.printStackTrace();
            out.println("SQL State: " + se.getSQLState() + "<br>");
            out.println("Error Code: " + se.getErrorCode() + "<br>");
            out.println("Message: " + se.getMessage() + "<br>");
        } catch (Exception e) {
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

      if (submissionSuccessful) {
%>
 <!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Thank You Page</title>
<style>
    body {
        margin: 0;
        padding: 0;
        background-image: url('n1.jpg');
        background-size: cover;
        font-family: Arial, sans-serif;
        overflow: hidden; /* Hide scrollbar */
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
    .container {
        display: flex;
        justify-content: center;
        align-items: center;
        height: calc(100vh - 100px); /* Adjusted height to fit within a single screen */
    }
    .message {
        text-align: center;
        padding: 20px;
        font-size: 48px; /* Adjust font size as needed */
        color: white; /* Adjust font color */
        background-color: rgba(0, 0, 0, 0.5); /* Adjust background color opacity */
        border-radius: 10px; /* Adjust border radius as needed */
    }
    .btn-container {
        text-align: center;
        margin-top: -20px; /* Adjusted margin to move the button slightly higher */
    }
    .btn {
        padding: 10px 20px;
        font-size: 18px;
        background-color: #4CAF50; /* Button background color */
        color: white; /* Button text color */
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }
    .btn:hover {
        background-color: #45a049; /* Button background color on hover */
    }
</style>
</head>
<body>
    <div class="header">
    <a href='Home.html'><img src="homepage.png" alt="Your Image"></a>
</div>
    <div class="container">
        <div class="message">
            Thanks for your Feedback
        </div>
    </div>
    <div class="btn-container">
        <form action="Home.html">
            <input type="submit" value="Back" class="btn">
        </form>
    </div>
</body>
</html>
<%
      }
    }
%>
