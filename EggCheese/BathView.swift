import SwiftUI

struct BathView: View {
    @StateObject private var batchManager = BatchManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Batch Counting")
                        .font(.anton(.largeTitle))
                        .foregroundColor(.white)
                        .padding(.top, 80)
                    
                    if batchManager.batches.isEmpty {
                        
                        VStack(spacing: 20) {
                            Image("bathImage")
                            
                            Text("No parties yet")
                                .font(.anton(.title))
                                .foregroundColor(.black)
                            
                            Text("You have not added a single batch of cheese yet")
                                .font(.anton(.body))
                                .foregroundColor(.brown)
                                .multilineTextAlignment(.center)
                            
                            NavigationLink(destination: AddBatchView()) {
                                Text("Add batch")
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
                                ForEach(Array(batchManager.batches.enumerated()), id: \.element.id) { index, batch in
                                    BatchCardView(batch: batch, index: index)
                                }

                                NavigationLink(destination: AddBatchView()) {
                                    Text("Add batch")
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
            
            batchManager.loadBatches()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("BatchAdded"))) { _ in
            
            batchManager.loadBatches()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("BatchDeleted"))) { _ in
            
            batchManager.loadBatches()
        }
    }
}

#Preview {
    BathView()
}