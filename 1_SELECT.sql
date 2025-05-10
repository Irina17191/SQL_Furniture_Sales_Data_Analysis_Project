/* Переглянути загальну кількість сесій по дню, за який період в нас дані? Які тут тренди?*/

SELECT
  COUNT(ga_session_id) AS session_cnt,
  date
FROM `data-analytics-mate.DA.session`
GROUP BY date;



/* Які топові країни та девайси*/

SELECT
  sm.country,
  COUNT(s.ga_session_id) AS session_cnt,
FROM `data-analytics-mate.DA.session` s
JOIN `data-analytics-mate.DA.session_params` sm
  ON s.ga_session_id = sm.ga_session_id
GROUP BY sm.country
ORDER BY COUNT(s.ga_session_id) DESC;



SELECT
  sm.device,
  COUNT(s.ga_session_id) AS session_cnt,
FROM `data-analytics-mate.DA.session` s
JOIN `data-analytics-mate.DA.session_params` sm
  ON s.ga_session_id = sm.ga_session_id
GROUP BY sm.device
ORDER BY COUNT(s.ga_session_id) DESC;



/* В якому відсотку сесій були створені підписки (account)? */

SELECT
  COUNT(ass.account_id) / COUNT (s.ga_session_id) * 100 AS session_account
FROM `data-analytics-mate.DA.session` s
LEFT JOIN `data-analytics-mate.DA.account_session` ass
 ON s.ga_session_id = ass.ga_session_id;
