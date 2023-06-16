import UIKit

struct AppEnvironment {
  let container: DIContainer
}

extension AppEnvironment {
  static func bootstrap() -> AppEnvironment {
    let repositoryContainer = DIContainer.RepositoryContainer(
      logMeasurement: LogMeasurementRepository(
        userDefaults: UserDefaults.standard
      )
    )

    let serviceContainer = DIContainer.ServiceContainer(
      logMeasurement: LogMeasurementService(
        repository: repositoryContainer.logMeasurement
      ),
      userPermission: UserPermissionService(openAppSettings: {
        URL(string: UIApplication.openSettingsURLString).flatMap {
          UIApplication.shared.open($0, options: [:], completionHandler: nil)
        }
      })
    )

    let container = DIContainer(
      service: serviceContainer
    )

    return AppEnvironment(
      container: container
    )
  }
}
