import Foundation

extension Content {
  class ViewModel: ObservableObject {
    let container: DIContainer

    init(container: DIContainer) {
      self.container = container
    }
  }
}
