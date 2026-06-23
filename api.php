<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

// ==========================================
// PENGATURAN KONEKSI DATABASE (SESUAIKAN DENGAN XAMPP)
// ==========================================
$host = 'localhost';
$db   = 'esaka_db';
$user = 'root'; // default xampp user
$pass = '';     // default xampp password
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
     $pdo = new PDO($dsn, $user, $pass, $options);
} catch (\PDOException $e) {
     echo json_encode(['status' => 'error', 'message' => 'Connection failed: ' . $e->getMessage()]);
     exit;
}

$action = $_GET['action'] ?? '';
$table = $_GET['table'] ?? '';
$op = $_GET['op'] ?? '';

// Helper to get raw POST data
$rawData = file_get_contents("php://input");
$postData = json_decode($rawData, true);

if ($action === 'get_data') {
    $data = [];
    $tables = ['users', 'absen_pegawai', 'action_plans', 'semester_plans', 'event_classes', 'weekly_plans', 'weekly_reports', 'siswa', 'absensi'];
    foreach ($tables as $tbl) {
        $stmt = $pdo->query("SELECT * FROM $tbl");
        $data[$tbl] = $stmt->fetchAll();
    }
    echo json_encode(['status' => 'success', 'data' => $data]);
    exit;
}

if ($action === 'login') {
    $username = $postData['username'] ?? '';
    $password = $postData['password'] ?? '';
    $stmt = $pdo->prepare("SELECT * FROM users WHERE username = ? AND password = ?");
    $stmt->execute([$username, $password]);
    $userRow = $stmt->fetch();
    if ($userRow) {
        echo json_encode(['status' => 'success', 'user' => $userRow]);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Username/Password salah.']);
    }
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && $table && $op) {
    if ($op === 'insert') {
        $keys = array_keys($postData);
        $fields = implode(", ", $keys);
        $placeholders = implode(", ", array_fill(0, count($keys), "?"));
        $sql = "INSERT INTO $table ($fields) VALUES ($placeholders)";
        $stmt = $pdo->prepare($sql);
        $stmt->execute(array_values($postData));
        echo json_encode(['status' => 'success', 'id' => $pdo->lastInsertId()]);
        exit;
    } 
    
    elseif ($op === 'update') {
        $id = $postData['id'] ?? null;
        if (!$id) { 
            echo json_encode(['status' => 'error', 'message' => 'Missing ID']); 
            exit; 
        }
        unset($postData['id']); // do not update ID
        
        $setParams = [];
        foreach (array_keys($postData) as $key) {
            $setParams[] = "$key = ?";
        }
        $setClause = implode(", ", $setParams);
        $sql = "UPDATE $table SET $setClause WHERE id = ?";
        $stmt = $pdo->prepare($sql);
        $values = array_values($postData);
        $values[] = $id;
        $stmt->execute($values);
        echo json_encode(['status' => 'success']);
        exit;
    } 
    
    elseif ($op === 'delete') {
        $id = $postData['id'] ?? null;
        if (!$id) { 
            echo json_encode(['status' => 'error', 'message' => 'Missing ID']); 
            exit; 
        }
        $sql = "DELETE FROM $table WHERE id = ?";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([$id]);
        echo json_encode(['status' => 'success']);
        exit;
    } 
    
    elseif ($op === 'save_absensi_bulk') {
        // Special operation for saving multiple absences at once
        $tanggal = $_GET['tanggal'] ?? '';
        $unit = $_GET['unit'] ?? '';
        $kelas = $_GET['kelas'] ?? '';
        
        // Remove existing for this date/unit/kelas
        if($tanggal && $unit && $kelas){
            $stmt = $pdo->prepare("DELETE FROM absensi WHERE tanggal = ? AND unit = ? AND kelas = ?");
            $stmt->execute([$tanggal, $unit, $kelas]);
        }

        foreach ($postData as $row) {
            $keys = array_keys($row);
            $fields = implode(", ", $keys);
            $placeholders = implode(", ", array_fill(0, count($keys), "?"));
            $sql = "INSERT INTO absensi ($fields) VALUES ($placeholders)";
            $stmt = $pdo->prepare($sql);
            $stmt->execute(array_values($row));
        }
        echo json_encode(['status' => 'success']);
        exit;
    }

    elseif ($op === 'import_siswa') {
        foreach ($postData as $row) {
            $keys = array_keys($row);
            $filteredKeys = array_filter($keys, function($k) { return $k !== 'id'; });
            $fields = implode(", ", $filteredKeys);
            $placeholders = implode(", ", array_fill(0, count($filteredKeys), "?"));
            
            $values = [];
            foreach ($filteredKeys as $k) {
                $values[] = $row[$k];
            }

            $sql = "INSERT INTO siswa ($fields) VALUES ($placeholders)";
            $stmt = $pdo->prepare($sql);
            $stmt->execute($values);
        }
        echo json_encode(['status' => 'success']);
        exit;
    }
}

// Fallback error
echo json_encode(['status' => 'error', 'message' => 'Invalid action or operation']);
?>
