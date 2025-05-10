# Revenue by Device

/* Country - revenue from mobile - revenue from desktop - % revenue from mobile from total */


SELECT sp.country,
       SUM(CASE WHEN sp.device = 'mobile' THEN p.price END) AS revenue_from_mobile,
       SUM(CASE WHEN sp.device = 'desktop' THEN p.price END) AS revenue_from_desktop,
       SUM(CASE WHEN sp.device = 'mobile' THEN p.price END) / SUM(p.price) * 100 AS revenue_from_mobile_percent
FROM `data-analytics-mate.DA.order` o
JOIN `data-analytics-mate.DA.session_params` sp
  ON o.ga_session_id = sp.ga_session_id
JOIN `data-analytics-mate.DA.product` p
  ON o.item_id = p.item_id
GROUP BY sp.country
ORDER BY SUM(p.price) DESC;




# Revenue by Session Type

/* Який відсоток доходу приносять сесії, під час яких користувачі зареєструвалися?
Якщо брати середній дохід на одну сесію, то він більший ніж у того, хто не реєструвався, чи менший ?
Вивести дані з розбивкою на mobile / desctop /*


SELECT sp.device,
       SUM(p.price) AS revenue,

       SUM(CASE WHEN acs.ga_session_id IS NOT NULL THEN p.price ELSE 0 END) AS revenue_usd_for_registered_sessions,
       SUM(CASE WHEN acs.ga_session_id IS NULL THEN p.price ELSE 0 END) AS revenue_usd_for_not_registered_sessions,

       SUM(CASE WHEN acs.ga_session_id IS NOT NULL THEN p.price ELSE 0 END) * 100 / SUM(p.price) AS revenue_percent_from_registered,

       COUNT(DISTINCT CASE WHEN acs.ga_session_id IS NOT NULL THEN sp.ga_session_id END) AS registered_session_cnt,
       COUNT(DISTINCT CASE WHEN acs.ga_session_id IS NULL THEN sp.ga_session_id END) AS not_registered_session_cnt,
       COUNT(DISTINCT sp.ga_session_id) AS total_sessions_cnt,

       SUM(CASE WHEN acs.ga_session_id IS NOT NULL THEN p.price ELSE 0 END) /
       COUNT(DISTINCT CASE WHEN acs.ga_session_id IS NOT NULL THEN sp.ga_session_id END) AS avg_revenue_usd_for_one_registered_session,

       SUM(CASE WHEN acs.ga_session_id IS NULL THEN p.price ELSE 0 END) /
       COUNT(DISTINCT CASE WHEN acs.ga_session_id IS NULL THEN sp.ga_session_id END) AS avg_revenue_usd_for_one_not_registered_session

FROM `data-analytics-mate.DA.order` o
JOIN `data-analytics-mate.DA.session_params` sp
  ON  o.ga_session_id = sp.ga_session_id
JOIN `data-analytics-mate.DA.product` p
  ON o.item_id = p.item_id
LEFT JOIN `data-analytics-mate.DA.account_session` acs
  ON o.ga_session_id = acs.ga_session_id
GROUP BY sp.device;




# Segmentation by Income

/* Сегментувати всі країни на 3 групи: ті які принесли більше 50 000$ - Top,
 Ті, які принесли більше 10 000$ і менше 50 000$ - Middle, всі інші - Low */


SELECT sp.country,
       SUM(p.price) AS revenue,
       CASE WHEN SUM(p.price) >= 50000 THEN 'Top'
            WHEN SUM(p.price) < 50000 AND SUM(p.price) >= 10000 THEN 'Middle'
            ELSE 'Low' END AS revenue_segmentation

FROM `data-analytics-mate.DA.order` o
JOIN `data-analytics-mate.DA.session_params` sp
  ON o.ga_session_id = sp.ga_session_id
JOIN `data-analytics-mate.DA.product` p
  ON o.item_id = p.item_id
GROUP BY sp.country
ORDER BY SUM(p.price) DESC;




# Emails Sent to Unsubscribers by Country

/* Для кожної країни:
підрахуй загальну кількість відправлених імейлів (sent_cnt);
визнач кількість імейлів, відправлених акаунтам, які відписалися, та обчисли відсоток (sent_cnt_unsub_percent).
Відсортуй результати за кількістю всіх відправлених імейлів у спадному порядку.
Представ результати у форматі таблиці зі стовпцями country, sent_cnt та sent_cnt_unsub_percent. */


