import Photos
import SwiftUI

struct LogMeasurementRepository: LogMeasurementRepositoryType {
  let userDefaults: UserDefaults

  var logMeasurements: [LogMeasurement] {
    get { userDefaults[#function] ?? [] }
    nonmutating set { userDefaults[#function] = newValue }
  }

  func measurementImage(photoIdentifier: String) async throws -> Image {
    let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [photoIdentifier], options: nil)

    guard let asset = fetchResult.firstObject else {
      throw TimbeterError.generic
    }

    let options = PHImageRequestOptions()
    options.deliveryMode = .highQualityFormat

    return try await withCheckedThrowingContinuation { continuation in
      PHImageManager.default().requestImage(
        for: asset,
        targetSize: PHImageManagerMaximumSize,
        contentMode: .aspectFit,
        options: options
      ) { uiImage, _ in
        guard let uiImage = uiImage else {
          continuation.resume(throwing: TimbeterError.generic)

          return
        }

        continuation.resume(returning: Image(uiImage: uiImage))
      }
    }
  }
}
