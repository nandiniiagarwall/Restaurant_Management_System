<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Table Status</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('n1.jpg');
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
        .table-container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #f5f5f5;
            border-radius: 5px;
            background-color: rgba(255, 255, 255, 0.4);
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <div class="header">
    <a href='Home.html'><img src="homepage.png" alt="Your Image"></a>
</div>
    <div class="table-container">
        <h2>Table Status</h2>
        <table>
            <thead>
                <tr>
                    <th>Table No</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Party Size</th>
                </tr>
            </thead>
            <tbody>
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

                        // Fetch table status data from BOOK table
                        String sqlSelect = "SELECT t_id, name, email, date, time, party_size FROM queenscorner.BOOK";

                        pstmt = conn.prepareStatement(sqlSelect);
                        rs = pstmt.executeQuery();

                        // Display table status data in the table
                        while (rs.next()) {
                            int tableNo = rs.getInt("t_id");
                            String name = rs.getString("name");
                            String email = rs.getString("email");
                            Date date = rs.getDate("date");
                            Time time = rs.getTime("time");
                            int partySize = rs.getInt("party_size");
                %>
                            <tr>
                                <td><%= tableNo %></td>
                                <td><%= name %></td>
                                <td><%= email %></td>
                                <td><%= date %></td>
                                <td><%= time %></td>
                                <td><%= partySize %></td>
                            </tr>
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
            </tbody>
        </table>
        <button class="back" onclick="goToHomepage()">Back</button> <!-- Back button outside the table -->
    </div>
   
    <script>        
        function goToHomepage() {
            window.location.href = "Home.html"; // Replace with your homepage URL
        }
    </script>
</body>
</html>
