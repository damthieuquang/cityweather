
#  CityWeather

  

CityWeather is an iOS application that allows users to search for cities and view their weather information. The app is built using Swift and SwiftUI, following a modular architecture with separate frameworks for different functionalities.

  

##  Project Structure

  

The project is organized into several modules:

  

1. CityWeather (Main App)

2. CWModels (Data Models)

3. CWServices (Networking and Services)

4. CWUtilities (Utility Functions)

5. VendorLibs (Third-party Libraries)

  

###  CityWeather (Main App)

  

The main application target containing the UI and view models.

  

Key components:

- Launcher.swift: Entry point of the application

- TabViewContainer.swift: Main tab-based navigation

- SearchView.swift: City search functionality

- FavouriteView.swift: Favorite cities list

- CityDetailsView.swift: Detailed weather information for a city

  

Each screen in there applies **MVVM architecture**

  
  
  

###  CWModels

  

Contains data models and Realm objects for local storage.

  

Key files:

- City.swift: City model

- CityRealmObject.swift: Realm object for city persistence

- RealmService.swift: Service for Realm database operations

  

###  CWServices

  

Handles networking and API communication.

  

Key components:

- ServiceManager.swift: Main service manager

- CityService.swift: Service for city-related API calls

- Networking components (Router, EndpointType, HTTPTask, etc.)

  

###  CWUtilities

  

Provides utility functions and environment configurations.

  

Key files:

- AppEnvironment.swift: Environment configuration

  

###  VendorLibs

  

Manages third-party dependencies.

  

##  Dependencies

  

- RealmSwift: Used for local data persistence

  

##  Development

  

The project follows Swift coding standards and uses SwiftLint for code style enforcement. The `.swiftlint.yml` file contains the linting rules.

  

##  Testing

  

The project includes unit tests for each module. To run the tests, use the `Cmd+U` shortcut in Xcode or navigate to Product > Test in the menu bar.

  

##  Building and Running

  

1. Open the `CityWeather.xcodeproj` file in Xcode.

2. Select the desired target (CityWeather) and device/simulator.

3. Build and run the project (Cmd+R).