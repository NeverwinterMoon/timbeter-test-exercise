import SwiftUI

struct History: View {
  @StateObject private var viewModel: ViewModel

  init(viewModel: ViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    ZStack {
      content
        .onReceive(viewModel.timer, perform: { _ in
          viewModel.updatePhotoLibraryAuthorizationStatus()
        })
    }
  }

  @ViewBuilder private var content: some View {
    if viewModel.isPhotoLibraryAuthorized == true {
      switch viewModel.history {
        case .notRequested:
          notRequestedView

        case .isLoading:
          loadingView

        case .loaded(let history):
          loadedView(history)

        case .failed(let error):
          failedView(error)
      }
    } else if viewModel.isPhotoLibraryAuthorized == false {
      VStack(spacing: 8.0) {
        Text("To be able to load images for measurements, you have to give Photo Library permissions")

        Button(action: viewModel.authorizePhotoLibrary) {
          Text("Authorize Photo Library")
        }
      }
        .multilineTextAlignment(.center)
        .padding()
    } else {
      ProgressView()
        .progressViewStyle(.circular)
    }
  }
}

// MARK: - Content

private extension History {
  var notRequestedView: some View {
    Text("")
      .onAppear {
        viewModel.fetchHistory()
      }
  }

  var loadingView: some View {
    ProgressView()
      .progressViewStyle(.circular)
  }

  func loadedView(_ history: [LogMeasurement]) -> some View {
    List(history) { measurement in
      Button(action: {
        viewModel.openLogMeasurementSheet(measurement)
      }) {
        HStack {
          historyItemView(measurement)

          Spacer()

          Image(systemName: "chevron.right")
            .foregroundColor(.gray)
            .font(Font.body.weight(.semibold))
        }
          .contentShape(Rectangle())
      }
        .buttonStyle(.plain)
        .sheet(item: $viewModel.logMeasurementSheetItem, onDismiss: viewModel.closeLogMeasurementSheet) { item in
          LogMeasurementView(viewModel: .init(container: viewModel.container, logMeasurement: item))
        }
    }
  }

  func historyItemView(_ value: LogMeasurement) -> some View {
    HStack {
      VStack(alignment: .leading, spacing: 8.0) {
        Text(value.description)
          .lineLimit(1)
          .truncationMode(.middle)
        Text(value.savedAt.formatted())
        Text("Length: \(value.length.toCmFormat)")
        Text("Diameter: \(value.diameter.toCmFormat)")
      }

      Spacer()

      PhotoLibraryAssetView(viewModel: .init(
        container: viewModel.container,
        photoIdentifier: value.photoIdentifier
      ))
        .frame(width: 100, height: 100)
        .padding(4.0)
    }
  }

  func failedView(_ error: Error) -> some View {
    VStack {
      Text("Ran into an error")
        .font(.title)

      Text(error.localizedDescription)
        .font(.callout)
        .multilineTextAlignment(.center)
        .padding()
    }
  }
}

// MARK: - Previews

struct History_Previews: PreviewProvider {
  static var previews: some View {
    History(
      viewModel: .init(container: .preview)
    )
  }
}
