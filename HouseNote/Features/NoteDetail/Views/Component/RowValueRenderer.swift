import SwiftUI

protocol RowValueRenderer: View {
    init(item: Binding<PropertyItem>, fieldTemplate: FieldTemplate)
}
