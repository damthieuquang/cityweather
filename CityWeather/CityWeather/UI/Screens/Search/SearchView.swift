//
//  SearchView.swift
//  CityWeather
//
//  Created by Quang Dam on 8/9/24.
//

import SwiftUI

struct SearchView: View {
  // ViewModel
  @StateObject var viewModel = SearchViewViewModel()
  
  var body: some View {
    VStack {
      // SearchBar
      SearchBar { text in
        viewModel.getCityByName(cityName: text)
      }
      // list result
      List {
        ForEach(viewModel.cities, id: \.self) { city in
          Text(city.name ?? "")
        }
      }
    }
  }
}

#Preview {
  SearchView()
}
