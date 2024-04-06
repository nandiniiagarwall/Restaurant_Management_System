<!-- manager.jsp -->
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedbacks</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('ST1.webp');
            background-size: cover;
            background-repeat: no-repeat;
            background-attachment: fixed;
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
        .feedback-container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #f5f5f5;
            border-radius: 5px;
            background-color: rgba(255, 255, 255, 0.4);
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
        }
        .feedback-item {
            margin-bottom: 10px;
        }
        .delete-feedback {
            margin-top: 10px;
        }
        .notification {
            background-color: #4CAF50;
            color: white;
            text-align: center;
            padding: 10px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="header">
    <a href='Home.html'><img src="homepage.png" alt="Your Image"></a>
</div>
    <div class="feedback-container">
        <h2>Feedbacks</h2>
        <form action="deleteFeedback.jsp" method="post">
            <%
                // Database connection parameters
                String url = "jdbc:mysql://localhost:3306/queenscorner";
                String user = "root";
                String dbpassword = ""; 

                // JDBC variables
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    // Register JDBC driver
                    Class.forName("com.mysql.jdbc.Driver");

                    // Open a connection
                    conn = DriverManager.getConnection(url, user, dbpassword);

                    // Fetch existing feedback data
                    String sqlSelect = "SELECT email, name, rating, comment FROM feedbacks";
                    pstmt = conn.prepareStatement(sqlSelect);
                    rs = pstmt.executeQuery();

                    // Display existing feedback with checkboxes for selection
                    while (rs.next()) {
                        String reviewerEmail = rs.getString("email");
                        String reviewerName = rs.getString("name");
                        String reviewerRating = rs.getString("rating");
                        String reviewerComment = rs.getString("comment");

                        // Display fetched feedback with checkbox
            %>
                        <div class="feedback-item">
                            <input type="checkbox" name="feedbackEmails" value="<%= reviewerEmail %>">
                            <strong><%= reviewerName %></strong> - <%= reviewerEmail %> - Rating: <%= reviewerRating %><br>
                            Comment: <%= reviewerComment %>
                        </div>
            <%
                    }
                } catch (SQLException se) {
                    se.printStackTrace();
                } catch (Exception e) {
                    e.printStackTrace();
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
            %>
            <button class="delete-feedback" type="submit">Delete Selected Feedback</button>
        </form>
        <button class="back" onclick="goToHomepage()">Back</button> <!-- Back button outside the form -->
            <!-- Deletion successful message and back to homepage button -->
        <% 
            // Check if deletion successful parameter is present in the request
            String deletionSuccessful = request.getParameter("deletionSuccessful");
            if ("true".equals(deletionSuccessful)) {
        %>
            <div class="notification">Deletion Successful | <a href="Home.html">Back to Home Page</a></div>
        <% } %>
    </div>
   
    <script>        
        function goToHomepage() {
            window.location.href = "Home.html"; // Replace with your homepage URL
        }
    </script>
</body>
</html>