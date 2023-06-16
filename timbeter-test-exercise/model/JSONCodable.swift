import Foundation

protocol JSONCodable: Codable {
}

extension Array: JSONCodable where Element: JSONCodable {
}
