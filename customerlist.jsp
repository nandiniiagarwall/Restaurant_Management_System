<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Customer Information</title>
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
        table {
            border-collapse: collapse;
            width: 100%;
        }
        th, td {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }
        th {
            background-color: #764c29;
        }
    </style>
</head>
<body>
    <div class="header">
    <a href='Home.html'><img src="homepage.png" alt="Your Image"></a>
</div>
    <h1>Customer Information</h1>
    <table>
        <tr>
            <th>Name</th>
            <th>Email</th>
            <th>Phone</th>
        </tr>
        <%
            String url = "jdbc:mysql://localhost:3306/mysql?zeroDateTimeBehavior=convertToNull";
                String user = "root";
                String dbpassword = "";

                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(url, user, dbpassword);

                // Create a statement
                Statement stmt = conn.createStatement();

                // Execute a query to fetch data from the customer_table
                ResultSet rs = stmt.executeQuery("SELECT * FROM queenscorner.Customers");

                // Display the data
                while (rs.next()) {
                    String name = rs.getString("name");
                    String email = rs.getString("email");
                    String phone = rs.getString("phone");
        %>
                    <tr>
                        <td><%= name %></td>
                        <td><%= email %></td>
                        <td><%= phone %></td>
                    </tr>
        <%
                }
                // Close the connections and statements
                rs.close();
                stmt.close();
                conn.close();
            } catch (Exception e) {
                out.println("<tr><td colspan='3'>An error occurred: " + e + "</td></tr>");
            }
        %>
    </table>
</body>
</html>
