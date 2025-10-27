import SwiftUI

struct AddRestraintView: View {
    let editingData: RestraintData?
    let editingIndex: Int?
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var restraintManager = RestraintManager()
    @State private var name = ""
    @State private var date = Date()
    @State private var restraintPeriod = ""
    @State private var readinessDate = Date()
    @State private var notes = ""
    @State private var selectedStatus = "In production"
    @State private var showingCalendar = false
    @State private var showingDataCard = false
    @State private var showingDeleteAlert = false
    
    init(editingData: RestraintData? = nil, editingIndex: Int? = nil) {
        self.editingData = editingData
        self.editingIndex = editingIndex
    }

    private var isFormValid: Bool {
        !name.isEmpty && !restraintPeriod.isEmpty
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

                    Text(showingDataCard ? "" : "Add data")
                        .font(.anton(.title))
                        .foregroundColor(.white)
                    
                    Spacer()

                    if showingDataCard {
                        HStack(spacing: 15) {
                            Button(action: { showingDataCard = false }) {
                                Text("Edit")
                                    .foregroundColor(.blue)
                                    .font(.anton(.headline))
                            }
                            Button(action: { showingDeleteAlert = true }) {
                                Text("Delete")
                                    .foregroundColor(.red)
                                    .font(.anton(.headline))
                            }
                        }
                    } else {
                        Button(action: { saveRestraintData() }) {
                            Image("doneButton")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .opacity(isFormValid ? 1.0 : 0.5)
                        }
                        .disabled(!isFormValid)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 90)

                if !showingDataCard {
                    ScrollView {
                        VStack(spacing: 20) {
                            
                            VStack(spacing: 15) {
                                
                                HStack {
                                    TextField("Batch Name", text: $name)
                                        .font(.anton(.body))
                                        .textFieldStyle(PlainTextFieldStyle())
                                    
                                    if !name.isEmpty {
                                        Button(action: { name = "" }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .cornerRadius(25)

                                Button(action: { showingCalendar = true }) {
                                    HStack {
                                        Text(dateFormatter.string(from: date))
                                            .foregroundColor(.black)
                                        Spacer()
                                        Image("calendarIcon")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                                    .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                    .background(Color.white)
                                    .cornerRadius(25)
                                }

                                HStack {
                                    TextField("Aging Period", text: $restraintPeriod)
                                        .font(.anton(.body))
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .keyboardType(.numberPad)
                                        .toolbar {
                                            ToolbarItemGroup(placement: .keyboard) {
                                                Spacer()
                                                Button("Done") {
                                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                                }
                                            }
                                        }
                                    
                                    if !restraintPeriod.isEmpty {
                                        Button(action: { restraintPeriod = "" }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .cornerRadius(25)

                                Button(action: { showingCalendar = true }) {
                                    HStack {
                                        Text(dateFormatter.string(from: readinessDate))
                                            .foregroundColor(.black)
                                        Spacer()
                                        Image("calendarIcon")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                                    .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                    .background(Color.white)
                                    .cornerRadius(25)
                                }
                            }

                            HStack(spacing: 15) {
                                
                                Button(action: { selectedStatus = "In production" }) {
                                    VStack(spacing: 8) {
                                        Image("inProdImage")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                        Text("In production")
                                            .font(.anton(.body))
                                            .foregroundColor(selectedStatus == "In production" ? .white : .brown)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(selectedStatus == "In production" ? Color.brown : Color.white)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.brown, lineWidth: selectedStatus == "In production" ? 0 : 2)
                                    )
                                }

                                Button(action: { selectedStatus = "Ready" }) {
                                    VStack(spacing: 8) {
                                        Image("readyImage")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                        Text("Ready")
                                            .font(.anton(.body))
                                            .foregroundColor(selectedStatus == "Ready" ? .white : .brown)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(selectedStatus == "Ready" ? Color.brown : Color.white)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.brown, lineWidth: selectedStatus == "Ready" ? 0 : 2)
                                    )
                                }
                            }

                            TextField("Notes", text: $notes, axis: .vertical)
                                        .font(.anton(.body))
                                .textFieldStyle(PlainTextFieldStyle())
                                .frame(minHeight: 80)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .cornerRadius(25)
                            
                            Spacer(minLength: 100) 
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .onTapGesture {
                                
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                    }
                } else {
                    
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 20) {
                            
                            VStack(spacing: 10) {
                                Image("bathImage")
                                
                                Text("Restraint")
                                    .font(.anton(.headline))
                                    .foregroundColor(.brown)
                            }

                            Text(name)
                                .font(.anton(.title))
                                .foregroundColor(.brown)

                            VStack(alignment: .leading, spacing: 10) {
                                DetailRow(title: "Date", value: dateFormatter.string(from: date))
                                DetailRow(title: "Restraint Period", value: restraintPeriod)
                                DetailRow(title: "Readiness Date", value: dateFormatter.string(from: readinessDate))
                                if !notes.isEmpty {
                                    DetailRow(title: "Notes", value: notes)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                        
                        Spacer()
                    }
                }

                if showingCalendar {
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 0) {
                            
                            HStack {
                                Button(action: { showingCalendar = false }) {
                                    Image(systemName: "xmark")
                                        .font(.anton(.title2))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Text("Select Date")
                                    .font(.anton(.title2))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.brown)
                                
                                Spacer()
                                
                                Button(action: { showingCalendar = false }) {
                                    Text("Done")
                                        .font(.anton(.headline))
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 15)
                            .background(Color.white)

                            DatePicker("", selection: $date, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .padding(.horizontal, 20)
                                .padding(.bottom, 20)
                                .background(Color.white)
                        }
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            if let editingData = editingData {
                name = editingData.name
                date = editingData.date
                restraintPeriod = editingData.restraintPeriod
                readinessDate = editingData.readinessDate
                notes = editingData.notes
                selectedStatus = editingData.status
            }
            
            NotificationCenter.default.post(name: NSNotification.Name("HideTabBar"), object: nil)
        }
        .onDisappear {
            
            NotificationCenter.default.post(name: NSNotification.Name("ShowTabBar"), object: nil)
        }
        .alert("Delete", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                
                deleteCreatedRestraintData()
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this restraint data?")
        }
    }
    
    private func saveRestraintData() {
        
        let newData = RestraintData(
            name: name,
            date: date,
            restraintPeriod: restraintPeriod,
            readinessDate: readinessDate,
            notes: notes,
            status: selectedStatus
        )

        if let editingIndex = editingIndex {
            restraintManager.updateRestraintData(at: editingIndex, with: newData)
            NotificationCenter.default.post(name: NSNotification.Name("RestraintDataUpdated"), object: nil)
        } else {
            restraintManager.addRestraintData(newData)
            NotificationCenter.default.post(name: NSNotification.Name("RestraintDataAdded"), object: nil)
        }

        showingDataCard = true
    }
    
    private func deleteCreatedRestraintData() {
        
        let userDefaults = UserDefaults.standard
        let restraintKey = "savedRestraintData"
        
        if let data = userDefaults.data(forKey: restraintKey),
           var restraintData = try? JSONDecoder().decode([RestraintData].self, from: data) {
            
            if !restraintData.isEmpty {
                restraintData.removeLast()
            }

            if let encoded = try? JSONEncoder().encode(restraintData) {
                userDefaults.set(encoded, forKey: restraintKey)
            }
        }

        NotificationCenter.default.post(name: NSNotification.Name("RestraintDataDeleted"), object: nil)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }
}

#Preview {
    AddRestraintView()
}