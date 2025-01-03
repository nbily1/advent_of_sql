-- DDL
DROP TABLE IF EXISTS elves CASCADE;
    CREATE TABLE elves (
      id SERIAL PRIMARY KEY,
      elf_name VARCHAR(255) NOT NULL,
      skills TEXT NOT NULL
    );
   
INSERT INTO elves (elf_name, skills)
VALUES 
    ('Eldrin', 'Elixir,Python,C#,JavaScript,MySQL'),           -- 4 programming skills
    ('Faenor', 'C++,Ruby,Kotlin,Swift,Perl'),          -- 5 programming skills
    ('Luthien', 'PHP,TypeScript,Go,SQL');              -- 4 programming skills

   
-- SQL
select
	count(*) as numofelveswithsql
from elves
where regexp_match(skills, '(^|,)SQL(,|$)') is not null