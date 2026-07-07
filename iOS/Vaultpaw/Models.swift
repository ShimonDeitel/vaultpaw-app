import Foundation

struct PetDocument: Identifiable, Codable, Equatable {
    let id: UUID
    var createdAt: Date
    var petName: String
    var title: String
    var category: String
    var notes: String

    init(id: UUID = UUID(), createdAt: Date = Date(), petName: String = "", title: String = "", category: String = "", notes: String = "") {
        self.id = id
        self.createdAt = createdAt
        self.petName = petName
        self.title = title
        self.category = category
        self.notes = notes
    }
}
