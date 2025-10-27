//
//  ContentView.swift
//  EggCheese
//
//  Created by Fora on 24.10.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showLoading = true
    
    var body: some View {
        if showLoading {
            LoadingView()
                .onAppear {
                    // Показываем LoadingView 2 секунды
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            showLoading = false
                        }
                    }
                }
        } else {
            MainTabView()
        }
    }
}

#Preview {
    ContentView()
}
