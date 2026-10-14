-- ============================================================
-- ATIVIDADE PRÁTICA DE SQL — NYCFLIGHTS13
-- Inspirada nos problemas do R for Data Science
-- Base: voos que partiram de NYC em 2013
-- Tabelas: flights, airlines, airports, planes, weather
-- ============================================================

-- ------------------------------------------------------------
-- BLOCO 1 — CONHECENDO O BANCO
-- SELECT, LIMIT, DISTINCT, ORDER BY
-- ------------------------------------------------------------

-- 1. Mostre as 10 primeiras linhas da tabela flights.
SELECT * FROM flights LIMIT 10;

-- 2. Liste apenas as colunas year, month, day, carrier, flight,
--    origin e dest dos 20 primeiros voos.
SELECT year, month, day, carrier, flight, origin, dest FROM flights LIMIT 20;   

-- 3. Quais aeroportos de origem aparecem na base?
--    Mostre cada código apenas uma vez.
SELECT DISTINCT origin FROM flights;

-- 4. Quais destinos aparecem na base?
--    Liste-os sem repetição e em ordem alfabética.
SELECT DISTINCT dest FROM flights ORDER BY dest ASC;

-- 5. Liste os 20 voos com maior distância percorrida.
--    Mostre origin, dest, carrier, flight e distance.
SELECT DISTINCT origin, dest, carrier, flight, distance FROM flights ORDER BY distance DESC LIMIT 20;

-- ------------------------------------------------------------
-- BLOCO 2 — FILTROS
-- WHERE, AND, OR, BETWEEN, IN, LIKE, IS NULL
-- ------------------------------------------------------------

-- 6. Liste todos os voos que tiveram como destino LAX.
SELECT * FROM flights WHERE dest = 'LAX';

-- 7. Encontre os voos que saíram de JFK e tiveram destino LAX.
SELECT * FROM flights WHERE origin = 'JFK' AND dest = 'LAX';

-- 8. Encontre os voos com atraso de partida superior a 120 minutos.
SELECT * FROM flights WHERE dep_delay > 120 ORDER BY dep_delay DESC; 

-- 9. Encontre os voos que chegaram pelo menos 30 minutos adiantados.
SELECT * FROM flights WHERE arr_delay < -30;

-- 10. Liste os voos realizados nos meses de junho, julho e agosto.
SELECT * FROM flights WHERE month IN (6, 7, 8);

-- 11. Encontre os voos que partiram no dia 25 de dezembro de 2013.
SELECT * FROM flights WHERE year = 2013 AND month = 12 AND day = 25;

-- 12. Identifique os voos cancelados.
--     Dica: no conjunto nycflights13, dep_time ausente indica cancelamento.
SELECT * FROM flights WHERE dep_time IS NULL;

-- 13. Liste os voos cujo código da companhia aérea começa com a letra 'U'.
SELECT * FROM flights WHERE carrier LIKE 'U%';

-- ------------------------------------------------------------
-- BLOCO 3 — AGREGAÇÃO
-- COUNT, AVG, MIN, MAX, SUM, GROUP BY, HAVING
-- ------------------------------------------------------------

-- 14. Quantos voos existem na tabela flights?
SELECT COUNT (*) AS total_voos FROM flights;

-- 15. Quantos voos partiram de cada aeroporto de origem?
--     Ordene do maior para o menor.
SELECT origin, COUNT(*) AS total_voos FROM flights GROUP BY origin ORDER BY total_voos DESC;

-- 16. Quais foram os 10 destinos com maior número de voos?
SELECT dest, COUNT (*) AS numero_voos FROM flights GROUP BY dest ORDER BY numero_voos DESC limit 10;

-- 17. Calcule o atraso médio de partida de todos os voos.
--     Ignore valores ausentes automaticamente com AVG().
SELECT ROUND(AVG(dep_delay), 2) AS atraso_partida, ROUND(AVG(arr_delay), 2) AS atraso_chegada FROM flights GROUP BY origin ORDER BY atraso_partida DESC;

