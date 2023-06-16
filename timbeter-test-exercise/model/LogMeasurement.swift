import Foundation

struct LogMeasurement: Identifiable, JSONCodable {
  var id = UUID()
  let description: String
  let diameter: Double
  let length: Double
  let savedAt: Date
  let photoIdentifier: String
}

extension LogMeasurement {
  #if DEBUG
  static let preview01 = LogMeasurement(
    description: "A very very very very very very very very very very very very very very very very very very very very very long description",
    diameter: 1.0,
    length: 2.0,
    savedAt: Date(),
    photoIdentifier: "B84E8479-475C-4727-A4A4-B77AA9980897/L0/001"
  )
  
  static let preview02 = LogMeasurement(description: "B", diameter: 1.0, length: 2.0, savedAt: Date(), photoIdentifier: "9F983DBA-EC35-42B8-8773-B597CF782EDD/L0/001")
  #endif
}
