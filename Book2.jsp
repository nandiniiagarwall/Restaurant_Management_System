<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <style>
        /* CSS styles */
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            margin: 0;
            padding: 0;
            background-image: url('Donut.jpg');
            background-repeat: no-repeat;
            background-size: cover;
            background-position: center;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            font-size: 24px; /* Adjust the font size as needed */
            font-weight: bold; /* Make the text bold */
            position: relative; /* Ensure relative positioning */
        }

        .header {
            background-color: peru;
            color: #fff;
            text-align: left;
            padding: 5px;
            position: absolute; /* Position at the top */
            top: 0; /* Stick to the top */
            width: 100%; /* Full width */
        }

        .header img {
            max-width: 2%;
            height: 2%;
            cursor: pointer; 
        }
    </style>
</head>
<body>
    <div class="header">
        <a href='Home.html'><img src="homepage.png" alt="Your Image"></a>
    </div>
<%
    // Java code
    // Database connection parameters
    String url = "jdbc:mysql://localhost:3306/queenscorner";
    String user = "root";
    String dbpassword = ""; 

    // Get form parameters
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String contact = request.getParameter("contact");
    String date = request.getParameter("date");
    String time = request.getParameter("time");
    String party_size = request.getParameter("partysize");

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

            // Execute SQL query with PreparedStatement to fetch available tables
            String sqlSelect = "SELECT t_id, capacity FROM queenscorner.TABLES WHERE status = 'available' AND capacity >= ?";
            pstmt = conn.prepareStatement(sqlSelect);
            pstmt.setString(1, party_size);

            rs = pstmt.executeQuery();

            boolean tablesAvailable = rs.next();

            // Display available tables as radio buttons
            if (tablesAvailable) {
%>
                <div style='text-align:center; padding:20px;'>Select a table:</div>
                <form id="confirmationForm" action="BookConfirmation.jsp" method="post">
                    <div style='text-align:center; padding:20px;'>
<%
                        do {
%>
                            <input type="radio" name="t_id" value="<%= rs.getString("t_id") %>"> Table: <%= rs.getString("t_id") %>, Capacity: <%= rs.getString("capacity") %><br>
<%
                        } while (rs.next());
%>
                    </div>
                    
                    <input type="hidden" name="name" value="<%= name %>">
                    <input type="hidden" name="email" value="<%= email %>">
                    <input type="hidden" name="contact" value="<%= contact %>">
                    <input type="hidden" name="date" value="<%= date %>">
                    <input type="hidden" name="time" value="<%= time %>">
                    <input type="hidden" name="partysize" value="<%= party_size %>">
                    <center>
                        <button type="submit" class="confirm-button">Confirm Table</button>
                    </center>
                </form>
            
<%
            }
            
            
            else {
%>
                <div style='text-align:center; padding:20px;'>Sorry, no table available for the selected party size. <a href="Home.html">Go back</a></div>
<%
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
        
    }
    
%>
</body>
</html>
