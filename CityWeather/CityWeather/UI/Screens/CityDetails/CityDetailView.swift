//
//  CityDetailView.swift
//  CityWeather
//
//  Created by Quang Dam on 8/9/24.
//

//
//  CityDetailView.swift
//  CityWeather
//
//  Created by Quang Dam on 8/9/24.
//

import SwiftUI
import CWModels

struct CityDetailView: View {
  @StateObject var viewModel: CityDetailViewViewModel
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        currentWeatherView
        hourlyForecastView
        cloudsView
        systemInfoView
      }
      .padding()
    }
    .navigationTitle(viewModel.city.name)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button(action: {
          viewModel.toggleFavorite()
        }) {
          Image(systemName: viewModel.city.isFavourite ? "heart.fill" : "heart")
        }
      }
    }
  }
  
  private var currentWeatherView: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("Now")
        .font(.title2)
        .fontWeight(.bold)
      HStack(alignment: .top, spacing: 20) {
        VStack(alignment: .leading) {
          HStack(alignment: .top) {
            Text("\(Int(viewModel.city.main?.temp ?? 0))°")
              .font(.system(size: 60))
              .fontWeight(.thin)
            weatherIconView
          }
          Text("Feels like \(Int(viewModel.city.main?.feelsLike ?? 0))°")
            .font(.title3)
        }
        VStack(alignment: .leading) {
          if let weather = viewModel.city.weather?.first {
            Text(weather.main)
              .font(.title2)
              .fontWeight(.semibold)
            Text(weather.description)
              .foregroundColor(.secondary)
          }
          if let coord = viewModel.city.coordinate {
            Text("Lat: \(coord.lat), Lon: \(coord.lon)")
              .font(.caption)
              .foregroundColor(.secondary)
          }
          DetailRow(title: "Precip", value: "\(Int(viewModel.city.main?.humidity ?? 0))%")
          DetailRow(title: "Humidity", value: "\(Int(viewModel.city.main?.humidity ?? 0))%")
          if let wind = viewModel.city.wind {
            DetailRow(title: "Wind", value: "\(Int(wind.speed)) km/h")
          }
        }
      }
    }
    .padding()
    .background(Color.blue.opacity(0.1))
    .cornerRadius(15)
  }
  
  private var hourlyForecastView: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("Hourly Forecast")
        .font(.title2)
        .fontWeight(.bold)
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 20) {
          ForEach(0..<7) { hour in
            VStack {
              Text(formatHour(hour: hour))
                .font(.caption)
              weatherIconView
              Text("\(Int(viewModel.city.main?.temp ?? 0))°")
                .font(.title3)
            }
          }
        }
      }
    }
    .padding()
    .background(Color.blue.opacity(0.1))
    .cornerRadius(15)
  }
  
  private var cloudsView: some View {
    VStack(alignment: .leading) {
      Text("Clouds")
        .font(.headline)
      if let clouds = viewModel.city.clouds {
        DetailRow(title: "Cloudiness", value: "\(clouds.all)%")
      }
    }
  }
  
  private var systemInfoView: some View {
    VStack(alignment: .leading) {
      Text("System Info")
        .font(.headline)
      if let sys = viewModel.city.sys {
        DetailRow(title: "Country", value: sys.country)
        DetailRow(title: "Sunrise", value: formatTime(sys.sunrise))
        DetailRow(title: "Sunset", value: formatTime(sys.sunset))
      }
      if let timezone = viewModel.city.timezone {
        DetailRow(title: "Timezone", value: "UTC \(formatTimezone(timezone))")
      }
    }
  }
  
  private var weatherIconView: some View {
    // Replace with actual weather icon based on conditions
    Image(systemName: "sun.max.fill")
      .renderingMode(.original)
      .font(.largeTitle)
  }
  
  private func formatTime(_ unixTime: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
  }
  
  private func formatTimezone(_ seconds: Int) -> String {
    let hours = seconds / 3600
    return String(format: "%+03d:00", hours)
  }
  
  private func formatHour(hour: Int) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:00"
    let date = Calendar.current.date(byAdding: .hour, value: hour, to: Date()) ?? Date()
    return formatter.string(from: date)
  }
  
  init(city: City) {
    _viewModel = StateObject(wrappedValue: CityDetailViewViewModel(city: city))
  }
}

struct DetailRow: View {
  let title: String
  let value: String
  
  var body: some View {
    HStack {
      Text(title)
        .foregroundColor(.secondary)
      Spacer()
      Text(value)
    }
  }
}
