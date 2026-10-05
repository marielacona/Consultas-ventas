/*M4 CONSULTAS DEL NEGOCIO*/

USE VentasTechDB

/*==============================================
Consulta 1— Resumen ejecutivo mensual
===============================================*/
SELECT
MONTH (fecha_venta) AS mes, 
SUM(cantidad * precio_unitario) AS total_facturado,
COUNT(*) AS cantidad_pedidos,
AVG(cantidad * precio_unitario) AS ticket_promedio
FROM [dbo].[Ventas]
GROUP BY MONTH (fecha_venta)
ORDER BY mes;

/*==============================================
Consulta 2 — Ranking de productos
===============================================*/
SELECT TOP 5
    IDproducto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY IDproducto
ORDER BY total_generado DESC;

/*==============================================
Consulta 3 — Clientes recurrentes
===============================================*/
SELECT
    IDcliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY IDcliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;
/*==============================================
Consulta 4 — Meses por encima/por debajo del promedio 
===============================================*/
WITH ventas_mensuales AS (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM ventas_mensuales)
            THEN 'Por encima'
        WHEN total_facturado < (SELECT AVG(total_facturado) FROM ventas_mensuales)
            THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END AS comparacion_promedio
FROM ventas_mensuales
ORDER BY mes;
-- =========================================
-- HALLAZGOS
-- =========================================

-- 1. El producto 1 es el que más facturación genera,
--    con un total de $3.600, aproximadamente el 55,9%
--    de la facturación total.

-- 2. El producto 2 es el que más unidades vende,
--    con 13 unidades, pero genera solo $364 de facturación
--    debido a su menor precio unitario.

-- 3. Los 5 clientes realizaron 2 pedidos cada uno,
--    por lo que todos cumplen con el criterio de cliente recurrente.