import SwiftUI

struct DIContainer: EnvironmentKey {
  let service: ServiceContainer

  static var defaultValue: Self { Self.default }

  private static let `default` = DIContainer(service: .stub)
}

#if DEBUG
extension DIContainer {
  static var preview: Self {
    DIContainer(service: ServiceContainer.stub)
  }
}
#endif
