import Foundation

struct Note: Identifiable {
    let id: UUID = .init()
    var title: String
    var content: String
    var date: Date = .init()
}
