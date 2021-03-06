// DataExtensions.swift - Copyright 2020 SwifterSwift

#if canImport(Foundation)
import Foundation

// MARK: - Properties

public extension Data {
    /// SwifterSwift: Return data as an array of bytes.
    var bytes: [UInt8] {
        // http://stackoverflow.com/questions/38097710/swift-3-changes-for-getbytes-method
        return [UInt8](self)
    }
    
    
    var prettyJSON: String {
        let jsonString = (try? String(data: JSONSerialization.data(withJSONObject: JSONSerialization.jsonObject(with: self, options: []), options: .prettyPrinted), encoding: .utf8)!) ?? ""
        return jsonString
    }
}

// MARK: - Methods

public extension Data {
    /// SwifterSwift: String by encoding Data using the given encoding (if applicable).
    ///
    /// - Parameter encoding: encoding.
    /// - Returns: String by encoding Data using the given encoding (if applicable).
    func string(encoding: String.Encoding) -> String? {
        return String(data: self, encoding: encoding)
    }

    /// SwifterSwift: Returns a Foundation object from given JSON data.
    ///
    /// - Parameter options: Options for reading the JSON data and creating the Foundation object.
    ///
    ///   For possible values, see `JSONSerialization.ReadingOptions`.
    /// - Returns: A Foundation object from the JSON data in the receiver, or `nil` if an error occurs.
    /// - Throws: An `NSError` if the receiver does not represent a valid JSON object.
    func jsonObject(options: JSONSerialization.ReadingOptions = []) throws -> Any {
        return try JSONSerialization.jsonObject(with: self, options: options)
    }
}

#endif
