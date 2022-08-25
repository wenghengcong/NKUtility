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

    var strings: [String] {
        let strs = split(separator: 0).flatMap { String(bytes: $0, encoding: .utf8) }
        return strs
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

    func strings(encoding: String.Encoding) -> [String] {
        let strs = split(separator: 0).flatMap { String(bytes: $0, encoding: encoding) }
        return strs
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
    
    static func jsonObject(options: JSONSerialization.ReadingOptions = [], from file: String) throws -> Any? {
        guard let data = readFile(file) else {
            return nil
        }
        if let object = try? JSONSerialization.jsonObject(with: data, options: options) {
            return object
        }
        return nil
    }
    
    /// 读取 本地 文件
    static func readFile(_ name: String, ofType type: String = ".json", fromBundle bundle: Bundle = .main, encoding: String.Encoding = .utf8, error: NSErrorPointer = nil) -> Data? {
        do {
            if let bundlePath = bundle.path(forResource: name, ofType: type),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: encoding) {
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    /// 获取 json decode 类型对象
    static func jsonsObject<T: Codable>(of type: T.Type, from file: String) -> T?  {
        guard let data = readFile(file) else {
            return nil
        }
        if let object = try? JSONDecoder().decode(type, from: data) {
            return object
        }
        return nil
    }
}

#endif
