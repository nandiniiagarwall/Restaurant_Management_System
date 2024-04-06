<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurant Reviews</title>
    <style>
       body {
            font-family: 'Arial', sans-serif;
            background-image: url('n1.jpg');
            background-color: #f5f5f5;
            background-size: cover;
            background-repeat: no-repeat;
            background-attachment: fixed;
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
        .reviews-container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #c0c0c0;
            background-color: rgba(255, 255, 255, 0.4);
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            color: #333;
        }

        .review {
            border-bottom: 1px solid #ccc;
            padding: 10px;
            margin-bottom: 10px;
        }

        .review p {
            margin: 0;
        }

        .reviewer-name {
            font-weight: bold;
            color: black;
        }

        .feedback-button {
            display: block;
            margin: 20px auto;
            padding: 8px; /* Adjusted size */
            background-color: #808000;
            color: #fff;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }

        .feedback-form {
            display: none;
            text-align: center;
        }

        .feedback-form label {
            display: inline-block; /* Display labels and input fields in the same line */
            width: 30%; /* Adjust the width of labels */
            margin: 7px auto;
            text-align: center;
            vertical-align: top;/* Align text to the left */
        }

        .feedback-form textarea,
        .feedback-form input,
        .feedback-form select {
            width: 40%; /* Adjusted width of input fields */
            padding: 8px;
            margin: 5px auto;
            box-sizing: border-box;
            display: inline-block;
            justify-content: center;
            align-items: center;/* Display input fields in the same line */
        }

        .submit-button {
            display: block;
            margin: 20px auto;
            padding: 8px; /* Adjusted size */
            background-color: #808000;
            color: #fff;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }

        .back {
            display: block;
            margin-top: 20px;
            padding: 10px;
            background-color: #808080;
            color: #fff;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }

        a {
            color: #007bff;
            text-decoration: none;
        }
    </style><!-- Your CSS and other meta tags -->
</head>
<body>
    <div class="header">
    <a href='Home.html'><img src="homepage.png" alt="Your Image"></a>
</div>
    <div class="reviews-container">
        <h2>Restaurant Reviews</h2>

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
                String sqlSelect = "SELECT name,comment FROM FEEDBACKS";
                pstmt = conn.prepareStatement(sqlSelect);
                rs = pstmt.executeQuery();
        
                int count = 0; // Track the number of records
        
                // Display existing feedback in the reviews section
                while (rs.next()) {
                    String reviewerName = rs.getString("name");
                    String reviewerComment = rs.getString("comment");
                    
                    count++;
        
                    // Display fetched feedback
                    %>
                    <div class="review">
                        <p class="reviewer-name"><%= reviewerName %></p>
                        <p><strong>Comment:</strong> <%= reviewerComment %></p>
                    </div>
                    <%
                    
                    // Show dropdown arrow after the top three records
                    if (count == 3) {
                    %>
                    <div class="dropdown">
                        <button onclick="toggleReviews(this)">Show More Reviews</button>
                        <div class="dropdown-content" style="display: none;">
                    <% } %>
                <% } %>
                </div> <!-- Close dropdown-content -->
            </div> <!-- Close dropdown -->
        <% } catch (SQLException se) {
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

        <form action="Feedbacks.jsp" method="post" onsubmit="return validateForm()">
        
        <p>Please provide your valuable feedback:</p>
        
        <button class="feedback-button" onclick="showFeedbackForm()">Give your Feedback</button>

        <div class="feedback-form">
            <label for="name">Your Name:</label>
            <input type="text" id="name" name="name" required>

            <label for="email">Email Id:</label>
            <input type="text" name="email" required>

            <label for="rating">Rating:</label>
            <select id="rating" name="rating" required>
                <option value="5">Excellent</option>
                <option value="4">Very Good</option>
                <option value="3">Good</option>
                <option value="2">Fair</option>
                <option value="1">Can be better</option>
            </select>
            
            <label for="comment">Comment:</label>
            <textarea id="comment" name="comment" rows="4" cols="50" required></textarea>
            
            <button class="submit-button" onclick="showThanksMessage()">Submit</button>
        </div>
    

    
<!--    <p id="thanksMessage" style="display: none;">Thanks for your feedback!</p>-->

    <!-- "Show Less Reviews" button moved here -->
    <button class="feedback-button" onclick="toggleReviews(this)" style="display:none;">Show Less Reviews</button>

    <button class="back" onclick="goToHomepage()">Back</button>
    </form>
    </div>

    <script>
        function showFeedbackForm() {
        var feedbackForm = document.querySelector('.feedback-form');
        feedbackForm.style.display = 'block';
    }

        function goToHomepage() {
        window.location.href = "Home.html";
    }

        function showThanksMessage() {
        var thanksMessage = document.getElementById('thanksMessage');
        thanksMessage.style.display = 'block';
    }

           function toggleReviews(button) {
            var dropdownContent = document.querySelector('.dropdown-content');
            var reviewsContainer = document.querySelector('.reviews-container');
            var reviews = reviewsContainer.querySelectorAll('.review');
            var feedbackForm = document.querySelector('.feedback-form');

            if (dropdownContent.style.display === 'block') {
                dropdownContent.style.display = 'none';
                button.innerText = 'Show More Reviews';

                // Move button between the last feedback and the feedback form
                var lastFeedback = reviews[reviews.length - 1];
                reviewsContainer.insertBefore(button, feedbackForm);
                reviewsContainer.insertBefore(document.createElement('br'), feedbackForm);
            } else {
                dropdownContent.style.display = 'block';
                button.innerText = 'Show Less Reviews';

                // Move button to the end of the last feedback
                reviewsContainer.appendChild(button);
                reviewsContainer.appendChild(document.createElement('br'));
            }
        }

    </script>
</body>
</html>