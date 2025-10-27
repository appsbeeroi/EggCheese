import SwiftUI

struct BatchDetailView: View {
    let batch: Batch
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var batchManager: BatchManager
    @State private var showingDeleteAlert = false
    @State private var showingEditSheet = false
    
    private var batchIndex: Int? {
        batchManager.batches.firstIndex { $0.id == batch.id }
    }
    
    var body: some View {
        ZStack {
            
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                HStack {
                    
                    Button(action: { dismiss() }) {
                        Image("backButton")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    
                    Spacer()

                    Text("Batch Details")
                        .font(.anton(.title))
                        .foregroundColor(.white)
                    
                    Spacer()

                    HStack(spacing: 15) {
                        if batchIndex != nil {
                            Button(action: { showingEditSheet = true }) {
                                Text("Edit")
                                    .foregroundColor(.blue)
                                    .font(.anton(.headline))
                            }
                        }
                        
                        Button(action: { showingDeleteAlert = true }) {
                            Text("Delete")
                                .foregroundColor(.red)
                                .font(.anton(.headline))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 90)

                VStack {
                    Spacer()
                        .frame(height: 20)
                    
                    VStack(spacing: 20) {
                        
                        VStack(spacing: 10) {
                            Image(batch.status == "In production" ? "inProdImage" : "readyImage")
                                .resizable()
                                .frame(width: 50, height: 50)
                            
                            Text(batch.status)
                                .font(.anton(.headline))
                                .foregroundColor(.brown)
                        }

                        Text(batch.name)
                            .font(.anton(.title))
                            .foregroundColor(.brown)

                        VStack(alignment: .leading, spacing: 10) {
                            DetailRow(title: "Date", value: dateFormatter.string(from: batch.date))
                            DetailRow(title: "Cheese Type", value: batch.cheeseType)
                            DetailRow(title: "Milk Type", value: batch.milkType)
                            DetailRow(title: "Volume", value: batch.volume)
                            if !batch.notes.isEmpty {
                                DetailRow(title: "Notes", value: batch.notes)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            NotificationCenter.default.post(name: NSNotification.Name("HideTabBar"), object: nil)
        }
        .onDisappear {
            
            NotificationCenter.default.post(name: NSNotification.Name("ShowTabBar"), object: nil)
        }
        .alert("Delete", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                
                deleteBatchFromUserDefaults(batch)
                
                NotificationCenter.default.post(name: NSNotification.Name("BatchDeleted"), object: nil)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this batch?")
        }
        .sheet(isPresented: $showingEditSheet) {
            if let index = batchIndex {
                AddBatchView(editingBatch: batch, editingIndex: index)
                    .environmentObject(batchManager)
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
    
    private func deleteBatchFromUserDefaults(_ batch: Batch) {
        let userDefaults = UserDefaults.standard
        let batchesKey = "savedBatches"
        
        if let data = userDefaults.data(forKey: batchesKey),
           var batches = try? JSONDecoder().decode([Batch].self, from: data) {
            
            batches.removeAll { $0.id == batch.id }

            if let encoded = try? JSONEncoder().encode(batches) {
                userDefaults.set(encoded, forKey: batchesKey)
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }
}

#Preview {
    BatchDetailView(batch: Batch(
        name: "Alpine Brine",
        date: Date(),
        cheeseType: "Mold Cheese",
        milkType: "Cow",
        volume: "8 kg",
        status: "In production",
        notes: "Added a bit of sea salt"
    ))
    .environmentObject(BatchManager())
}
