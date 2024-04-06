<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Database connection parameters
    String url = "jdbc:mysql://localhost:3306/mysql?zeroDateTimeBehavior=convertToNull";
                String user = "root";
                String dbpassword = "";
   

    // Get form parameters
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String contact = request.getParameter("contact");
    String date = request.getParameter("date");
    String time = request.getParameter("time");
    String party_size = request.getParameter("partysize");
    String t_id= request.getParameter("t_id");

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

        // Execute SQL query with PreparedStatement to update table status to occupied
        String sqlUpdate = "UPDATE queenscorner.TABLES SET status = 'occupied' WHERE t_id = ?";
        pstmt = conn.prepareStatement(sqlUpdate);
        pstmt.setString(1, t_id);
        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            // Commit transaction if the table status is successfully updated
            conn.commit();

            // Insert booking details into the BOOK table
            String sqlInsert = "INSERT INTO queenscorner.book (name, email, contact, date, time, party_size, t_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sqlInsert);
            pstmt.setString(1, name);
            pstmt.setString(2, email);
            pstmt.setString(3, contact);
            pstmt.setString(4, date);
            pstmt.setString(5, time);
            pstmt.setString(6, party_size);
            pstmt.setString(7, t_id);
            rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
%>
                <html lang="en">
                <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Thank You Page</title>
                <style>
                    body {
                        margin: 0;
                        padding: 0;
                        background-image: url('Donut.jpg');
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
                            Thank you! your table has been booked
                        </div>
                    </div>
                    <div class="btn-container">
                        <form action="Home.html">
                            <input type="submit" value="Back" class="btn">
                        </form>
                    </div>
                    <div class="btn-container">
                        <form action="book_cancel.jsp" method="post">
                            <input type="hidden" name="Table_Id" value="<%= t_id %>">
                            <input type="submit" value="Cancel Your Table" class="btn-cancel">
                        </form>

                    </div>
                </body>
                </html>
<%
            }
        } else {
%>
            <div style='text-align:center; padding:20px;'>Failed to book table. Please try again later.</div>
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
   
    // Assuming you've already established a database connection and confirmed the booking

// Insert into notifications table
// Perform booking confirmation logic...

// Insert into notifications table

%>