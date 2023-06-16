import SwiftUI

protocol LogMeasurementServiceType {
  func fetchLogMeasurementList(history: Binding<Loadable<[LogMeasurement]>>)

  func saveLogMeasurement(savedID: Binding<Loadable<UUID>>, logMeasurement: LogMeasurement)

  func measurementImage(image: Binding<Loadable<Image>>, photoIdentifier: String) async
}