-- 18. Calcule o atraso médio de chegada por aeroporto de destino.
--     Ordene do maior atraso médio para o menor.
SELECT dest, ROUND(AVG(arr_delay), 2) AS atraso_chegada FROM flights GROUP BY dest ORDER BY atraso_chegada DESC;

-- 19. Calcule, por companhia aérea:
--     a) número de voos;   
--     b) atraso médio de partida;
--     c) atraso médio de chegada.
SELECT carrier, COUNT(*) AS numero_voos, ROUND(AVG(dep_delay), 2) AS atraso_partida, ROUND(AVG(arr_delay), 2) AS atraso_chegada FROM flights GROUP BY carrier;

-- 20. Quais companhias tiveram atraso médio de chegada superior a 10 minutos?
--     Use HAVING.
SELECT carrier, ROUND(AVG(arr_delay), 2) AS atraso_chegada FROM flights GROUP BY carrier HAVING AVG(arr_delay) > 10;

-- 21. Em qual mês ocorreu o maior número de voos?
SELECT month, COUNT(*) AS total_voos FROM flights GROUP BY month ORDER BY total_voos DESC LIMIT 1;

-- 22. Calcule o número de voos cancelados por mês.
SELECT month, COUNT(*) AS total_cancelados FROM flights WHERE dep_time IS NULL GROUP BY month ORDER BY total_cancelados DESC;

