import Foundation

struct RestraintData: Codable, Identifiable {
    let id = UUID()
    let name: String
    let date: Date
    let restraintPeriod: String
    let readinessDate: Date
    let notes: String
    let status: String
    
    init(name: String, date: Date, restraintPeriod: String, readinessDate: Date, notes: String, status: String) {
        self.name = name
        self.date = date
        self.restraintPeriod = restraintPeriod
        self.readinessDate = readinessDate
        self.notes = notes
        self.status = status
    }
}

class RestraintManager: ObservableObject {
    @Published var restraintData: [RestraintData] = []
    
    private let userDefaults = UserDefaults.standard
    private let restraintKey = "savedRestraintData"
    
    init() {
        loadRestraintData()
    }
    
    func addRestraintData(_ data: RestraintData) {
        restraintData.append(data)
        saveRestraintData()
    }
    
    func deleteRestraintData(_ data: RestraintData) {
        restraintData.removeAll { $0.id == data.id }
        saveRestraintData()
    }
    
    func updateRestraintData(at index: Int, with newData: RestraintData) {
        if index < restraintData.count {
            restraintData[index] = newData
            saveRestraintData()
        }
    }
    
    func loadRestraintData() {
        if let data = userDefaults.data(forKey: restraintKey),
           let decoded = try? JSONDecoder().decode([RestraintData].self, from: data) {
            restraintData = decoded
            
            objectWillChange.send()
        }
    }
    
    private func saveRestraintData() {
        if let encoded = try? JSONEncoder().encode(restraintData) {
            userDefaults.set(encoded, forKey: restraintKey)
        }
    }
}