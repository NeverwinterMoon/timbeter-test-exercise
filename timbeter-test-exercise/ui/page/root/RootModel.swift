import Foundation

extension Root {
  class ViewModel: ObservableObject {
    let container: DIContainer

    init(container: DIContainer) {
      self.container = container
    }
  }
}
