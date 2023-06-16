import Foundation
import Photos

struct UserPermissionService: UserPermissionServiceType {
  var isPhotoLibraryAuthorized: Bool {
    PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized
  }

  func handlePhotoLibraryPermission() {
    guard !isPhotoLibraryAuthorized else {
      return
    }

    if PHPhotoLibrary.authorizationStatus() == .notDetermined {
      requestPhotoLibraryPermission()
    } else {
      openAppSettings()
    }
  }

  private let openAppSettings: () -> Void

  init(openAppSettings: @escaping () -> Void) {
    self.openAppSettings = openAppSettings
  }
}

private extension UserPermissionService {
  func requestPhotoLibraryPermission() {
    PHPhotoLibrary.requestAuthorization(for: .readWrite) { _ in }
  }
}