-- 23. Calcule a proporção de voos cancelados em cada mês.
--     Sugestão: compare o número de cancelados com o total de voos no mês.
SELECT month, 
       COUNT(*) AS total_voos, 
       SUM(CASE WHEN dep_time IS NULL THEN 1 ELSE 0 END) AS total_cancelados,
       ROUND(SUM(CASE WHEN dep_time IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS proporcao_cancelados
FROM flights
GROUP BY month;

-- ------------------------------------------------------------
-- BLOCO 4 — PERGUNTAS ANALÍTICAS
-- ------------------------------------------------------------

-- 24. Qual aeroporto de origem apresentou o maior atraso médio de partida?
SELECT origin, ROUND(AVG(dep_delay), 2) AS atraso_partida FROM flights GROUP BY origin ORDER BY atraso_partida DESC LIMIT 1;

-- 25. Quais são os cinco destinos com maior distância média a partir de NYC?
SELECT dest, ROUND(AVG(distance), 2) AS distancia_media FROM flights GROUP BY dest ORDER BY distancia_media DESC LIMIT 5;

-- 26. Para cada mês, calcule o atraso médio de chegada.
--     Em quais meses os atrasos médios foram maiores?
SELECT month, ROUND(AVG(arr_delay), 2) AS atraso_chegada FROM flights GROUP BY month ORDER BY atraso_chegada DESC;

-- 27. Quais voos recuperaram tempo durante a viagem?
--     Considere que um voo recuperou tempo quando:
--        arr_delay < dep_delay
--     Mostre dep_delay, arr_delay e a diferença entre eles.
SELECT dep_delay, arr_delay, (dep_delay - arr_delay) AS tempo_recuperado FROM flights WHERE arr_delay < dep_delay ORDER BY tempo_recuperado DESC;

-- 28. Qual companhia aérea teve o maior número de voos cancelados?
SELECT carrier, COUNT(*) AS total_cancelados FROM flights WHERE dep_time IS NULL GROUP BY carrier ORDER BY total_cancelados DESC LIMIT 1;

-- 29. Para cada companhia, calcule a porcentagem de voos cancelados.
SELECT carrier,
       COUNT(*) AS total_voos, 
       SUM(CASE WHEN dep_time IS NULL THEN 1 ELSE 0 END) AS total_cancelados,
       ROUND(SUM(CASE WHEN dep_time IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS proporcao_cancelados
FROM flights
GROUP BY carrier;

-- ------------------------------------------------------------
-- BLOCO 5 — JOINs
-- ------------------------------------------------------------

-- 30. Mostre cada voo junto com o nome completo da companhia aérea.
--     Tabelas: flights + airlines
--     Chave: carrier
SELECT a.name, COUNT(*) AS numero_voos FROM flights AS f JOIN airlines AS a ON f.carrier = a.carrier GROUP BY a.name ORDER BY numero_voos DESC;

-- 31. Conte o número de voos por companhia usando o nome da companhia,
--     e não apenas o código.
SELECT a.name, COUNT(*) AS numero_voos FROM flights AS f JOIN airlines AS a ON f.carrier = a.carrier GROUP BY a.name ORDER BY numero_voos DESC;

-- 32. Mostre os 10 destinos mais frequentes com o nome completo
--     do aeroporto de destino.
--     Tabelas: flights + airports
--     Chave: flights.dest = airports.faa
SELECT * FROM flights AS f JOIN airports AS a ON f.dest = a.faa GROUP BY a.name ORDER BY COUNT(*) DESC LIMIT 10;    

-- 33. Para cada aeroporto de destino, mostre:
--     nome do aeroporto, cidade/código FAA, número de voos
--     e atraso médio de chegada.
SELECT
    a.name                       AS aeroporto,
    f.dest                       AS faa,
    COUNT(*)                     AS num_voos,
    ROUND(AVG(f.arr_delay), 2)   AS atraso_medio_chegada
FROM flights f
LEFT JOIN airports a ON a.faa = f.dest
GROUP BY f.dest, a.name
ORDER BY num_voos DESC;
-- prof, tive dificuldade nessa pq n tem a tabela de cidades, então coloquei o código FAA no lugar da cidade.


-- 34. Mostre os voos junto com fabricante e modelo da aeronave.
--     Tabelas: flights + planes
--     Chave: tailnum
SELECT
    f.year, f.month, f.day,
    f.carrier, f.flight, f.tailnum,
    f.origin, f.dest,
    p.manufacturer AS fabricante,
    p.model        AS modelo
FROM flights f
LEFT JOIN planes p ON p.tailnum = f.tailnum;


-- 35. Quais fabricantes de aeronaves aparecem em maior número de voos?
SELECT
    p.manufacturer AS fabricante,
    COUNT(*)        AS numero_voos
FROM flights f
LEFT JOIN planes p ON p.tailnum = f.tailnum
GROUP BY p.manufacturer
ORDER BY numero_voos DESC;


-- 36. Calcule o atraso médio de chegada por fabricante de aeronave.
--     Considere apenas fabricantes com pelo menos 1000 voos.
SELECT 
    p.manufacturer AS fabricante,
    COUNT(*)        AS numero_voos,
    ROUND(AVG(f.arr_delay), 2) AS atraso_medio_chegada
FROM flights f
LEFT JOIN planes p ON p.tailnum = f.tailnum
GROUP BY p.manufacturer
HAVING COUNT(*) >= 1000
ORDER BY atraso_medio_chegada DESC;


-- 37. Para cada voo, mostre simultaneamente:
--     companhia aérea, aeroporto de origem e aeroporto de destino
--     com seus respectivos nomes completos.
--     Atenção: será necessário usar airports duas vezes com aliases.
SELECT
    f.year, f.month, f.day,
    a1.name AS aeroporto_origem,
    a2.name AS aeroporto_destino,
    al.name AS companhia_aerea,
    f.flight, f.tailnum
FROM flights f
LEFT JOIN airports a1 ON a1.faa     = f.origin
LEFT JOIN airports a2 ON a2.faa     = f.dest
LEFT JOIN airlines al ON al.carrier = f.carrier;
COALESCE(a1.name, f.origin) AS aeroporto_origem,
COALESCE(a2.name, f.dest)   AS aeroporto_destino,

-- ------------------------------------------------------------
-- BLOCO 6 — QUESTÕES DIRETAMENTE INSPIRADAS NO R FOR DATA SCIENCE
-- ------------------------------------------------------------

-- 38. Encontre os 10 destinos mais populares e, em seguida,
--     retorne todos os voos cujo destino pertence a esse grupo.
--     Faça usando uma subconsulta.
SELECT
    f.year, f.month, f.day,
    f.carrier, f.flight, f.tailnum,
    f.origin, f.dest
FROM flights f
WHERE f.dest IN (
    SELECT dest
    FROM flights
    WHERE dest IS NOT NULL
    GROUP BY dest
    ORDER BY COUNT(*) DESC
    LIMIT 10
);
-- 39. Existem voos cujo aeroporto de destino não possui registro
--     correspondente na tabela airports?
--     Tente responder usando LEFT JOIN + IS NULL.
SELECT f.dest, COUNT(*) AS voos
FROM flights f
LEFT JOIN airports a ON a.faa = f.dest
WHERE a.faa IS NULL
GROUP BY f.dest
ORDER BY voos DESC;SELECT f.dest, COUNT(*) AS voos
FROM flights f
LEFT JOIN airports a ON a.faa = f.dest
WHERE a.faa IS NULL
GROUP BY f.dest
ORDER BY voos DESC;SELECT f.dest, COUNT(*) AS voos
FROM flights f
LEFT JOIN airports a ON a.faa = f.dest
WHERE a.faa IS NULL
GROUP BY f.dest
ORDER BY voos DESC;SELECT f.dest, COUNT(*) AS voos
FROM flights f
LEFT JOIN airports a ON a.faa = f.dest
WHERE a.faa IS NULL
GROUP BY f.dest
ORDER BY voos DESC;


-- 40. Existem aeronaves (tailnum) presentes em flights que não possuem
--     registro correspondente em planes?
SELECT DISTINCT f.tailnum
FROM flights f
LEFT JOIN planes p ON p.tailnum = f.tailnum
WHERE p.tailnum IS NULL
  AND f.tailnum IS NOT NULL;

-- 41. Quais companhias aparecem com maior frequência entre os tailnum
--     que não possuem correspondência na tabela planes?
SELECT f.carrier, al.name AS companhia, COUNT(*) AS voos_sem_registro
FROM flights f
LEFT JOIN planes p    ON p.tailnum  = f.tailnum
LEFT JOIN airlines al ON al.carrier = f.carrier
WHERE p.tailnum IS NULL
  AND f.tailnum IS NOT NULL
GROUP BY f.carrier, al.name
ORDER BY voos_sem_registro DESC;

-- 42. Calcule o atraso médio de chegada por destino e associe latitude
--     e longitude do aeroporto de destino.
--     Esta consulta poderia ser exportada depois para construção de um mapa.
SELECT f.carrier, al.name AS companhia, COUNT(*) AS voos_sem_registro
FROM flights f
LEFT JOIN planes p    ON p.tailnum  = f.tailnum
LEFT JOIN airlines al ON al.carrier = f.carrier
WHERE p.tailnum IS NULL
  AND f.tailnum IS NOT NULL
GROUP BY f.carrier, al.name
ORDER BY voos_sem_registro DESC;

-- 43. Acrescente aos voos a latitude e longitude tanto do aeroporto
--     de origem quanto do aeroporto de destino.
--     Use aliases diferentes para airports.
SELECT
    f.year, f.month, f.day, f.flight,
    f.origin, o.lat AS lat_origem,  o.lon AS lon_origem,
    f.dest,   d.lat AS lat_destino, d.lon AS lon_destino
FROM flights f
LEFT JOIN airports o ON o.faa = f.origin
LEFT JOIN airports d ON d.faa = f.dest;

-- ------------------------------------------------------------
-- BLOCO 7 — WEATHER E CHAVES COMPOSTAS
-- ------------------------------------------------------------
 -- NÃO EXISTE TABELA WEATHER NO BANCO DE DADOS SQL, ENTÃO NÃO CONSEGUI FAZER AS QUESTÕES 44 A 48.


-- 44. Observe a tabela weather. Quais aeroportos de origem possuem
--     informações meteorológicas?

-- 45. Calcule temperatura média, mínima e máxima por aeroporto de origem.

-- 46. Associe flights e weather pela combinação de:
--       flights.origin = weather.origin
--       flights.time_hour = weather.time_hour
--     Mostre atraso de partida, temperatura, precipitação e velocidade do vento.

-- 47. Investigue se voos com precipitação apresentaram maior atraso médio
--     de partida do que voos sem precipitação.

-- 48. Divida os registros em duas categorias:
--       'com chuva'  -> precip > 0
--       'sem chuva'  -> precip = 0
--     e compare o atraso médio de partida.


-- ------------------------------------------------------------
-- BLOCO 8 — DESAFIOS FINAIS
-- ------------------------------------------------------------

-- 49. Para cada companhia aérea, encontre o destino mais frequente.
--     Desafio: pode exigir CTE, função de janela ou subconsulta.

WITH contagem AS (
    SELECT carrier, dest, COUNT(*) AS voos,
           ROW_NUMBER() OVER (
               PARTITION BY carrier
               ORDER BY COUNT(*) DESC, dest
           ) AS rn
    FROM flights
    WHERE dest IS NOT NULL
    GROUP BY carrier, dest
)
SELECT c.carrier, al.name AS companhia, c.dest, c.voos
FROM contagem c
JOIN airlines al ON al.carrier = c.carrier
WHERE c.rn = 1
ORDER BY c.voos DESC;

-- 50. Para cada mês, identifique a companhia aérea com o maior número de voos.

WITH contagem AS (
    SELECT month, carrier, COUNT(*) AS voos,
           ROW_NUMBER() OVER (
               PARTITION BY month
               ORDER BY COUNT(*) DESC, carrier
           ) AS rn
    FROM flights
    GROUP BY month, carrier
)
SELECT c.month, c.carrier, al.name AS companhia, c.voos
FROM contagem c
JOIN airlines al ON al.carrier = c.carrier
WHERE c.rn = 1
ORDER BY c.month;

-- 51. Calcule um ranking das companhias pelo atraso médio de chegada,
--     considerando somente companhias com pelo menos 1000 voos válidos.
SELECT
    f.carrier, al.name AS companhia,
    COUNT(f.arr_delay)         AS voos_validos,
    ROUND(AVG(f.arr_delay), 2) AS atraso_medio_chegada,
    RANK() OVER (ORDER BY AVG(f.arr_delay)) AS ranking
FROM flights f
JOIN airlines al ON al.carrier = f.carrier
WHERE f.arr_delay IS NOT NULL
GROUP BY f.carrier, al.name
HAVING COUNT(*) >= 1000
ORDER BY atraso_medio_chegada;

-- 52. Identifique os dias de 2013 com os maiores atrasos médios de chegada.
--     Mostre ano, mês, dia, número de voos válidos e atraso médio.

SELECT
    year, month, day,
    COUNT(arr_delay)         AS voos_validos,
    ROUND(AVG(arr_delay), 2) AS atraso_medio_chegada
FROM flights
WHERE arr_delay IS NOT NULL
GROUP BY year, month, day
ORDER BY atraso_medio_chegada DESC
LIMIT 10;

-- 53. Investigue o dia 13 de junho de 2013:
--     a) número de voos;
--     b) atraso médio de partida;
--     c) atraso médio de chegada;
--     d) número de cancelamentos;
--     e) condições meteorológicas médias por aeroporto de origem. (NAO FIZ POIS N TINHA TABELA WEATHER)
--     Essa questão é inspirada diretamente em um exercício do R for Data Science.

SELECT
    COUNT(*)                                       AS num_voos,
    ROUND(AVG(dep_delay), 2)                       AS atraso_medio_partida,
    ROUND(AVG(arr_delay), 2)                       AS atraso_medio_chegada,
    SUM(CASE WHEN dep_time IS NULL THEN 1 ELSE 0 END) AS cancelamentos
FROM flights
WHERE year = 2013 AND month = 6 AND day = 13;
