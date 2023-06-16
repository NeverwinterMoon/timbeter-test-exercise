import PhotosUI
import SwiftUI

struct PhotoPicker: View {
  @ObservedObject private(set) var viewModel: ViewModel

  var body: some View {
    content
  }

  private var content: some View {
    VStack {
      photoView
    }
      .toolbar {
        ToolbarItem(placement: .bottomBar) {
          // NB! Without providing photoLibary, photos will not have asset identifiers: https://developer.apple.com/documentation/photokit/selecting_photos_and_videos_in_ios#3856458
          PhotosPicker(selection: $viewModel.photoSelection, matching: .images, photoLibrary: .shared()) {
            Image(systemName: "photo")
          }
        }
      }
  }
}

// MARK: - Content

private extension PhotoPicker {
  @ViewBuilder var photoView: some View {
    switch viewModel.photo {
      case .notRequested:
        EmptyView()

      case .isLoading:
        ProgressView()
          .progressViewStyle(.circular)

      case .loaded(let photo):
        PhotoEditor(viewModel: .init(
          container: viewModel.container,
          photoData: photo
        ))

      case .failed:
        Text("Failed to load selected image")
    }
  }
}

// MARK: - Previews

struct PhotoPicker_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      PhotoPicker(
        viewModel: .init(container: .preview)
      )
    }
  }
}
