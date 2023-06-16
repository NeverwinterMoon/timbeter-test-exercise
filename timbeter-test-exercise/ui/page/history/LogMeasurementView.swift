import SwiftUI

struct LogMeasurementView: View {
  @Environment(\.presentationMode) private var presentation
  @ObservedObject private(set) var viewModel: ViewModel

  var body: some View {
    NavigationStack {
      content
    }
  }

  private var content: some View {
    imageView
      .overlay(MeasurementDataView(value: viewModel.logMeasurement))
      .toolbar(content: {
        Button(action: { presentation.wrappedValue.dismiss() }) {
          Image(systemName: "xmark")
        }
      })
  }
}

// MARK: - Content

private extension LogMeasurementView {
  var imageView: some View {
    PhotoLibraryAssetView(viewModel: .init(
      container: viewModel.container,
      photoIdentifier: viewModel.logMeasurement.photoIdentifier
    ))
  }
}

// MARK: - ViewModel

extension LogMeasurementView {
  class ViewModel: ObservableObject {
    let container: DIContainer
    let logMeasurement: LogMeasurement

    init(container: DIContainer, logMeasurement: LogMeasurement) {
      self.container = container
      self.logMeasurement = logMeasurement
    }
  }
}

// MARK: - Previews

struct LogMeasurementView_Previews: PreviewProvider {
  static var previews: some View {
    LogMeasurementView(viewModel: .init(
      container: .preview,
      logMeasurement: .preview01
    ))
  }
}
