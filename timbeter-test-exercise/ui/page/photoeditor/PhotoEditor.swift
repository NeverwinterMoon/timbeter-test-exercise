import SwiftUI

struct PhotoEditor: View {
  @ObservedObject private(set) var viewModel: ViewModel

  var body: some View {
    content
      .alert("Reset previous line?", isPresented: $viewModel.showResetAlert, actions: resetAlertButtons)
      .sheet(isPresented: $viewModel.showAddDescriptionSheet, content: descriptionSheetView)
  }

  private var content: some View {
    ZStack {
      viewModel.photoData.photo
        .resizable()
        .scaledToFit()
    }
      .overlay(instructionsOverlay)
      .overlay(drawingOverlay)
      .overlay(currentMeasurementOverlay)
      .overlay(measurementDataOverlay)
      .overlay(dragGestureOverlay)
      .onTapGesture(perform: viewModel.handleTapOnCanvasGesture)
      .overlay(buttonsOverlay)
  }
}

// MARK: - Content

private extension PhotoEditor {
  func descriptionSheetView() -> some View {
    VStack(spacing: 0.0) {
      HStack {
        ZStack(alignment: .leading) {
          Button("Skip", action: viewModel.closeAddDescriptionSheet)

          HStack {
            Spacer()

            Text("Measurement description")

            Spacer()
          }
        }
      }
        .padding()

      Form {
        TextField("Description", text: $viewModel.description)
          .onSubmit(viewModel.saveDescription)
      }
    }
    
      .interactiveDismissDisabled()
  }

  @ViewBuilder func resetAlertButtons() -> some View {
    Button("Reset", role: .destructive, action: viewModel.resetLine)

    Button("Cancel", role: .cancel, action: {})
  }

  @ViewBuilder var instructionsOverlay: some View {
    if !viewModel.logMeasurement.hasSufficientData,
       let measurementName = viewModel.measurementType?.localizedStringKey {
      VStack {
        Spacer()

        HStack {
          Text("Measure log \(Text(measurementName))")
            .foregroundColor(.black)
            .bold()
            .padding(8.0)
            .background(Color.yellow.opacity(0.2))
            .cornerRadius(8.0)

          Spacer()
        }
      }
    }
  }

  var dragGestureOverlay: some View {
    GeometryReader { proxy in
      Color.clear
        .contentShape(Rectangle())
        .gesture(dragGesture(proxy.frame(in: .local)))
        .disabled(viewModel.logMeasurement.length != nil && viewModel.logMeasurement.diameter != nil)
    }
  }

  @ViewBuilder var drawingOverlay: some View {
    if let startPoint = viewModel.startPoint,
       let endPoint = viewModel.endPoint {
      LineShape(
        startPoint: startPoint,
        endPoint: endPoint
      )
        .stroke(lineWidth: 5)
        .foregroundColor(.blue)
    }
  }

  @ViewBuilder var currentMeasurementOverlay: some View {
    viewModel.currentMeasurementCm.map { valueCm in
      VStack {
        HStack {
          Spacer()

          Text("\(valueCm.toCmFormat) cm")

          Spacer()
        }
          .foregroundColor(Color.white)
          .padding(8.0)
          .background(Color.blue.opacity(0.2))

        Spacer()
      }
    }
  }

  @ViewBuilder var measurementDataOverlay: some View {
    if viewModel.showMeasurementDataOverlay {
      ZStack(alignment: .trailing) {
        Color.clear

        VStack(alignment: .trailing) {
          Text("Current measurements")

          viewModel.logMeasurement.length.map {
            Text("Length: \(Text($0.toCmFormat).bold()) cm")
          }

          viewModel.logMeasurement.diameter.map {
            Text("Diameter: \(Text($0.toCmFormat).bold()) cm")
          }

          if viewModel.showDescription {
            Text("Description: \(viewModel.logMeasurement.description ?? "no description")")
          }
        }
          .foregroundColor(.white)
          .padding(8.0)
          .background(Color.blue.opacity(0.3))
          .cornerRadius(8.0)
      }
    }
  }

  func textRow(_ value: Text) -> some View {
    HStack {
      Spacer()

      value
    }
  }

  @ViewBuilder var buttonsOverlay: some View {
    VStack {
      Spacer()

      viewModel.nextMeasurement.map { measurementType in
        HStack {
          Spacer()

          progressButton(measurementType)
            .foregroundColor(.black)
            .padding(.horizontal, 16.0)
            .padding(.vertical, 8.0)
            .background(Color.green)
            .cornerRadius(16.0)
        }
      }

      if viewModel.showSaveAndResetButtons {
        HStack {
          resetAllButton

          Spacer()

          saveButton
        }
      }
    }
      .padding(8.0)
  }

  @ViewBuilder func progressButton(_ measurementType: MeasurementType) -> some View {
    switch measurementType {
      case .length:
        Button("Measure diameter", action: viewModel.measureDiameterButtonAction)

      case .diameter:
        Button("Add description", action: viewModel.addDescriptionButtonAction)
    }
  }

  var saveButton: some View {
    Button(action: viewModel.saveMeasurement) {
      HStack {
        Text(viewModel.saveButtonText)

        if viewModel.isSaveInProgress {
          ProgressView()
            .progressViewStyle(.circular)
        }
      }
    }
      .disabled(viewModel.isSaveButtonDisabled)
      .foregroundColor(.black)
      .padding(.horizontal, 16.0)
      .padding(.vertical, 8.0)
      .background(Color.green)
      .cornerRadius(16.0)
  }

  var resetAllButton: some View {
    Button("Reset current measurements", action: viewModel.resetMeasurement)
      .foregroundColor(.black)
      .padding(.horizontal, 16.0)
      .padding(.vertical, 8.0)
      .background(Color.green)
      .cornerRadius(16.0)
  }

  func dragGesture(_ canvas: CGRect) -> some Gesture {
    DragGesture()
      .onChanged { value in
        viewModel.handleDragGestureChanged(value: value, canvas: canvas)
      }
  }
}

// MARK: - Previews

struct PhotoEditor_Previews: PreviewProvider {
  static var previews: some View {
    PhotoEditor(viewModel: .init(
      container: .preview,
      photoData: .init(photo: Image("log"), photoIdentifier: "")
    ))
  }
}
