-- q1:SELECT * FROM flights LIMIT 10;

-- q2:SELECT year, month, day, carrier, flight, origin, dest FROM flights LIMIT 20;   

-- q3:SELECT DISTINCT origin FROM flights;

-- q4:SELECT DISTINCT dest FROM flights; ORDER BY ASC; 

-- q5:SELECT DISTINCT origin, dest, carrier, flight, distance FROM flights ORDER BY distance DESC LIMIT 20;

-- q6:SELECT * FROM flights WHERE dest = 'LAX';

-- q7:SELECT * FROM flights WHERE origin = 'JFK' AND dest = 'LAX';

-- q8:SELECT * FROM flights WHERE dep_delay > 120 ORDER BY dep_delay DESC; 
