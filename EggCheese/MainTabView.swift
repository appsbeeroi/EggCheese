//
//  MainTabView.swift
//  EggCheese
//
//  Created by Fora on 24.10.2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var hideTabBar = false
    
    var body: some View {
        ZStack {
            // Основной контент
            Group {
                switch selectedTab {
                case 0:
                    BathView()
                case 1:
                    RecipesView()
                case 2:
                    RestraintView()
                case 3:
                    SettingsView()
                default:
                    BathView()
                }
            }
            
            // Кастомный таббар в виде капсулы (скрывается при навигации)
            if !hideTabBar {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        HStack(spacing: 40) {
                            // Таб 1 - Bath (сыр)
                            Button(action: { selectedTab = 0 }) {
                                Image(selectedTab == 0 ? "bathIconSelected" : "bathIcon")
//                                .renderingMode(.template)
//                                .foregroundColor(selectedTab == 0 ? Color(red: 1.0, green: 1, blue: 0.0) : .gray)
                                    .frame(width: 24, height: 24)
//                                .scaleEffect(selectedTab == 0 ? 1.1 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: selectedTab)
                            }
                            
                            // Таб 2 - Recipes (печенье)
                            Button(action: { selectedTab = 1 }) {
                                Image(selectedTab == 1 ? "recipesIconSelected" : "recipesIcon")
//                                .renderingMode(.template)
//                                .foregroundColor(selectedTab == 1 ? Color(red: 1.0, green: 1, blue: 0.0) : .gray)
                                    .frame(width: 24, height: 24)
//                                .scaleEffect(selectedTab == 1 ? 1.1 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: selectedTab)
                            }
                            
                            // Таб 3 - Restraint (галочка)
                            Button(action: { selectedTab = 2 }) {
                                Image(selectedTab == 2 ?"restraintIconSelected" : "restraintIcon")
//                                .renderingMode(.template)
//                                .foregroundColor(selectedTab == 2 ? Color(red: 1.0, green: 01, blue: 0.0) : .gray)
                                    .frame(width: 24, height: 24)
//                                .scaleEffect(selectedTab == 2 ? 1.1 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: selectedTab)
                            }
                            
                            // Таб 4 - Settings (шестеренка)
                            Button(action: { selectedTab = 3 }) {
                                Image(selectedTab == 3 ? "settingsIconSelected" : "settingsIcon")
//                                .renderingMode(.template)
//                                .foregroundColor(selectedTab == 3 ? Color(red: 1.0, green: 1, blue: 0.0) : .gray)
                                    .frame(width: 24, height: 24)
//                                .scaleEffect(selectedTab == 3 ? 1.1 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: selectedTab)
                            }
                        }
                        .padding(.horizontal, 50)
                        .padding(.vertical, 20)
                        .background(Color.white)
                        .cornerRadius(30) // Капсульная форма
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        
                        Spacer()
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("HideTabBar"))) { _ in
            withAnimation {
                hideTabBar = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ShowTabBar"))) { _ in
            withAnimation {
                hideTabBar = false
            }
        }
    }
}

#Preview {
    MainTabView()
}
