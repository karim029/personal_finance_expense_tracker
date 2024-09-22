
# Personal Finance Expense Tracker

A comprehensive **Personal Finance Expense Tracker** built with **Flutter**, offering users a modern and intuitive platform to manage their expenses. With a **separation of concerns** architecture, the app ensures clean, scalable, and maintainable code both in the frontend and backend.

## 🔥 Key Features
- **User Authentication**: Secure **sign-up**, **login**, and **password reset** with backend validation.
- **Expense Management**: Log expenses by category, date, and amount.
- **State Management**: Built using **Riverpod** for optimized, reactive state management.
- **Data Persistence**: Offline storage of expenses with Hive integration, ensuring data is saved locally even after app closure.
- **Clean Architecture**: The app follows **separation of concerns**, organizing the code into:
  - **Domain Layer**: Core business logic and models.
  - **Data Layer**: API handling and data persistence.
  - **Presentation Layer**: UI with Riverpod state management.
- **Responsive UI**: Adaptive design for mobile and tablet screens.
- **Dark Mode**: Sleek, user-friendly dark theme for a modern feel.
  
## 🛠️ Technologies
- **Flutter & Dart** for frontend development.
- **Riverpod** for state management.
- **Node.js** & **Express** with **MongoDB** for the backend API.
- **Hive** for local data persistence in the app.

## 🌟 Why This Project?
This project leverages industry-standard tools and architectures, making it an excellent showcase for cross-platform mobile development. The integration of **Riverpod** ensures reactive, efficient UI updates, while the **repository pattern** cleanly separates business logic from UI, adhering to clean code principles. 

Whether you're a user or developer, this app ensures a seamless experience and is designed with **scalability** and **maintainability** in mind, ideal for demonstrating practical skills in a modern, cross-platform mobile app.

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**
- **Node.js** and **MongoDB** for backend setup.

### Setup Instructions
1. **Clone the repository**:
   ```bash
   git clone https://github.com/karim029/personal_finance_expense_tracker.git
   ```
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Run the application**:
   ```bash
   flutter run
   ```

## 🌐 Backend API
The backend is built using **Node.js** and **Express**, with a **MongoDB** database for storing user and expense data. The API handles user authentication, expense CRUD operations, and more.

