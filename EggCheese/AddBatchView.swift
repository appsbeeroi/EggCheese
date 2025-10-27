import SwiftUI

struct AddBatchView: View {
    let editingBatch: Batch?
    let editingIndex: Int?
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var batchManager: BatchManager
    @State private var name = ""
    @State private var date = Date()
    @State private var cheeseType = ""
    @State private var milkType = ""
    @State private var volume = ""
    @State private var selectedStatus = "In production"
    @State private var notes = ""
    @State private var showingCalendar = false
    @State private var showingBatchCard = false
    @State private var showingDeleteAlert = false
    
    private let cheeseTypes = ["Soft Cheese", "Hard Cheese", "Mold Cheese", "Fresh Cheese", "Blue Cheese"]
    
    init(editingBatch: Batch? = nil, editingIndex: Int? = nil) {
        self.editingBatch = editingBatch
        self.editingIndex = editingIndex
    }

    private var isFormValid: Bool {
        !name.isEmpty && !cheeseType.isEmpty && !milkType.isEmpty && !volume.isEmpty
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

                    Text(editingBatch != nil ? "Edit batch" : "Add batch")
                        .font(.anton(.title))
                        .foregroundColor(.white)
                    
                    Spacer()

                    if showingBatchCard {
                        HStack(spacing: 15) {
                            Button(action: { showingBatchCard = false }) {
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
                        Button(action: { saveBatch() }) {
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

                if !showingBatchCard {
                    ScrollView {
                        VStack(spacing: 20) {
                            
                            VStack(spacing: 15) {
                                
                                HStack {
                                    TextField("Name", text: $name)
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

                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Cheese Type")
                                        .font(.anton(.headline))
                                        .foregroundColor(.brown)
                                    
                                    VStack(spacing: 10) {
                                        HStack(spacing: 10) {
                                            ForEach(Array(cheeseTypes.prefix(2)), id: \.self) { type in
                                                Button(action: { cheeseType = type }) {
                                                    Text(type)
                                                        .font(.anton(.body))
                                                        .foregroundColor(cheeseType == type ? .white : .brown)
                                                        .padding(.horizontal, 16)
                                                        .padding(.vertical, 12)
                                                        .background(cheeseType == type ? Color.brown : Color.white)
                                                        .cornerRadius(20)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 20)
                                                                .stroke(Color.brown, lineWidth: cheeseType == type ? 0 : 2)
                                                        )
                                                }
                                            }
                                        }
                                        
                                        HStack(spacing: 10) {
                                            ForEach(Array(cheeseTypes.dropFirst(2)), id: \.self) { type in
                                                Button(action: { cheeseType = type }) {
                                                    Text(type)
                                                        .font(.anton(.body))
                                                        .foregroundColor(cheeseType == type ? .white : .brown)
                                                        .padding(.horizontal, 16)
                                                        .padding(.vertical, 12)
                                                        .background(cheeseType == type ? Color.brown : Color.white)
                                                        .cornerRadius(20)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 20)
                                                                .stroke(Color.brown, lineWidth: cheeseType == type ? 0 : 2)
                                                        )
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .cornerRadius(25)

                                HStack {
                                    TextField("Milk Type", text: $milkType)
                                        .font(.anton(.body))
                                        .textFieldStyle(PlainTextFieldStyle())
                                    
                                    if !milkType.isEmpty {
                                        Button(action: { milkType = "" }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .cornerRadius(25)

                                HStack {
                                    TextField("Volume", text: $volume)
                                        .font(.anton(.body))
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .keyboardType(.decimalPad)
                                        .toolbar {
                                            ToolbarItemGroup(placement: .keyboard) {
                                                Spacer()
                                                Button("Done") {
                                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                                }
                                            }
                                        }
                                    
                                    if !volume.isEmpty {
                                        Button(action: { volume = "" }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .cornerRadius(25)
                            }

                            VStack(spacing: 15) {
                                
                                Button(action: { selectedStatus = "In production" }) {
                                    VStack(spacing: 12) {
                                        Image("inProdImage")
                                            .resizable()
                                            .frame(width: 40, height: 40)

                                        Text("In production")
                                            .font(.anton(.headline))
                                            .foregroundColor(.brown)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 20)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(selectedStatus == "In production" ? Color.brown : Color.clear, lineWidth: 3)
                                    )
                                    .shadow(color: selectedStatus == "In production" ? Color.brown.opacity(0.3) : Color.clear, radius: 5, x: 0, y: 2)
                                }

                                Button(action: { selectedStatus = "Ready" }) {
                                    VStack(spacing: 12) {
                                        Image("readyImage")
                                            .resizable()
                                            .frame(width: 40, height: 40)

                                        Text("Ready")
                                            .font(.anton(.headline))
                                            .foregroundColor(.brown)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 20)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(selectedStatus == "Ready" ? Color.brown : Color.clear, lineWidth: 3)
                                    )
                                    .shadow(color: selectedStatus == "Ready" ? Color.brown.opacity(0.3) : Color.clear, radius: 5, x: 0, y: 2)
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
                                Image(selectedStatus == "In production" ? "inProdImage" : "readyImage")

                                Text(selectedStatus)
                                    .font(.anton(.headline))
                                    .foregroundColor(.brown)
                            }

                            Text(name)
                                .font(.anton(.title))
                                .foregroundColor(.brown)

                            VStack(alignment: .leading, spacing: 10) {
                                DetailRow(title: "Date", value: dateFormatter.string(from: date))
                                DetailRow(title: "Cheese Type", value: cheeseType)
                                DetailRow(title: "Milk Type", value: milkType)
                                DetailRow(title: "Volume", value: volume)
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
                    print("🔍 AddBatchView: onAppear called")
                    print("🔍 AddBatchView: editingBatch: \(editingBatch?.name ?? "nil")")
                    print("🔍 AddBatchView: editingIndex: \(editingIndex ?? -1)")
                    
                    if let editingBatch = editingBatch {
                        name = editingBatch.name
                        date = editingBatch.date
                        cheeseType = editingBatch.cheeseType
                        milkType = editingBatch.milkType
                        volume = editingBatch.volume
                        selectedStatus = editingBatch.status
                        notes = editingBatch.notes
                        
                        print("🔍 AddBatchView: Form populated with batch data")
                    }
                    
                    NotificationCenter.default.post(name: NSNotification.Name("HideTabBar"), object: nil)
                }
                .onDisappear {
                    
                    NotificationCenter.default.post(name: NSNotification.Name("ShowTabBar"), object: nil)
                }
                .alert("Delete", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        
                        deleteCreatedBatch()
                        dismiss()
                    }
                } message: {
                    Text("Are you sure you want to delete this batch?")
                }
    }
    
    private func saveBatch() {
        print("🔍 AddBatchView: saveBatch called")
        print("🔍 AddBatchView: editingIndex: \(editingIndex ?? -1)")
        
        let newBatch = Batch(
            name: name,
            date: date,
            cheeseType: cheeseType,
            milkType: milkType,
            volume: volume,
            status: selectedStatus,
            notes: notes
        )

        if let editingIndex = editingIndex {
            print("🔍 AddBatchView: Updating batch at index \(editingIndex)")
            batchManager.updateBatch(at: editingIndex, with: newBatch)
            NotificationCenter.default.post(name: NSNotification.Name("BatchUpdated"), object: nil)
        } else {
            print("🔍 AddBatchView: Adding new batch")
            batchManager.addBatch(newBatch)
            NotificationCenter.default.post(name: NSNotification.Name("BatchAdded"), object: nil)
        }

        showingBatchCard = true
    }
    
    private func deleteCreatedBatch() {
        
        let userDefaults = UserDefaults.standard
        let batchesKey = "savedBatches"
        
        if let data = userDefaults.data(forKey: batchesKey),
           var batches = try? JSONDecoder().decode([Batch].self, from: data) {
            
            if !batches.isEmpty {
                batches.removeLast()
            }

            if let encoded = try? JSONEncoder().encode(batches) {
                userDefaults.set(encoded, forKey: batchesKey)
            }
        }

        NotificationCenter.default.post(name: NSNotification.Name("BatchDeleted"), object: nil)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 20)
                                .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(10)
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.anton(.subheadline))
                .foregroundColor(.gray)
                .frame(width: 100, alignment: .leading)
            Spacer()

            Text(value)
                .font(.anton(.subheadline))
                .foregroundColor(.brown)
            
        }
    }
}

#Preview {
    AddBatchView()
}