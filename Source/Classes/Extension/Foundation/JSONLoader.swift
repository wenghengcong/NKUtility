//
//  File.swift
//  NKUtility
//
//  Created by Nemo on 2022/11/17.
//

import Foundation


/// JSON loader
public class JSONLoader {
    /// load json file to object model
    /// Usage:
    ///     let employee1 = JSONLoader.load("employee.json", Employee.self)
    ///     let employee2: Employee = JSONLoader.load("employee.json")
    /// - Parameters:
    ///   - file: file name
    ///   - type: convert model type
    /// - Returns: model
    /// - Issue: 如果发现资源加载不成功，看看资源是否在Copy Bundle Resource中添加
   public static func load<T: Decodable>(file: String, type: T.Type) -> T {
        guard let file = Bundle.main.url(forResource: file, withExtension: "json") else {
            fatalError("Couldn't find \(file) in main bundle.")
        }
        let data: Data
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(file) from main bundle:\n\(error)")
        }
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            fatalError("Couldn't parse \(file) as \(T.self):\n\(error)")
        }
    }
    
    public static func load<T: Decodable>(file: String) -> T {
        load(file: file, type: T.self)
    }
}
