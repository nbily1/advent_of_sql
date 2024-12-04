-- DDL
DROP TABLE IF EXISTS toy_production CASCADE;
CREATE TABLE toy_production (
  toy_id INT,
  toy_name VARCHAR(100),
  previous_tags TEXT[],
  new_tags TEXT[]
);

INSERT INTO toy_production VALUES
(1, 'Robot', ARRAY['fun', 'battery'], ARRAY['smart', 'battery', 'educational', 'scientific']),
(2, 'Doll', ARRAY['cute', 'classic'], ARRAY['cute', 'collectible', 'classic']),
(3, 'Puzzle', ARRAY['brain', 'wood'], ARRAY['educational', 'wood', 'strategy']);


-- SQL
with p as (
    select toy_id, unnest(previous_tags) as previous_tag
    from toy_production t
)
, n as (
    select toy_id, unnest(new_tags) as new_tag
    from toy_production t
)
, comb as (
	select
		p.toy_id, cast(null as varchar(30)) as added, p.previous_tag as unchanged, cast(null as varchar(30)) as removed
	from p
		inner join n
			on p.toy_id = n.toy_id
			and p.previous_tag = n.new_tag
	union
	select
		p.toy_id, cast(null as varchar(30)) as added, cast(null as varchar(30)) as unchanged, p.previous_tag as removed
	from p
	where not exists (select 1 from n where p.toy_id = n.toy_id and p.previous_tag = n.new_tag)
	union
	select
		n.toy_id, n.new_tag as added, cast(null as varchar(30)) as unchanged, cast(null as varchar(30)) as removed
	from n
	where not exists (select 1 from p where p.toy_id = n.toy_id and p.previous_tag = n.new_tag)
)
select
	toy_id,
	count(added) as added,
	count(unchanged) as unchanged,
	count(removed) as removed
from comb
group by 1
order by 2 desc