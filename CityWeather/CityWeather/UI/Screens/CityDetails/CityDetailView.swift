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
    Text(viewModel.city.name ?? "")
  }
  
  init(city: City) {
    _viewModel = StateObject(wrappedValue: CityDetailViewViewModel(city: city))
  }
}

//#Preview {
//  CityDetailView(city: City(name: "Hanoi", temperature: "30", addedTime: Date()))
//}
