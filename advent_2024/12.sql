-- DDL
DROP table if exists gifts CASCADE;
CREATE TABLE gifts (
    gift_id INT PRIMARY KEY,
    gift_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2)
);
DROP table if exists gift_requests CASCADE;
CREATE TABLE gift_requests (
    request_id INT PRIMARY KEY,
    gift_id INT,
    request_date DATE,
    FOREIGN KEY (gift_id) REFERENCES Gifts(gift_id)
);

INSERT INTO gifts VALUES 
(1, 'Robot Kit', 89.99),
(2, 'Smart Watch', 149.99),
(3, 'Teddy', 199.99),
(4, 'Hat', 59.99);

INSERT INTO gift_requests VALUES
(1, 1, '2024-12-25'),
(2, 1, '2024-12-25'),
(3, 1, '2024-12-25'),
(4, 2, '2024-12-25'),
(5, 2, '2024-12-25'),
(6, 2, '2024-12-25'),
(7, 3, '2024-12-25'),
(8, 3, '2024-12-25'),
(9, 3, '2024-12-25'),
(10, 3, '2024-12-25'),
(11, 4, '2024-12-25'),
(12, 4, '2024-12-25'),
(13, 4, '2024-12-25'),
(14, 4, '2024-12-25'),
(15, 4, '2024-12-25');

   
-- SQL
select
	g.gift_name,
	round(percent_rank() over(order by gr.gift_requests)::numeric, 2) as overall_rank
from (select gift_id, count(*) as gift_requests from gift_requests group by 1) gr
	inner join gifts g
		on gr.gift_id = g.gift_id
order by 2 desc, 1 asc