import SwiftUI

struct Root: View {
  @ObservedObject private(set) var viewModel: ViewModel
  @State private var routing: [Route] = []

  var body: some View {
    NavigationStack(path: $routing) {
      content
        .navigationDestination(for: Route.self) { route in
          switch route {
            case .logMeasurementHistory:
              logMeasurementHistoryPage
          }
        }
        .toolbar {
          ToolbarItemGroup(placement: .bottomBar) {
            Button(action: pushHistory) {
              Image(systemName: "list.bullet.below.rectangle")
            }
          }
        }
    }
  }

  private var content: some View {
    PhotoPicker(viewModel: .init(container: viewModel.container))
  }
}

// MARK: - Side Effects

private extension Root {
  func pushHistory() {
    routing.append(.logMeasurementHistory)
  }
}

// MARK: - Content

private extension Root {
  var logMeasurementHistoryPage: some View {
    History(viewModel: .init(container: viewModel.container))
  }
}

enum Route: Hashable {
  case logMeasurementHistory
}

// MARK: - Previews

struct Root_Previews: PreviewProvider {
  static var previews: some View {
    Root(
      viewModel: .init(container: .preview)
    )
  }
}
