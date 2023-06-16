import Foundation

extension Data {
  func decodeTo<T: Decodable>(clazz: T.Type) -> T? {
    let decoder: JSONDecoder = {
      let decoder = JSONDecoder()

      return decoder
    }()

    let output: T?
    do {
      output = try decoder.decode(clazz, from: self)
    } catch {
      output = nil
    }

    return output
  }
}
