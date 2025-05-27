import Combine
import Foundation
import SwiftUI

protocol PropertyServiceProtocol {
    func saveProperty(_ property: Property) async throws
    func loadProperty(id: UUID) async throws -> Property
}

protocol PropertyItemManageable {
    func toggleStar(for id: UUID)
    func toggleStatus(for id: UUID)
    func updateValue(for id: UUID, value: ItemValue)
}

class PropertyService: PropertyServiceProtocol {
    func saveProperty(_ property: Property) async throws {
        // TODO: Implement save logic
    }

    func loadProperty(id: UUID) async throws -> Property {
        throw NSError(domain: "", code: -1)
    }
}

struct EditNoteViewData: Identifiable {
    let id: UUID
    let name: String
    let advantageCount: Int
    let disadvantageCount: Int
    let totalCount: Int
}

class EditNoteViewModel: ObservableObject, PropertyItemManageable {
    /// Input
    @Published var showStarredOnly: Bool = false
    @Published var saveSuccess: Bool = false

    /// Output
    @Published var property: Property {
        didSet {
            viewData = EditNoteViewModel.makeViewData(from: property)
        }
    }

    @Published private(set) var viewData: EditNoteViewData
    @Published private(set) var filteredSections: [PropertySection] = []

    private let dependency: EditNoteDependency
    private let service: PropertyServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    var sectionBindings: Binding<[PropertySection]> {
        Binding(
            get: { self.property.sections },
            set: { self.property.sections = $0 }
        )
    }

    // MARK: - Init

    init(service: PropertyServiceProtocol = PropertyService(), dependency: EditNoteDependency) {
        self.service = service
        self.dependency = dependency
        property = dependency.fetchInitialTemplate()
        viewData = EditNoteViewModel.makeViewData(from: dependency.fetchInitialTemplate())
        setupBindings()
    }

    // MARK: - Bindings

    private func setupBindings() {
        $showStarredOnly
            .combineLatest($property)
            .map { shouldFilter, property in
                guard shouldFilter else { return property.sections }

                return property.sections.map { section in
                    var filteredSection = section
                    filteredSection.items = section.items.filter(\.isStarred)
                    return filteredSection
                }
            }
            .assign(to: \.filteredSections, on: self)
            .store(in: &cancellables)
    }

    // MARK: - User Actions

    func saveProperty() {
        Task {
            do {
                try await service.saveProperty(property)
                DispatchQueue.main.async {
                    self.saveSuccess = true
                }
            } catch {
                print("Save failed: \(error)")
            }
        }
    }

    func dismissView() {
        // TODO: Implement dismiss logic
    }

    func lockProperty() {
        // TODO: Implement lock logic
    }

    func addPhoto() {
        // TODO: Implement add photo logic
    }

    // MARK: - PropertyItemManageable Implementation

    func toggleStar(for id: UUID) {
        let newSections = property.sections.map { section in
            let newItems = section.items.map { item in

                guard item.id == id else { return item }
                var updatedItem = item
                updatedItem.isStarred.toggle()
                return updatedItem
            }
            return PropertySection(id: section.id, type: section.type, items: newItems, order: section.order)
        }

        property = property.copyWithUpdatedSections(newSections)
    }

    func toggleStatus(for id: UUID) {
        let newSections = property.sections.map { section in
            let newItems = section.items.map { item in

                guard item.id == id else { return item }

                var updatedItem = item
                updatedItem.status = item.status.next()
                return updatedItem
            }

            return PropertySection(id: section.id, type: section.type, items: newItems, order: section.order)
        }

        property = property.copyWithUpdatedSections(newSections)
    }

    func updateValue(for id: UUID, value: ItemValue) {
        let newSections = property.sections.map { section in
            let newItems = section.items.map { item in
                guard item.id == id else { return item }

                var updatedItem = item
                updatedItem.value = value
                return updatedItem
            }

            return PropertySection(id: section.id, type: section.type, items: newItems, order: section.order)
        }

        property = property.copyWithUpdatedSections(newSections)
    }

    // MARK: - Helper Methods

    static func makeViewData(from property: Property) -> EditNoteViewData {
        let items = property.sections.flatMap(\.items)

        let advantages = items.filter { $0.status == ItemStatus.advantage }.count
        let disadvantages = items.filter { $0.status == ItemStatus.disadvantage }.count
        let total = items.count

        return EditNoteViewData(
            id: property.id,
            name: property.name,
            advantageCount: advantages,
            disadvantageCount: disadvantages,
            totalCount: total
        )
    }
}
