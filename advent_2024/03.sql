-- DDL
DROP TABLE IF EXISTS christmas_menus CASCADE;

CREATE TABLE christmas_menus (
  id SERIAL PRIMARY KEY,
  menu_data XML
);

INSERT INTO christmas_menus (id, menu_data) VALUES
(1, '<menu version="1.0">
    <dishes>
        <dish>
            <food_item_id>99</food_item_id>
        </dish>
        <dish>
            <food_item_id>102</food_item_id>
        </dish>
    </dishes>
    <total_count>80</total_count>
</menu>');

INSERT INTO christmas_menus (id, menu_data) VALUES
(2, '<menu version="2.0">
    <total_guests>85</total_guests>
    <dishes>
        <dish_entry>
            <food_item_id>101</food_item_id>
        </dish_entry>
        <dish_entry>
            <food_item_id>102</food_item_id>
        </dish_entry>
    </dishes>
</menu>');

INSERT INTO christmas_menus (id, menu_data) VALUES
(3, '<menu version="beta">
  <guestCount>15</guestCount>
  <foodList>
      <foodEntry>
          <food_item_id>102</food_item_id>
      </foodEntry>
  </foodList>
</menu>');


-- SQL
with cte as (
    select
        id,
        substring(cast(menu_data as varchar(10000)) from '<[a-z_]+ version=".{1,10}">') as "version",
        menu_data
    from christmas_menus cm
)
, cte2 as (
    select
        id,
        "version",
        cast(substring(
            case substring("version", '\d\.\d')
                when '1.0' then 
                    cast(xpath('northpole_database/annual_celebration/event_metadata/dinner_details/guest_registry/total_count/text()', menu_data) as varchar(1000))
                when '2.0' then
                    cast(xpath('christmas_feast/organizational_details/attendance_record/total_guests/text()', menu_data) as varchar(1000))
                when '3.0' then
                    cast(xpath('polar_celebration/event_administration/participant_metrics/attendance_details/headcount/total_present/text()', menu_data) as varchar(1000))
                end
            , '\d+'
            ) as int)
            as attendance,
        replace(replace(
            case substring("version", '\d\.\d')
                when '1.0' then 
                    cast(xpath('northpole_database/annual_celebration/event_metadata/menu_items/food_category/food_category/dish/food_item_id/text()', menu_data) as varchar(1000))
                when '2.0' then
                    cast(xpath('christmas_feast/organizational_details/menu_registry/course_details/dish_entry/food_item_id/text()', menu_data) as varchar(1000))
                when '3.0' then
                    cast(xpath('polar_celebration/event_administration/culinary_records/menu_analysis/item_performance/food_item_id/text()', menu_data) as varchar(1000))
                end
            , '{', ''), '}', '')
                as dishes
    from cte
)
, cte3 as (
    SELECT dish, id
    FROM   cte2 c, string_to_table(dishes, ',') dish
    WHERE  c.attendance > 78
)
select dish, count(*)
from cte3
group by 1
order by 2 desc