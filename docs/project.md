# ☕ Point of Sale (POS) System

A modular and extensible Point of Sale (POS) system designed for retail and food businesses. Built to support fast sales, inventory management, and operational transparency.

---

## 📦 Core Features

### 🧾 Orders & Sales
- Create and manage customer orders
- Supports itemized orders, discounts, and payment tracking
- Order statuses: `pending`, `completed`, `cancelled`

### 👥 Customers
- Register customers (optional per order)
- Store customer contact info and order history

### 📦 Products
- Product catalog with SKU, stock, cost, and pricing
- Active/inactive status to toggle visibility
- Automatic stock updates on orders and restocks

### 🔁 Inventory Management
- Restocking flow with approval status
- Tracks stock quantity changes per product
- Audit logs for stock history

### 🧾 Refunds
- Refund items from completed orders
- Approval-based refund workflow
- Refund effects applied only after approval

### 🏷️ Discounts
- Supports flat or percentage-based discounts
- Applied at item level
- Discount amount recorded on order item

### 🛠️ Price Changes
- Price change log per product
- Trigger updates product price automatically
- Supports audit trail of pricing history

### 👨‍💼 User Roles
- Roles: `admin`, `agent`, `teller`
- Permission system can be expanded in app logic

---

## 🗃️ Database Schema Summary (PostgreSQL)

### Tables

#### `products`
- `id`, `name`, `description`, `price`, `cost`, `sku`, `stock`, `is_active`, `created_at`

#### `customers`
- `id`, `name`, `email`, `phone`, `created_at`

#### `orders`
- `id`, `customer_id`, `user_id`, `status`, `total_amount`, `paid_amount`, `created_at`

#### `order_items`
- `id`, `order_id`, `product_id`, `quantity`, `unit_price`, `discount_applied`, `total_price`

#### `refunds`
- `id`, `order_item_id`, `quantity`, `reason`, `status`, `created_at`

#### `product_stock`
- `id`, `product_id`, `quantity`, `source`, `reason`, `status`, `created_at`

#### `price_changes`
- `id`, `product_id`, `old_price`, `new_price`, `changed_at`

#### `users`
- `id`, `name`, `role` (`admin`, `agent`, `teller`), `email`, `password_hash`, `created_at`

---

## ⚙️ Triggers & Business Logic

- **Stock update on order/refund**
  - Automatically subtract/restore quantity
- **Price change**
  - `BEFORE INSERT` trigger updates `products.price`
- **Approval System**
  - Refunds and Restocks use `status = 'pending' | 'approved' | 'rejected'`
  - Triggers apply stock/refund effects only when `approved`

---

## 🛠️ Tech Stack

- **Frontend**: React + Vite + TypeScript (with Ant Design)
- **Backend**: (Planned) Node.js / Express or Next.js
- **Database**: PostgreSQL 15+
- **Infrastructure**: Docker, Terraform, Google Cloud Run
- **ORM/Query**: (Planned) Prisma or Drizzle

---

## 🧪 Mock Data & Dev Tools

- `lib/posData.ts`: Mock data for `products`, `orders`, `customers`
- Simulated async delays for frontend testing
- Easy switch to real API when backend is live

---

## 🔮 Future Plans

- ✅ Basic CRUD for core entities
- ✅ Database trigger-based logic
- ⏳ Authentication & authorization
- ⏳ POS sales terminal interface (touch-screen friendly)
- ⏳ Sales reporting dashboard
- ⏳ Barcode scanning / QR support
- ⏳ Receipt generation (PDF/thermal print)
- ⏳ Offline mode (PWA)

---

## 📂 Repository Structure (Planned)

