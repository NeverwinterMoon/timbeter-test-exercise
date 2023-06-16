import Foundation

extension DIContainer {
  struct ServiceContainer {
    let logMeasurement: LogMeasurementServiceType

    let userPermission: UserPermissionServiceType

    static var stub: Self {
      ServiceContainer(
        logMeasurement: LogMeasurementServiceStub(),
        userPermission: UserPermissionServiceStub()
      )
    }
  }
}
