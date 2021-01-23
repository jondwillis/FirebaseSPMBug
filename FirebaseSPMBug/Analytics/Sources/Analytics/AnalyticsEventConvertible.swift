//
//  AnalyticsEventConvertible.swift
//  FirebaseCore
//
//  Created by Jonathan Willis on 8/5/18.
//

import Foundation

public enum AnalyticsEventConvertibleError: LocalizedError {
    case analyticsEventValueTypeIsNotString
    
    public var errorDescription: String? {
        switch self {
        case .analyticsEventValueTypeIsNotString: return "Analytics Event value is not a string"
        }
    }
}

public protocol AnalyticsEventConvertible {
    var name: String { get }
    func properties() throws -> [String: String]?
}

public extension AnalyticsEventConvertible {
    // this provides a default implementation that generates properties from the fields of
    // a structure or class that conforms to AnalyticsEventConvertible
    // if there are none, it will return nil
    // if a value cannot be converted into a string, it will throw
    // AnalyticsEventConvertibleError.analyticsEventValueTypeIsNotString
    func properties() throws -> [String: String]? {

        let mirror = Mirror(reflecting: self)

        let properties: [String: String] = try mirror.children
            .compactMap { label, value -> (label: String, value: String?)? in

                func castToOptional<T>(_ any: Any) -> T? {
                    return any as? T
                }

                let optionalValue: Any? = castToOptional(value)
                guard let notNilLabel = label, optionalValue != nil else {
                    return nil
                }

                let snakeCaseLabel = notNilLabel.camelCaseToSnakeCase()

                if let stringValue = value as? String ?? (value as? CustomStringConvertible)?.description {
                    return (label: snakeCaseLabel, value: stringValue)
                }

                if let nonOptionalValue = optionalValue {
                    let stringValue = String(describing: nonOptionalValue)
                    return (label: snakeCaseLabel, value: stringValue)
                }

                throw AnalyticsEventConvertibleError.analyticsEventValueTypeIsNotString
            }
            .filter { $0.label != "name" && $0.label != "properties" }
            .reduce(into: [:] as [String: String]) { (result, next) in
                result[next.label] = next.value
            }

        return properties.isEmpty ? nil : properties
    }
}

fileprivate extension String {
    func camelCaseToSnakeCase() -> String {
        let acronymPattern = "([A-Z]+)([A-Z][a-z]|[0-9])"
        let normalPattern = "([a-z0-9])([A-Z])"
        return self.processCamalCaseRegex(pattern: acronymPattern)?
            .processCamalCaseRegex(pattern: normalPattern)?.lowercased() ?? self.lowercased()
    }

    private func processCamalCaseRegex(pattern: String) -> String? {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2")
    }
}
