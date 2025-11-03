import SwiftUI

struct SettingsView: View {
    @State private var showingClearHistoryAlert = false
    @StateObject private var batchManager = BatchManager()
    @StateObject private var recipeManager = RecipeManager()
    @StateObject private var restraintManager = RestraintManager()
    @EnvironmentObject var notificationManager: NotificationManager
    
    @Binding var hideTabBar: Bool
    
    @State private var isShowWeb = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Settings")
                        .font(.anton(.largeTitle))
                        .foregroundColor(.white)
                        .padding(.top, 80)
                    
                    Spacer()
                        .frame(height: 40)
                    
                    VStack(spacing: 15) {
                        
                        Button {
                            hideTabBar = true 
                            isShowWeb = true
                        } label: {
                            HStack {
                                Text("About the app")
                                    .font(.anton(.title3))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.yellow)
                                    .font(.title3)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        VStack(spacing: 10) {
                            HStack {
                                Text("Notification")
                                    .font(.anton(.title3))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Toggle("", isOn: .constant(notificationManager.isAuthorized))
                                    .toggleStyle(SwitchToggleStyle(tint: .yellow))
                                    .disabled(true)
                                    .onTapGesture {
                                        if notificationManager.canRequestPermission {
                                            notificationManager.requestPermission()
                                        } else if !notificationManager.isAuthorized {
                                            notificationManager.openSettings()
                                        }
                                    }
                            }
                            
                            if notificationManager.authorizationStatus == .denied {
                                Text("Notifications are disabled. Enable them in Settings to receive alerts.")
                                    .font(.anton(.caption))
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.leading)
                            } else if notificationManager.authorizationStatus == .notDetermined {
                                Text("Tap the toggle to allow notifications for batch reminders.")
                                    .font(.anton(.caption))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.leading)
                            } else {
                                Text("Notifications are enabled for batch reminders.")
                                    .font(.anton(.caption))
                                    .foregroundColor(.green)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        
                        HStack {
                            Text("History")
                                .font(.anton(.title3))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Button(action: { showingClearHistoryAlert = true }) {
                                Text("Clear")
                                    .foregroundColor(.red)
                                    .font(.anton(.headline))
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                
                if isShowWeb,
                   let url = URL(string: "https://sites.google.com/view/eggcheese/about-the-developer") {
                    WebView(url: url) {
                        hideTabBar = false
                        isShowWeb = false
                    }
                    .ignoresSafeArea(edges: [.bottom])
                }
            }
        }
        .alert("Clear history", isPresented: $showingClearHistoryAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                clearAllData()
            }
        } message: {
            Text("Are you sure you want to delete the entire history? This action cannot be undone.")
        }
    }
    
    private func clearAllData() {
        
        UserDefaults.standard.removeObject(forKey: "savedBatches")
        UserDefaults.standard.removeObject(forKey: "savedRecipes")
        UserDefaults.standard.removeObject(forKey: "savedRestraintData")
        
        batchManager.batches.removeAll()
        recipeManager.recipes.removeAll()
        restraintManager.restraintData.removeAll()
        
        NotificationCenter.default.post(name: NSNotification.Name("BatchDeleted"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("RecipeDeleted"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("RestraintDataDeleted"), object: nil)
    }
    
#if DEBUG
    private func resetFirstLaunchFlag() {
        UserDefaults.standard.removeObject(forKey: "HasLaunchedBefore")
    }
#endif
}

#Preview {
    SettingsView(hideTabBar: .constant(false))
        .environmentObject(NotificationManager())
}
