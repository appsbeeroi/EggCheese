import SwiftUI

struct ContentView: View {
    @State private var showLoading = true
    
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
        }
    }
}

#Preview {
    ContentView()
}