<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Database connection parameters
    String url = "jdbc:mysql://localhost:3306/mysql?zeroDateTimeBehavior=convertToNull";
    String user = "root";
    String dbpassword = "";

    // Get Table_Id parameter from the request
    String t_id = request.getParameter("Table_Id");

    // JDBC variables
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // Register JDBC driver
        Class.forName("com.mysql.jdbc.Driver");

        // Open a connection
        conn = DriverManager.getConnection(url, user, dbpassword);

        // Start a transaction
        conn.setAutoCommit(false);

        // Execute SQL query with PreparedStatement to update table status to available
        String sqlUpdate = "UPDATE queenscorner.TABLES SET status = 'available' WHERE t_id = ?";
        pstmt = conn.prepareStatement(sqlUpdate);
        pstmt.setString(1, t_id);
        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            // Commit transaction if the table status is successfully updated

            // Delete booking details from the BOOK table
            String sqlDelete = "DELETE FROM queenscorner.book WHERE t_id = ?";
            pstmt = conn.prepareStatement(sqlDelete);
            pstmt.setString(1, t_id);
            rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                conn.commit();
%>
                <html lang="en">
                <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Cancel Confirmation</title>
                <style>
                    body {
                        margin: 0;
                        padding: 0;
                        background-image: url('background.jpg'); /* Change the background image */
                        background-size: cover;
                        font-family: Arial, sans-serif;
                        overflow: hidden; /* Hide scrollbar */
                    }
                    .header {
        background-color: peru;
        color: #fff;
        text-align: left;
        padding: 10px;
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
                        font-size: 24px; /* Adjust font size as needed */
                        color: white; /* Adjust font color */
                        background-color: rgba(0, 0, 0, 0.5); /* Adjust background color opacity */
                        border-radius: 10px; /* Adjust border radius as needed */
                    }
                </style>
                </head>
                <body>
                    <div class="header">
        <a href='Home.html'><-Back</a>
    </div>
                    <div class="container">
                        <div class="message">
                            Booking canceled successfully.
                        </div>
                    </div>
                </body>
                </html>
<%
            } else {
%>
                <div style='text-align:center; padding:20px;'>Failed to cancel table. Please try again later.</div>
<%
            }
        } else {
%>
            <div style='text-align:center; padding:20px;'>Failed to cancel table. Please try again later.</div>
<%
        }
    } catch (SQLException se) {
        if (conn != null) {
            try {
                conn.rollback(); // Rollback the transaction if an exception occurs
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        se.printStackTrace();
        out.println("SQL State: " + se.getSQLState() + "<br>");
        out.println("Error Code: " + se.getErrorCode() + "<br>");
        out.println("Message: " + se.getMessage() + "<br>");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage() + "<br>");
    } finally {
        // Close resources and reset auto-commit
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        } catch (SQLException se) {
            se.printStackTrace();
        }
    }
%>
