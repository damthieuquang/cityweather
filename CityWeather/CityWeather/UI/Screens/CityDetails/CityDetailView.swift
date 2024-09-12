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
      Text(viewModel.nowText)
        .font(.title2)
        .fontWeight(.bold)
        .foregroundColor(.white)
      HStack(alignment: .top, spacing: 20) {
        VStack(alignment: .leading) {
          HStack(alignment: .top) {
            Text(viewModel.temperatureText)
              .font(.system(size: 60))
              .fontWeight(.thin)
              .foregroundColor(.white)
            weatherIconView
          }
          Text(viewModel.feelsLikeTemperatureText)
            .font(.title3)
            .foregroundColor(.white.opacity(0.8))
        }
        VStack(alignment: .leading) {
          if let weather = viewModel.city.weather?.first {
            Text(weather.main)
              .font(.title2)
              .fontWeight(.semibold)
              .foregroundColor(.white)
            Text(weather.description)
              .foregroundColor(.white.opacity(0.8))
          }
          Text(viewModel.coordinateText)
            .font(.caption)
            .foregroundColor(.white.opacity(0.8))
          DetailRow(title: viewModel.precipText, value: viewModel.precipitationText)
          DetailRow(title: viewModel.humidityText, value: viewModel.humidityValue)
          DetailRow(title: viewModel.windText, value: viewModel.windSpeedText)
        }
      }
    }
    .padding()
    .background(
      LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.cyan.opacity(0.6)]),
                     startPoint: .topLeading,
                     endPoint: .bottomTrailing)
    )
    .cornerRadius(15)
    .shadow(radius: 5)
  }
  
  private var hourlyForecastView: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(viewModel.hourlyForecastText)
        .font(.title2)
        .fontWeight(.bold)
        .foregroundColor(.white)
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 20) {
          ForEach(0..<7) { hour in
            VStack {
              Text(formatHour(hour: hour))
                .font(.caption)
                .foregroundColor(.white)
              weatherIconView
              Text(viewModel.temperatureText)
                .font(.title3)
                .foregroundColor(.white)
            }
          }
        }
      }
    }
    .padding()
    .background(
      LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.pink.opacity(0.6)]),
                     startPoint: .topLeading,
                     endPoint: .bottomTrailing)
    )
    .cornerRadius(15)
    .shadow(radius: 5)
  }
  
  private var cloudsView: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(viewModel.cloudsText)
        .font(.headline)
        .foregroundColor(.white)
      HStack {
        Image(systemName: "cloud.fill")
          .foregroundColor(.white)
          .font(.system(size: 40))
        VStack(alignment: .leading) {
          Text(viewModel.cloudinessText)
            .foregroundColor(.white.opacity(0.8))
          Text(viewModel.cloudinessPercentText)
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.white)
        }
      }
    }
    .padding()
    .background(
      LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                     startPoint: .topLeading,
                     endPoint: .bottomTrailing)
    )
    .cornerRadius(15)
    .shadow(radius: 5)
  }
  
  private var systemInfoView: some View {
    VStack(alignment: .leading, spacing: 15) {
      Text(viewModel.systemText)
        .font(.headline)
        .foregroundColor(.white)
      if let sys = viewModel.city.sys {
        HStack {
          VStack(alignment: .leading, spacing: 10) {
            InfoRow(icon: "globe", title: viewModel.country, value: sys.country)
            InfoRow(icon: "sunrise.fill", title: viewModel.sunrise, value: formatTime(sys.sunrise))
          }
          Spacer()
          VStack(alignment: .leading, spacing: 10) {
            if let timezone = viewModel.city.timezone {
              InfoRow(icon: "clock.fill", title: viewModel.timezone, value: "UTC \(formatTimezone(timezone))")
            }
            InfoRow(icon: "sunset.fill", title: viewModel.sunset, value: formatTime(sys.sunset))
          }
        }
      }
    }
    .padding()
    .background(
      LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]),
                     startPoint: .topLeading,
                     endPoint: .bottomTrailing)
    )
    .cornerRadius(15)
    .shadow(radius: 5)
  }
  
  private var weatherIconView: some View {
    // Replace with actual weather icon based on conditions
    Image(systemName: "sun.max.fill")
      .renderingMode(.original)
      .font(.largeTitle)
  }
  
  private func formatTime(_ unixTime: TimeInterval) -> String {
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
        .foregroundColor(.white.opacity(0.8))
      Spacer()
      Text(value)
        .foregroundColor(.white)
    }
  }
}

private struct InfoRow: View {
  let icon: String
  let title: String
  let value: String
  
  var body: some View {
    HStack {
      Image(systemName: icon)
        .foregroundColor(.white)
        .frame(width: 30)
      VStack(alignment: .leading) {
        Text(title)
          .font(.caption)
          .foregroundColor(.white.opacity(0.8))
        Text(value)
          .fontWeight(.semibold)
          .foregroundColor(.white)
      }
    }
  }
}
