import SwiftUI

struct LogMeasurementService: LogMeasurementServiceType {
  let repository: LogMeasurementRepositoryType

  func fetchLogMeasurementList(history: Binding<Loadable<[LogMeasurement]>>) {
    let data = repository.logMeasurements.sorted { $0.savedAt > $1.savedAt }

    history.wrappedValue = .loaded(data)
  }

  func saveLogMeasurement(savedID: Binding<Loadable<UUID>>, logMeasurement: LogMeasurement) {
    savedID.wrappedValue = .isLoading

    let persistedList = repository.logMeasurements
    let newList = persistedList + [logMeasurement]

    repository.logMeasurements = newList

    savedID.wrappedValue = .loaded(logMeasurement.id)
  }

  func measurementImage(image: Binding<Loadable<Image>>, photoIdentifier: String) async {
    await MainActor.run {
      image.wrappedValue = .isLoading
    }

    do {
      let result = try await repository.measurementImage(photoIdentifier: photoIdentifier)

      await MainActor.run {
        image.wrappedValue = .loaded(result)
      }
    } catch {
      await MainActor.run {
        image.wrappedValue = .failed(error)
      }
    }
  }
}