SELECT sp.country,
       COUNT(DISTINCT es.id_message) AS email_sent_cnt,
       COUNT(DISTINCT CASE WHEN acc.is_unsubscribed = 1 THEN es.id_message END) AS email_sent_to_unsubscribed,
       COUNT(DISTINCT CASE WHEN acc.is_unsubscribed = 1 THEN es.id_message END) * 100 /
       COUNT(DISTINCT es.id_message) AS sent_cnt_unsub_percent

FROM `data-analytics-mate.DA.email_sent` es
LEFT JOIN `data-analytics-mate.DA.account` acc
 ON es.id_account = acc.id
LEFT JOIN `data-analytics-mate.DA.account_session` acs
  ON es.id_account = acs.account_id
JOIN `data-analytics-mate.DA.session_params` sp
  ON acs.ga_session_id = sp.ga_session_id
GROUP BY sp.country
ORDER BY COUNT(DISTINCT es.id_message) DESC;




# Purchase by Continent

/* У цьому завданні тобі потрібно визначити, на якому континенті найбільший дохід від покупок, зроблених з мобільних
пристроїв. Щоб це зробити для кожного континенту:
підрахуй загальний дохід (revenue);
визнач дохід від покупок, зроблених з мобільних пристроїв, та обчисли його відсоток (revenue_from_mobile_percent).
Відсортуй результати за загальним доходом у спадному порядку.
Представ результати у форматі таблиці зі стовпцями continent, revenue та revenue_from_mobile_percent. */


SELECT sp.continent,
       SUM(p.price) AS revenue,

       SUM(CASE WHEN sp.device = 'mobile' THEN p.price END) AS revenue_from_mobile,
       SUM(CASE WHEN sp.device = 'mobile' THEN p.price END) * 100 / SUM(p.price) AS revenue_from_mobile_percent
FROM `data-analytics-mate.DA.order` o
JOIN `data-analytics-mate.DA.product` p
  ON o.item_id = p.item_id
LEFT JOIN `data-analytics-mate.DA.session_params` sp
  ON o.ga_session_id = sp.ga_session_id
GROUP BY sp.continent
ORDER BY SUM(p.price) DESC;




/* потрібно визначити відсоток сесій, в яких не вказана мова (поле language є порожнім). Для цього:
Для кожного браузера: підрахуй загальну кількість сесій (session_cnt);
визнач кількість сесій, у яких поле language є пустим (session_cnt_with_empty_language);
обчисли відсоток сесій із пустим полем language (session_cnt_with_empty_language_percent);
Представ результати у форматі таблиці зі стовпцями browser, session_cnt,
session_cnt_with_empty_language та session_cnt_with_empty_language_percent. */


SELECT sp.browser,
       COUNT(DISTINCT s.ga_session_id) AS session_cnt,
       COUNT(CASE WHEN sp.language IS NULL THEN s.ga_session_id END) AS session_cnt_with_empty_language,
       COUNT(CASE WHEN sp.language IS NULL THEN s.ga_session_id END) /
       COUNT(DISTINCT s.ga_session_id) * 100 AS session_cnt_with_empty_language_percent
FROM `data-analytics-mate.DA.session_params` sp
RIGHT JOIN `data-analytics-mate.DA.session` s
  ON sp.ga_session_id = s.ga_session_id
GROUP BY sp.browser;




/* Для кожного континенту:
підрахуй загальний дохід (revenue);
визнач дохід від категорії Bookcases & shelving units (revenue_from_bookcases);
обчисли відсоток доходу від категорії Bookcases & shelving units від загального
доходу по континенту (revenue_from_bookcases_percent).
Представ результати у форматі таблиці зі стовпцями continent, revenue,
revenue_from_bookcases та revenue_from_bookcases_percent. */


SELECT sp.continent,
       SUM(p.price) AS revenue,
       SUM(CASE WHEN p.category = 'Bookcases & shelving units' THEN p.price END) AS revenue_from_bookcases,
       SUM(CASE WHEN p.category = 'Bookcases & shelving units' THEN p.price END) / SUM(p.price) *
       100 AS revenue_from_bookcases_percent
FROM `data-analytics-mate.DA.order` o
LEFT JOIN `data-analytics-mate.DA.session_params` sp
  ON o.ga_session_id = sp.ga_session_id
LEFT JOIN `data-analytics-mate.DA.product` p
  ON o.item_id = p.item_id
GROUP BY sp.continent;
