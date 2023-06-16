import Foundation

extension String {
  func decodeTo<T: Decodable>(clazz: T.Type) -> T? {
    Data(self.utf8).decodeTo(clazz: clazz)
  }
}
