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
SELECT ROUND(AVG(dep_delay), 2) AS atraso_partida, ROUND(AVG(arr_delay), 2) AS atraso_chegada FROM flights GROUP BY origin ORDER BY atraso_partida DESC

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

-- 22. Calcule o número de voos cancelados por mês.

-- 23. Calcule a proporção de voos cancelados em cada mês.
--     Sugestão: compare o número de cancelados com o total de voos no mês.


-- ------------------------------------------------------------
-- BLOCO 4 — PERGUNTAS ANALÍTICAS
-- ------------------------------------------------------------

-- 24. Qual aeroporto de origem apresentou o maior atraso médio de partida?

-- 25. Quais são os cinco destinos com maior distância média a partir de NYC?

-- 26. Para cada mês, calcule o atraso médio de chegada.
--     Em quais meses os atrasos médios foram maiores?

-- 27. Quais voos recuperaram tempo durante a viagem?
--     Considere que um voo recuperou tempo quando:
--        arr_delay < dep_delay
--     Mostre dep_delay, arr_delay e a diferença entre eles.

-- 28. Qual companhia aérea teve o maior número de voos cancelados?

-- 29. Para cada companhia, calcule a porcentagem de voos cancelados.


-- ------------------------------------------------------------
-- BLOCO 5 — JOINs
-- ------------------------------------------------------------

-- 30. Mostre cada voo junto com o nome completo da companhia aérea.
--     Tabelas: flights + airlines
--     Chave: carrier

-- 31. Conte o número de voos por companhia usando o nome da companhia,
--     e não apenas o código.

-- 32. Mostre os 10 destinos mais frequentes com o nome completo
--     do aeroporto de destino.
--     Tabelas: flights + airports
--     Chave: flights.dest = airports.faa

-- 33. Para cada aeroporto de destino, mostre:
--     nome do aeroporto, cidade/código FAA, número de voos
--     e atraso médio de chegada.

-- 34. Mostre os voos junto com fabricante e modelo da aeronave.
--     Tabelas: flights + planes
--     Chave: tailnum

-- 35. Quais fabricantes de aeronaves aparecem em maior número de voos?

-- 36. Calcule o atraso médio de chegada por fabricante de aeronave.
--     Considere apenas fabricantes com pelo menos 1000 voos.

-- 37. Para cada voo, mostre simultaneamente:
--     companhia aérea, aeroporto de origem e aeroporto de destino
--     com seus respectivos nomes completos.
--     Atenção: será necessário usar airports duas vezes com aliases.


-- ------------------------------------------------------------
-- BLOCO 6 — QUESTÕES DIRETAMENTE INSPIRADAS NO R FOR DATA SCIENCE
-- ------------------------------------------------------------

-- 38. Encontre os 10 destinos mais populares e, em seguida,
--     retorne todos os voos cujo destino pertence a esse grupo.
--     Faça usando uma subconsulta.

-- 39. Existem voos cujo aeroporto de destino não possui registro
--     correspondente na tabela airports?
--     Tente responder usando LEFT JOIN + IS NULL.

-- 40. Existem aeronaves (tailnum) presentes em flights que não possuem
--     registro correspondente em planes?

-- 41. Quais companhias aparecem com maior frequência entre os tailnum
--     que não possuem correspondência na tabela planes?

-- 42. Calcule o atraso médio de chegada por destino e associe latitude
--     e longitude do aeroporto de destino.
--     Esta consulta poderia ser exportada depois para construção de um mapa.

-- 43. Acrescente aos voos a latitude e longitude tanto do aeroporto
--     de origem quanto do aeroporto de destino.
--     Use aliases diferentes para airports.


-- ------------------------------------------------------------
-- BLOCO 7 — WEATHER E CHAVES COMPOSTAS
-- ------------------------------------------------------------

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

-- 50. Para cada mês, identifique a companhia aérea com o maior número de voos.

-- 51. Calcule um ranking das companhias pelo atraso médio de chegada,
--     considerando somente companhias com pelo menos 1000 voos válidos.

-- 52. Identifique os dias de 2013 com os maiores atrasos médios de chegada.
--     Mostre ano, mês, dia, número de voos válidos e atraso médio.

-- 53. Investigue o dia 13 de junho de 2013:
--     a) número de voos;
--     b) atraso médio de partida;
--     c) atraso médio de chegada;
--     d) número de cancelamentos;
--     e) condições meteorológicas médias por aeroporto de origem.
--     Essa questão é inspirada diretamente em um exercício do R for Data Science.