import Foundation

extension Encodable {
  func toJSON() -> String? {
    let encoder: JSONEncoder = {
      let encoder = JSONEncoder()
#if DEBUG
      encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
#endif

      return encoder
    }()

    let json: String?
    if let data = try? encoder.encode(self) {
      json = String(data: data, encoding: .utf8)
    } else {
      json = nil
    }
























    






















    return json
  }
}
