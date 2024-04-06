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
    String password = request.getParameter("password");
    String phone = request.getParameter("phone");
    String securityQuestion = request.getParameter("security_question");
    String securityAnswer = request.getParameter("security_answer");

    // Check if the email ends with "@gmail.com"
    if (!email.endsWith("@gmail.com")) {
%>
    <div style='text-align:center; padding:20px;'>Invalid email format. Please enter a valid Gmail address. <a href="reg.html">Go back</a></div>
<%
    } else {
        // JDBC variables
        Connection conn = null;
        PreparedStatement pstmt = null;

        boolean registrationSuccessful = false;

        try {
            // Register JDBC driver
            Class.forName("com.mysql.jdbc.Driver");

            // Open a connection
            conn = DriverManager.getConnection(url, user, dbpassword);

            // Execute SQL query with PreparedStatement
            String sql = "INSERT INTO queenscorner.customers (name, phone, email, password, security_question, security_answer) VALUES (?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, name);
            pstmt.setString(2, phone);
            pstmt.setString(3, email);
            pstmt.setString(4, password);
            pstmt.setString(5, securityQuestion);
            pstmt.setString(6, securityAnswer);

            int rowsAffected = pstmt.executeUpdate();

            // Check if registration was successful
            if (rowsAffected > 0) {
                registrationSuccessful = true;
            } else {
                // Log a message if no rows were affected
                System.out.println("No rows affected during registration.");
            }
        } catch (SQLException se) {
            // Handle errors for JDBC
            se.printStackTrace();
            out.println("SQL State: " + se.getSQLState()+"<br>");
            out.println("Error Code: " + se.getErrorCode()+"<br>");
            out.println("Message: " + se.getMessage()+"<br>");
        } catch (Exception e) {
            // Handle other exceptions
            e.printStackTrace();
            out.println("Error: " + e.getMessage()+"<br>");
        } finally {
            // Close resources in finally block
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException se) {
                se.printStackTrace();
            }
        }

        if (registrationSuccessful) {
%>
             <div style='text-align:center; padding:20px;'>Registration successful! Click <a href="Home.html">here</a> to go to the home page.</div>
<%
        } else {
%>
            <div style='text-align:center; padding:20px;'>Registration failed. Please try again. <a href="Register.html">Go back</a></div>
<%
        }
    }

System.out.println("Name: " + name);
System.out.println("Email: " + email);
System.out.println("Password: " + password);
System.out.println("Phone: " + phone);
System.out.println("Security Question: " + securityQuestion);
System.out.println("Security Answer: " + securityAnswer);
%>
