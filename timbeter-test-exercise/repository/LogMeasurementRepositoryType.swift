import SwiftUI

protocol LogMeasurementRepositoryType {
  var logMeasurements: [LogMeasurement] { get nonmutating set }

  func measurementImage(photoIdentifier: String) async throws -> Image
}
