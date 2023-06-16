import Foundation

extension UserDefaults {
  subscript<T>(key: String) -> T? {
    get { value(forKey: key) as? T }
    set { set(newValue, forKey: key) }
  }

  subscript<T: RawRepresentable>(key: String) -> T? {
    get {
      guard let rawValue = value(forKey: key) as? T.RawValue else { return nil }

      return T(rawValue: rawValue)
    }
    set { self[key] = newValue?.rawValue }
  }

  subscript<T: JSONCodable>(key: String) -> T? {
    get {
      guard let rawValue = string(forKey: key),
            let value = rawValue.decodeTo(clazz: T.self)
      else {
        return nil
      }

      return value
    }
    set {
      set(newValue?.toJSON(), forKey: key)
    }
  }
}
