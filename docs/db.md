Here’s a clean and structured `DATABASE.md` file that documents your **PostgreSQL schema** for the POS system. You can place this in your repo's `docs/` folder.

---

````md
# 🗃️ Database Schema Documentation

This document outlines the PostgreSQL schema used in the POS system, including tables, fields, enums, relationships, and key business rules.

---

## 🔤 Enums

```sql
CREATE TYPE transaction_status AS ENUM ('pending', 'approved', 'rejected');
CREATE TYPE order_status AS ENUM ('pending', 'completed', 'cancelled');
CREATE TYPE stock_source AS ENUM ('manual', 'restock', 'refund', 'order');
CREATE TYPE user_role AS ENUM ('admin', 'agent', 'teller');
````

---

## 📦 Tables

---

### `products`

Stores all product information.

| Column      | Type        | Description                      |
| ----------- | ----------- | -------------------------------- |
| id          | SERIAL      | Primary key                      |
| name        | TEXT        | Product name                     |
| description | TEXT        | Description of the product       |
| price       | NUMERIC     | Current selling price            |
| cost        | NUMERIC     | Cost of acquisition              |
| sku         | TEXT        | Stock keeping unit (unique code) |
| stock       | INTEGER     | Current stock                    |
| is\_active  | BOOLEAN     | Availability toggle              |
| created\_at | TIMESTAMPTZ | Timestamp of creation            |

---

### `price_changes`

Tracks product pricing history.

| Column      | Type        | Description      |
| ----------- | ----------- | ---------------- |
| id          | SERIAL      | Primary key      |
| product\_id | INTEGER     | FK to `products` |
| old\_price  | NUMERIC     | Previous price   |
| new\_price  | NUMERIC     | New price        |
| changed\_at | TIMESTAMPTZ | Change timestamp |

**Trigger:** `BEFORE INSERT` — automatically updates `products.price`.

---

### `product_stock`

Tracks inventory changes (restocks, refunds, manual edits).

| Column      | Type                 | Description                            |
| ----------- | -------------------- | -------------------------------------- |
| id          | SERIAL               | Primary key                            |
| product\_id | INTEGER              | FK to `products`                       |
| quantity    | INTEGER              | Added (positive) or removed (negative) |
| source      | `stock_source`       | Source of stock change                 |
| reason      | TEXT                 | Optional note                          |
| status      | `transaction_status` | Approval state                         |
| created\_at | TIMESTAMPTZ          | Timestamp                              |

**Trigger:** `AFTER UPDATE` on `status` = `'approved'` applies to `products.stock`.

---

### `customers`

Customer directory.

| Column      | Type        | Description      |
| ----------- | ----------- | ---------------- |
| id          | SERIAL      | Primary key      |
| name        | TEXT        | Customer name    |
| email       | TEXT        | Optional email   |
| phone       | TEXT        | Optional contact |
| created\_at | TIMESTAMPTZ | Timestamp        |

---

### `orders`

Main transaction record.

| Column        | Type           | Description                  |
| ------------- | -------------- | ---------------------------- |
| id            | SERIAL         | Primary key                  |
| customer\_id  | INTEGER        | Nullable FK to `customers`   |
| user\_id      | INTEGER        | FK to `users` (teller/agent) |
| status        | `order_status` | Order progress               |
| total\_amount | NUMERIC        | Gross amount                 |
| paid\_amount  | NUMERIC        | Payment made                 |
| created\_at   | TIMESTAMPTZ    | Order time                   |

---

### `order_items`

Each item in an order.

| Column            | Type    | Description           |
| ----------------- | ------- | --------------------- |
| id                | SERIAL  | Primary key           |
| order\_id         | INTEGER | FK to `orders`        |
| product\_id       | INTEGER | FK to `products`      |
| quantity          | INTEGER | Number of units       |
| unit\_price       | NUMERIC | Price at time of sale |
| discount\_applied | NUMERIC | Discount per unit     |
| total\_price      | NUMERIC | Final line total      |

---

### `refunds`

Refund request records.

| Column          | Type                 | Description           |
| --------------- | -------------------- | --------------------- |
| id              | SERIAL               | Primary key           |
| order\_item\_id | INTEGER              | FK to `order_items`   |
| quantity        | INTEGER              | Units refunded        |
| reason          | TEXT                 | Justification or note |
| status          | `transaction_status` | Approval state        |
| created\_at     | TIMESTAMPTZ          | Request timestamp     |

**Trigger:** Applies effect to `product_stock` only when approved.

---

### `users`

Internal user accounts.

| Column         | Type        | Description              |
| -------------- | ----------- | ------------------------ |
| id             | SERIAL      | Primary key              |
| name           | TEXT        | Full name                |
| role           | `user_role` | User role                |
| email          | TEXT        | Unique login email       |
| password\_hash | TEXT        | Hashed password (bcrypt) |
| created\_at    | TIMESTAMPTZ | Account creation date    |

---

## 🔄 Triggers Summary

| Trigger Name           | Table           | Event           | Action                                       |
| ---------------------- | --------------- | --------------- | -------------------------------------------- |
| `update_product_price` | `price_changes` | `BEFORE INSERT` | Updates `products.price`                     |
| `apply_restock_effect` | `product_stock` | `AFTER UPDATE`  | Updates `products.stock` if `approved`       |
| `apply_refund_effect`  | `refunds`       | `AFTER UPDATE`  | Creates `product_stock` refund if `approved` |

---

## 📌 Notes

* `stock` is derived and updated based on transactions, not manually edited.
* `price_changes`, `product_stock`, and `refunds` all serve as historical audit logs.
* Extensible to support batches, suppliers, and receipts.

---

## 📤 ER Diagram

Refer to [`pos_erd.png`](../sql/pos_erd.png) for a graphical view of all table relationships.

---

```
