SELECT o.order_number,
       CONCAT(c.last_name,' ',c.first_name) AS client,
       t.tour_name,
       CONCAT(e.last_name,' ',e.first_name) AS manager,
       s.status_name,
       o.order_date,
       o.total_price
FROM orders o
JOIN clients        c ON o.client_id   = c.client_id
JOIN tours          t ON o.tour_id     = t.tour_id
JOIN employees      e ON o.employee_id = e.employee_id
JOIN order_statuses s ON o.status_id   = s.status_id
ORDER BY o.order_date;