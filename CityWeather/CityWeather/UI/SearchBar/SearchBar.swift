//
//  SearchBar.swift
//  CityWeather
//
//  Created by Quang Dam on 8/9/24.
//

import SwiftUI

struct SearchBar: View {
  @Binding var searchText: String
  @FocusState.Binding var isFocused: Bool
  var onSearchButtonClicked: (String) -> Void

  var body: some View {
    HStack {
      TextField("Search...", text: $searchText, onCommit: {
        let standardizedText = standardizeSearchText(searchText)
        searchText = standardizedText
        onSearchButtonClicked(standardizedText)
      })
      .padding(8)
      .focused($isFocused)
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
