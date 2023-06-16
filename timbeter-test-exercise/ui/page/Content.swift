import SwiftUI

struct Content: View {
  @ObservedObject private(set) var viewModel: ViewModel

  var body: some View {
    Root(
      viewModel: .init(container: viewModel.container)
    )
  }
}

// MARK: - Previews

struct Content_Previews: PreviewProvider {
  static var previews: some View {
    Content(
      viewModel: .init(container: DIContainer.preview)
    )
  }
}
