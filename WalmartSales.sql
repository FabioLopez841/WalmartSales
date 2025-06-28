
##creacion de base de datos
CREATE DATABASE WalmartSucursal;
USE WalmartSucursal;
#tabla produccto
CREATE TABLE Producto (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    precio DECIMAL(10, 2),
    stock INT,
    categoria_id INT,
    proveedor_id INT,
    FOREIGN KEY (categoria_id) REFERENCES Categoria(id),
    FOREIGN KEY (proveedor_id) REFERENCES Proveedor(id)
);
#tabla empleado
CREATE TABLE Empleado (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    puesto VARCHAR(50),
    salario DECIMAL(10, 2)
);
#tabla cliente
CREATE TABLE Cliente (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    email VARCHAR(100)
);
#tabla venta
CREATE TABLE Venta (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fecha DATETIME,
    cliente_id INT,
    empleado_id INT,
    total DECIMAL(10, 2),
    FOREIGN KEY (cliente_id) REFERENCES Cliente(id),
    FOREIGN KEY (empleado_id) REFERENCES Empleado(id)
);
#tabla proveedor
CREATE TABLE Proveedor (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    contacto VARCHAR(100)
);
#tabla categoria
CREATE TABLE Categoria (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50)
);
#inserción de datos, categorias
INSERT INTO Categoria (nombre) VALUES
('Electrónica'),
('Ropa'),
('Alimentos'),
('Hogar');
#insertar proveedores
INSERT INTO Proveedor (nombre, contacto) VALUES
('Proveedor A', 'contacto@proveedora.com'),
('Proveedor B', 'contacto@proveedorb.com');
#insertar productos
INSERT INTO Producto (nombre, precio, stock, categoria_id, proveedor_id) VALUES
('Televisor', 5000.00, 10, 1, 1),
('Camisa', 300.00, 50, 2, 2),
('Arroz', 20.00, 100, 3, 1),
('Sofá', 8000.00, 5, 4, 2);
#insertar empleados
INSERT INTO Empleado (nombre, apellido, puesto, salario) VALUES
('Juan', 'Pérez', 'Cajero', 8000.00),
('Ana', 'Gómez', 'Gerente', 15000.00);
#insertar clientes
INSERT INTO Cliente (nombre, apellido, email) VALUES
('Luis', 'Martínez', 'luis@example.com'),
('Marta', 'López', 'marta@example.com');
##consultas

##obtener el total de productos por categoria
SELECT c.nombre AS categoria, COUNT(p.id) AS total_productos
FROM Categoria c
LEFT JOIN Producto p ON c.id = p.categoria_id
GROUP BY c.id;

###obtener el precio promedio de los productos por categoría
SELECT c.nombre AS categoria, AVG(p.precio) AS precio_promedio
FROM Categoria c
JOIN Producto p ON c.id = p.categoria_id
GROUP BY c.id;
##lista de productos donde el stock es menor a 10 
SELECT * FROM Producto WHERE stock < 10;
##lista de ventas realizadas el ultimo mes
SELECT * FROM Venta WHERE fecha >= DATE_SUB(NOW(), INTERVAL 1 MONTH);
##ventas totales por cada cliente
SELECT c.nombre, c.apellido, SUM(v.total) AS total_ventas
FROM Cliente c
JOIN Venta v ON c.id = v.cliente_id
GROUP BY c.id;
##obtener el empleado que ha realizado mas ventas
SELECT e.nombre, e.apellido, COUNT(v.id) AS total_ventas
FROM Empleado e
JOIN Venta v ON e.id = v.empleado_id
GROUP BY e.id
ORDER BY total_ventas DESC
LIMIT 1;

#obtener el producto mas caro 
SELECT * FROM Producto ORDER BY precio DESC LIMIT 1;

#obtener el total de ventas por mes
SELECT DATE_FORMAT(fecha, '%Y-%m') AS mes, SUM(total) AS total_ventas
FROM Venta
GROUP BY mes;
#obtener los productos que no han sido vendidos
SELECT p.nombre
FROM Producto p
LEFT JOIN Venta v ON p.id = v.id
WHERE v.id IS NULL;
#obtener el total de empleados por puesto
SELECT puesto, COUNT(*) AS total_empleados
FROM Empleado
GROUP BY puesto;
##obtener el total de productos por proveedor_id
SELECT pr.nombre AS proveedor, COUNT(p.id) AS total_productos
FROM Proveedor pr
LEFT JOIN Producto P on pr.id = p.proveedor_id
GROUP BY pr.id;
##obtener el cliente que ha gastado mas dinero
SELECT c.nombre, c.apellido, SUM(v.total) AS total_gastado
FROM Cliente c 
JOIN Venta v ON c.id = v.cliente_id
GROUP BY c.id
ORDER BY total_gastado DESC 
LIMIT 1;
#obtener el total de ventas y el total de productos vendidos
SELECT p.nombre
FROM Producto p
JOIN Categoria c ON p.categoria_id = c.id
WHERE c.nombre = "Electrónica";
#obtener el total de ventas por empleado en el último año
SELECT e.nombre, e.apellido, SUM(v.total) AS total_ventas
FROM Empleado E
JOIN Venta v ON e.id = v.empleado_id
WHERE v.fecha >= DATE_SUB(NOW(), INTERVAL 1 YEAR)
GROUP BY e.id;
##obtener el stock total de todos los productos
SELECT SUM(stock) AS total_stock FROM Producto;
#obtener el promedio de salario de los empleados por puesto
SELECT puesto, AVG(salario) AS salario_promedio
GROUP BY puesto;
#obtener las ventas realizadas por un cliente específico por ejemplo id 1
SELECT v.*
FROM Venta v
WHERE v.cliente_id = 1;
##obtenerr los productos que tienen un precio superior al promedio
SELECT * FROM Producto WHERE precio > (SELECT AVG(precio) FROM Producto);
#obtener el total de ventas por categoria en un año
SELECT c.nombre AS categoria, SUM(v.total) AS total_ventas
FROM Categoria c
JOIN Producto p ON  c.id = p.categoria_id
JOIN Venta v ON p.id = v.id
