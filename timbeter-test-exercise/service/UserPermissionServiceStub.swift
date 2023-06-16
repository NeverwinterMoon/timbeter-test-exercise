import Foundation

struct UserPermissionServiceStub: UserPermissionServiceType {
  var isPhotoLibraryAuthorized: Bool {
    true
  }

  func handlePhotoLibraryPermission() {
  }
}
