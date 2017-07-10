<?php echo 'Hello world 2'; ?>

<?php
$servername = "dbserver";
$username = $_ENV['MYSQL_USER'];
$password = $_ENV['MYSQL_PASSWORD'];

try {
	$db=$_ENV['DATABASE'];
    $conn = new PDO("mysql:host=$servername;dbname=".$db, $username, $password);
    // set the PDO error mode to exception
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $result = $conn->query("show tables;");
     foreach ($result as $row) {
        print $row['Tables_in_orangehrm_mysql'] . "\n";
    }
    //echo $result;
    echo "Connected successfully"; 
    }
catch(PDOException $e)
    {
    echo "Connection failed: " . $e->getMessage();
    }
?>
