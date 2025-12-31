# CoinGecko

**CoinGecko** is an iOS application that fetches cryptocurrency market data from the CoinGecko API and displays it in a clean and responsive UIKit interface.

The project focuses on networking, data mapping, caching, and a scalable UIKit architecture suitable for real-world applications.

## Features
- Fetch cryptocurrency market data from the CoinGecko API
- Display a list of coins with prices and market metrics
- Load and display coin icons asynchronously
- Handle loading and error states
- Local in-memory caching to reduce network usage
- Modular architecture with clear separation of responsibilities
- Unit tests for core business logic

## Architecture
The app is built using a modular UIKit architecture with explicit layers:

- **Presentation layer**  
  ViewControllers and Views responsible for UI rendering and user interaction

- **Business layer**  
  Presenters and Services encapsulating application logic

- **Data layer**  
  Network services and models responsible for API communication and data mapping

This separation improves testability, maintainability, and scalability.

## Tech Stack
- Swift
- UIKit
- URLSession
- Auto Layout
- XCTest
- SwiftLint / SwiftFormat
- CoinGecko Public API

## Requirements
- iOS 15+
- Xcode 15+

## Project Goals
This project was created to demonstrate practical iOS development skills, including:
- Working with REST APIs
- Async data loading and error handling
- UIKit-based UI composition
- Clean architecture and code organization
- Writing testable and maintainable code

The application is intended as a technical showcase rather than a production trading tool.

## Screenshots
_Add screenshots here_
