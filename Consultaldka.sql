-- ============================================================================
-- AULA DE JOINS | ATIVIDADE ESTILO ENTREVISTA DE EMPREGO — SQL (SQLite / VS Code)
-- Duração prevista: 1h30 | Individual ou em duplas
-- ============================================================================
-- Cenário: vocês estão em uma entrevista para Analista de Dados. O recrutador faz
-- perguntas TEÓRICAS (respondam em comentário, como se falassem em voz alta) e
-- PRÁTICAS (escrevam a consulta). Expliquem o raciocínio: é isso que se avalia.
-- ============================================================================
-- Base: nycflights13 — tabelas usadas nesta aula:
--   flights(year,month,day,dep_time,dep_delay,arr_delay,carrier,flight,tailnum,origin,dest,distance,time_hour,...)
--   airlines(carrier PK, name)
--   airports(faa PK, name, lat, lon, alt, tz, dst, tzone)
--   planes(tailnum PK, year, type, manufacturer, model, engines, seats, speed, engine)
--   weather(origin, year, month, day, hour, temp, wind_speed, precip, time_hour, ...)
-- Chaves de ligação: flights.carrier=airlines.carrier | flights.origin/dest=airports.faa |
--                    flights.tailnum=planes.tailnum | flights.origin+time_hour=weather.origin+time_hour
-- Ferramentas: SELECT, FROM, WHERE, JOIN, ON, GROUP BY, ORDER BY, DISTINCT (+ LIMIT, COUNT, AVG).
-- PARTE A — PERGUNTAS TEÓRICAS (15 min) — responda em 2 a 4 linhas de comentário ===
-- T01. Qual a diferença entre INNER JOIN e LEFT JOIN? Dê um exemplo com as tabelas flights e planes.
-- RESPOSTA:
-- LEFT JOIN preserva a tabela da esquerda na hora do cruzamento, trazendo correspondência ou nulo da linha direita, enquanto isso o INNER JOIN traz a intercessão das duas tabelas ou seja traz somente aquilo que tem em comum.
SELECT *
FROM flights
    INNER JOIN planes ON flights.dep_delay = planes.model
LIMIT 10;
SELECT *
FROM flights
    LEFT JOIN planes ON flights.dep_delay = planes.model
LIMIT 10;
--
-- T02. O que são chave primária (PK) e chave estrangeira (FK)? Qual coluna liga flights a airlines? E flights a airports?
-- RESPOSTA:
Chave primaria é a chave de identificação dos elementos da tabela, a chave estrangeira é utilizada para facilitar o cruzamento de dados com a chave primária da tabela airports a coluna name se relaciona com origin.E flights names com o arr_time.-- T03. Se eu juntar duas tabelas por uma coluna que NÃO é única em uma delas, o que acontece com o número de linhas?
-- RESPOSTA:
As quantidades de linhas aumentam,
que se dá o nome de produto cartesiano -- T04. Qual a diferença entre colocar uma condição no ON e no WHERE em um LEFT JOIN?
-- RESPOSTA:
O
WHERE pode excluir dados por não haver correspondências do filtro.O ON pode trazer linhas sem correspondência sem perder elas.-- T05. Como encontrar linhas de uma tabela que NÃO têm correspondente em outra? Por que usar IS NULL e não '= NULL'?
    -- RESPOSTA:
    O = NULL considera os dados como vazios,
    enquanto o IS NULL reconhece valores como o zero por exemplo.-- T06. O que é um self join? Quando usar?
    -- RESPOSTA:
    É quando uma tabela é combinada com ela mesma.--
    -- T07. O que acontece com linhas cuja chave de junção é NULL? (ex.: voos com tailnum NULL)
    -- RESPOSTA:
    Onde o valor for nulo vai aparecer NULL -- T08. O que acontece se eu esquecer o ON (ou usar CROSS JOIN)? Quantas linhas teria flights x airlines?
    -- RESPOSTA:
    Será o plano cartesiano,
    ou seja,
    a quantidade total de linhas geradas será a multiplicação exata do número de linhas de uma tabela pelo número de linhas da outra.-- BÔNUS — Qual a diferença entre JOIN e UNION?
    -- RESPOSTA:
    O
