Here's a grouped feature list for your POS system, organized by **domain or module**, highlighting how features interrelate (e.g., how orders connect with refunds, products with restocks, etc.).

---

# 🧩 Feature Groupings

## 🛒 Orders & Refunds

**Core Features:**

* Place order (with customer and products)
* Order item details (quantity, unit price, discount)
* Order statuses: `pending`, `completed`, `cancelled`
* Automatic stock deduction per product sold

**Refund Features:**

* Refund request per order item
* Refund reasons & quantity
* Approval flow (status: `pending`, `approved`, `rejected`)
* Approved refunds trigger stock restocking via `product_stock`

---

## 📦 Products & Inventory

**Core Product Features:**

* Product creation with name, price, SKU, description
* Track active/inactive state
* Maintain current stock level
* Historical pricing changes

**Inventory (Stock) Management:**

* Restock transactions (manual or purchase-driven)
* Refund-based stock return
* All stock changes logged in `product_stock`
* Requires approval before affecting `products.stock`

**Price Management:**

* Submit price change with old and new price
* Triggers auto-update on product record
* Full price history audit

---

## 🧾 Discounts & Promotions

**Current Mechanism:**

* Per-order-item discount field (`discount_applied`)
* Total price reflects applied discount
* (Planned) Link to discount campaigns or coupon systems

---

## 👥 Users, Roles, and Access

**User Roles:**

* `admin`: Full access
* `agent`: Limited management rights
* `teller`: Frontline cashier/sales

**User Features:**

* Login via email/password
* Role-based permission checks (backend concern)

---

## 🧑‍🤝‍🧑 Customers

**Customer Features:**

* Basic customer registry (name, phone, email)
* Optional for walk-in orders
* Link to orders for future lookup/history

---

## 🔐 Approvals System

**Transactions that require approval:**

* Restock (`product_stock`)
* Refunds
* All have `status: 'pending' | 'approved' | 'rejected'`
* Triggers apply business logic **only when approved**

---

## 📈 Reporting & Auditing (Planned)

**Data sources:**

* `orders` + `order_items` for sales
* `refunds` for loss/recovery tracking
* `product_stock` for inventory movement
* `price_changes` for margin and price trend analysis

---

Let me know if you’d like this converted into markdown, exported, or broken down into separate module files for onboarding or docs.
