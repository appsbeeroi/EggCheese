import SwiftUI

struct LoadingView: View {
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            
            Image("loading")
                .resizable()
                .ignoresSafeArea()
        }
        .onAppear {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                isLoading = false
            }
        }
    }
}

#Preview {
    LoadingView()
}
