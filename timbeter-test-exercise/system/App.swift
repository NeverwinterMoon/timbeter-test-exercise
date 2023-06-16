import SwiftUI

@main
struct TimbeterApp: App {
  var body: some Scene {
    WindowGroup {
      let environment = AppEnvironment.bootstrap()

      Content(
        viewModel: .init(container: environment.container)
      )
    }
  }
}
