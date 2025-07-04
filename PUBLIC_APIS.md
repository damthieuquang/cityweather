# CityWeather Public API Documentation

This document provides an overview of all **public** types, functions, and helpers exposed by the CityWeather code-base and its internal Swift Packages.

* Package prefixes:
  * **CWUtilities** — Environment helpers
  * **CWServices**  — Networking layer
  * **CWModels**    — Realm models & value types
  * **CityWeather** — The iOS application layer

---

## 1. CWUtilities

### `AppEnvironment`
```swift
public enum AppEnvironment: String {
    case staging, production
}
```
`AppEnvironment` represents the build time / runtime environment the application should use.

| Property | Type | Description |
|----------|------|-------------|
| `current` | `AppEnvironment` | Automatically resolved from the **Info.plist** key `app_environment` (defaults to `.staging`). |
| `apiKey`  | `String` | The OpenWeatherMap API key associated with the environment. |
| `baseURL` | `String` | Root URL for all network calls. |

#### Usage
```swift
let env = AppEnvironment.current
print(env.baseURL)         // → https://api.openweathermap.org/data

let requestURL = env.baseURL + "/..."
```

---

## 2. CWServices (Networking)

### 2.1 `ServiceManager`
Singleton that orchestrates every network call produced by the app.
```swift
public class ServiceManager {
    public static let shared = ServiceManager()

    func getCityByName(cityName: String,
                       completion: @escaping (_ city: City?, _ error: String?) -> Void)
}
```
#### Example
```swift
ServiceManager.shared.getCityByName(cityName: "London") { city, error in
    if let city {
        print("🌤", city.name, city.main?.temp ?? 0)
    } else {
        print("❌", error ?? "Unknown error")
    }
}
```

### 2.2 Router Stack
The low-level request builder is composed of the following public primitives:

| Type | Kind | Purpose |
|------|------|---------|
| `EndpointVersion` | `enum` | API versioning helper (e.g. `.ver2x = "2.5"`). |
| `HTTPTask` | `enum` | Describes the request's body & query requirements (`.request`, `.requestParameters(...)`). |
| `HTTPHeaders` | `typealias` | `[String : String]`: convenience alias. |
| `ParameterEncoding` | `enum` | Strategy that encodes `Parameters` into either the **query-string**, **HTTP body**, or both. |
| `Parameters` | `typealias` | `[String : Any]` generic parameter bag. |
| `URLParameterEncoder` / `JSONParameterEncoder` | `struct` | Actual encoders conforming to `ParameterEncoder`. |
| `NetworkError` | `enum` (`Error`) | Common encoding & URL errors. |

All above pieces are glued together by the internal (non-public) protocols `EndPointType` and `ServiceRouter` plus the concrete `Router<EndPoint>` class.

#### Custom endpoint example
```swift
enum CityService: EndPointType {
    case city(name: String)

    var baseURL: String { AppEnvironment.current.baseURL }
    var path: String      { "weather" }
    var httpMethod: HTTPMethod { .get }
    var task: HTTPTask {
        switch self {
        case .city(let name):
            return .requestParameters(bodyEncoding: .urlEncoding,
                                      urlParameters: ["q": name,
                                                      "appid": AppEnvironment.current.apiKey])
        }
    }
    var headers: HTTPHeaders? { nil }
    var version: EndpointVersion { .ver2x }
    var parameters: Parameters? { nil }
}
```

---

## 3. CWModels (Persistence & DTOs)

### 3.1 `City`
The root Codable/Hashable value returned by OpenWeatherMap.
```swift
public struct City: Codable, Identifiable, Hashable { … }
```
Key highlights:
* Nested structs: `Clouds`, `Coordinate`, `Main`, `Sys`, `Weather`, `Wind` – all **public** and `Codable`.
* `toObject()` & `encode(to:)` helper bridge between Realm & Codable.
* Equality (`==`) is implemented on `id`+`name`.

#### Quick decode example
```swift
let city = try JSONDecoder().decode(City.self, from: data)
print(city.name, city.main?.temp ?? 0)
```

### 3.2 `RealmService`
Thin wrapper around a `Realm` instance.

| Method | Purpose |
|--------|---------|
| `addCity(city:)` | Persist a `City` value. |
| `getCities()` | Retrieve **all** saved cities. |
| `updateCity(city:)` | Upsert a city record. |
| `deleteCity(city:)` | Cascade-delete a city together with its nested objects. |
| `addCityInBackground(city:)` | Same as above but executed on a background thread.

#### Usage
```swift
let realmService = RealmService()
realmService.addCity(city: city)

let cached = realmService.getCities()
print("Cached cities:", cached)
```

### 3.3 `CityRealmObject`
A Realm `Object` mirror of `City`. It exposes one public helper:
```swift
public func toModel() -> City
```
Which transforms a Realm object back to its Codable struct counterpart.

---

## 4. CityWeather (UI Helpers)

### `LoadingState`
```swift
public enum LoadingState {
    case none, loading, success, failed
}
```
Utility enum used by SwiftUI views to drive progress / error placeholders.

---

## 5. Error Handling Cheat-Sheet
| Layer | Error type | Typical causes |
|-------|------------|----------------|
| **CWServices** | `NetworkError` | Bad URL, parameter encoding failures. |
| **ServiceManager** | `ServiceResponse` (internal) | HTTP status-code mapping.

---

## 6. Contributing & Extending the API

1. Add your new endpoint as an `EndPointType` implementation inside **CWServices**.
2. Call it through `ServiceManager` or use `Router` directly for full control.
3. When adding new Realm models make sure to:
   * create a matching `[Name]RealmObject` subclass of `Object`;
   * provide `toModel()` / `toObject()` helpers.

---

## 7. Quick Start
```swift
// 1. Fetch current weather for Hanoi
ServiceManager.shared.getCityByName(cityName: "Hanoi") { city, error in
    guard let city else { return }

    // 2. Persist it
    let realmService = RealmService()
    realmService.addCity(city: city)

    // 3. Retrieve cached items later
    let cached = realmService.getCities()
    print(cached.map(\ .name))
}
```

---

_Last updated automatically by documentation generator on {{DATE}}._