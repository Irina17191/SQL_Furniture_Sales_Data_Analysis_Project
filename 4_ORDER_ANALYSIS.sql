# Orders Analysis

/* Вивести динаміку кількості продажей та та доходів по днях
(зрозуміти скільки взагалі в середньому в день ми заробляємо) */


SELECT s.date,
      COUNT(o.ga_session_id) AS orders_cnt,
      SUM(p.price) AS income
FROM `data-analytics-mate.DA.order` o
JOIN `data-analytics-mate.DA.session` s
  ON o.ga_session_id = s.ga_session_id
JOIN `data-analytics-mate.DA.product` p
  ON o.item_id = p.item_id
GROUP BY s.date
--ORDER BY s.date DESC




/* Яку категорію товарів купляли найчастіше? А яка принесла найбільше доходу ? */


SELECT p.category,
      COUNT(o.ga_session_id) AS orders_count,
      SUM(p.price) AS revenue
FROM `data-analytics-mate.DA.order` o
JOIN `data-analytics-mate.DA.session` s
  ON o.ga_session_id = s.ga_session_id
JOIN `data-analytics-mate.DA.product` p
  ON o.item_id = p.item_id
GROUP BY p.category
--ORDER BY COUNT(o.ga_session_id) DESC
ORDER BY SUM(p.price) DESC




/* В якій країні купили найбільше товарів з категорії Cabinets & Cupboards? */


SELECT sp.country,
      COUNT(o.ga_session_id) AS orders_count,
      SUM(p.price) AS revenue
FROM `data-analytics-mate.DA.order` o
JOIN `data-analytics-mate.DA.session_params` sp
  ON o.ga_session_id = sp.ga_session_id
JOIN `data-analytics-mate.DA.product` p
  ON o.item_id = p.item_id
WHERE p.category = 'Cabinets & cupboards'
GROUP BY sp.country
ORDER BY orders_count DESC
LIMIT 1;




/* Порахувати середню ціну товарів у кожній категорії.
Зробити сортування категорій за середньою ціною у порядку спадання (від найдорожчої до найдешевшої).
Набір даних повинен мати такий вигляд:
| category       | average_price |*/


SELECT category,
       ROUND(AVG(price), 2) AS average_price
FROM `data-analytics-mate.DA.product`
GROUP BY category
ORDER BY average_price DESC;




/* Створи запит, який обчислює кількість проданих товарів та загальний дохід від продажів у категорії Beds для кожної країни на континенті Європа.
Знайди країну з найбільшою кількістю покупок у категорії Beds.
Набір даних повинен мати такий вигляд:
| country       | revenue  | count_of_orders |*/


SELECT sp.country,
      ROUND(SUM(p.price), 2) AS revenue,
      COUNT(o.ga_session_id) AS count_of_orders
FROM `data-analytics-mate.DA.order` o
JOIN `data-analytics-mate.DA.session_params` sp
  ON o.ga_session_id = sp.ga_session_id
JOIN `data-analytics-mate.DA.product` p
  ON o.item_id = p.item_id
WHERE p.category = 'Beds' AND sp.continent = 'Europe'
GROUP BY sp.country
ORDER BY count_of_orders DESC;
