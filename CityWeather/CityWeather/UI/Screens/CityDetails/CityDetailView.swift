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
        headerView
        weatherView
        detailsView
        windView
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
  
  private var headerView: some View {
    VStack(alignment: .leading) {
      if let coord = viewModel.city.coordinate {
        Text("Lat: \(coord.lat), Lon: \(coord.lon)")
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
    }
  }
  
  private var weatherView: some View {
    VStack(alignment: .leading) {
      Text("Weather")
        .font(.headline)
      if let weather = viewModel.city.weather?.first {
        HStack {
          Text(weather.main)
          Text(weather.description)
            .foregroundColor(.secondary)
        }
      }
    }
  }
  
  private var detailsView: some View {
    VStack(alignment: .leading) {
      Text("Details")
        .font(.headline)
      if let main = viewModel.city.main {
        DetailRow(title: "Temperature", value: "\(main.temp)°C")
        DetailRow(title: "Feels Like", value: "\(main.feelsLike)°C")
        DetailRow(title: "Min Temp", value: "\(main.tempMin)°C")
        DetailRow(title: "Max Temp", value: "\(main.tempMax)°C")
        DetailRow(title: "Pressure", value: "\(main.pressure) hPa")
        DetailRow(title: "Humidity", value: "\(main.humidity)%")
      }
      if let visibility = viewModel.city.visibility {
        DetailRow(title: "Visibility", value: "\(visibility) m")
      }
    }
  }
  
  private var windView: some View {
    VStack(alignment: .leading) {
      Text("Wind")
        .font(.headline)
      if let wind = viewModel.city.wind {
        DetailRow(title: "Speed", value: "\(wind.speed) m/s")
          DetailRow(title: "Direction", value: "\(wind.deg)°")
      }
    }
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
