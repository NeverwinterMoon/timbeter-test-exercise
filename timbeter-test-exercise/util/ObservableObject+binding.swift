import SwiftUI

extension ObservableObject {
  func binding<Value>(_ keyPath: WritableKeyPath<Self, Value>) -> Binding<Value> {
    let defaultValue = self[keyPath: keyPath]

    return Binding(
      get: { [weak self] in
        self?[keyPath: keyPath] ?? defaultValue
      },
      set: { [weak self] in
        self?[keyPath: keyPath] = $0
      }
    )
  }
}
