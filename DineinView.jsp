<%-- 
    Document   : view22
    Created on : 4 Apr, 2024, 11:18:58 PM
    Author     : RCTI
--%>

<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Order Info</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
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
        th, td {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h1>Customer Information</h1>
    <table>
        <tr>
            <th>ORDER_ID</th>
            <th>CUSTOMER_NAME</th>
            <th>tableno</th>
            <th>ORDER_DATE</th>
           
        </tr>
        <div class="header">
    <a href='Home.html'><img src="homepage.png" alt="Your Image"></a>
</div>
        <%
            try {
                String url = "jdbc:mysql://localhost:3306/mysql?zeroDateTimeBehavior=convertToNull";
                String username = "root";
                String password = "";
                // Register the JDBC driver
                Class.forName("com.mysql.jdbc.Driver");

                // Establish a connection to the database
                Connection conn = DriverManager.getConnection(url, username, password);

                // Create a statement
                Statement stmt = conn.createStatement();

                // Execute a query to fetch data from the customer_table
                ResultSet rs = stmt.executeQuery("SELECT * FROM roughwork.ordersd where ");


                // Display the data
                while (rs.next()) {
                    String order_id = rs.getString("ORDER_ID");
                    String customer_name = rs.getString("CUSTOMER_NAME");
                    String tableno = rs.getString("tableno");
                    String order_date = rs.getString("ORDER_DATE");
        %>
                    <tr>
                      
                        <td><%= order_id %></td>
                        <td><%= customer_name %></td>
                        <td><%= tableno %></td>
                        <td><%= order_date %></td>
                    </tr>
        <%
                }
                // Close the connections and statements
                rs.close();
                stmt.close();
                conn.close();
            } catch (Exception e) {
                out.println("<tr><td colspan='5'>An error occurred: " + e + "</td></tr>");
            }
        %>
    </table>
</body>
</html>