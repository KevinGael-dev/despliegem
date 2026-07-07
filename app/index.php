<?php
// Configuración de conexión a la base de datos.
// DB_HOST se puede sobreescribir con una variable de entorno (útil para Render / TiDB Cloud).
$db_host = getenv('DB_HOST') ?: '127.0.0.1';
$db_user = getenv('DB_USER') ?: 'biblioteca_user';
$db_pass = getenv('DB_PASS') ?: 'secret123';
$db_name = getenv('DB_NAME') ?: 'biblioteca';

$conn = null;
$error = null;

try {
    $conn = new mysqli($db_host, $db_user, $db_pass, $db_name);
    if ($conn->connect_error) {
        throw new Exception($conn->connect_error);
    }
} catch (Exception $e) {
    $error = $e->getMessage();
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Libros Disponibles</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 40px;
            color: #2c3e50;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: #ffffff;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }
        h1 {
            text-align: center;
            color: #1a5276;
            margin-bottom: 5px;
        }
        p.subtitle {
            text-align: center;
            color: #7f8c8d;
            margin-top: 0;
            margin-bottom: 30px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #e1e4e8;
        }
        th {
            background-color: #1a5276;
            color: #ffffff;
        }
        tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        .error {
            background: #fdecea;
            color: #c0392b;
            padding: 15px;
            border-radius: 6px;
            border: 1px solid #f5b7b1;
        }
        .footer {
            text-align: center;
            margin-top: 25px;
            font-size: 0.85em;
            color: #95a5a6;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>📚 Libros Disponibles</h1>
        <p class="subtitle">Práctica: Contenedor PHP + MySQL desplegado en la nube</p>

        <?php if ($error): ?>
            <div class="error">
                <strong>No se pudo conectar a la base de datos:</strong><br>
                <?php echo htmlspecialchars($error); ?>
            </div>
        <?php else: ?>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Título</th>
                        <th>Autor</th>
                        <th>Año</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
                    $result = $conn->query("SELECT id, titulo, autor, anio FROM libros ORDER BY id ASC");
                    if ($result && $result->num_rows > 0) {
                        while ($row = $result->fetch_assoc()) {
                            echo "<tr>";
                            echo "<td>" . htmlspecialchars($row['id']) . "</td>";
                            echo "<td>" . htmlspecialchars($row['titulo']) . "</td>";
                            echo "<td>" . htmlspecialchars($row['autor']) . "</td>";
                            echo "<td>" . htmlspecialchars($row['anio']) . "</td>";
                            echo "</tr>";
                        }
                    } else {
                        echo "<tr><td colspan='4' style='text-align:center;'>No hay libros registrados.</td></tr>";
                    }
                    ?>
                </tbody>
            </table>
        <?php endif; ?>

        <p class="footer">Servidor: <?php echo htmlspecialchars($db_host); ?> &middot; PHP <?php echo phpversion(); ?></p>
    </div>
</body>
</html>
<?php if ($conn) { $conn->close(); } ?>
