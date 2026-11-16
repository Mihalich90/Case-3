-- ============================================================
-- База данных «Туризм»
-- ============================================================
DROP DATABASE IF EXISTS tourism;
CREATE DATABASE tourism
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE tourism;

-- ------------------------------------------------------------
-- Справочник 1: Клиенты
-- ------------------------------------------------------------
CREATE TABLE clients (
    client_id     INT AUTO_INCREMENT PRIMARY KEY,
    last_name     VARCHAR(50)  NOT NULL,
    first_name    VARCHAR(50)  NOT NULL,
    middle_name   VARCHAR(50)  NULL,
    passport      VARCHAR(20)  NOT NULL UNIQUE,   -- серия+номер
    phone         VARCHAR(20)  NOT NULL,
    email         VARCHAR(100) NULL,
    birth_date    DATE         NULL,
    created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Справочник 2: Туры (услуги)
-- ------------------------------------------------------------
CREATE TABLE tours (
    tour_id       INT AUTO_INCREMENT PRIMARY KEY,
    tour_name     VARCHAR(100)   NOT NULL,
    country       VARCHAR(60)    NOT NULL,
    city          VARCHAR(60)    NULL,
    duration_days SMALLINT       NOT NULL CHECK (duration_days > 0),
    price         DECIMAL(10,2)  NOT NULL CHECK (price >= 0),
    tour_type     ENUM('пляжный','экскурсионный','горнолыжный',
                       'круиз','сафари','лечебный') NOT NULL,
    description   TEXT           NULL
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Справочник 3: Сотрудники (менеджеры)
-- ------------------------------------------------------------
CREATE TABLE employees (
    employee_id   INT AUTO_INCREMENT PRIMARY KEY,
    last_name     VARCHAR(50)  NOT NULL,
    first_name    VARCHAR(50)  NOT NULL,
    position      VARCHAR(50)  NOT NULL DEFAULT 'менеджер',
    phone         VARCHAR(20)  NULL,
    email         VARCHAR(100) NULL,
    hire_date     DATE         NOT NULL
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Справочник 4: Статусы заказов
-- ------------------------------------------------------------
CREATE TABLE order_statuses (
    status_id     INT AUTO_INCREMENT PRIMARY KEY,
    status_name   VARCHAR(30) NOT NULL UNIQUE,   -- 'новый', 'оплачен', 'отменён'...
    description   VARCHAR(200) NULL
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Таблица переменной информации: Заказы туров
-- ------------------------------------------------------------
CREATE TABLE orders (
    order_id      INT AUTO_INCREMENT PRIMARY KEY,
    order_number  VARCHAR(20)   NOT NULL UNIQUE,   -- номер договора
    client_id     INT           NOT NULL,          -- FK → clients
    tour_id       INT           NOT NULL,          -- FK → tours
    employee_id   INT           NOT NULL,          -- FK → employees
    status_id     INT           NOT NULL,          -- FK → order_statuses
    order_date    DATE          NOT NULL,
    persons_count SMALLINT      NOT NULL DEFAULT 1 CHECK (persons_count > 0),
    total_price   DECIMAL(10,2) NOT NULL CHECK (total_price >= 0),
    comment       VARCHAR(255)  NULL,

    CONSTRAINT fk_orders_client
        FOREIGN KEY (client_id)   REFERENCES clients(client_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_orders_tour
        FOREIGN KEY (tour_id)     REFERENCES tours(tour_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_orders_employee
        FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_orders_status
        FOREIGN KEY (status_id)   REFERENCES order_statuses(status_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Индексы по внешним ключам (ускоряют соединения)
CREATE INDEX idx_orders_client   ON orders(client_id);
CREATE INDEX idx_orders_tour     ON orders(tour_id);
CREATE INDEX idx_orders_employee ON orders(employee_id);
CREATE INDEX idx_orders_status   ON orders(status_id);
CREATE INDEX idx_orders_date     ON orders(order_date);