import Foundation

struct Batch: Codable, Identifiable {
    let id = UUID()
    let name: String
    let date: Date
    let cheeseType: String
    let milkType: String
    let volume: String
    let status: String
    let notes: String
    
    init(name: String, date: Date, cheeseType: String, milkType: String, volume: String, status: String, notes: String) {
        self.name = name
        self.date = date
        self.cheeseType = cheeseType
        self.milkType = milkType
        self.volume = volume
        self.status = status
        self.notes = notes
    }
}

class BatchManager: ObservableObject {
    @Published var batches: [Batch] = []
    
    private let userDefaults = UserDefaults.standard
    private let batchesKey = "savedBatches"
    
    init() {
        loadBatches()
    }
    
    func addBatch(_ batch: Batch) {
        batches.append(batch)
        saveBatches()
    }
    
    func deleteBatch(_ batch: Batch) {
        batches.removeAll { $0.id == batch.id }
        saveBatches()
    }
    
    func updateBatch(at index: Int, with newBatch: Batch) {
        print("🔍 BatchManager: updateBatch called with index \(index)")
        print("🔍 BatchManager: batches count: \(batches.count)")
        
        if index < batches.count {
            print("🔍 BatchManager: Updating batch at index \(index)")
            batches[index] = newBatch
            saveBatches()
            print("🔍 BatchManager: Batch updated successfully")
        } else {
            print("🔍 BatchManager: ERROR - Index \(index) is out of bounds!")
        }
    }
    
    func loadBatches() {
        if let data = userDefaults.data(forKey: batchesKey),
           let decoded = try? JSONDecoder().decode([Batch].self, from: data) {
            batches = decoded
            
            objectWillChange.send()
        }
    }
    
    private func saveBatches() {
        if let encoded = try? JSONEncoder().encode(batches) {
            userDefaults.set(encoded, forKey: batchesKey)
        }
    }
    
}