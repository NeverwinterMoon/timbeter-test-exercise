import Combine
import PhotosUI
import SwiftUI

extension History {
  class ViewModel: ObservableObject {
    let container: DIContainer

    // This is a hacky solution. Proper way would be handle sceneDidBecomeActive/sceneWillResignActive if we know we need to navigate to settings
    @Published var timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    @Published var history: Loadable<[LogMeasurement]> = .notRequested
    @Published var isPhotoLibraryAuthorized: Bool? = nil
    @Published var logMeasurementSheetItem: LogMeasurement? = nil

    init(container: DIContainer) {
      self.container = container
    }

    func fetchHistory() {
      container.service.logMeasurement.fetchLogMeasurementList(
        history: binding(\.history)
      )
    }

    // We are not copying any images in scope of this application and are accessing them from the Photo Library,
    // to load pictures from the Photo Library without using the PhotosPicker, we need user's access to the library
    // Furthermore, SwiftUI's implementation PhotosPicker does not allow to load images as UIImage and only as Image, which is not easily convertable to UIImage or Data, thus cannot be copied to app storage. Bummer.
    func updatePhotoLibraryAuthorizationStatus() {
      isPhotoLibraryAuthorized = container.service.userPermission.isPhotoLibraryAuthorized
    }

    func authorizePhotoLibrary() {
      container.service.userPermission.handlePhotoLibraryPermission()
    }

    func openLogMeasurementSheet(_ value: LogMeasurement) {
      logMeasurementSheetItem = value
    }

    func closeLogMeasurementSheet() {
      logMeasurementSheetItem = nil
    }
  }
}

