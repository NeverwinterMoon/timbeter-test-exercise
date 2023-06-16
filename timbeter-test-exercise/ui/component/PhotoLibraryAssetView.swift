import PhotosUI
import SwiftUI

struct PhotoLibraryAssetView: View {
  @StateObject private var viewModel: ViewModel

  init(viewModel: ViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    content
  }

  @ViewBuilder private var content: some View {
    switch viewModel.image {
      case .notRequested:
        Image(systemName: "photo")
          .resizable()
          .scaledToFit()
          .task {
            await viewModel.fetchPhoto()
          }

      case .isLoading:
        ProgressView()
          .progressViewStyle(.circular)

      case .loaded(let image):
        image
          .resizable()
          .aspectRatio(contentMode: .fit)

      case .failed:
        Image(systemName: "exclamationmark.triangle")
          .resizable()
    }
  }
}

// MARK: - ViewModel

extension PhotoLibraryAssetView {
  class ViewModel: ObservableObject {
    private let container: DIContainer

    private let photoIdentifier: String
    @Published var image: Loadable<Image> = .notRequested

    init(container: DIContainer, photoIdentifier: String) {
      self.container = container
      self.photoIdentifier = photoIdentifier
    }

    func fetchPhoto() async {
      await container.service.logMeasurement.measurementImage(
        image: binding(\.image),
        photoIdentifier: photoIdentifier
      )
    }
  }
}

// MARK: - Previews
struct PhotoPickerItemView_Previews: PreviewProvider {
  static var previews: some View {
    PhotoLibraryAssetView(viewModel: .init(
      container: .preview,
      photoIdentifier: "9F983DBA-EC35-42B8-8773-B597CF782EDD/L0/001"
    ))
  }
}

