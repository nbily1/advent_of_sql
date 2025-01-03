-- DDL
DROP TABLE IF EXISTS web_requests;
CREATE TABLE web_requests (
    request_id SERIAL PRIMARY KEY,
  url TEXT NOT NULL
);

INSERT INTO web_requests (url) VALUES
('http://example.com/page?param1=value1¶m2=value2'),
('https://shop.example.com/items?item=toy&color=red&size=small&ref=google&utm_source=advent-of-sql'),
('http://news.example.org/article?id=123&source=rss&author=jdoe&utm_source=advent-of-sql'),
('https://travel.example.net/booking?dest=paris&date=2024-12-19&class=business'),
('http://music.example.com/playlist?genre=pop&duration=long&listener=guest&utm_source=advent-of-sql');

   
-- SQL
-- NOTE: puzzle does not specify to count the distinct parameter names
-- but that is apparently what the solution wants
select url, count(distinct a[1])
from (
select distinct
	url,
	regexp_split_to_array(regexp_split_to_table(substring(substring(url, '\?.+'), 2), '&'), '=') as a
--	length(url) - length(replace(url, '&', ''))
from web_requests wr
where url like '%utm_source=advent-of-sql%'
) sub
group by 1
order by 2 desc, url
limit 1
;