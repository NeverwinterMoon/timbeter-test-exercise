import Foundation

enum Loadable<T> {
  case notRequested

  case isLoading

  case loaded(T)

  case failed(Error)

  var value: T? {
    switch self {
      case .loaded(let value):
        return value

      default:
        return nil
    }
  }

  var error: Error? {
    switch self {
      case let .failed(error):
        return error

      default:
        return nil
    }
  }
}
