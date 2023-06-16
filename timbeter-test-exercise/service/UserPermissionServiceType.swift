import Foundation

protocol UserPermissionServiceType {
  var isPhotoLibraryAuthorized: Bool { get }

  func handlePhotoLibraryPermission()
}
