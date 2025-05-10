/* Обєднати всю активність користувача в одну таблицю:
session_id, event_name де будуть назви івентів з event_params, registration (якщо ця сесія є в account session) якщо є така подія.
ga_session_id = 3399339465
результат: ga_session_id, event_name */


SELECT
  ep.ga_session_id,
  ep.event_name,
FROM `data-analytics-mate.DA.event_params` ep
WHERE ep.ga_session_id = 3399339465

UNION ALL --OR UNION DISTINCT

SELECT
  acs.ga_session_id,
  'registration' AS event_name
FROM `data-analytics-mate.DA.account_session` acs
WHERE acs.ga_session_id = 3399339465;


SELECT ep.ga_session_id,
       ep.event_name,

       CASE WHEN acs.ga_session_id IS NOT NULL THEN 'registration' END AS registration
FROM `data-analytics-mate.DA.event_params` ep
LEFT JOIN `data-analytics-mate.DA.account_session` acs
  ON ep.ga_session_id = acs.ga_session_id
WHERE ep.ga_session_id = 3399339465;




/* Чи є листи, де ми записали клік, але не записали відкриття? */

# 309893 309893
SELECT DISTINCT eo.id_message
FROM `data-analytics-mate.DA.email_sent` es
JOIN `data-analytics-mate.DA.email_open` eo
  ON es.id_message = eo.id_message

UNION DISTINCT

SELECT DISTINCT ev.id_message
FROM `data-analytics-mate.DA.email_sent` es
JOIN `data-analytics-mate.DA.email_visit` ev
  ON es.id_message = ev.id_message;




/* Створити список активних сесій. Вважати сесію активною, якщо в ній було
два і більше івенти, або була реєстрація */


SELECT ep.ga_session_id AS active_sessions
FROM `data-analytics-mate.DA.event_params` ep
GROUP BY ep.ga_session_id
HAVING COUNT(ep.event_name) >= 2

UNION DISTINCT

SELECT ga_session_id AS active_sessions
FROM `data-analytics-mate.DA.account_session` acs;




/* Створи список сесій, у яких були підписки (account) або замовлення (order).
У результаті познач, які сесії походять з account, а які з order.
У кожній групі сесії повинні бути унікальними (якщо було кілька замовлень, сесія має з'явитися лише один раз).
Але в загальному списку одна й та сама сесія може зустрічатися двічі, якщо в ній були як підписки, так і замовлення. */


SELECT DISTINCT ga_session_id, 'account' AS event_types
FROM `data-analytics-mate.DA.account_session` acs

UNION ALL

SELECT DISTINCT ga_session_id, 'order' AS event_types
FROM `data-analytics-mate.DA.account_session` o;




/* Вивести в одній таблиці суму доходу та витрати на рекламу по днях.
Результуючий набір повинен мати такий вигляд:
date - type - value */


SELECT s.date,
       'revenue' AS type,
       SUM(p.price) AS value
FROM `data-analytics-mate.DA.order` o
LEFT JOIN `data-analytics-mate.DA.session` s
  ON o.ga_session_id = s.ga_session_id
LEFT JOIN `data-analytics-mate.DA.product` p
  ON o.item_id = p.item_id
GROUP BY s.date

UNION ALL

SElECT psc.date,
       'cost' AS type,
       SUM(psc.cost) AS value
FROM `data-analytics-mate.DA.paid_search_cost` psc
GROUP BY psc.date;
