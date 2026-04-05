# StockTracker

StockTracker is an iOS application built to track real-time stock prices, leveraging SwiftUI for the user interface and a Clean Architecture approach for maintainable and testable code. The app supports multiple environments and real-time WebSocket updates.

---

## Table of Contents

- [Overview](#overview)  
- [Technologies](#technologies)  
- [Architecture](#architecture)  
- [Environments & Configuration](#environments--configuration)  
- [Setup & Running](#setup--running)  

---

## Overview

StockTracker allows users to:

- View a list of stocks with real-time price updates.  
- Sort stocks by price or price change.  
- Observe connection status via WebSocket.  

The app uses a **Clean Architecture** design to separate layers and responsibilities, ensuring high testability and maintainability.

---

## Technologies

- **UI Framework:** SwiftUI  
- **Asynchronous Programming:** Swift Concurrency (`async/await`, `Task`)  
- **Networking:** WebSocket via `URLSessionWebSocketClient`  

---

## Architecture

StockTracker follows **Clean Architecture** principles:

- **Presentation Layer:**  
  - `StockListViewModel` – Manages state, applies sorting, observes real-time updates, and exposes data to SwiftUI views.  
  - `Navigator` – Handles app navigation in a type-safe manner.  

- **Domain Layer:**  
  - `StockFeedUseCase` – Use case for fetching stock data and managing real-time feed.  
  - Interfaces defined via protocols for easy mocking in tests.  

- **Data Layer:**  
  - `StockRepository` – Handles data retrieval from local JSON or WebSocket feed.  
  - `SharedStateService` – Observes connection state and stores the latest stock data.
  -  **Data Source:** `stocks.json` for initial data.

- **Dependency Injection:**  
  - `DependencyContainer` – Centralized container for app dependencies, including flows, WebSocket clients, and app shared state.  

---

## Environments & Configuration

StockTracker supports multiple build configurations:

- **Schemes:** `Prod` and `Dev`  
- **Configuration Files:** `.xcconfig` files per scheme for environment-specific settings and variables.  

This setup allows switching between environments without code changes.

---

## Setup & Running

1. **Clone the repository**
 
   ```bash
   git clone <repository-url>
   cd StockTracker
   ```
 
2. **Open in Xcode**
 
   Open `StockTracker.xcodeproj`
 
3. **Select a Scheme**
 
   Choose either **Dev** or **Prod** scheme depending on the environment you want to run.
 
4. **Build & Run**
 
   - Select a simulator or a connected device.
   - Press `Cmd+R` to run the app.
 
5. **Run Tests**
 
   - Select the **StockTrackerTests** target.
   - Press `Cmd+U` to execute all unit tests.
   - Only unit tests run, UI tests are not required.
