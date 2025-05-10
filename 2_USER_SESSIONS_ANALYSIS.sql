# User Sessions Analysis

/* Sessions by Browsers. Порахуй кількість сесій для кожного браузера,використовуючи поле browser.
Зроби сортування браузерів за кількістю сесій у порядку спадання.*/



SELECT
  browser,
  COUNT(ga_session_id) AS session_count
FROM `data-analytics-mate.DA.session_params`
GROUP BY browser
ORDER BY session_count DESC;



/* Вирахувати відсоток сесій з покупками для кожної країни. Відсоток сесій з покупками розраховується
як відношення кількості сесій, в яких були зроблені покупки, до загальної кількості сесій для цієї країни.
Вивести цей показник по кожній країні. Зробити сортування країн за кількістю сесій у порядку спадання.*/

SELECT
  country,
  COUNT(o.ga_session_id) / COUNT(sp.ga_session_id) * 100 AS session_with_orders_percent,
  COUNT(o.ga_session_id) AS session_with_orders,
  COUNT(sp.ga_session_id) AS total_session_cnt
FROM `data-analytics-mate.DA.session_params` sp
LEFT JOIN `data-analytics-mate.DA.order` o
  ON sp.ga_session_id = o.ga_session_id
GROUP BY country
ORDER BY COUNT(o.ga_session_id) DESC;



/* Визначити кількість сесій, які містять подію scroll (поле event_params.event_name) для країни
United Kingdomі для сесій, під час яких було створено акаунт (для цього використай таблицю account_session).
Для підрахунку кількості сесій використай distinct. Результат повинен містити загальну кількість таких сесій.*/

SELECT
  COUNT(DISTINCT sp.ga_session_id) AS session_cnt
FROM `data-analytics-mate.DA.session_params` sp
JOIN `data-analytics-mate.DA.event_params` e
  ON e.ga_session_id = sp.ga_session_id
JOIN `data-analytics-mate.DA.account_session` acs
  ON sp.ga_session_id = acs.ga_session_id
WHERE
  event_name = 'scroll'
  AND country = 'United Kingdom';
