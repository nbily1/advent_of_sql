-- DDL
DROP TABLE IF EXISTS staff;
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
    (10, 'Apprentice Toy Maker', 7);         -- Entry Level

   
-- SQL
WITH RECURSIVE subs
AS(
    -- anchor member
    SELECT staff_id as anchr, staff_id, staff_name, manager_id, 1 as lvl, trim(cast(staff_id as varchar(1000))) as "path" FROM staff where manager_id is null
    union
    -- recursive term
    SELECT anchr, s.staff_id, s.staff_name, s.manager_id, lvl + 1 as lvl, concat("path", concat(',', trim(cast(s.staff_id as varchar(1000))))) as "path"
    FROM subs su
    	inner join staff s
    		on s.manager_id = su.staff_id
)
select
	staff_id,
	staff_name,
	lvl as "level",
	"path",
	manager_id,
	count(staff_id) over(partition by coalesce(manager_id, -5000)) as peers_same_manager,
	count(staff_id) over(partition by lvl) as total_peers_same_level
from subs
order by 7 desc, 3, 1
;