import SwiftUI

struct ContentView: View {
    @State private var showLoading = true
    @EnvironmentObject var notificationManager: NotificationManager
    
    var body: some View {
        if showLoading {
            LoadingView()
                .onAppear {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            showLoading = false
                        }
                    }
                }
        } else {
            MainTabView()
                .onAppear {
                    checkFirstLaunch()
                }
        }
    }
    
    private func checkFirstLaunch() {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "HasLaunchedBefore")
        
        if !hasLaunchedBefore {
            UserDefaults.standard.set(true, forKey: "HasLaunchedBefore")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                notificationManager.requestPermission()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(NotificationManager())
}