UNION
realiza a junção verticalmente,
colocando os resultados empilhados em um conjunto de linhas enquanto o
JOIN horizontalmente utiliza de chaves primárias e secundárias e adiciona colunas lado a lado.


-- PARTE B — 'QUANTAS LINHAS?' SEM RODAR (10 min) ==============================
-- Execute este bloco UMA vez (cria duas tabelinhas de brinquedo no banco).
DROP TABLE IF EXISTS tab_a;
DROP TABLE IF EXISTS tab_b;
CREATE TABLE tab_a (id INTEGER);
CREATE TABLE tab_b (id INTEGER);
INSERT INTO tab_a (id)
VALUES (1),(2),(3),(3),(NULL);
INSERT INTO tab_b (id)
VALUES (3),3),(4),(NULL);
tab_a = { 1,2,3,3, NULL } | tab_b = { 3,3,4,NULL }


 -- PRIMEIRO escreva sua previsão do número de linhas; DEPOIS rode COUNT(*) para conferir.
-- Q1. Quantas linhas retorna: tab_a INNER JOIN tab_b ON tab_a.id = tab_b.id?
-- MINHA PREVISÃO: 4
-- (o 3 aparece 2x em cada tabela: 2 x 2 = 4; o NULL não casa com nada)
SELECT COUNT(*) FROM tab_a INNER JOIN tab_b ON tab_a.id = tab_b.id;

-- Q2. tab_a LEFT JOIN tab_b ON tab_a.id = tab_b.id
-- MINHA PREVISÃO: 7
-- (1 -> 1 linha; 2 -> 1 linha; 3 e 3 -> 2 cada = 4 linhas; NULL -> 1 linha)
SELECT COUNT(*) FROM tab_a LEFT JOIN tab_b ON tab_a.id = tab_b.id;

-- Q3. tab_a LEFT JOIN tab_b ... WHERE tab_b.id IS NULL
-- MINHA PREVISÃO: 3
-- (só ficam as linhas sem par: o 1, o 2 e o NULL de tab_a)
SELECT COUNT(*) FROM tab_a LEFT JOIN tab_b ON tab_a.id = tab_b.id WHERE tab_b.id IS NULL;

 
-- Q4. tab_a CROSS JOIN tab_b (sem ON)
-- MINHA PREVISÃO: 20
-- (5 x 4)
SELECT COUNT(*) FROM tab_a CROSS JOIN tab_b;

-- PARTE C — PRÁTICA: ESCREVA A CONSULTA (45 min) ==============================
-- P01. Quais aeroportos de destino ficam acima de 5.000 pés de altitude (airports.alt) e recebem voos de NYC? Mostre faa, name e alt, do mais alto para o mais baixo, cada aeroporto uma vez.
SELECT DISTINCT ap.faa, ap.name, ap.alt
FROM flights f
    JOIN airports ap ON ap.faa = f.dest
WHERE ap.alt > 5000
ORDER BY ap.alt DESC;

-- P02. Quais modelos de aeronave com mais de 200 assentos (planes.seats) realizaram voos? Mostre manufacturer, model e seats, sem repetição, do maior para o menor número de assentos (15 linhas).
SELECT DISTINCT p.manufacturer, p.model, p.seats
FROM flights f
    JOIN planes p ON p.tailnum = f.tailnum
WHERE p.seats > 200
ORDER BY p.seats DESC
LIMIT 15;

-- P03. Quantos voos de NYC chegaram a destinos de cada fuso horário (airports.tz)? Ordene pelo fuso.
SELECT ap.tz, COUNT(*) AS num_voos
FROM flights f
    JOIN airports ap ON ap.faa = f.dest
GROUP BY ap.tz
ORDER BY ap.tz;

-- P04. Quantos voos e qual o atraso médio de partida (dep_delay) por ano de fabricação da aeronave (planes.year)? Ignore year NULL e mostre os 10 anos de fabricação mais recentes.
SELECT p.year AS ano_fabricacao,
    COUNT(*) AS num_voos,
    ROUND(AVG(f.dep_delay), 2) AS atraso_medio_partida
FROM flights f
    JOIN planes p ON p.tailnum = f.tailnum
