import PhotosUI
import SwiftUI

extension PhotoPicker {
  class ViewModel: ObservableObject {
    let container: DIContainer

    init(container: DIContainer) {
      self.container = container
    }

    @Published var photoSelection: PhotosPickerItem? = nil {
      didSet {
        guard let photoSelection = photoSelection else {
          return
        }

        Task {
          await loadTransferable(from: photoSelection)
        }
      }
    }
    @Published var photo: Loadable<PhotoData> = .notRequested

    private func loadTransferable(from imageSelection: PhotosPickerItem) async {
      await MainActor.run {
        photo = .isLoading
      }

      if let transferable = try? await imageSelection.loadTransferable(type: Image.self),
         let photoIdentifier = imageSelection.itemIdentifier {
        await MainActor.run {
          photo = .loaded(.init(photo: transferable, photoIdentifier: photoIdentifier))
        }
      } else {
        await MainActor.run {
          photo = .failed(TimbeterError.generic)
        }
      }
    }
  }
}

extension PhotoPicker {
  enum MeasurementType {
    case length

    case diameter
  }
}
