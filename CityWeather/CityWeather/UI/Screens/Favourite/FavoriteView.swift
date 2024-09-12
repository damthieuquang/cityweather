//
//  FavouriteView.swift
//  CityWeather
//
//  Created by Quang Dam on 8/9/24.
//

import SwiftUI
import CWModels

struct FavoriteView: View {
  @StateObject var viewModel = FavoriteViewViewModel()
  
  var body: some View {
    NavigationStack {
      Group {
        if viewModel.cities.isEmpty {
          emptyStateView
        } else {
          cityListView
        }
      }
      .onAppear {
        viewModel.loadCities()
      }
      .navigationTitle(viewModel.navigationTitle)
    }
  }
  
  private var emptyStateView: some View {
    VStack {
      Spacer()
      Text(viewModel.emptyStateMessage)
        .font(.title2)
        .foregroundColor(.secondary)
      Spacer()
    }
  }
  
  private var cityListView: some View {
    List {
      ForEach(viewModel.cities, id: \.self) { city in
        NavigationLink(value: city) {
          Text(city.name)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
          Button(role: .destructive) {
            viewModel.deleteCity(city: city)
          } label: {
            Label(viewModel.removeButtonLabel, systemImage: "trash")
          }
        }
      }
    }
    .listStyle(.automatic)
    .navigationDestination(for: City.self) { city in
      CityDetailView(city: city)
    }
  }
}