WHERE p.year IS NOT NULL
GROUP BY p.year
ORDER BY p.year DESC
LIMIT 10;

-- P05. Qual o número médio de assentos das aeronaves usadas por cada companhia aérea (nome completo)? Considere cada voo como uma observação. Ordene da maior média para a menor.
SELECT al.name AS companhia,
    ROUND(AVG(p.seats), 2) AS media_assentos
FROM flights f
    JOIN planes p ON p.tailnum = f.tailnum
    JOIN airlines al ON al.carrier = f.carrier
GROUP BY al.name
ORDER BY media_assentos DESC;

-- P06. Quais companhias (nome completo) operaram aeronaves AIRBUS ou AIRBUS INDUSTRIE? Mostre também quantos voos cada uma fez com essas aeronaves. Dica: confira os valores com SELECT DISTINCT manufacturer FROM planes.
SELECT al.name AS companhia,
    COUNT(*) AS voos_airbus
FROM flights f
    JOIN planes p ON p.tailnum = f.tailnum
    JOIN airlines al ON al.carrier = f.carrier
WHERE p.manufacturer IN ('AIRBUS', 'AIRBUS INDUSTRIE')
GROUP BY al.name
ORDER BY voos_airbus DESC;

-- P07. Em cada aeroporto de origem, quantos voos decolaram com vento (weather.wind_speed) acima de 25 mph, e qual foi o atraso médio de partida nesses voos? Dica: weather é identificada por origin + time_hour.
SELECT f.origin,
    COUNT(*) AS num_voos,
    ROUND(AVG(f.dep_delay), 2) AS atraso_medio_partida
FROM flights f
    JOIN weather w ON w.origin = f.origin
    AND w.time_hour = f.time_hour
WHERE w.wind_speed > 25
GROUP BY f.origin;

-- P08. Self join: liste as outras aeronaves (tailnum) do MESMO fabricante e MESMO modelo da aeronave N10156 (sem incluir a própria N10156).
SELECT p2.tailnum
FROM planes p1
    JOIN planes p2 ON p2.manufacturer = p1.manufacturer
    AND p2.model = p1.model
WHERE p1.tailnum = 'N10156'
    AND p2.tailnum <> 'N10156'
ORDER BY p2.tailnum;

-- P09. Liste os 10 aeroportos do cadastro airports que MENOS receberam voos como destino, incluindo os que receberam ZERO, com o número de voos recebidos.
SELECT ap.faa, ap.name,
    COUNT(f.dest) AS voos_recebidos
FROM airports ap
    LEFT JOIN flights f ON f.dest = ap.faa
GROUP BY ap.faa, ap.name
ORDER BY voos_recebidos ASC, ap.faa
LIMIT 10;
 
-- P10. Quais companhias aéreas (nome completo) NUNCA operaram um voo saindo de LGA?
SELECT al.name AS companhia
FROM airlines al
    LEFT JOIN flights f ON f.carrier = al.carrier
    AND f.origin = 'LGA'
WHERE f.carrier IS NULL;
 
-- P11. DESAFIO 1 — Para cada companhia (nome completo), quantos voos para destinos acima de 3.000 pés de altitude foram operados por aeronaves com menos de 100 assentos? Ordene do maior para o menor.
SELECT al.name AS companhia,
    COUNT(*) AS num_voos
FROM flights f
    JOIN airlines al ON al.carrier = f.carrier
    JOIN airports ap ON ap.faa = f.dest
    JOIN planes p ON p.tailnum = f.tailnum
WHERE ap.alt > 3000
    AND p.seats < 100
GROUP BY al.name
ORDER BY num_voos DESC;

-- P12. DESAFIO 2 — Para cada aeroporto de origem (nome completo) e para cada fabricante entre BOEING, AIRBUS e EMBRAER, quantos voos foram operados? Ordene por nome do aeroporto e, dentro dele, do maior para o menor número de voos.
SELECT COALESCE(ap.name, f.origin) AS aeroporto_origem,
    p.manufacturer AS fabricante,
    COUNT(*) AS num_voos
FROM flights f
    JOIN planes p ON p.tailnum = f.tailnum
    LEFT JOIN airports ap ON ap.faa = f.origin
