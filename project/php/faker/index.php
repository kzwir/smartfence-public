<?php
require_once 'vendor/autoload.php';
?>

<!DOCTYPE html>
<html>
<head>
<title>Aplikacja testowa obsługi http.</title>
<style type="text/css">
table, th, td {
  border:1px solid black;
}</style>
</head>
<body>
<?php
	// The MySQL service named in the docker-compose.yml.
	$host = 'mariadb';

	// Database use name
	$user = 'admin';

	//database user password
	$pass = 'Fe8n!3ce#123';

	// check the MySQL connection status
	$conn = new mysqli($host, $user, $pass);
	if ($conn->connect_error) {
		die("Connection failed: " . $conn->connect_error);
	} else {
		echo "Connected to MySQL server successfully!";
	}

	$faker = new Faker\Generator();
	$faker->addProvider(new Faker\Provider\Lorem($faker));
	$faker->addProvider(new Faker\Provider\DateTime($faker));
	$faker->addProvider(new Faker\Provider\Internet($faker));
?>
<table>
	<thead>
	  <tr>
		<th colspan="11">Lista rekordow do wstawienia</th>
	  </tr>
	  <tr>
		<th>Id.</th>
		<th>Id centrali</th>
		<th>Nazwa centrali</th>
		<th>Data</th>
		<th>Typ wiadomosci</th>
		<th>Nazwa modulu</th>
		<th>Id modulu</th>
		<th>Moc</th>
		<th>Napiecie</th>
		<th>Prad</th>
		<th>Tekst</th>
	  </tr>
	</thead>
	<tbody>
		<?php for ($i = 0; $i < 1; $i++) { ?>
			<tr> 
				<td><?php // p_centralId VARCHAR(17)
					echo $i;?></td>
				<td><?php echo $faker->macAddress;?></td>
				<td><?php // central name p_centralName VARCHAR(100)
					echo $faker->word;?></td>
				<td><?php // p_messageDate DATETIME "2022/11/15/19/14/2"
					echo $faker->dateTime->format('Y/m/d/H/i/s');//->format('Y/m/d/H/i/s');
					//echo '2022/12/01/12/34/1'
					?></td>
				<td><?php // p_messageTypeId ENUM('1','A','B','C','D','E','F','G')
					echo $faker->randomElement(array ('1','A','B','C','D','E','F','G'));?></td>
				<td><?php // module name p_moduleName VARCHAR(100)
					echo $faker->word;?></td>
				<td><?php // p_moduleId VARCHAR(17)
					echo $faker->macAddress;?></td>
				<td><?php // p_power DECIMAL(5,2)
					echo round($faker->randomFloat(2, 0, 500), 2);?></td>
				<td><?php // p_voltage DECIMAL(5,2)
					echo round($faker->randomFloat(2, 0, 230), 2);?></td>
				<td><?php // p_amperage DECIMAL(5,2)
					echo round($faker->randomFloat(2, 0, 50), 2);?></td>
				<td><?php // message text p_messageTxt VARCHAR(100)
					echo $faker->word; } // phpinfo();?></td>
			</tr>
	</tbody>
</table>

	<?php
		const maxIdxMessage = 1000;
		const  maxIdxCentralMcAddress = 10;
		const maxIdxCentralName = 15;
		const maxIdxModulMcAddress = 15;
		const maxIdxModulName = 15;
		const meesageType = 0;
		$macAddressCentral = "";
		$nameCentral = "";
		$meesageDate;
		$macAddressModul = "";
		$nameModul = "";
		$power = 0;
		$voltage = 0;
		$amperage = 0;
		$messageTxt = "";
		
		// losowanie macadres centrali 
		$a_centralMcAddress = array();
		for ($i = 0; $i < maxIdxCentralMcAddress; $i++) {
			$a_centralMcAddress []= $faker->macAddress;
		}
		
		// losowanie name centrali 
		$a_centralName = array();
		for ($i = 0; $i < maxIdxCentralName; $i++) {
			$a_centralName []= $faker->word;
		}
		
		// losowanie macaddres modulu
		$a_modulMcAddress = array();
		for ($i = 0; $i < maxIdxModulMcAddress; $i++) {
			$a_modulMcAddress []= $faker->macAddress;
		}
		
		// losowanie name modulu
		$a_modulName = array();
		for ($i = 0; $i < maxIdxModulMcAddress; $i++) {
			$a_modulName []= $faker->word;
		}

		for ($i = 0; $i < maxIdxMessage; $i++) {
			$macAddressCentral = $faker->randomElement($a_centralMcAddress);
			$nameCentral = $faker->randomElement($a_centralName);

			$meesageDate = $faker->dateTime->format('Y/m/d/H/i/s');
			$meesageType = $faker->randomElement(array ('1','A','B','C','D','E','F','G'));
			
			$macAddressModul = "";
			$nameModul = "";
			$power = 0;
			$voltage = 0;
			$amperage = 0;
			$messageTxt = "";
		
			switch ($meesageType) {
				case '1':
					$macAddressModul = $faker->randomElement($a_modulMcAddress);
					$nameModul = $faker->randomElement($a_modulName);
					$power = round($faker->randomFloat(2, 0, 500), 2);
					$voltage = round($faker->randomFloat(2, 0, 230), 2);
					$amperage = round($faker->randomFloat(2, 0, 50), 2);
				break;
				case 'A':
				case 'B':
					$macAddressModul = $faker->randomElement($a_modulMcAddress);
					$nameModul = $faker->randomElement($a_modulName);
					$messageTxt = $faker->word;
				break;
				case 'C':
				case 'D':
				case 'E':
				case 'F':
				case 'G':
					$macAddressModul = $faker->randomElement($a_modulMcAddress);
					$nameModul = $faker->randomElement($a_modulName);
				break;
			}
			// call populate_message($macAddressCentral, $nameCentral, $meesageType, $meesageDate, $nameModul, $macAddressModul, $power, $voltage, $amperage, $messageTxt);
			echo $i+1 . ";     " . $macAddressCentral . "; " . $nameCentral . "; " .  $meesageType . "; " . $meesageDate . "; " . $nameModul . "; " . $macAddressModul . "; " . $power . "; " . $voltage . "; " . $amperage . "; " . $messageTxt . "<br>";
		}
	?>	
</body>
</html>
