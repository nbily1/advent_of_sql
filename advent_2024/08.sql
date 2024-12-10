-- DDL
CREATE TABLE staff (
    staff_id INT PRIMARY KEY,
    staff_name VARCHAR(100) NOT NULL,
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES Staff(staff_id)
);

INSERT INTO staff (staff_id, staff_name, manager_id) VALUES
    (1, 'Santa Claus', NULL),                -- CEO level
    (2, 'Head Elf Operations', 1),           -- Department Head
    (3, 'Head Elf Logistics', 1),            -- Department Head
    (4, 'Senior Toy Maker', 2),              -- Team Lead
    (5, 'Senior Gift Wrapper', 2),           -- Team Lead
    (6, 'Inventory Manager', 3),             -- Team Lead
    (7, 'Junior Toy Maker', 4),              -- Staff
    (8, 'Junior Gift Wrapper', 5),           -- Staff
    (9, 'Inventory Clerk', 6),               -- Staff
    (10, 'Apprentice Toy Maker', 7);         -- Entry level
    ;
   
-- SQL
WITH RECURSIVE subs
AS(
    -- anchor member
    SELECT staff_id as anchr, staff_id, staff_name, manager_id FROM staff
    union
    -- recursive term
    SELECT anchr, s.staff_id, s.staff_name, s.manager_id
    FROM subs su
    	inner join staff s
    		on s.staff_id = su.manager_id
)
SELECT anchr, count(*) FROM subs group by 1 order by 2 desc limit 1;