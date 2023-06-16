import Foundation

protocol Cloneable {
}

extension Cloneable {
  func clone<T>(path: WritableKeyPath<Self, T>, to value: T) -> Self {
    var clone = self
    clone[keyPath: path] = value
    return clone
  }
}
