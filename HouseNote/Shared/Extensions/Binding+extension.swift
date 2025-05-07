import SwiftUI

extension Binding where Value: MutableCollection, Value: RandomAccessCollection {
    subscript(index: Value.Index) -> Binding<Value.Element> {
        Binding<Value.Element>(
            get: { self.wrappedValue[index] },
            set: { self.wrappedValue[index] = $0 }
        )
    }
}
