<div align="center">

# 🛒 OMG E-Commerce Dashboard

**A full-featured admin dashboard for modern e-commerce operations**

[![Flutter](https://img.shields.io/badge/Flutter-3.5+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase&logoColor=white)](https://supabase.com)
[![GetX](https://img.shields.io/badge/GetX-State%20Management-8B5CF6?logo=flutter&logoColor=white)](https://pub.dev/packages/get)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

*Responsive • Cross-platform • Real-time • Secure*

</div>

---

## ✨ Overview

OMG E-Commerce Dashboard is a comprehensive business management platform built with **Flutter** and powered by **Supabase**. It provides a complete toolkit for managing orders, products, customers, vendors, sales, and finances — all from a single, elegant interface that adapts seamlessly to desktop, tablet, and mobile devices.

---

## 🚀 Features

<table>
<tr>
<td width="50%">

### 📦 Operations
- **Order Management** — Track and manage customer orders with full lifecycle support
- **Product Management** — CRUD operations with variants, brands, categories & collections
- **Purchase Management** — Vendor purchases and purchase history
- **Sales & Checkout** — Point-of-sale with admin checkout integration
- **Installment Tracking** — Manage installment-based sales and payment plans

</td>
<td width="50%">

### 👥 People & Entities
- **Customer Management** — Profiles, purchase history, and contact info
- **Vendor Management** — Supplier tracking with addresses and order history
- **Salesman Management** — Sales team performance and commission tracking
- **Account Book** — Financial ledger for customers, vendors, and salesmen

</td>
</tr>
<tr>
<td width="50%">

### 📊 Analytics & Reports
- **Dashboard** — Real-time analytics with charts (fl_chart)
- **Reports** — PDF generation, receipt reports, installment plans
- **Expense Tracking** — Business expense management
- **Reviews** — Product and order reviews

</td>
<td width="50%">

### 🛠️ Tools & Integrations
- **Media Management** — Upload and organize product images
- **AI Descriptions** — Gemini AI–powered product descriptions
- **Thermal Printing** — Receipt and label printing
- **Maps** — Order delivery location visualization
- **QR Codes** — Generate product/invoice QR codes

</td>
</tr>
</table>

---

## 🏗️ Tech Stack

| Category | Technologies |
|----------|--------------|
| **Framework** | Flutter 3.5+ |
| **Backend** | Supabase (Auth, Database, Realtime, Storage) |
| **State Management** | GetX, GetStorage |
| **Charts & Visualization** | fl_chart, Lottie |
| **Documents** | pdf, printing |
| **UI Components** | data_table_2, dropdown_search, syncfusion_flutter_datepicker |
| **Utilities** | intl, logger, connectivity_plus, shimmer |

---

## 📱 Platform Support

| Platform | Support |
|----------|---------|
| 🖥️ Windows | ✅ Desktop app |
| 🍎 macOS | ✅ Desktop app |
| 🐧 Linux | ✅ Desktop app |
| 🌐 Web | ✅ Progressive web app |
| 📱 Android | ✅ Mobile app |
| 🍏 iOS | ✅ Mobile app |

---

## 📋 Prerequisites

- **Flutter SDK** 3.5 or higher ([Install Flutter](https://docs.flutter.dev/get-started/install))
- **Supabase** account ([Sign up](https://supabase.com))
- **Dart** 3.5+

---

## ⚡ Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/your-username/ecommerce_dashboard.git
cd ecommerce_dashboard
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure environment variables

Create a `.env` file in the project root with your Supabase credentials:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_KEY=your_supabase_service_key  # Optional, for admin operations

# Optional: For AI-generated product descriptions
GEMINI_API_KEY=your_gemini_api_key
```

> ⚠️ **Important:** Never commit `.env` to version control. It's already in `.gitignore`.

### 4. Run the application

```bash
# Web
flutter run -d chrome

# Windows
flutter run -d windows

# Android
flutter run -d android
```

---

## 📁 Project Structure

```
lib/
├── app.dart                 # App entry & theme configuration
├── main.dart                # App initialization, Supabase setup
├── bindings/                # GetX dependency injection
├── common/                  # Shared widgets, layouts, utilities
├── controllers/             # GetX controllers (business logic)
├── models/                  # Data models
├── repositories/            # Data access layer
├── routes/                  # Navigation & routing
├── services/                # External services (Gemini, etc.)
├── utils/                   # Helpers, theme, constants
└── views/                   # UI screens & widgets
    ├── dashboard/
    ├── products/
    ├── orders/
    ├── customer/
    ├── vendor/
    ├── salesman/
    ├── sales/
    ├── reports/
    └── ...
```

---

## 🔒 Security & Network

- **Secure Storage** — Sensitive keys stored with `flutter_secure_storage`
- **Environment Variables** — Credentials loaded from `.env` via `flutter_dotenv`
- **Network Resilience** — `SupabaseNetworkManager` with timeout handling and retry logic
- **Service Key Protection** — Admin key only available in debug mode for production safety

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [Admin Dashboard V3](docs/ADMIN_DASHBOARD_V3.md) | Comprehensive feature & schema documentation |
| [Checkout Implementation](docs/ADMIN_CHECKOUT_IMPLEMENTATION.md) | Admin checkout flow details |
| [Gemini AI Setup](docs/GEMINI_AI_SETUP.md) | AI product description configuration |
| [Order Details Map](docs/ORDER_DETAILS_MAP_DOCUMENTATION.md) | Map integration for delivery tracking |

---

## 🎨 Screenshots

> *Add your dashboard screenshots here*

```
[Desktop Dashboard]  [Mobile View]  [Order Management]
```

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**Built with ❤️ using Flutter & Supabase**

</div>
