-- User role types
CREATE TYPE user_role AS ENUM ('admin', 'agent', 'teller');

-- Product restock types
CREATE TYPE restock_type AS ENUM ('initial', 'restock', 'adjustment');

-- Approval status
CREATE TYPE approval_status AS ENUM ('pending', 'approved', 'rejected');

CREATE TABLE users (
  id            SERIAL PRIMARY KEY,
  name          VARCHAR(100),
  email         VARCHAR(100) UNIQUE,
  password_hash TEXT,
  role          user_role NOT NULL,
  is_active     BOOLEAN DEFAULT TRUE,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
  id           SERIAL PRIMARY KEY,
  name         VARCHAR(100),
  description  TEXT,
  price        NUMERIC(10,2),
  cost         NUMERIC(10,2),
  sku          VARCHAR(50) UNIQUE,
  stock        INTEGER DEFAULT 0,
  is_active    BOOLEAN DEFAULT TRUE,
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE product_stock (
  id            SERIAL PRIMARY KEY,
  product_id    INTEGER REFERENCES products(id),
  quantity      INTEGER NOT NULL,
  restock_type  restock_type NOT NULL,
  source        VARCHAR(100),
  created_by    INTEGER REFERENCES users(id),
  status        approval_status DEFAULT 'pending',
  approved_by   INTEGER REFERENCES users(id),
  approved_at   TIMESTAMP,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
  id            SERIAL PRIMARY KEY,
  customer_id   INTEGER REFERENCES customers(id),
  user_id       INTEGER REFERENCES users(id),
  status        VARCHAR(20) CHECK (status IN ('completed', 'pending', 'cancelled')),
  total_amount  NUMERIC(10,2),
  paid_amount   NUMERIC(10,2),
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
  id               SERIAL PRIMARY KEY,
  order_id         INTEGER REFERENCES orders(id),
  product_id       INTEGER REFERENCES products(id),
  quantity         INTEGER,
  unit_price       NUMERIC(10,2),
  discount_applied NUMERIC(10,2) DEFAULT 0,
  total_price      NUMERIC(10,2)
);

CREATE TABLE refunds (
  id             SERIAL PRIMARY KEY,
  order_id       INTEGER, -- Replace with FOREIGN KEY to orders table when defined
  refunded_by    INTEGER REFERENCES users(id),
  refund_reason  TEXT,
  refund_amount  NUMERIC(10,2),
  status         approval_status DEFAULT 'pending',
  approved_by    INTEGER REFERENCES users(id),
  approved_at    TIMESTAMP,
  created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE refund_items (
  id             SERIAL PRIMARY KEY,
  refund_id      INTEGER REFERENCES refunds(id),
  order_item_id  INTEGER REFERENCES order_items(id),
  quantity       INTEGER,
  refund_amount  NUMERIC(10,2)
);

CREATE TABLE discounts (
  id             SERIAL PRIMARY KEY,
  product_id     INTEGER REFERENCES products(id),
  name           VARCHAR(100),
  discount_type  VARCHAR(20) CHECK (discount_type IN ('percentage', 'fixed')),
  value          NUMERIC(10,2),
  starts_at      TIMESTAMP,
  ends_at        TIMESTAMP
);

CREATE TABLE customers (
  id          SERIAL PRIMARY KEY,
  name        VARCHAR(100),
  email       VARCHAR(100),
  phone       VARCHAR(20),
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);