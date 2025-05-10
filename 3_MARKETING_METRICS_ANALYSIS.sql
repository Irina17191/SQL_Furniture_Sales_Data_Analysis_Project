# Marketing Metrics Analysis

/* Порахувати Open Rate, Click Rate,CTOR по листах.
Отримати такий результуючий набір: email_sent_cnt - email_open_cnt - email_click_cnt -
email_open_cnt / email_sent_cnt - email_click_cnt / email_sent_cnt - email_click_cnt / email_open_cnt */


SELECT
  COUNT(DISTINCT es.id_message) AS email_sent_cnt,
  COUNT(DISTINCT eo.id_message) AS email_open_cnt,
  COUNT(DISTINCT ev.id_message) AS email_click_cnt,
  COUNT(DISTINCT eo.id_message) / COUNT(DISTINCT es.id_message) AS OpenRate,
  COUNT(DISTINCT ev.id_message) / COUNT(DISTINCT es.id_message) AS ClickRate,
  COUNT(DISTINCT ev.id_message) / COUNT(DISTINCT eo.id_message) AS CTOR
FROM `data-analytics-mate.DA.email_sent` es
LEFT JOIN `data-analytics-mate.DA.email_open` eo
  ON es.id_message = eo.id_message
LEFT JOIN `data-analytics-mate.DA.email_visit` ev
  ON es.id_message = ev.id_message;




/* В якій країні найкращий click_rate? З топ трьох за кількістю відправлених.*/


SELECT
  sp.country,
  COUNT(DISTINCT es.id_message) AS email_sent_cnt,
  COUNT(DISTINCT eo.id_message) AS email_open_cnt,
  COUNT(DISTINCT ev.id_message) AS email_click_cnt,
  COUNT(DISTINCT eo.id_message) / COUNT(DISTINCT es.id_message) AS OpenRate,
  COUNT(DISTINCT ev.id_message) / COUNT(DISTINCT es.id_message) AS ClickRate,
  COUNT(DISTINCT ev.id_message) / COUNT(DISTINCT eo.id_message) AS CTOR
FROM `data-analytics-mate.DA.email_sent` es
LEFT JOIN `data-analytics-mate.DA.email_open` eo
  ON es.id_message = eo.id_message
LEFT JOIN `data-analytics-mate.DA.email_visit` ev
  ON es.id_message = ev.id_message
LEFT JOIN `data-analytics-mate.DA.account_session` acs
  ON es.id_account = acs.account_id
LEFT JOIN `data-analytics-mate.DA.session_params` sp
  ON acs.ga_session_id = sp.ga_session_id
GROUP BY sp.country
ORDER BY COUNT(DISTINCT es.id_message) DESC
LIMIT 4;




/* Виконати запит до бази даних, щоб знайти тип листа (letter_type) з найвищим показником open_rate у
Сполучених Штатах. Результуючий набір повинен мати один рядок з такими полями:
| letter_type | email_sent_cnt | email_open_cnt | open_rate | */


SELECT es.letter_type,
  COUNT(DISTINCT es.id_message) AS email_sent_cnt,
  COUNT(DISTINCT eo.id_message) AS email_open_cnt,
  COUNT(DISTINCT eo.id_message) / COUNT(DISTINCT es.id_message) AS open_rate
FROM `data-analytics-mate.DA.email_sent` es
LEFT JOIN `data-analytics-mate.DA.email_open` eo
  ON es.id_message = eo.id_message
LEFT JOIN `data-analytics-mate.DA.account_session` acs
  ON es.id_account = acs.account_id
LEFT JOIN `data-analytics-mate.DA.session_params` sp
  ON acs.ga_session_id = sp.ga_session_id
WHERE sp.country = 'United States'
GROUP BY es.letter_type
ORDER BY open_rate DESC
LIMIT 1;




/* Emails Sent to Unsubscribers. Визнач кількість листів, відправлених користувачам, які вже відписалися від
розсилки. Виведи цю інформацію в розрізі країн.
Зроби сортування країн за кількістю таких відправлених листів у порядку спадання (від більшої до меншої).
Набір даних повинен мати такий вигляд: | country      | sent_cnt | */


SELECT sp.country,
  COUNT(DISTINCT es.id_message) AS sent_count
FROM `data-analytics-mate.DA.email_sent` es
JOIN `data-analytics-mate.DA.account` acc
  ON es.id_account = acc.id
LEFT JOIN `data-analytics-mate.DA.account_session` acs
  ON es.id_account = acs.account_id
LEFT JOIN `data-analytics-mate.DA.session_params` sp
  ON acs.ga_session_id = sp.ga_session_id
WHERE acc.is_unsubscribed = 1
GROUP BY sp.country
ORDER BY sent_count DESC;
