import SwiftUI

struct MeasurementDataView: View {
  let value: LogMeasurement

  var body: some View {
    content
  }

  private var content: some View {
    ZStack(alignment: .bottomTrailing) {
      Color.clear

      VStack(alignment: .trailing) {
        HStack {
          Spacer()
        }
        
        Text("Length: \(Text(value.length.toCmFormat).bold()) cm")

        Text("Diameter: \(Text(value.diameter.toCmFormat).bold()) cm")

        Text("Description: \(value.description)")
          .multilineTextAlignment(.trailing)
      }
        .foregroundColor(.white)
        .background(Color.blue.opacity(0.4))
    }
  }
}

// MARK: - Previews

struct MeasurementDataView_Previews: PreviewProvider {
  static var previews: some View {
    Image("log")
      .resizable()
      .scaledToFit()
      .overlay(MeasurementDataView(value: .preview01))
  }
}
