import SwiftUI

struct RestraintView: View {
    @StateObject private var restraintManager = RestraintManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Restraint & readiness")
                        .font(.anton(.largeTitle))
                        .foregroundColor(.white)
                        .padding(.top, 80)
                    
                    if restraintManager.restraintData.isEmpty {
                        
                        VStack(spacing: 20) {
                            Image("cheeseImage")
                            
                            Text("No retention data")
                                .font(.anton(.title))
                                .foregroundColor(.black)
                            
                            Text("There are currently no batches to track ripening times")
                                .font(.anton(.body))
                                .foregroundColor(.brown)
                                .multilineTextAlignment(.center)
                            
                            NavigationLink(destination: AddRestraintView()) {
                                Text("Add data")
                                    .font(.anton(.headline))
                                    .foregroundColor(.brown)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.yellow)
                                    .cornerRadius(20)
                                    .padding(.horizontal, 40)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                    } else {
                        
                        ScrollView {
                            LazyVStack(spacing: 15) {
                                ForEach(restraintManager.restraintData) { data in
                                    RestraintCardView(data: data)
                                }

                                NavigationLink(destination: AddRestraintView()) {
                                    Text("Add data")
                                        .font(.anton(.headline))
                                        .foregroundColor(.brown)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.yellow)
                                        .cornerRadius(20)
                                }
                                .padding(.horizontal, 20)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                        .padding(.bottom, 180)
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            
            restraintManager.loadRestraintData()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RestraintDataAdded"))) { _ in
            
            restraintManager.loadRestraintData()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RestraintDataDeleted"))) { _ in
            
            restraintManager.loadRestraintData()
        }
    }
}

#Preview {
    RestraintView()
}