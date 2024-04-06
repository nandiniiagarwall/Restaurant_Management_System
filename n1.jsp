<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!--<html>
<head>
    <style>
        
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            margin: 0;
            padding: 0;
            background-image: url('ST1.webp');
            background-repeat: no-repeat;
            background-size: cover;
            background-position: center;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        </style>
    <body>-->
    <%
    // Database connection parameters
    String url = "jdbc:mysql://localhost:3306/queenscorner";
    String user = "root";
    String dbpassword = ""; 

    // Get form parameters
    String name = request.getParameter("Name");
    String email = request.getParameter("EmailId");
    String contact = request.getParameter("Contact");
    String date = request.getParameter("Date");
    String time = request.getParameter("Time");
    String party_size = request.getParameter("PartySize");

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
            String sqlSelect = "SELECT t_id, capacity FROM QUEENSCORNER.TABLES WHERE status = 'available' AND capacity >= ?";
            pstmt = conn.prepareStatement(sqlSelect);
            pstmt.setString(1, party_size);

            rs = pstmt.executeQuery();

            boolean tablesAvailable = rs.next();

            // Display available tables as radio buttons
            if (tablesAvailable) {
    %>
                <div style='text-align:center; padding:20px;'>Select a table:</div>
                <form id="confirmationForm" action="confirmbooking.jsp" method="post">
                    <div style='text-align:center; padding:20px;'>
    <%
                        do {
    %>
                            <input type="radio" name="t_id" value="<%= rs.getString("t_id") %>"> Table: <%= rs.getString("t_id") %>, Capacity: <%= rs.getString("capacity") %><br>
    <%
                        } while (rs.next());
    %>
                    </div>
                    <input type="hidden" name="Name" value="<%= name %>">
                    <input type="hidden" name="EmailId" value="<%= email %>">
                    <input type="hidden" name="Contact" value="<%= contact %>">
                    <input type="hidden" name="Date" value="<%= date %>">
                    <input type="hidden" name="Time" value="<%= time %>">
                    <input type="hidden" name="PartySize" value="<%= party_size %>">
                    <center>
                        <button type="submit" class="confirm-button">Confirm Table</button>
                    </center>
                </form>
            
    <%
            }
            
            
            else {
    %>
                <div style='text-align:center; padding:20px;'>Sorry, no table available for the selected party size. <a href="HomePage.html">Go back</a></div>
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
<!--    </body>
    </head>
</html>-->