<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurant Management System</title>
    <!-- Include jQuery library -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
    <h1>Welcome to Restaurant Management System</h1>
    
    <!-- Notification area -->
    <div id="notificationArea">
        <!-- Notifications will be displayed here -->
    </div>

    <script>
        // Function to fetch notifications from the server
        function fetchNotifications() {
            $.ajax({
                url: 'notifications.php', // Endpoint to fetch notifications
                method: 'GET',
                success: function(response) {
                    // Display notifications in the notification area
                    $('#notificationArea').html(response);
                },
                error: function(xhr, status, error) {
                    console.error('Error fetching notifications:', error);
                }
            });
        }

        // Fetch notifications initially when the page loads
        $(document).ready(function() {
            fetchNotifications();

            // Refresh notifications every 10 seconds (adjust as needed)
            setInterval(fetchNotifications, 10000);
        });
    </script>
</body>
</html>
