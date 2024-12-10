-- DDL
DROP TABLE IF EXISTS Reindeers CASCADE;
CREATE TABLE Reindeers (
    reindeer_id SERIAL PRIMARY KEY,
    reindeer_name VARCHAR(50) NOT NULL,
    years_of_service INTEGER NOT NULL,
    speciality VARCHAR(100)
);

DROP TABLE IF EXISTS Training_Sessions CASCADE;
CREATE TABLE Training_Sessions (
    session_id SERIAL PRIMARY KEY,
    reindeer_id INTEGER REFERENCES Reindeers(reindeer_id),
    exercise_name VARCHAR(100) NOT NULL,
    speed_record DECIMAL(5,2) NOT NULL,
    session_date DATE NOT NULL,
    weather_conditions VARCHAR(50)
);

INSERT INTO Reindeers (reindeer_name, years_of_service, speciality) VALUES
    ('Dasher', 287, 'Sprint Master'),
    ('Dancer', 283, 'Agility Expert'),
    ('Prancer', 275, 'High-Altitude Specialist'),
    ('Comet', 265, 'Long-Distance Expert'),
    ('Rudolf', 152, 'Night Navigation');

INSERT INTO Training_Sessions (reindeer_id, exercise_name, speed_record, session_date, weather_conditions) VALUES
    (1, 'Sprint Start', 88.5, '2024-11-15', 'Snowy'),
    (1, 'High-Speed Turn', 92.3, '2024-11-20', 'Clear'),
    (1, 'Rooftop Landing', 85.7, '2024-11-25', 'Windy'),
    (2, 'Sprint Start', 90.1, '2024-11-15', 'Snowy'),
    (2, 'High-Speed Turn', 94.8, '2024-11-20', 'Clear'),
    (2, 'Rooftop Landing', 89.2, '2024-11-25', 'Windy'),
    (3, 'Sprint Start', 87.3, '2024-11-15', 'Snowy'),
    (3, 'High-Speed Turn', 91.5, '2024-11-20', 'Clear'),
    (3, 'Rooftop Landing', 88.9, '2024-11-25', 'Windy'),
    (4, 'Sprint Start', 89.7, '2024-11-15', 'Snowy'),
    (4, 'High-Speed Turn', 93.2, '2024-11-20', 'Clear'),
    (4, 'Rooftop Landing', 87.8, '2024-11-25', 'Windy'),
    (5, 'Sprint Start', 86.9, '2024-11-15', 'Snowy'),
    (5, 'High-Speed Turn', 90.8, '2024-11-20', 'Clear'),
    (5, 'Rooftop Landing', 88.1, '2024-11-25', 'Windy');

   
-- SQL
with cte as (
	select
		r.reindeer_name,
		ts.exercise_name,
		round(avg(ts.speed_record),2) as avg_speed
	from reindeers r
		inner join training_sessions ts
			on r.reindeer_id = ts.reindeer_id
	where r.reindeer_name <> 'Rudolf'
	group by 1,2
)
select
	reindeer_name,
	max(avg_speed) as max_speed
from cte
group by 1
order by 2 desc
limit 3