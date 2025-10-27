import SwiftUI

struct RestraintDetailView: View {
    let data: RestraintData
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var restraintManager: RestraintManager
    @State private var showingDeleteAlert = false
    @State private var showingEditSheet = false
    
    private var restraintIndex: Int? {
        restraintManager.restraintData.firstIndex { $0.id == data.id }
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

                    Text("Restraint Details")
                        .font(.anton(.title))
                        .foregroundColor(.white)
                    
                    Spacer()

                    HStack(spacing: 15) {
                        if restraintIndex != nil {
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
                            Image(data.status == "In production" ? "inProdImage" : "readyImage")
                                .resizable()
                                .frame(width: 50, height: 50)
                            
                            Text(data.status)
                                .font(.anton(.headline))
                                .foregroundColor(.yellow)
                        }

                        Text(data.name)
                            .font(.anton(.title))
                            .foregroundColor(.brown)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HStack(alignment: .top, spacing: 20) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Start Date")
                                    .font(.anton(.caption))
                                    .foregroundColor(.gray)
                                Text(dateFormatter.string(from: data.date))
                                    .font(.anton(.subheadline))
                                    .foregroundColor(.brown)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Start Date")
                                    .font(.anton(.caption))
                                    .foregroundColor(.gray)
                                Text(dateFormatter.string(from: data.readinessDate))
                                    .font(.anton(.subheadline))
                                    .foregroundColor(.brown)
                            }
                            
                            Spacer()
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Aging Period")
                                .font(.anton(.caption))
                                .foregroundColor(.gray)
                            Text(data.restraintPeriod)
                                .font(.anton(.subheadline))
                                .foregroundColor(.brown)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
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
                
                deleteRestraintDataFromUserDefaults(data)
                
                NotificationCenter.default.post(name: NSNotification.Name("RestraintDataDeleted"), object: nil)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this restraint data?")
        }
        .sheet(isPresented: $showingEditSheet) {
            if let index = restraintIndex {
                AddRestraintView(editingData: data, editingIndex: index)
                    .environmentObject(restraintManager)
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
    
    private func deleteRestraintDataFromUserDefaults(_ data: RestraintData) {
        let userDefaults = UserDefaults.standard
        let restraintKey = "savedRestraintData"
        
        if let userData = userDefaults.data(forKey: restraintKey),
           var restraintData = try? JSONDecoder().decode([RestraintData].self, from: userData) {
            
            restraintData.removeAll { $0.id == data.id }

            if let encoded = try? JSONEncoder().encode(restraintData) {
                userDefaults.set(encoded, forKey: restraintKey)
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
    RestraintDetailView(data: RestraintData(
        name: "Alpine Brine",
        date: Date(),
        restraintPeriod: "30 days",
        readinessDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date(),
        notes: "Track ripening progress",
        status: "In production"
    ))
    .environmentObject(RestraintManager())
}
