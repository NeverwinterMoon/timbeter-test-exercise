import PhotosUI
import SwiftUI

extension PhotoEditor {
  class ViewModel: ObservableObject {
    let container: DIContainer

    @Published var measurementType: MeasurementType? = .length
    @Published var saveID: Loadable<UUID> = .notRequested
    @Published var logMeasurement: LogMeasurementViewData
    @Published var showAddDescriptionSheet: Bool = false
    @Published var description: String = ""
    @Published var startPoint: CGPoint? = nil
    @Published var endPoint: CGPoint? = nil
    @Published var showResetAlert: Bool = false

    var currentMeasurementCm: Double? {
      get {
        guard let startPoint = startPoint, let endPoint = endPoint else {
          return nil
        }

        let xDistance = endPoint.x - startPoint.x
        let yDistance = endPoint.y - startPoint.y
        let lengthInPoints = sqrt(xDistance * xDistance + yDistance * yDistance)
        let lengthInCentimeters = lengthInPoints / UIScreen.main.scale

        return abs(lengthInCentimeters)
      }
    }
    let photoData: PhotoData


    init(container: DIContainer, photoData: PhotoData) {
      self.container = container
      self.photoData = photoData

      _logMeasurement = .init(initialValue: LogMeasurementViewData(
        photoIdentifier: photoData.photoIdentifier
      ))
    }

    func saveMeasurement() {
      guard let diameter = logMeasurement.diameter,
            let length = logMeasurement.length
      else {
        return
      }

      let measurement = LogMeasurement(
        description: logMeasurement.description ?? "No description",
        diameter: diameter,
        length: length,
        savedAt: Date(),
        photoIdentifier: logMeasurement.photoIdentifier
      )

      container.service.logMeasurement.saveLogMeasurement(
        savedID: binding(\.saveID),
        logMeasurement: measurement
      )
    }

    func resetMeasurement() {
      logMeasurement = .init(photoIdentifier: photoData.photoIdentifier)
      measurementType = .length
      saveID = .notRequested
      description = ""
    }

    var nextMeasurement: MeasurementType? {
      guard startPoint != nil,
            endPoint != nil
      else {
        return nil
      }

      return measurementType
    }

    var showSaveAndResetButtons: Bool {
      logMeasurement.hasSufficientData
    }

    var showDescription: Bool {
      logMeasurement.hasSufficientData
    }

    var showMeasurementDataOverlay: Bool {
      logMeasurement.length != nil
    }

    func closeAddDescriptionSheet() {
      showAddDescriptionSheet = false
    }

    func saveDescription() {
      closeAddDescriptionSheet()

      logMeasurement = logMeasurement.clone(path: \.description, to: description)
    }

    func measureDiameterButtonAction() {
      logMeasurement = logMeasurement.clone(path: \.length, to: currentMeasurementCm)

      measurementType = .diameter
      startPoint = nil
      endPoint = nil
    }

    func addDescriptionButtonAction() {
      logMeasurement = logMeasurement.clone(path: \.diameter, to: currentMeasurementCm)

      measurementType = nil
      startPoint = nil
      endPoint = nil

      showAddDescriptionSheet = true
    }

    func resetLine() {
      startPoint = nil
      endPoint = nil
    }

    func handleTapOnCanvasGesture() {
      if startPoint != nil && endPoint != nil {
        showResetAlert = true
      }
    }

    func handleDragGestureChanged(value: DragGesture.Value, canvas: CGRect) {
      guard canvas.contains(value.location) else {
        return
      }

      addPoint(value.location)
    }

    var saveButtonText: String {
      switch saveID {
        case .notRequested:
          return "Save"

        case .isLoading:
          return "Saving"

        case .loaded:
          return "Saved"

        case .failed:
          return "Failed to save, try again"
      }
    }

    var isSaveInProgress: Bool {
      if case .isLoading = saveID {
        return true
      }

      return false
    }

    var isSaveButtonDisabled: Bool {
      switch saveID {
        case .notRequested,
             .failed:
          return false

        case .isLoading,
             .loaded:
          return true
      }
    }
  }

  struct LineShape: Shape {
    let startPoint: CGPoint
    let endPoint: CGPoint

    func path(in rect: CGRect) -> Path {
      Path { path in
        path.move(to: startPoint)
        path.addLine(to: endPoint)
      }
    }
  }

  enum MeasurementType {
    case length

    case diameter

    var localizedStringKey: LocalizedStringKey {
      switch self {
        case .length:
          return "length"

        case .diameter:
          return "diameter"
      }
    }
  }

  struct LogMeasurementViewData: Cloneable {
    var length: Double?
    var diameter: Double?
    var description: String?
    let photoIdentifier: String

    var hasSufficientData: Bool {
      length != nil && diameter != nil
    }
  }
}

private extension PhotoEditor.ViewModel {
  func addPoint(_ location: CGPoint) {
    if startPoint == nil {
      startPoint = location
    }

    endPoint = location
  }
}
