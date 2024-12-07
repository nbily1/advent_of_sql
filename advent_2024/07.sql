-- DDL
DROP table if exists workshop_elves CASCADE;
CREATE TABLE workshop_elves (
    elf_id SERIAL PRIMARY KEY,
    elf_name VARCHAR(100) NOT NULL,
    primary_skill VARCHAR(50) NOT NULL,
    years_experience INTEGER NOT NULL
);

INSERT INTO workshop_elves (elf_name, primary_skill, years_experience) VALUES
    ('Tinker', 'Toy Making', 150),
    ('Sparkle', 'Gift Wrapping', 75),
    ('Twinkle', 'Toy Making', 90),
    ('Holly', 'Cookie Baking', 200),
    ('Jolly', 'Gift Wrapping', 85),
    ('Berry', 'Cookie Baking', 120),
    ('Star', 'Toy Making', 95);
    
-- SQL
with cte as (
	select
		primary_skill as shared_skill,
		min(years_experience) as min_years_experience,
		max(years_experience) as max_years_experience
	from workshop_elves
	group by 1
 )
 select
 	min(ma.elf_id) as max_years_experience_elf_id,
 	min(mi.elf_id) as min_years_experience_elf_id,
 	c.shared_skill
from cte c
	inner join workshop_elves mi
		on c.min_years_experience = mi.years_experience
		and c.shared_skill = mi.primary_skill
	inner join workshop_elves ma
		on c.max_years_experience = ma.years_experience
		and c.shared_skill = ma.primary_skill
group by 3
order by 3