# ✈️ THY Flight Reservation System (Web Forms & MSSQL)

![C#](https://img.shields.io/badge/C%23-239120?style=for-the-badge&logo=c-sharp&logoColor=white)
![ASP.NET](https://img.shields.io/badge/ASP.NET-512BD4?style=for-the-badge&logo=dotnet&logoColor=white)
![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![Bootstrap](https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white)

## 📖 Project Overview
This project is a comprehensive **Airline Reservation System** developed using **ASP.NET Web Forms** and **Advanced SQL Server** architecture. It simulates a real-world scenario where users can search for flights, book tickets, and manage cancellations, while administrators and company owners can track financial performance and flight logistics.

The system is designed with a strong focus on **Database Engineering**, utilizing Stored Procedures, Triggers, and Views to handle complex business logic directly within the database layer.

---

## 📸 Screenshots
<img width="1911" alt="Screenshot 1" src="screenshots/1.png" />
<img width="1901" alt="Screenshot 2" src="screenshots/2.png" />
<img width="1916" alt="Screenshot 3" src="screenshots/3.png" />
<img width="1895" alt="Screenshot 4" src="screenshots/4.png" />
<img width="1505" alt="Screenshot 5" src="screenshots/5.png" />

---

## 🏗️ Technical Architecture

### 💻 Backend & Frontend
* **Language:** C# (ASP.NET Web Forms)
* **Architecture:** N-Layered Architecture approach with centralized Connection Class (`SqlBaglantisi.cs`)
* **Frontend:** HTML5, CSS3, Bootstrap, FontAwesome

### 🗄️ Database Engineering (The Core Power)
The project relies heavily on **T-SQL** capabilities to ensure data integrity and performance:

* **Tables:** 8 Relational Tables (Airports, Flights, Tickets, Users, PriceLogs, etc.)
* **Stored Procedures (16+):**
    * `SP_ISFLIGHTEXIST`: Advanced flight search algorithm.
    * `SP_BuyTicket`: Handles the transactional process of booking.
    * `SP_BossReport`: Generates financial performance reports for the owner.
    * `SP_CancelTicket`: Manages cancellations and mileage refunds.
* **Triggers (Automation):**
    * `TRG_UpdateSoldSeat` & `TRG_DecreaseSoldSeat`: Automatically manages seat capacity upon booking/cancellation.
    * `TRG_PriceChangeLog`: Audits every price change for security and history.
    * `TRG_FlightCancelLog`: Automatically archives cancelled flights.
* **Views & Functions:**
    * `VW_UcusListesi`: Optimized view for complex JOINs.
    * `FN_DolulukOrani`: Calculates real-time flight occupancy rates.
    * `FN_KDVHesapla`: Dynamic tax calculation per ticket.

---

## 🚀 Installation & Setup

### 1. Database Setup
The project includes a full database script (`Database/Thy_Proje.sql`) containing the schema, stored procedures, triggers, views, functions and sample data.
1. Open **SQL Server Management Studio (SSMS)**.
2. Go to **File** > **Open** > **File...** and select `Database/Thy_Proje.sql`.
3. Click **Execute** (or press **F5**).
4. The database named `Thy_Proje` will be created with all tables, SPs and Triggers ready.

> All user data in the script is fictional and intended for testing only.

### 2. Connection String
The project uses a dynamic connection string set to `Data Source=.` (Localhost).
* *Note:* You do not need to configure the server name manually if you are running a standard local SQL Server instance.

---

## 🔐 Demo Credentials (For Testing)
You can use the following accounts to test different roles in the system:

| Role | Email | Password | Access Level |
| :--- | :--- | :--- | :--- |
| **User (Passenger)** | `passenger1@example.com` | `1234` | Ticket Booking, Search |
| **Admin** | `admin@example.com` | `112776` | Flight Management, Pricing, Cancellations |
| **Company Owner (Boss)** | `boss@example.com` | `259112` | Financial Reports, Occupancy Rates |

---

### 👨‍💻 Developer
**Kurtuluş Hayta** - *Computer Engineering Student*
* [LinkedIn Profile](https://www.linkedin.com/in/kurtulus-hayta-9302b83b0/)