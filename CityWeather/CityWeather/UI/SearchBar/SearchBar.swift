//
//  SearchBar.swift
//  CityWeather
//
//  Created by Quang Dam on 8/9/24.
//

import SwiftUI

struct SearchBar: View {
  @State private var searchText = ""
  var onSearchButtonClicked: (String) -> Void
  
  var body: some View {
    HStack {
      TextField("Search...", text: $searchText, onCommit: {
        onSearchButtonClicked(standardizeSearchText(searchText))
      })
      .padding(8)
      .background(Color(.systemGray6))
      .cornerRadius(8)
      .padding(.horizontal)
      
      if !searchText.isEmpty {
        Button(action: {
          searchText = ""
        }) {
          Image(systemName: "xmark.circle.fill")
            .foregroundColor(.gray)
            .padding(.trailing, 16)
        }
      }
    }
  }
}

private extension SearchBar {
  func standardizeSearchText(_ text: String) -> String {
    text.trimmingCharacters(in: .whitespacesAndNewlines)
  }
}
