import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published private(set) var entries: [PetDocument] = []
    @Published var isPro: Bool = false

    /// Free-tier cap. Kept comfortably above seed count so a fresh install
    /// never hits the paywall on first launch.
    let freeLimit = 25

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("vaultpaw_entries.json")
        load()
    }

    var canAddMore: Bool {
        isPro || entries.count < freeLimit
    }

    func add(_ entry: PetDocument) {
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: PetDocument) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: PetDocument) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([PetDocument].self, from: data) {
            entries = decoded
        } else {
            entries = Store.seedData
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }

    static var seedData: [PetDocument] {
        [
        PetDocument(petName: "Pet Name 1", title: "Document Title 1", category: "Category 1", notes: "Notes 1")
        ]
    }
}
