import SwiftUI

struct LogMeasurementServiceStub: LogMeasurementServiceType {
  func fetchLogMeasurementList(history: Binding<Loadable<[LogMeasurement]>>) {
    history.wrappedValue = .loaded(
      [
        .preview01,
        .preview02,
      ]
    )
  }

  func saveLogMeasurement(savedID: Binding<Loadable<UUID>>, logMeasurement: LogMeasurement) {
  }

  func measurementImage(image: Binding<Loadable<Image>>, photoIdentifier: String) async {
  }
}
