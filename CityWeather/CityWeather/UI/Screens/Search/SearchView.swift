//
//  SearchView.swift
//  CityWeather
//
//  Created by Quang Dam on 8/9/24.
//

import SwiftUI
import CWModels

struct SearchView: View {
  @StateObject private var viewModel = SearchViewViewModel()
  
  var body: some View {
    NavigationStack {
      VStack {
        SearchBar { text in
          viewModel.getCityByName(cityName: text)
        }
        content
      }
      .navigationDestination(for: City.self) { city in
        CityDetailView(city: city)
      }
      .navigationTitle("Search")
    }
  }
  
  @ViewBuilder
  private var content: some View {
    switch viewModel.loadingState {
    case .loading: loadingView
    case .success: cityListView
    case .none, .failed: Spacer()
    }
  }
  
  private var loadingView: some View {
    VStack {
      Spacer()
      ProgressView()
      Spacer()
    }
  }
  
  private var cityListView: some View {
    List {
      Text("Recent Search")
        .font(.subheadline)
        .fontWeight(.bold)
      ForEach(viewModel.history, id: \.self) { city in
        NavigationLink(city.name, value: city)
          .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
              viewModel.deleteHistory(city: city)
            } label: {
              Label("Remove", systemImage: "trash")
            }
          }
      }
    }
  }
}
