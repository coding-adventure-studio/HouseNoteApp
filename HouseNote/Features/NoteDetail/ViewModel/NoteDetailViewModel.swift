import Combine
import Foundation
import SwiftUI

protocol PropertyServiceProtocol {
    func saveProperty(_ property: Property) async throws
    func loadProperty(id: UUID) async throws -> Property
}

@MainActor
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

struct NoteDetailViewData: Identifiable {
    let id: UUID
    let name: String
    let advantageCount: Int
    let disadvantageCount: Int
    let totalCount: Int
}

@MainActor
class NoteDetailViewModel: ObservableObject, PropertyItemManageable {
    /// Input
    @Published var showStarredOnly: Bool = false
    @Published var saveSuccess: Bool = false
    @Published var saveError: Bool = false

    /// Output
    @Published var property: Property {
        didSet {
            viewData = NoteDetailViewModel.makeViewData(from: property)
        }
    }

    @Published private(set) var viewData: NoteDetailViewData
    @Published private(set) var filteredSections: [PropertySection] = []
    @Published var mode: NoteMode

    private let dependency: NoteDetailDependency
    private let service: PropertyServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    var sectionBindings: Binding<[PropertySection]> {
        Binding(
            get: { self.property.sections },
            set: { self.property.sections = $0 }
        )
    }

    // MARK: - Init

    init(
        mode: NoteMode,
        service: PropertyServiceProtocol = PropertyService(),
        dependency: NoteDetailDependency
    ) {
        self.mode = mode
        self.service = service
        self.dependency = dependency

        let property = NoteDetailViewModel.makeProperty(mode: mode, dependency: dependency)
        self.property = property
        viewData = NoteDetailViewModel.makeViewData(from: property)
        setupBindings()
    }

    private static func makeProperty(mode: NoteMode, dependency: NoteDetailDependency) -> Property {
        switch mode {
        case .create:
            dependency.fetchInitialTemplate()
        case let .edit(note), let .view(note):
            note.toProperty()
        }
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
                self.saveError = true
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

    func reset() {
        property = dependency.fetchInitialTemplate()
        viewData = NoteDetailViewModel.makeViewData(from: property)
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

    static func makeViewData(from property: Property) -> NoteDetailViewData {
        let items = property.sections.flatMap(\.items)

        let advantages = items.filter { $0.status == ItemStatus.advantage }.count
        let disadvantages = items.filter { $0.status == ItemStatus.disadvantage }.count
        let total = items.count

        return NoteDetailViewData(
            id: property.id,
            name: property.name,
            advantageCount: advantages,
            disadvantageCount: disadvantages,
            totalCount: total
        )
    }
}
