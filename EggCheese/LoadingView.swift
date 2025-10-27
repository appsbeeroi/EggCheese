//
//  LoadingView.swift
//  EggCheese
//
//  Created by Fora on 24.10.2025.
//

import SwiftUI

struct LoadingView: View {
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            // Фоновая картинка loading из assets
            Image("loading")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
        }
        .onAppear {
            // Таймер на 2 секунды
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                isLoading = false
            }
        }
    }
}

#Preview {
    LoadingView()
}
