import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var hideTabBar = false
    
    var body: some View {
        ZStack {
            
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

            if !hideTabBar {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        HStack(spacing: 40) {
                            
                            Button(action: { selectedTab = 0 }) {
                                Image(selectedTab == 0 ? "bathIconSelected" : "bathIcon")

                                    .frame(width: 24, height: 24)

                                    .animation(.easeInOut(duration: 0.2), value: selectedTab)
                            }

                            Button(action: { selectedTab = 1 }) {
                                Image(selectedTab == 1 ? "recipesIconSelected" : "recipesIcon")

                                    .frame(width: 24, height: 24)

                                    .animation(.easeInOut(duration: 0.2), value: selectedTab)
                            }

                            Button(action: { selectedTab = 2 }) {
                                Image(selectedTab == 2 ?"restraintIconSelected" : "restraintIcon")

                                    .frame(width: 24, height: 24)

                                    .animation(.easeInOut(duration: 0.2), value: selectedTab)
                            }

                            Button(action: { selectedTab = 3 }) {
                                Image(selectedTab == 3 ? "settingsIconSelected" : "settingsIcon")

                                    .frame(width: 24, height: 24)

                                    .animation(.easeInOut(duration: 0.2), value: selectedTab)
                            }
                        }
                        .padding(.horizontal, 50)
                        .padding(.vertical, 20)
                        .background(Color.white)
                        .cornerRadius(30) 
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