
//
//  ContentView.swift
//  SwiftUiCocoa
//
//  Created by 이승용 on 3/18/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .toolbar {
              ToolbarItem(placement: .primaryAction) {
                  Button {
                 
                  } label: {
                      Image(systemName: "plus")
                          .help("button.createBottle")
                  }
              }
              ToolbarItem(placement: .primaryAction) {
                  Button {
                     
                  } label: {
                      Image(systemName: "arrow.triangle.2.circlepath")
                  }
              }
          }
    }
}

#Preview {
    ContentView()
}
