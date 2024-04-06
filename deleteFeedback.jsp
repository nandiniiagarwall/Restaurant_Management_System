<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Database connection parameters
    String url = "jdbc:mysql://localhost:3306/queenscorner";
    String user = "root";
    String dbpassword = ""; 

    // Get selected feedback email(s) from the form
    String[] feedbackEmails = request.getParameterValues("feedbackEmails");

    // Check if at least one feedback is selected
    if (feedbackEmails == null || feedbackEmails.length == 0) {
        // If no feedback is selected, display a message and redirect back to manager.jsp
        response.sendRedirect("man_feedback.jsp?deletionSuccessful=false&msg=Please select a feedback");
    } else {
        // At least one feedback is selected, proceed with deletion
        // JDBC variables
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Register JDBC driver
            Class.forName("com.mysql.jdbc.Driver");

            // Open a connection
            conn = DriverManager.getConnection(url, user, dbpassword);

            // Delete selected feedback(s)
            String sqlDelete = "DELETE FROM queenscorner.FEEDBACKS WHERE email = ?";
            pstmt = conn.prepareStatement(sqlDelete);
            for (String feedbackEmail : feedbackEmails) {
                pstmt.setString(1, feedbackEmail);
                pstmt.executeUpdate();
            }

            // Display deletion successful message and redirect back to manager.jsp
            response.sendRedirect("man_feedback.jsp?deletionSuccessful=true");
        } catch (SQLException se) {
            se.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Close resources
            try {
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
    <title>Delete Feedback</title>
    <style>
        body {
            background-color: wheat; /* Set your desired background color */
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
            max-width: 800px;
            margin: auto;
            padding: 20px;
            text-align: center;
        }

        .message {
            margin-top: 20px;
            font-size: 18px;
            color: red;
        }
    </style>
</head>
<body>
    <div class="header">
    <a href='Home.html'><img src="homepage.png" alt="Your Image"></a>
</div>
    <div class="container">
        <div class="message">
            <%-- Display the message if provided --%>
            <%= request.getParameter("msg") %>
        </div>
    </div>
</body>
</html>