WHERE p.manufacturer IN ('BOEING', 'AIRBUS', 'EMBRAER')
GROUP BY f.origin, ap.name, p.manufacturer
ORDER BY aeroporto_origem, num_voos DESC;

-- PARTE D — DEBUG: 'O QUE HÁ DE ERRADO?' (15 min) =============================

-- Copie a consulta, execute, explique o problema em comentário e escreva a versão correta.
-- D1. Quero cada voo com o nome da companhia, mas o resultado mostra a MESMA companhia para todos os voos. Por quê? Corrija.
-- CONSULTA COM PROBLEMA:
--   SELECT f.flight, a.name
--   FROM flights AS f, airlines AS a
--   LIMIT 5;
-- EXPLICAÇÃO:
-- A vírgula no FROM faz um produto cartesiano (CROSS JOIN) e falta a condição de
-- ligação. Cada voo é combinado com todas as 16 companhias (336.776 x 16 linhas).
-- Com LIMIT 5 só vemos as primeiras linhas, que repetem a mesma companhia.
-- VERSÃO CORRIGIDA:
SELECT f.flight, a.name
FROM flights AS f
    JOIN airlines AS a ON f.carrier = a.carrier
LIMIT 5;

-- VERSÃO CORRIGIDA:
-- D2. Quero TODOS os voos, mostrando o modelo da aeronave só quando for BOEING (NULL nos demais). A consulta abaixo perde voos. Por quê? Corrija.
-- CONSULTA COM PROBLEMA:
--   SELECT f.flight, f.tailnum, p.model
--   FROM flights AS f
--   LEFT JOIN planes AS p ON f.tailnum = p.tailnum
--   WHERE p.manufacturer = 'BOEING'
--   LIMIT 10;
-- EXPLICAÇÃO:
-- O WHERE roda depois da junção. Os voos sem avião correspondente (e os de
-- outros fabricantes) têm p.manufacturer NULL ou diferente de 'BOEING' e são
-- eliminados, então o LEFT JOIN vira na prática um INNER JOIN (82.912 linhas
-- em vez de 336.776). A condição precisa ir para o ON.
-- VERSÃO CORRIGIDA:
SELECT f.flight, f.tailnum, p.model
FROM flights AS f
    LEFT JOIN planes AS p ON f.tailnum = p.tailnum
    AND p.manufacturer = 'BOEING'
LIMIT 10;

-- D3. A consulta abaixo dá erro. Qual é a mensagem e como corrigir?
-- CONSULTA COM PROBLEMA:
--   SELECT name, f.flight
--   FROM flights AS f
--   INNER JOIN airlines AS a ON f.carrier = a.carrier
--   INNER JOIN airports AS ap ON f.origin = ap.faa
--   LIMIT 5;
-- EXPLICAÇÃO:
-- Mensagem: "ambiguous column name: name". As tabelas airlines e airports têm
-- uma coluna chamada name, e o SQLite não sabe de qual delas se trata. É preciso
-- qualificar a coluna com o alias da tabela (a.name ou ap.name).
-- VERSÃO CORRIGIDA:
SELECT a.name AS companhia, f.flight
FROM flights AS f
    INNER JOIN airlines AS a ON f.carrier = a.carrier
    INNER JOIN airports AS ap ON f.origin = ap.faa
LIMIT 5;

-- D4. A consulta abaixo roda sem erro, mas devolve 0 linhas. Por quê? Corrija.
-- CONSULTA COM PROBLEMA:
--   SELECT f.flight, ap.name
--   FROM flights AS f
--   INNER JOIN airports AS ap ON f.dest = ap.name
--   LIMIT 5;
-- EXPLICAÇÃO:
-- A junção compara f.dest (código FAA de 3 letras, ex.: 'DFW') com ap.name (nome
-- completo, ex.: 'Dallas Fort Worth Intl'). Esses valores nunca são iguais, então
-- nada casa. A chave correta de airports é a coluna faa.
-- VERSÃO CORRIGIDA:
SELECT f.flight, ap.name
FROM flights AS f
    INNER JOIN airports AS ap ON f.dest = ap.faa
LIMIT 5;
-- FIM ========================================================================