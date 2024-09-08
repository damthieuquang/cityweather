//
//  FavouriteView.swift
//  CityWeather
//
//  Created by Quang Dam on 8/9/24.
//

import SwiftUI

struct FavoriteView: View {
  @StateObject var viewModel = FavoriteViewViewModel()
  
  var body: some View {
    List {
      ForEach(viewModel.cities, id: \.self) { city in
        NavigationLink(destination: CityDetailView(city: city)) {
          HStack {
            Text(city.name ?? "")
          }
        }
      }
      .onDelete(perform: viewModel.deleteFavoriteCity)
    }
  }
}

//#Preview {
//  FavoriteView()
//}
