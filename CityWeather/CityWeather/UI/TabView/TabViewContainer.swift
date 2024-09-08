//
//  TabView.swift
//  CityWeather
//
//  Created by Quang Dam on 8/9/24.
//

import SwiftUI

struct TabViewContainer: View {
  @StateObject private var tabViewVM = TabViewViewModel()
  
  var body: some View {
    TabView {
      SearchView()
        .tabItem {
          Image(systemName: "magnifyingglass")
          Text("Search")
        }
      FavoriteView()
        .tabItem {
          Image(systemName: "heart")
          Text("Favourite")
        }
    }
  }
}


#Preview {
  TabViewContainer()
}
