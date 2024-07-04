//  This file was automatically generated and should not be edited.

#if canImport(AWSAPIPlugin)
import Foundation

public protocol GraphQLInputValue {
}

public struct GraphQLVariable {
  let name: String
  
  public init(_ name: String) {
    self.name = name
  }
}

extension GraphQLVariable: GraphQLInputValue {
}

extension JSONEncodable {
  public func evaluate(with variables: [String: JSONEncodable]?) throws -> Any {
    return jsonValue
  }
}

public typealias GraphQLMap = [String: JSONEncodable?]

extension Dictionary where Key == String, Value == JSONEncodable? {
  public var withNilValuesRemoved: Dictionary<String, JSONEncodable> {
    var filtered = Dictionary<String, JSONEncodable>(minimumCapacity: count)
    for (key, value) in self {
      if value != nil {
        filtered[key] = value
      }
    }
    return filtered
  }
}

public protocol GraphQLMapConvertible: JSONEncodable {
  var graphQLMap: GraphQLMap { get }
}

public extension GraphQLMapConvertible {
  var jsonValue: Any {
    return graphQLMap.withNilValuesRemoved.jsonValue
  }
}

public typealias GraphQLID = String

public protocol APISwiftGraphQLOperation: AnyObject {
  
  static var operationString: String { get }
  static var requestString: String { get }
  static var operationIdentifier: String? { get }
  
  var variables: GraphQLMap? { get }
  
  associatedtype Data: GraphQLSelectionSet
}

public extension APISwiftGraphQLOperation {
  static var requestString: String {
    return operationString
  }

  static var operationIdentifier: String? {
    return nil
  }

  var variables: GraphQLMap? {
    return nil
  }
}

public protocol GraphQLQuery: APISwiftGraphQLOperation {}

public protocol GraphQLMutation: APISwiftGraphQLOperation {}

public protocol GraphQLSubscription: APISwiftGraphQLOperation {}

public protocol GraphQLFragment: GraphQLSelectionSet {
  static var possibleTypes: [String] { get }
}

public typealias Snapshot = [String: Any?]

public protocol GraphQLSelectionSet: Decodable {
  static var selections: [GraphQLSelection] { get }
  
  var snapshot: Snapshot { get }
  init(snapshot: Snapshot)
}

extension GraphQLSelectionSet {
    public init(from decoder: Decoder) throws {
        if let jsonObject = try? APISwiftJSONValue(from: decoder) {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(jsonObject)
            let decodedDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
            let optionalDictionary = decodedDictionary.mapValues { $0 as Any? }

            self.init(snapshot: optionalDictionary)
        } else {
            self.init(snapshot: [:])
        }
    }
}

enum APISwiftJSONValue: Codable {
    case array([APISwiftJSONValue])
    case boolean(Bool)
    case number(Double)
    case object([String: APISwiftJSONValue])
    case string(String)
    case null
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode([String: APISwiftJSONValue].self) {
            self = .object(value)
        } else if let value = try? container.decode([APISwiftJSONValue].self) {
            self = .array(value)
        } else if let value = try? container.decode(Double.self) {
            self = .number(value)
        } else if let value = try? container.decode(Bool.self) {
            self = .boolean(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else {
            self = .null
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .array(let value):
            try container.encode(value)
        case .boolean(let value):
            try container.encode(value)
        case .number(let value):
            try container.encode(value)
        case .object(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        case .null:
            try container.encodeNil()
        }
    }
}

public protocol GraphQLSelection {
}

public struct GraphQLField: GraphQLSelection {
  let name: String
  let alias: String?
  let arguments: [String: GraphQLInputValue]?
  
  var responseKey: String {
    return alias ?? name
  }
  
  let type: GraphQLOutputType
  
  public init(_ name: String, alias: String? = nil, arguments: [String: GraphQLInputValue]? = nil, type: GraphQLOutputType) {
    self.name = name
    self.alias = alias
    
    self.arguments = arguments
    
    self.type = type
  }
}

public indirect enum GraphQLOutputType {
  case scalar(JSONDecodable.Type)
  case object([GraphQLSelection])
  case nonNull(GraphQLOutputType)
  case list(GraphQLOutputType)
  
  var namedType: GraphQLOutputType {
    switch self {
    case .nonNull(let innerType), .list(let innerType):
      return innerType.namedType
    case .scalar, .object:
      return self
    }
  }
}

public struct GraphQLBooleanCondition: GraphQLSelection {
  let variableName: String
  let inverted: Bool
  let selections: [GraphQLSelection]
  
  public init(variableName: String, inverted: Bool, selections: [GraphQLSelection]) {
    self.variableName = variableName
    self.inverted = inverted;
    self.selections = selections;
  }
}

public struct GraphQLTypeCondition: GraphQLSelection {
  let possibleTypes: [String]
  let selections: [GraphQLSelection]
  
  public init(possibleTypes: [String], selections: [GraphQLSelection]) {
    self.possibleTypes = possibleTypes
    self.selections = selections;
  }
}

public struct GraphQLFragmentSpread: GraphQLSelection {
  let fragment: GraphQLFragment.Type
  
  public init(_ fragment: GraphQLFragment.Type) {
    self.fragment = fragment
  }
}

public struct GraphQLTypeCase: GraphQLSelection {
  let variants: [String: [GraphQLSelection]]
  let `default`: [GraphQLSelection]
  
  public init(variants: [String: [GraphQLSelection]], default: [GraphQLSelection]) {
    self.variants = variants
    self.default = `default`;
  }
}

public typealias JSONObject = [String: Any]

public protocol JSONDecodable {
  init(jsonValue value: Any) throws
}

public protocol JSONEncodable: GraphQLInputValue {
  var jsonValue: Any { get }
}

public enum JSONDecodingError: Error, LocalizedError {
  case missingValue
  case nullValue
  case wrongType
  case couldNotConvert(value: Any, to: Any.Type)
  
  public var errorDescription: String? {
    switch self {
    case .missingValue:
      return "Missing value"
    case .nullValue:
      return "Unexpected null value"
    case .wrongType:
      return "Wrong type"
    case .couldNotConvert(let value, let expectedType):
      return "Could not convert \"\(value)\" to \(expectedType)"
    }
  }
}

extension String: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let string = value as? String else {
      throw JSONDecodingError.couldNotConvert(value: value, to: String.self)
    }
    self = string
  }

  public var jsonValue: Any {
    return self
  }
}

extension Int: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let number = value as? NSNumber else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Int.self)
    }
    self = number.intValue
  }

  public var jsonValue: Any {
    return self
  }
}

extension Float: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let number = value as? NSNumber else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Float.self)
    }
    self = number.floatValue
  }

  public var jsonValue: Any {
    return self
  }
}

extension Double: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let number = value as? NSNumber else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Double.self)
    }
    self = number.doubleValue
  }

  public var jsonValue: Any {
    return self
  }
}

extension Bool: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let bool = value as? Bool else {
        throw JSONDecodingError.couldNotConvert(value: value, to: Bool.self)
    }
    self = bool
  }

  public var jsonValue: Any {
    return self
  }
}

extension RawRepresentable where RawValue: JSONDecodable {
  public init(jsonValue value: Any) throws {
    let rawValue = try RawValue(jsonValue: value)
    if let tempSelf = Self(rawValue: rawValue) {
      self = tempSelf
    } else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Self.self)
    }
  }
}

extension RawRepresentable where RawValue: JSONEncodable {
  public var jsonValue: Any {
    return rawValue.jsonValue
  }
}

extension Optional where Wrapped: JSONDecodable {
  public init(jsonValue value: Any) throws {
    if value is NSNull {
      self = .none
    } else {
      self = .some(try Wrapped(jsonValue: value))
    }
  }
}

extension Optional: JSONEncodable {
  public var jsonValue: Any {
    switch self {
    case .none:
      return NSNull()
    case .some(let wrapped as JSONEncodable):
      return wrapped.jsonValue
    default:
      fatalError("Optional is only JSONEncodable if Wrapped is")
    }
  }
}

extension Dictionary: JSONEncodable {
  public var jsonValue: Any {
    return jsonObject
  }
  
  public var jsonObject: JSONObject {
    var jsonObject = JSONObject(minimumCapacity: count)
    for (key, value) in self {
      if case let (key as String, value as JSONEncodable) = (key, value) {
        jsonObject[key] = value.jsonValue
      } else {
        fatalError("Dictionary is only JSONEncodable if Value is (and if Key is String)")
      }
    }
    return jsonObject
  }
}

extension Array: JSONEncodable {
  public var jsonValue: Any {
    return map() { element -> (Any) in
      if case let element as JSONEncodable = element {
        return element.jsonValue
      } else {
        fatalError("Array is only JSONEncodable if Element is")
      }
    }
  }
}

extension URL: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let string = value as? String else {
      throw JSONDecodingError.couldNotConvert(value: value, to: URL.self)
    }
    self.init(string: string)!
  }

  public var jsonValue: Any {
    return self.absoluteString
  }
}

extension Dictionary {
  static func += (lhs: inout Dictionary, rhs: Dictionary) {
    lhs.merge(rhs) { (_, new) in new }
  }
}

#elseif canImport(AWSAppSync)
import AWSAppSync
#endif

public struct CreateGoalInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, description: String, targetDate: String, reason: String? = nil, dailyLimit: Int? = nil, reward: String? = nil, createdAt: String? = nil, updatedAt: String? = nil) {
    graphQLMap = ["id": id, "description": description, "targetDate": targetDate, "reason": reason, "dailyLimit": dailyLimit, "reward": reward, "createdAt": createdAt, "updatedAt": updatedAt]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var description: String {
    get {
      return graphQLMap["description"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "description")
    }
  }

  public var targetDate: String {
    get {
      return graphQLMap["targetDate"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "targetDate")
    }
  }

  public var reason: String? {
    get {
      return graphQLMap["reason"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "reason")
    }
  }

  public var dailyLimit: Int? {
    get {
      return graphQLMap["dailyLimit"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dailyLimit")
    }
  }

  public var reward: String? {
    get {
      return graphQLMap["reward"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "reward")
    }
  }

  public var createdAt: String? {
    get {
      return graphQLMap["createdAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: String? {
    get {
      return graphQLMap["updatedAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }
}

public struct ModelGoalConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(description: ModelStringInput? = nil, targetDate: ModelStringInput? = nil, reason: ModelStringInput? = nil, dailyLimit: ModelIntInput? = nil, reward: ModelStringInput? = nil, createdAt: ModelStringInput? = nil, updatedAt: ModelStringInput? = nil, and: [ModelGoalConditionInput?]? = nil, or: [ModelGoalConditionInput?]? = nil, not: ModelGoalConditionInput? = nil) {
    graphQLMap = ["description": description, "targetDate": targetDate, "reason": reason, "dailyLimit": dailyLimit, "reward": reward, "createdAt": createdAt, "updatedAt": updatedAt, "and": and, "or": or, "not": not]
  }

  public var description: ModelStringInput? {
    get {
      return graphQLMap["description"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "description")
    }
  }

  public var targetDate: ModelStringInput? {
    get {
      return graphQLMap["targetDate"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "targetDate")
    }
  }

  public var reason: ModelStringInput? {
    get {
      return graphQLMap["reason"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "reason")
    }
  }

  public var dailyLimit: ModelIntInput? {
    get {
      return graphQLMap["dailyLimit"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dailyLimit")
    }
  }

  public var reward: ModelStringInput? {
    get {
      return graphQLMap["reward"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "reward")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var and: [ModelGoalConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelGoalConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelGoalConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelGoalConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelGoalConditionInput? {
    get {
      return graphQLMap["not"] as! ModelGoalConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelStringInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: String? = nil, eq: String? = nil, le: String? = nil, lt: String? = nil, ge: String? = nil, gt: String? = nil, contains: String? = nil, notContains: String? = nil, between: [String?]? = nil, beginsWith: String? = nil, attributeExists: Bool? = nil, attributeType: ModelAttributeTypes? = nil, size: ModelSizeInput? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "attributeExists": attributeExists, "attributeType": attributeType, "size": size]
  }

  public var ne: String? {
    get {
      return graphQLMap["ne"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: String? {
    get {
      return graphQLMap["eq"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: String? {
    get {
      return graphQLMap["le"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: String? {
    get {
      return graphQLMap["lt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: String? {
    get {
      return graphQLMap["ge"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: String? {
    get {
      return graphQLMap["gt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: String? {
    get {
      return graphQLMap["contains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: String? {
    get {
      return graphQLMap["notContains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [String?]? {
    get {
      return graphQLMap["between"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: String? {
    get {
      return graphQLMap["beginsWith"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var attributeExists: Bool? {
    get {
      return graphQLMap["attributeExists"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeExists")
    }
  }

  public var attributeType: ModelAttributeTypes? {
    get {
      return graphQLMap["attributeType"] as! ModelAttributeTypes?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeType")
    }
  }

  public var size: ModelSizeInput? {
    get {
      return graphQLMap["size"] as! ModelSizeInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "size")
    }
  }
}

public enum ModelAttributeTypes: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  public typealias RawValue = String
  case binary
  case binarySet
  case bool
  case list
  case map
  case number
  case numberSet
  case string
  case stringSet
  case null
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "binary": self = .binary
      case "binarySet": self = .binarySet
      case "bool": self = .bool
      case "list": self = .list
      case "map": self = .map
      case "number": self = .number
      case "numberSet": self = .numberSet
      case "string": self = .string
      case "stringSet": self = .stringSet
      case "_null": self = .null
      default: self = .unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .binary: return "binary"
      case .binarySet: return "binarySet"
      case .bool: return "bool"
      case .list: return "list"
      case .map: return "map"
      case .number: return "number"
      case .numberSet: return "numberSet"
      case .string: return "string"
      case .stringSet: return "stringSet"
      case .null: return "_null"
      case .unknown(let value): return value
    }
  }

  public static func == (lhs: ModelAttributeTypes, rhs: ModelAttributeTypes) -> Bool {
    switch (lhs, rhs) {
      case (.binary, .binary): return true
      case (.binarySet, .binarySet): return true
      case (.bool, .bool): return true
      case (.list, .list): return true
      case (.map, .map): return true
      case (.number, .number): return true
      case (.numberSet, .numberSet): return true
      case (.string, .string): return true
      case (.stringSet, .stringSet): return true
      case (.null, .null): return true
      case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

public struct ModelSizeInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Int? = nil, eq: Int? = nil, le: Int? = nil, lt: Int? = nil, ge: Int? = nil, gt: Int? = nil, between: [Int?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "between": between]
  }

  public var ne: Int? {
    get {
      return graphQLMap["ne"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Int? {
    get {
      return graphQLMap["eq"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: Int? {
    get {
      return graphQLMap["le"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: Int? {
    get {
      return graphQLMap["lt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: Int? {
    get {
      return graphQLMap["ge"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: Int? {
    get {
      return graphQLMap["gt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var between: [Int?]? {
    get {
      return graphQLMap["between"] as! [Int?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }
}

public struct ModelIntInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Int? = nil, eq: Int? = nil, le: Int? = nil, lt: Int? = nil, ge: Int? = nil, gt: Int? = nil, between: [Int?]? = nil, attributeExists: Bool? = nil, attributeType: ModelAttributeTypes? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "between": between, "attributeExists": attributeExists, "attributeType": attributeType]
  }

  public var ne: Int? {
    get {
      return graphQLMap["ne"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Int? {
    get {
      return graphQLMap["eq"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: Int? {
    get {
      return graphQLMap["le"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: Int? {
    get {
      return graphQLMap["lt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: Int? {
    get {
      return graphQLMap["ge"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: Int? {
    get {
      return graphQLMap["gt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var between: [Int?]? {
    get {
      return graphQLMap["between"] as! [Int?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var attributeExists: Bool? {
    get {
      return graphQLMap["attributeExists"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeExists")
    }
  }

  public var attributeType: ModelAttributeTypes? {
    get {
      return graphQLMap["attributeType"] as! ModelAttributeTypes?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeType")
    }
  }
}

public struct UpdateGoalInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, description: String? = nil, targetDate: String? = nil, reason: String? = nil, dailyLimit: Int? = nil, reward: String? = nil, createdAt: String? = nil, updatedAt: String? = nil) {
    graphQLMap = ["id": id, "description": description, "targetDate": targetDate, "reason": reason, "dailyLimit": dailyLimit, "reward": reward, "createdAt": createdAt, "updatedAt": updatedAt]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var description: String? {
    get {
      return graphQLMap["description"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "description")
    }
  }

  public var targetDate: String? {
    get {
      return graphQLMap["targetDate"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "targetDate")
    }
  }

  public var reason: String? {
    get {
      return graphQLMap["reason"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "reason")
    }
  }

  public var dailyLimit: Int? {
    get {
      return graphQLMap["dailyLimit"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dailyLimit")
    }
  }

  public var reward: String? {
    get {
      return graphQLMap["reward"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "reward")
    }
  }

  public var createdAt: String? {
    get {
      return graphQLMap["createdAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: String? {
    get {
      return graphQLMap["updatedAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }
}

public struct DeleteGoalInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateDrinkRecordInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, details: String, amount: Int, content: String, feeling: String, location: String? = nil, createdAt: String? = nil, updatedAt: String? = nil, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
    graphQLMap = ["id": id, "details": details, "amount": amount, "content": content, "feeling": feeling, "location": location, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var details: String {
    get {
      return graphQLMap["details"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "details")
    }
  }

  public var amount: Int {
    get {
      return graphQLMap["amount"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "amount")
    }
  }

  public var content: String {
    get {
      return graphQLMap["content"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }

  public var feeling: String {
    get {
      return graphQLMap["feeling"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "feeling")
    }
  }

  public var location: String? {
    get {
      return graphQLMap["location"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "location")
    }
  }

  public var createdAt: String? {
    get {
      return graphQLMap["createdAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: String? {
    get {
      return graphQLMap["updatedAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: Int {
    get {
      return graphQLMap["_version"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: Bool? {
    get {
      return graphQLMap["_deleted"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: Int {
    get {
      return graphQLMap["_lastChangedAt"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }
}

public struct ModelDrinkRecordConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(details: ModelStringInput? = nil, amount: ModelIntInput? = nil, content: ModelStringInput? = nil, feeling: ModelStringInput? = nil, location: ModelStringInput? = nil, createdAt: ModelStringInput? = nil, updatedAt: ModelStringInput? = nil, version: ModelIntInput? = nil, deleted: ModelBooleanInput? = nil, lastChangedAt: ModelIntInput? = nil, and: [ModelDrinkRecordConditionInput?]? = nil, or: [ModelDrinkRecordConditionInput?]? = nil, not: ModelDrinkRecordConditionInput? = nil) {
    graphQLMap = ["details": details, "amount": amount, "content": content, "feeling": feeling, "location": location, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "and": and, "or": or, "not": not]
  }

  public var details: ModelStringInput? {
    get {
      return graphQLMap["details"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "details")
    }
  }

  public var amount: ModelIntInput? {
    get {
      return graphQLMap["amount"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "amount")
    }
  }

  public var content: ModelStringInput? {
    get {
      return graphQLMap["content"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }

  public var feeling: ModelStringInput? {
    get {
      return graphQLMap["feeling"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "feeling")
    }
  }

  public var location: ModelStringInput? {
    get {
      return graphQLMap["location"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "location")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: ModelIntInput? {
    get {
      return graphQLMap["_version"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: ModelIntInput? {
    get {
      return graphQLMap["_lastChangedAt"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }

  public var and: [ModelDrinkRecordConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelDrinkRecordConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelDrinkRecordConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelDrinkRecordConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelDrinkRecordConditionInput? {
    get {
      return graphQLMap["not"] as! ModelDrinkRecordConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelBooleanInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Bool? = nil, eq: Bool? = nil, attributeExists: Bool? = nil, attributeType: ModelAttributeTypes? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "attributeExists": attributeExists, "attributeType": attributeType]
  }

  public var ne: Bool? {
    get {
      return graphQLMap["ne"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Bool? {
    get {
      return graphQLMap["eq"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var attributeExists: Bool? {
    get {
      return graphQLMap["attributeExists"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeExists")
    }
  }

  public var attributeType: ModelAttributeTypes? {
    get {
      return graphQLMap["attributeType"] as! ModelAttributeTypes?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeType")
    }
  }
}

public struct UpdateDrinkRecordInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, details: String? = nil, amount: Int? = nil, content: String? = nil, feeling: String? = nil, location: String? = nil, createdAt: String? = nil, updatedAt: String? = nil, version: Int? = nil, deleted: Bool? = nil, lastChangedAt: Int? = nil) {
    graphQLMap = ["id": id, "details": details, "amount": amount, "content": content, "feeling": feeling, "location": location, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var details: String? {
    get {
      return graphQLMap["details"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "details")
    }
  }

  public var amount: Int? {
    get {
      return graphQLMap["amount"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "amount")
    }
  }

  public var content: String? {
    get {
      return graphQLMap["content"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }

  public var feeling: String? {
    get {
      return graphQLMap["feeling"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "feeling")
    }
  }

  public var location: String? {
    get {
      return graphQLMap["location"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "location")
    }
  }

  public var createdAt: String? {
    get {
      return graphQLMap["createdAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: String? {
    get {
      return graphQLMap["updatedAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: Bool? {
    get {
      return graphQLMap["_deleted"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: Int? {
    get {
      return graphQLMap["_lastChangedAt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }
}

public struct DeleteDrinkRecordInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateDiaryEntryInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, content: String, feeling: String, date: String, createdAt: String? = nil, updatedAt: String? = nil, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
    graphQLMap = ["id": id, "content": content, "feeling": feeling, "date": date, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var content: String {
    get {
      return graphQLMap["content"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }

  public var feeling: String {
    get {
      return graphQLMap["feeling"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "feeling")
    }
  }

  public var date: String {
    get {
      return graphQLMap["date"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "date")
    }
  }

  public var createdAt: String? {
    get {
      return graphQLMap["createdAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: String? {
    get {
      return graphQLMap["updatedAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: Int {
    get {
      return graphQLMap["_version"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: Bool? {
    get {
      return graphQLMap["_deleted"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: Int {
    get {
      return graphQLMap["_lastChangedAt"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }
}

public struct ModelDiaryEntryConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(content: ModelStringInput? = nil, feeling: ModelStringInput? = nil, date: ModelStringInput? = nil, createdAt: ModelStringInput? = nil, updatedAt: ModelStringInput? = nil, version: ModelIntInput? = nil, deleted: ModelBooleanInput? = nil, lastChangedAt: ModelIntInput? = nil, and: [ModelDiaryEntryConditionInput?]? = nil, or: [ModelDiaryEntryConditionInput?]? = nil, not: ModelDiaryEntryConditionInput? = nil) {
    graphQLMap = ["content": content, "feeling": feeling, "date": date, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "and": and, "or": or, "not": not]
  }

  public var content: ModelStringInput? {
    get {
      return graphQLMap["content"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }

  public var feeling: ModelStringInput? {
    get {
      return graphQLMap["feeling"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "feeling")
    }
  }

  public var date: ModelStringInput? {
    get {
      return graphQLMap["date"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "date")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: ModelIntInput? {
    get {
      return graphQLMap["_version"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: ModelIntInput? {
    get {
      return graphQLMap["_lastChangedAt"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }

  public var and: [ModelDiaryEntryConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelDiaryEntryConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelDiaryEntryConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelDiaryEntryConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelDiaryEntryConditionInput? {
    get {
      return graphQLMap["not"] as! ModelDiaryEntryConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct UpdateDiaryEntryInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, content: String? = nil, feeling: String? = nil, date: String? = nil, createdAt: String? = nil, updatedAt: String? = nil, version: Int? = nil, deleted: Bool? = nil, lastChangedAt: Int? = nil) {
    graphQLMap = ["id": id, "content": content, "feeling": feeling, "date": date, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var content: String? {
    get {
      return graphQLMap["content"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }

  public var feeling: String? {
    get {
      return graphQLMap["feeling"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "feeling")
    }
  }

  public var date: String? {
    get {
      return graphQLMap["date"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "date")
    }
  }

  public var createdAt: String? {
    get {
      return graphQLMap["createdAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: String? {
    get {
      return graphQLMap["updatedAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: Bool? {
    get {
      return graphQLMap["_deleted"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: Int? {
    get {
      return graphQLMap["_lastChangedAt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }
}

public struct DeleteDiaryEntryInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateCommunityMessageInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, content: String, sender: String, createdAt: String? = nil, updatedAt: String? = nil, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
    graphQLMap = ["id": id, "content": content, "sender": sender, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var content: String {
    get {
      return graphQLMap["content"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }

  public var sender: String {
    get {
      return graphQLMap["sender"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "sender")
    }
  }

  public var createdAt: String? {
    get {
      return graphQLMap["createdAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: String? {
    get {
      return graphQLMap["updatedAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: Int {
    get {
      return graphQLMap["_version"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: Bool? {
    get {
      return graphQLMap["_deleted"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: Int {
    get {
      return graphQLMap["_lastChangedAt"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }
}

public struct ModelCommunityMessageConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(content: ModelStringInput? = nil, sender: ModelStringInput? = nil, createdAt: ModelStringInput? = nil, updatedAt: ModelStringInput? = nil, version: ModelIntInput? = nil, deleted: ModelBooleanInput? = nil, lastChangedAt: ModelIntInput? = nil, and: [ModelCommunityMessageConditionInput?]? = nil, or: [ModelCommunityMessageConditionInput?]? = nil, not: ModelCommunityMessageConditionInput? = nil) {
    graphQLMap = ["content": content, "sender": sender, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "and": and, "or": or, "not": not]
  }

  public var content: ModelStringInput? {
    get {
      return graphQLMap["content"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }

  public var sender: ModelStringInput? {
    get {
      return graphQLMap["sender"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "sender")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: ModelIntInput? {
    get {
      return graphQLMap["_version"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: ModelIntInput? {
    get {
      return graphQLMap["_lastChangedAt"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }

  public var and: [ModelCommunityMessageConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelCommunityMessageConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelCommunityMessageConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelCommunityMessageConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelCommunityMessageConditionInput? {
    get {
      return graphQLMap["not"] as! ModelCommunityMessageConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct UpdateCommunityMessageInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, content: String? = nil, sender: String? = nil, createdAt: String? = nil, updatedAt: String? = nil, version: Int? = nil, deleted: Bool? = nil, lastChangedAt: Int? = nil) {
    graphQLMap = ["id": id, "content": content, "sender": sender, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var content: String? {
    get {
      return graphQLMap["content"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }

  public var sender: String? {
    get {
      return graphQLMap["sender"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "sender")
    }
  }

  public var createdAt: String? {
    get {
      return graphQLMap["createdAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: String? {
    get {
      return graphQLMap["updatedAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: Bool? {
    get {
      return graphQLMap["_deleted"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: Int? {
    get {
      return graphQLMap["_lastChangedAt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }
}

public struct DeleteCommunityMessageInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateEmergencyContactInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, name: String, phone: String, createdAt: String? = nil, updatedAt: String? = nil, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
    graphQLMap = ["id": id, "name": name, "phone": phone, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String {
    get {
      return graphQLMap["name"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var phone: String {
    get {
      return graphQLMap["phone"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phone")
    }
  }

  public var createdAt: String? {
    get {
      return graphQLMap["createdAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: String? {
    get {
      return graphQLMap["updatedAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: Int {
    get {
      return graphQLMap["_version"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: Bool? {
    get {
      return graphQLMap["_deleted"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: Int {
    get {
      return graphQLMap["_lastChangedAt"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }
}

public struct ModelEmergencyContactConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(name: ModelStringInput? = nil, phone: ModelStringInput? = nil, createdAt: ModelStringInput? = nil, updatedAt: ModelStringInput? = nil, version: ModelIntInput? = nil, deleted: ModelBooleanInput? = nil, lastChangedAt: ModelIntInput? = nil, and: [ModelEmergencyContactConditionInput?]? = nil, or: [ModelEmergencyContactConditionInput?]? = nil, not: ModelEmergencyContactConditionInput? = nil) {
    graphQLMap = ["name": name, "phone": phone, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "and": and, "or": or, "not": not]
  }

  public var name: ModelStringInput? {
    get {
      return graphQLMap["name"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var phone: ModelStringInput? {
    get {
      return graphQLMap["phone"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phone")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: ModelIntInput? {
    get {
      return graphQLMap["_version"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: ModelIntInput? {
    get {
      return graphQLMap["_lastChangedAt"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }

  public var and: [ModelEmergencyContactConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelEmergencyContactConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelEmergencyContactConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelEmergencyContactConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelEmergencyContactConditionInput? {
    get {
      return graphQLMap["not"] as! ModelEmergencyContactConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct UpdateEmergencyContactInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, name: String? = nil, phone: String? = nil, createdAt: String? = nil, updatedAt: String? = nil, version: Int? = nil, deleted: Bool? = nil, lastChangedAt: Int? = nil) {
    graphQLMap = ["id": id, "name": name, "phone": phone, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String? {
    get {
      return graphQLMap["name"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var phone: String? {
    get {
      return graphQLMap["phone"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phone")
    }
  }

  public var createdAt: String? {
    get {
      return graphQLMap["createdAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: String? {
    get {
      return graphQLMap["updatedAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: Bool? {
    get {
      return graphQLMap["_deleted"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: Int? {
    get {
      return graphQLMap["_lastChangedAt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }
}

public struct DeleteEmergencyContactInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateAchievementInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, title: String, description: String? = nil, dateAchieved: String, createdAt: String? = nil, updatedAt: String? = nil, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
    graphQLMap = ["id": id, "title": title, "description": description, "dateAchieved": dateAchieved, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var title: String {
    get {
      return graphQLMap["title"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var description: String? {
    get {
      return graphQLMap["description"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "description")
    }
  }

  public var dateAchieved: String {
    get {
      return graphQLMap["dateAchieved"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dateAchieved")
    }
  }

  public var createdAt: String? {
    get {
      return graphQLMap["createdAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: String? {
    get {
      return graphQLMap["updatedAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: Int {
    get {
      return graphQLMap["_version"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: Bool? {
    get {
      return graphQLMap["_deleted"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: Int {
    get {
      return graphQLMap["_lastChangedAt"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }
}

public struct ModelAchievementConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(title: ModelStringInput? = nil, description: ModelStringInput? = nil, dateAchieved: ModelStringInput? = nil, createdAt: ModelStringInput? = nil, updatedAt: ModelStringInput? = nil, version: ModelIntInput? = nil, deleted: ModelBooleanInput? = nil, lastChangedAt: ModelIntInput? = nil, and: [ModelAchievementConditionInput?]? = nil, or: [ModelAchievementConditionInput?]? = nil, not: ModelAchievementConditionInput? = nil) {
    graphQLMap = ["title": title, "description": description, "dateAchieved": dateAchieved, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "and": and, "or": or, "not": not]
  }

  public var title: ModelStringInput? {
    get {
      return graphQLMap["title"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var description: ModelStringInput? {
    get {
      return graphQLMap["description"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "description")
    }
  }

  public var dateAchieved: ModelStringInput? {
    get {
      return graphQLMap["dateAchieved"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dateAchieved")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: ModelIntInput? {
    get {
      return graphQLMap["_version"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: ModelIntInput? {
    get {
      return graphQLMap["_lastChangedAt"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }

  public var and: [ModelAchievementConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelAchievementConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelAchievementConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelAchievementConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelAchievementConditionInput? {
    get {
      return graphQLMap["not"] as! ModelAchievementConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct UpdateAchievementInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, title: String? = nil, description: String? = nil, dateAchieved: String? = nil, createdAt: String? = nil, updatedAt: String? = nil, version: Int? = nil, deleted: Bool? = nil, lastChangedAt: Int? = nil) {
    graphQLMap = ["id": id, "title": title, "description": description, "dateAchieved": dateAchieved, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var title: String? {
    get {
      return graphQLMap["title"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var description: String? {
    get {
      return graphQLMap["description"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "description")
    }
  }

  public var dateAchieved: String? {
    get {
      return graphQLMap["dateAchieved"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dateAchieved")
    }
  }

  public var createdAt: String? {
    get {
      return graphQLMap["createdAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: String? {
    get {
      return graphQLMap["updatedAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: Bool? {
    get {
      return graphQLMap["_deleted"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: Int? {
    get {
      return graphQLMap["_lastChangedAt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }
}

public struct DeleteAchievementInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateReminderInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, message: String, time: String, isEnabled: Bool, createdAt: String? = nil, updatedAt: String? = nil, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
    graphQLMap = ["id": id, "message": message, "time": time, "isEnabled": isEnabled, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var message: String {
    get {
      return graphQLMap["message"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "message")
    }
  }

  public var time: String {
    get {
      return graphQLMap["time"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "time")
    }
  }

  public var isEnabled: Bool {
    get {
      return graphQLMap["isEnabled"] as! Bool
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "isEnabled")
    }
  }

  public var createdAt: String? {
    get {
      return graphQLMap["createdAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: String? {
    get {
      return graphQLMap["updatedAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: Int {
    get {
      return graphQLMap["_version"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: Bool? {
    get {
      return graphQLMap["_deleted"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: Int {
    get {
      return graphQLMap["_lastChangedAt"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }
}

public struct ModelReminderConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(message: ModelStringInput? = nil, time: ModelStringInput? = nil, isEnabled: ModelBooleanInput? = nil, createdAt: ModelStringInput? = nil, updatedAt: ModelStringInput? = nil, version: ModelIntInput? = nil, deleted: ModelBooleanInput? = nil, lastChangedAt: ModelIntInput? = nil, and: [ModelReminderConditionInput?]? = nil, or: [ModelReminderConditionInput?]? = nil, not: ModelReminderConditionInput? = nil) {
    graphQLMap = ["message": message, "time": time, "isEnabled": isEnabled, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "and": and, "or": or, "not": not]
  }

  public var message: ModelStringInput? {
    get {
      return graphQLMap["message"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "message")
    }
  }

  public var time: ModelStringInput? {
    get {
      return graphQLMap["time"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "time")
    }
  }

  public var isEnabled: ModelBooleanInput? {
    get {
      return graphQLMap["isEnabled"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "isEnabled")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: ModelIntInput? {
    get {
      return graphQLMap["_version"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: ModelIntInput? {
    get {
      return graphQLMap["_lastChangedAt"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }

  public var and: [ModelReminderConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelReminderConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelReminderConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelReminderConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelReminderConditionInput? {
    get {
      return graphQLMap["not"] as! ModelReminderConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct UpdateReminderInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, message: String? = nil, time: String? = nil, isEnabled: Bool? = nil, createdAt: String? = nil, updatedAt: String? = nil, version: Int? = nil, deleted: Bool? = nil, lastChangedAt: Int? = nil) {
    graphQLMap = ["id": id, "message": message, "time": time, "isEnabled": isEnabled, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var message: String? {
    get {
      return graphQLMap["message"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "message")
    }
  }

  public var time: String? {
    get {
      return graphQLMap["time"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "time")
    }
  }

  public var isEnabled: Bool? {
    get {
      return graphQLMap["isEnabled"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "isEnabled")
    }
  }

  public var createdAt: String? {
    get {
      return graphQLMap["createdAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: String? {
    get {
      return graphQLMap["updatedAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: Bool? {
    get {
      return graphQLMap["_deleted"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: Int? {
    get {
      return graphQLMap["_lastChangedAt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }
}

public struct DeleteReminderInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct ModelGoalFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, description: ModelStringInput? = nil, targetDate: ModelStringInput? = nil, reason: ModelStringInput? = nil, dailyLimit: ModelIntInput? = nil, reward: ModelStringInput? = nil, createdAt: ModelStringInput? = nil, updatedAt: ModelStringInput? = nil, and: [ModelGoalFilterInput?]? = nil, or: [ModelGoalFilterInput?]? = nil, not: ModelGoalFilterInput? = nil) {
    graphQLMap = ["id": id, "description": description, "targetDate": targetDate, "reason": reason, "dailyLimit": dailyLimit, "reward": reward, "createdAt": createdAt, "updatedAt": updatedAt, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var description: ModelStringInput? {
    get {
      return graphQLMap["description"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "description")
    }
  }

  public var targetDate: ModelStringInput? {
    get {
      return graphQLMap["targetDate"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "targetDate")
    }
  }

  public var reason: ModelStringInput? {
    get {
      return graphQLMap["reason"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "reason")
    }
  }

  public var dailyLimit: ModelIntInput? {
    get {
      return graphQLMap["dailyLimit"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dailyLimit")
    }
  }

  public var reward: ModelStringInput? {
    get {
      return graphQLMap["reward"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "reward")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var and: [ModelGoalFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelGoalFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelGoalFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelGoalFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelGoalFilterInput? {
    get {
      return graphQLMap["not"] as! ModelGoalFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelIDInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: GraphQLID? = nil, eq: GraphQLID? = nil, le: GraphQLID? = nil, lt: GraphQLID? = nil, ge: GraphQLID? = nil, gt: GraphQLID? = nil, contains: GraphQLID? = nil, notContains: GraphQLID? = nil, between: [GraphQLID?]? = nil, beginsWith: GraphQLID? = nil, attributeExists: Bool? = nil, attributeType: ModelAttributeTypes? = nil, size: ModelSizeInput? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "attributeExists": attributeExists, "attributeType": attributeType, "size": size]
  }

  public var ne: GraphQLID? {
    get {
      return graphQLMap["ne"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: GraphQLID? {
    get {
      return graphQLMap["eq"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: GraphQLID? {
    get {
      return graphQLMap["le"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: GraphQLID? {
    get {
      return graphQLMap["lt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: GraphQLID? {
    get {
      return graphQLMap["ge"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: GraphQLID? {
    get {
      return graphQLMap["gt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: GraphQLID? {
    get {
      return graphQLMap["contains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: GraphQLID? {
    get {
      return graphQLMap["notContains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [GraphQLID?]? {
    get {
      return graphQLMap["between"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: GraphQLID? {
    get {
      return graphQLMap["beginsWith"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var attributeExists: Bool? {
    get {
      return graphQLMap["attributeExists"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeExists")
    }
  }

  public var attributeType: ModelAttributeTypes? {
    get {
      return graphQLMap["attributeType"] as! ModelAttributeTypes?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeType")
    }
  }

  public var size: ModelSizeInput? {
    get {
      return graphQLMap["size"] as! ModelSizeInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "size")
    }
  }
}

public struct ModelDrinkRecordFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, details: ModelStringInput? = nil, amount: ModelIntInput? = nil, content: ModelStringInput? = nil, feeling: ModelStringInput? = nil, location: ModelStringInput? = nil, createdAt: ModelStringInput? = nil, updatedAt: ModelStringInput? = nil, version: ModelIntInput? = nil, deleted: ModelBooleanInput? = nil, lastChangedAt: ModelIntInput? = nil, and: [ModelDrinkRecordFilterInput?]? = nil, or: [ModelDrinkRecordFilterInput?]? = nil, not: ModelDrinkRecordFilterInput? = nil) {
    graphQLMap = ["id": id, "details": details, "amount": amount, "content": content, "feeling": feeling, "location": location, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var details: ModelStringInput? {
    get {
      return graphQLMap["details"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "details")
    }
  }

  public var amount: ModelIntInput? {
    get {
      return graphQLMap["amount"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "amount")
    }
  }

  public var content: ModelStringInput? {
    get {
      return graphQLMap["content"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }

  public var feeling: ModelStringInput? {
    get {
      return graphQLMap["feeling"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "feeling")
    }
  }

  public var location: ModelStringInput? {
    get {
      return graphQLMap["location"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "location")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: ModelIntInput? {
    get {
      return graphQLMap["_version"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: ModelIntInput? {
    get {
      return graphQLMap["_lastChangedAt"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }

  public var and: [ModelDrinkRecordFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelDrinkRecordFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelDrinkRecordFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelDrinkRecordFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelDrinkRecordFilterInput? {
    get {
      return graphQLMap["not"] as! ModelDrinkRecordFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelDiaryEntryFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, content: ModelStringInput? = nil, feeling: ModelStringInput? = nil, date: ModelStringInput? = nil, createdAt: ModelStringInput? = nil, updatedAt: ModelStringInput? = nil, version: ModelIntInput? = nil, deleted: ModelBooleanInput? = nil, lastChangedAt: ModelIntInput? = nil, and: [ModelDiaryEntryFilterInput?]? = nil, or: [ModelDiaryEntryFilterInput?]? = nil, not: ModelDiaryEntryFilterInput? = nil) {
    graphQLMap = ["id": id, "content": content, "feeling": feeling, "date": date, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var content: ModelStringInput? {
    get {
      return graphQLMap["content"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }

  public var feeling: ModelStringInput? {
    get {
      return graphQLMap["feeling"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "feeling")
    }
  }

  public var date: ModelStringInput? {
    get {
      return graphQLMap["date"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "date")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: ModelIntInput? {
    get {
      return graphQLMap["_version"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: ModelIntInput? {
    get {
      return graphQLMap["_lastChangedAt"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }

  public var and: [ModelDiaryEntryFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelDiaryEntryFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelDiaryEntryFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelDiaryEntryFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelDiaryEntryFilterInput? {
    get {
      return graphQLMap["not"] as! ModelDiaryEntryFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelCommunityMessageFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, content: ModelStringInput? = nil, sender: ModelStringInput? = nil, createdAt: ModelStringInput? = nil, updatedAt: ModelStringInput? = nil, version: ModelIntInput? = nil, deleted: ModelBooleanInput? = nil, lastChangedAt: ModelIntInput? = nil, and: [ModelCommunityMessageFilterInput?]? = nil, or: [ModelCommunityMessageFilterInput?]? = nil, not: ModelCommunityMessageFilterInput? = nil) {
    graphQLMap = ["id": id, "content": content, "sender": sender, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var content: ModelStringInput? {
    get {
      return graphQLMap["content"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }

  public var sender: ModelStringInput? {
    get {
      return graphQLMap["sender"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "sender")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: ModelIntInput? {
    get {
      return graphQLMap["_version"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: ModelIntInput? {
    get {
      return graphQLMap["_lastChangedAt"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }

  public var and: [ModelCommunityMessageFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelCommunityMessageFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelCommunityMessageFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelCommunityMessageFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelCommunityMessageFilterInput? {
    get {
      return graphQLMap["not"] as! ModelCommunityMessageFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelEmergencyContactFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, name: ModelStringInput? = nil, phone: ModelStringInput? = nil, createdAt: ModelStringInput? = nil, updatedAt: ModelStringInput? = nil, version: ModelIntInput? = nil, deleted: ModelBooleanInput? = nil, lastChangedAt: ModelIntInput? = nil, and: [ModelEmergencyContactFilterInput?]? = nil, or: [ModelEmergencyContactFilterInput?]? = nil, not: ModelEmergencyContactFilterInput? = nil) {
    graphQLMap = ["id": id, "name": name, "phone": phone, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: ModelStringInput? {
    get {
      return graphQLMap["name"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var phone: ModelStringInput? {
    get {
      return graphQLMap["phone"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phone")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: ModelIntInput? {
    get {
      return graphQLMap["_version"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: ModelIntInput? {
    get {
      return graphQLMap["_lastChangedAt"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }

  public var and: [ModelEmergencyContactFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelEmergencyContactFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelEmergencyContactFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelEmergencyContactFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelEmergencyContactFilterInput? {
    get {
      return graphQLMap["not"] as! ModelEmergencyContactFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelAchievementFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, title: ModelStringInput? = nil, description: ModelStringInput? = nil, dateAchieved: ModelStringInput? = nil, createdAt: ModelStringInput? = nil, updatedAt: ModelStringInput? = nil, version: ModelIntInput? = nil, deleted: ModelBooleanInput? = nil, lastChangedAt: ModelIntInput? = nil, and: [ModelAchievementFilterInput?]? = nil, or: [ModelAchievementFilterInput?]? = nil, not: ModelAchievementFilterInput? = nil) {
    graphQLMap = ["id": id, "title": title, "description": description, "dateAchieved": dateAchieved, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var title: ModelStringInput? {
    get {
      return graphQLMap["title"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var description: ModelStringInput? {
    get {
      return graphQLMap["description"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "description")
    }
  }

  public var dateAchieved: ModelStringInput? {
    get {
      return graphQLMap["dateAchieved"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dateAchieved")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: ModelIntInput? {
    get {
      return graphQLMap["_version"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: ModelIntInput? {
    get {
      return graphQLMap["_lastChangedAt"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }

  public var and: [ModelAchievementFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelAchievementFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelAchievementFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelAchievementFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelAchievementFilterInput? {
    get {
      return graphQLMap["not"] as! ModelAchievementFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelReminderFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, message: ModelStringInput? = nil, time: ModelStringInput? = nil, isEnabled: ModelBooleanInput? = nil, createdAt: ModelStringInput? = nil, updatedAt: ModelStringInput? = nil, version: ModelIntInput? = nil, deleted: ModelBooleanInput? = nil, lastChangedAt: ModelIntInput? = nil, and: [ModelReminderFilterInput?]? = nil, or: [ModelReminderFilterInput?]? = nil, not: ModelReminderFilterInput? = nil) {
    graphQLMap = ["id": id, "message": message, "time": time, "isEnabled": isEnabled, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var message: ModelStringInput? {
    get {
      return graphQLMap["message"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "message")
    }
  }

  public var time: ModelStringInput? {
    get {
      return graphQLMap["time"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "time")
    }
  }

  public var isEnabled: ModelBooleanInput? {
    get {
      return graphQLMap["isEnabled"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "isEnabled")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: ModelIntInput? {
    get {
      return graphQLMap["_version"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: ModelIntInput? {
    get {
      return graphQLMap["_lastChangedAt"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }

  public var and: [ModelReminderFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelReminderFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelReminderFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelReminderFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelReminderFilterInput? {
    get {
      return graphQLMap["not"] as! ModelReminderFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelSubscriptionGoalFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, description: ModelSubscriptionStringInput? = nil, targetDate: ModelSubscriptionStringInput? = nil, reason: ModelSubscriptionStringInput? = nil, dailyLimit: ModelSubscriptionIntInput? = nil, reward: ModelSubscriptionStringInput? = nil, createdAt: ModelSubscriptionStringInput? = nil, updatedAt: ModelSubscriptionStringInput? = nil, and: [ModelSubscriptionGoalFilterInput?]? = nil, or: [ModelSubscriptionGoalFilterInput?]? = nil) {
    graphQLMap = ["id": id, "description": description, "targetDate": targetDate, "reason": reason, "dailyLimit": dailyLimit, "reward": reward, "createdAt": createdAt, "updatedAt": updatedAt, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var description: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["description"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "description")
    }
  }

  public var targetDate: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["targetDate"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "targetDate")
    }
  }

  public var reason: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["reason"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "reason")
    }
  }

  public var dailyLimit: ModelSubscriptionIntInput? {
    get {
      return graphQLMap["dailyLimit"] as! ModelSubscriptionIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dailyLimit")
    }
  }

  public var reward: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["reward"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "reward")
    }
  }

  public var createdAt: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var and: [ModelSubscriptionGoalFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionGoalFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionGoalFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionGoalFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionIDInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: GraphQLID? = nil, eq: GraphQLID? = nil, le: GraphQLID? = nil, lt: GraphQLID? = nil, ge: GraphQLID? = nil, gt: GraphQLID? = nil, contains: GraphQLID? = nil, notContains: GraphQLID? = nil, between: [GraphQLID?]? = nil, beginsWith: GraphQLID? = nil, `in`: [GraphQLID?]? = nil, notIn: [GraphQLID?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "in": `in`, "notIn": notIn]
  }

  public var ne: GraphQLID? {
    get {
      return graphQLMap["ne"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: GraphQLID? {
    get {
      return graphQLMap["eq"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: GraphQLID? {
    get {
      return graphQLMap["le"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: GraphQLID? {
    get {
      return graphQLMap["lt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: GraphQLID? {
    get {
      return graphQLMap["ge"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: GraphQLID? {
    get {
      return graphQLMap["gt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: GraphQLID? {
    get {
      return graphQLMap["contains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: GraphQLID? {
    get {
      return graphQLMap["notContains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [GraphQLID?]? {
    get {
      return graphQLMap["between"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: GraphQLID? {
    get {
      return graphQLMap["beginsWith"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var `in`: [GraphQLID?]? {
    get {
      return graphQLMap["in"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "in")
    }
  }

  public var notIn: [GraphQLID?]? {
    get {
      return graphQLMap["notIn"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }
}

public struct ModelSubscriptionStringInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: String? = nil, eq: String? = nil, le: String? = nil, lt: String? = nil, ge: String? = nil, gt: String? = nil, contains: String? = nil, notContains: String? = nil, between: [String?]? = nil, beginsWith: String? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "in": `in`, "notIn": notIn]
  }

  public var ne: String? {
    get {
      return graphQLMap["ne"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: String? {
    get {
      return graphQLMap["eq"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: String? {
    get {
      return graphQLMap["le"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: String? {
    get {
      return graphQLMap["lt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: String? {
    get {
      return graphQLMap["ge"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: String? {
    get {
      return graphQLMap["gt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: String? {
    get {
      return graphQLMap["contains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: String? {
    get {
      return graphQLMap["notContains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [String?]? {
    get {
      return graphQLMap["between"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: String? {
    get {
      return graphQLMap["beginsWith"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var `in`: [String?]? {
    get {
      return graphQLMap["in"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "in")
    }
  }

  public var notIn: [String?]? {
    get {
      return graphQLMap["notIn"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }
}

public struct ModelSubscriptionIntInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Int? = nil, eq: Int? = nil, le: Int? = nil, lt: Int? = nil, ge: Int? = nil, gt: Int? = nil, between: [Int?]? = nil, `in`: [Int?]? = nil, notIn: [Int?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "between": between, "in": `in`, "notIn": notIn]
  }

  public var ne: Int? {
    get {
      return graphQLMap["ne"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Int? {
    get {
      return graphQLMap["eq"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: Int? {
    get {
      return graphQLMap["le"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: Int? {
    get {
      return graphQLMap["lt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: Int? {
    get {
      return graphQLMap["ge"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: Int? {
    get {
      return graphQLMap["gt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var between: [Int?]? {
    get {
      return graphQLMap["between"] as! [Int?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var `in`: [Int?]? {
    get {
      return graphQLMap["in"] as! [Int?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "in")
    }
  }

  public var notIn: [Int?]? {
    get {
      return graphQLMap["notIn"] as! [Int?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }
}

public struct ModelSubscriptionDrinkRecordFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, details: ModelSubscriptionStringInput? = nil, amount: ModelSubscriptionIntInput? = nil, content: ModelSubscriptionStringInput? = nil, feeling: ModelSubscriptionStringInput? = nil, location: ModelSubscriptionStringInput? = nil, createdAt: ModelSubscriptionStringInput? = nil, updatedAt: ModelSubscriptionStringInput? = nil, version: ModelSubscriptionIntInput? = nil, deleted: ModelSubscriptionBooleanInput? = nil, lastChangedAt: ModelSubscriptionIntInput? = nil, and: [ModelSubscriptionDrinkRecordFilterInput?]? = nil, or: [ModelSubscriptionDrinkRecordFilterInput?]? = nil) {
    graphQLMap = ["id": id, "details": details, "amount": amount, "content": content, "feeling": feeling, "location": location, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var details: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["details"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "details")
    }
  }

  public var amount: ModelSubscriptionIntInput? {
    get {
      return graphQLMap["amount"] as! ModelSubscriptionIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "amount")
    }
  }

  public var content: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["content"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }

  public var feeling: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["feeling"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "feeling")
    }
  }

  public var location: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["location"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "location")
    }
  }

  public var createdAt: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: ModelSubscriptionIntInput? {
    get {
      return graphQLMap["_version"] as! ModelSubscriptionIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: ModelSubscriptionBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelSubscriptionBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: ModelSubscriptionIntInput? {
    get {
      return graphQLMap["_lastChangedAt"] as! ModelSubscriptionIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }

  public var and: [ModelSubscriptionDrinkRecordFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionDrinkRecordFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionDrinkRecordFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionDrinkRecordFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionBooleanInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Bool? = nil, eq: Bool? = nil) {
    graphQLMap = ["ne": ne, "eq": eq]
  }

  public var ne: Bool? {
    get {
      return graphQLMap["ne"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Bool? {
    get {
      return graphQLMap["eq"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }
}

public struct ModelSubscriptionDiaryEntryFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, content: ModelSubscriptionStringInput? = nil, feeling: ModelSubscriptionStringInput? = nil, date: ModelSubscriptionStringInput? = nil, createdAt: ModelSubscriptionStringInput? = nil, updatedAt: ModelSubscriptionStringInput? = nil, version: ModelSubscriptionIntInput? = nil, deleted: ModelSubscriptionBooleanInput? = nil, lastChangedAt: ModelSubscriptionIntInput? = nil, and: [ModelSubscriptionDiaryEntryFilterInput?]? = nil, or: [ModelSubscriptionDiaryEntryFilterInput?]? = nil) {
    graphQLMap = ["id": id, "content": content, "feeling": feeling, "date": date, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var content: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["content"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }

  public var feeling: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["feeling"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "feeling")
    }
  }

  public var date: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["date"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "date")
    }
  }

  public var createdAt: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: ModelSubscriptionIntInput? {
    get {
      return graphQLMap["_version"] as! ModelSubscriptionIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: ModelSubscriptionBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelSubscriptionBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: ModelSubscriptionIntInput? {
    get {
      return graphQLMap["_lastChangedAt"] as! ModelSubscriptionIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }

  public var and: [ModelSubscriptionDiaryEntryFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionDiaryEntryFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionDiaryEntryFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionDiaryEntryFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionCommunityMessageFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, content: ModelSubscriptionStringInput? = nil, sender: ModelSubscriptionStringInput? = nil, createdAt: ModelSubscriptionStringInput? = nil, updatedAt: ModelSubscriptionStringInput? = nil, version: ModelSubscriptionIntInput? = nil, deleted: ModelSubscriptionBooleanInput? = nil, lastChangedAt: ModelSubscriptionIntInput? = nil, and: [ModelSubscriptionCommunityMessageFilterInput?]? = nil, or: [ModelSubscriptionCommunityMessageFilterInput?]? = nil) {
    graphQLMap = ["id": id, "content": content, "sender": sender, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var content: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["content"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }

  public var sender: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["sender"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "sender")
    }
  }

  public var createdAt: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: ModelSubscriptionIntInput? {
    get {
      return graphQLMap["_version"] as! ModelSubscriptionIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: ModelSubscriptionBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelSubscriptionBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: ModelSubscriptionIntInput? {
    get {
      return graphQLMap["_lastChangedAt"] as! ModelSubscriptionIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }

  public var and: [ModelSubscriptionCommunityMessageFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionCommunityMessageFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionCommunityMessageFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionCommunityMessageFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionEmergencyContactFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, name: ModelSubscriptionStringInput? = nil, phone: ModelSubscriptionStringInput? = nil, createdAt: ModelSubscriptionStringInput? = nil, updatedAt: ModelSubscriptionStringInput? = nil, version: ModelSubscriptionIntInput? = nil, deleted: ModelSubscriptionBooleanInput? = nil, lastChangedAt: ModelSubscriptionIntInput? = nil, and: [ModelSubscriptionEmergencyContactFilterInput?]? = nil, or: [ModelSubscriptionEmergencyContactFilterInput?]? = nil) {
    graphQLMap = ["id": id, "name": name, "phone": phone, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["name"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var phone: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["phone"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phone")
    }
  }

  public var createdAt: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: ModelSubscriptionIntInput? {
    get {
      return graphQLMap["_version"] as! ModelSubscriptionIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: ModelSubscriptionBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelSubscriptionBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: ModelSubscriptionIntInput? {
    get {
      return graphQLMap["_lastChangedAt"] as! ModelSubscriptionIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }

  public var and: [ModelSubscriptionEmergencyContactFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionEmergencyContactFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionEmergencyContactFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionEmergencyContactFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionAchievementFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, title: ModelSubscriptionStringInput? = nil, description: ModelSubscriptionStringInput? = nil, dateAchieved: ModelSubscriptionStringInput? = nil, createdAt: ModelSubscriptionStringInput? = nil, updatedAt: ModelSubscriptionStringInput? = nil, version: ModelSubscriptionIntInput? = nil, deleted: ModelSubscriptionBooleanInput? = nil, lastChangedAt: ModelSubscriptionIntInput? = nil, and: [ModelSubscriptionAchievementFilterInput?]? = nil, or: [ModelSubscriptionAchievementFilterInput?]? = nil) {
    graphQLMap = ["id": id, "title": title, "description": description, "dateAchieved": dateAchieved, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var title: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["title"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var description: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["description"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "description")
    }
  }

  public var dateAchieved: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["dateAchieved"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dateAchieved")
    }
  }

  public var createdAt: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: ModelSubscriptionIntInput? {
    get {
      return graphQLMap["_version"] as! ModelSubscriptionIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: ModelSubscriptionBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelSubscriptionBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: ModelSubscriptionIntInput? {
    get {
      return graphQLMap["_lastChangedAt"] as! ModelSubscriptionIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }

  public var and: [ModelSubscriptionAchievementFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionAchievementFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionAchievementFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionAchievementFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionReminderFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, message: ModelSubscriptionStringInput? = nil, time: ModelSubscriptionStringInput? = nil, isEnabled: ModelSubscriptionBooleanInput? = nil, createdAt: ModelSubscriptionStringInput? = nil, updatedAt: ModelSubscriptionStringInput? = nil, version: ModelSubscriptionIntInput? = nil, deleted: ModelSubscriptionBooleanInput? = nil, lastChangedAt: ModelSubscriptionIntInput? = nil, and: [ModelSubscriptionReminderFilterInput?]? = nil, or: [ModelSubscriptionReminderFilterInput?]? = nil) {
    graphQLMap = ["id": id, "message": message, "time": time, "isEnabled": isEnabled, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var message: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["message"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "message")
    }
  }

  public var time: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["time"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "time")
    }
  }

  public var isEnabled: ModelSubscriptionBooleanInput? {
    get {
      return graphQLMap["isEnabled"] as! ModelSubscriptionBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "isEnabled")
    }
  }

  public var createdAt: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var version: ModelSubscriptionIntInput? {
    get {
      return graphQLMap["_version"] as! ModelSubscriptionIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var deleted: ModelSubscriptionBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelSubscriptionBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var lastChangedAt: ModelSubscriptionIntInput? {
    get {
      return graphQLMap["_lastChangedAt"] as! ModelSubscriptionIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_lastChangedAt")
    }
  }

  public var and: [ModelSubscriptionReminderFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionReminderFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionReminderFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionReminderFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public final class CreateGoalMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateGoal($input: CreateGoalInput!, $condition: ModelGoalConditionInput) {\n  createGoal(input: $input, condition: $condition) {\n    __typename\n    id\n    description\n    targetDate\n    reason\n    dailyLimit\n    reward\n    createdAt\n    updatedAt\n  }\n}"

  public var input: CreateGoalInput
  public var condition: ModelGoalConditionInput?

  public init(input: CreateGoalInput, condition: ModelGoalConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createGoal", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateGoal.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createGoal: CreateGoal? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createGoal": createGoal.flatMap { $0.snapshot }])
    }

    public var createGoal: CreateGoal? {
      get {
        return (snapshot["createGoal"] as? Snapshot).flatMap { CreateGoal(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createGoal")
      }
    }

    public struct CreateGoal: GraphQLSelectionSet {
      public static let possibleTypes = ["Goal"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("description", type: .nonNull(.scalar(String.self))),
        GraphQLField("targetDate", type: .nonNull(.scalar(String.self))),
        GraphQLField("reason", type: .scalar(String.self)),
        GraphQLField("dailyLimit", type: .scalar(Int.self)),
        GraphQLField("reward", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, description: String, targetDate: String, reason: String? = nil, dailyLimit: Int? = nil, reward: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Goal", "id": id, "description": description, "targetDate": targetDate, "reason": reason, "dailyLimit": dailyLimit, "reward": reward, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var description: String {
        get {
          return snapshot["description"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var targetDate: String {
        get {
          return snapshot["targetDate"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "targetDate")
        }
      }

      public var reason: String? {
        get {
          return snapshot["reason"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "reason")
        }
      }

      public var dailyLimit: Int? {
        get {
          return snapshot["dailyLimit"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "dailyLimit")
        }
      }

      public var reward: String? {
        get {
          return snapshot["reward"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "reward")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class UpdateGoalMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateGoal($input: UpdateGoalInput!, $condition: ModelGoalConditionInput) {\n  updateGoal(input: $input, condition: $condition) {\n    __typename\n    id\n    description\n    targetDate\n    reason\n    dailyLimit\n    reward\n    createdAt\n    updatedAt\n  }\n}"

  public var input: UpdateGoalInput
  public var condition: ModelGoalConditionInput?

  public init(input: UpdateGoalInput, condition: ModelGoalConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateGoal", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateGoal.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateGoal: UpdateGoal? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateGoal": updateGoal.flatMap { $0.snapshot }])
    }

    public var updateGoal: UpdateGoal? {
      get {
        return (snapshot["updateGoal"] as? Snapshot).flatMap { UpdateGoal(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateGoal")
      }
    }

    public struct UpdateGoal: GraphQLSelectionSet {
      public static let possibleTypes = ["Goal"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("description", type: .nonNull(.scalar(String.self))),
        GraphQLField("targetDate", type: .nonNull(.scalar(String.self))),
        GraphQLField("reason", type: .scalar(String.self)),
        GraphQLField("dailyLimit", type: .scalar(Int.self)),
        GraphQLField("reward", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, description: String, targetDate: String, reason: String? = nil, dailyLimit: Int? = nil, reward: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Goal", "id": id, "description": description, "targetDate": targetDate, "reason": reason, "dailyLimit": dailyLimit, "reward": reward, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var description: String {
        get {
          return snapshot["description"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var targetDate: String {
        get {
          return snapshot["targetDate"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "targetDate")
        }
      }

      public var reason: String? {
        get {
          return snapshot["reason"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "reason")
        }
      }

      public var dailyLimit: Int? {
        get {
          return snapshot["dailyLimit"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "dailyLimit")
        }
      }

      public var reward: String? {
        get {
          return snapshot["reward"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "reward")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class DeleteGoalMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteGoal($input: DeleteGoalInput!, $condition: ModelGoalConditionInput) {\n  deleteGoal(input: $input, condition: $condition) {\n    __typename\n    id\n    description\n    targetDate\n    reason\n    dailyLimit\n    reward\n    createdAt\n    updatedAt\n  }\n}"

  public var input: DeleteGoalInput
  public var condition: ModelGoalConditionInput?

  public init(input: DeleteGoalInput, condition: ModelGoalConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteGoal", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteGoal.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteGoal: DeleteGoal? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteGoal": deleteGoal.flatMap { $0.snapshot }])
    }

    public var deleteGoal: DeleteGoal? {
      get {
        return (snapshot["deleteGoal"] as? Snapshot).flatMap { DeleteGoal(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteGoal")
      }
    }

    public struct DeleteGoal: GraphQLSelectionSet {
      public static let possibleTypes = ["Goal"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("description", type: .nonNull(.scalar(String.self))),
        GraphQLField("targetDate", type: .nonNull(.scalar(String.self))),
        GraphQLField("reason", type: .scalar(String.self)),
        GraphQLField("dailyLimit", type: .scalar(Int.self)),
        GraphQLField("reward", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, description: String, targetDate: String, reason: String? = nil, dailyLimit: Int? = nil, reward: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Goal", "id": id, "description": description, "targetDate": targetDate, "reason": reason, "dailyLimit": dailyLimit, "reward": reward, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var description: String {
        get {
          return snapshot["description"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var targetDate: String {
        get {
          return snapshot["targetDate"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "targetDate")
        }
      }

      public var reason: String? {
        get {
          return snapshot["reason"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "reason")
        }
      }

      public var dailyLimit: Int? {
        get {
          return snapshot["dailyLimit"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "dailyLimit")
        }
      }

      public var reward: String? {
        get {
          return snapshot["reward"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "reward")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class CreateDrinkRecordMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateDrinkRecord($input: CreateDrinkRecordInput!, $condition: ModelDrinkRecordConditionInput) {\n  createDrinkRecord(input: $input, condition: $condition) {\n    __typename\n    id\n    details\n    amount\n    content\n    feeling\n    location\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: CreateDrinkRecordInput
  public var condition: ModelDrinkRecordConditionInput?

  public init(input: CreateDrinkRecordInput, condition: ModelDrinkRecordConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createDrinkRecord", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateDrinkRecord.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createDrinkRecord: CreateDrinkRecord? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createDrinkRecord": createDrinkRecord.flatMap { $0.snapshot }])
    }

    public var createDrinkRecord: CreateDrinkRecord? {
      get {
        return (snapshot["createDrinkRecord"] as? Snapshot).flatMap { CreateDrinkRecord(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createDrinkRecord")
      }
    }

    public struct CreateDrinkRecord: GraphQLSelectionSet {
      public static let possibleTypes = ["DrinkRecord"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("details", type: .nonNull(.scalar(String.self))),
        GraphQLField("amount", type: .nonNull(.scalar(Int.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("feeling", type: .nonNull(.scalar(String.self))),
        GraphQLField("location", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, details: String, amount: Int, content: String, feeling: String, location: String? = nil, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "DrinkRecord", "id": id, "details": details, "amount": amount, "content": content, "feeling": feeling, "location": location, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var details: String {
        get {
          return snapshot["details"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "details")
        }
      }

      public var amount: Int {
        get {
          return snapshot["amount"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "amount")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var feeling: String {
        get {
          return snapshot["feeling"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "feeling")
        }
      }

      public var location: String? {
        get {
          return snapshot["location"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "location")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class UpdateDrinkRecordMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateDrinkRecord($input: UpdateDrinkRecordInput!, $condition: ModelDrinkRecordConditionInput) {\n  updateDrinkRecord(input: $input, condition: $condition) {\n    __typename\n    id\n    details\n    amount\n    content\n    feeling\n    location\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: UpdateDrinkRecordInput
  public var condition: ModelDrinkRecordConditionInput?

  public init(input: UpdateDrinkRecordInput, condition: ModelDrinkRecordConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateDrinkRecord", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateDrinkRecord.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateDrinkRecord: UpdateDrinkRecord? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateDrinkRecord": updateDrinkRecord.flatMap { $0.snapshot }])
    }

    public var updateDrinkRecord: UpdateDrinkRecord? {
      get {
        return (snapshot["updateDrinkRecord"] as? Snapshot).flatMap { UpdateDrinkRecord(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateDrinkRecord")
      }
    }

    public struct UpdateDrinkRecord: GraphQLSelectionSet {
      public static let possibleTypes = ["DrinkRecord"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("details", type: .nonNull(.scalar(String.self))),
        GraphQLField("amount", type: .nonNull(.scalar(Int.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("feeling", type: .nonNull(.scalar(String.self))),
        GraphQLField("location", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, details: String, amount: Int, content: String, feeling: String, location: String? = nil, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "DrinkRecord", "id": id, "details": details, "amount": amount, "content": content, "feeling": feeling, "location": location, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var details: String {
        get {
          return snapshot["details"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "details")
        }
      }

      public var amount: Int {
        get {
          return snapshot["amount"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "amount")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var feeling: String {
        get {
          return snapshot["feeling"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "feeling")
        }
      }

      public var location: String? {
        get {
          return snapshot["location"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "location")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class DeleteDrinkRecordMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteDrinkRecord($input: DeleteDrinkRecordInput!, $condition: ModelDrinkRecordConditionInput) {\n  deleteDrinkRecord(input: $input, condition: $condition) {\n    __typename\n    id\n    details\n    amount\n    content\n    feeling\n    location\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: DeleteDrinkRecordInput
  public var condition: ModelDrinkRecordConditionInput?

  public init(input: DeleteDrinkRecordInput, condition: ModelDrinkRecordConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteDrinkRecord", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteDrinkRecord.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteDrinkRecord: DeleteDrinkRecord? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteDrinkRecord": deleteDrinkRecord.flatMap { $0.snapshot }])
    }

    public var deleteDrinkRecord: DeleteDrinkRecord? {
      get {
        return (snapshot["deleteDrinkRecord"] as? Snapshot).flatMap { DeleteDrinkRecord(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteDrinkRecord")
      }
    }

    public struct DeleteDrinkRecord: GraphQLSelectionSet {
      public static let possibleTypes = ["DrinkRecord"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("details", type: .nonNull(.scalar(String.self))),
        GraphQLField("amount", type: .nonNull(.scalar(Int.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("feeling", type: .nonNull(.scalar(String.self))),
        GraphQLField("location", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, details: String, amount: Int, content: String, feeling: String, location: String? = nil, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "DrinkRecord", "id": id, "details": details, "amount": amount, "content": content, "feeling": feeling, "location": location, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var details: String {
        get {
          return snapshot["details"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "details")
        }
      }

      public var amount: Int {
        get {
          return snapshot["amount"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "amount")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var feeling: String {
        get {
          return snapshot["feeling"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "feeling")
        }
      }

      public var location: String? {
        get {
          return snapshot["location"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "location")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class CreateDiaryEntryMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateDiaryEntry($input: CreateDiaryEntryInput!, $condition: ModelDiaryEntryConditionInput) {\n  createDiaryEntry(input: $input, condition: $condition) {\n    __typename\n    id\n    content\n    feeling\n    date\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: CreateDiaryEntryInput
  public var condition: ModelDiaryEntryConditionInput?

  public init(input: CreateDiaryEntryInput, condition: ModelDiaryEntryConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createDiaryEntry", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateDiaryEntry.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createDiaryEntry: CreateDiaryEntry? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createDiaryEntry": createDiaryEntry.flatMap { $0.snapshot }])
    }

    public var createDiaryEntry: CreateDiaryEntry? {
      get {
        return (snapshot["createDiaryEntry"] as? Snapshot).flatMap { CreateDiaryEntry(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createDiaryEntry")
      }
    }

    public struct CreateDiaryEntry: GraphQLSelectionSet {
      public static let possibleTypes = ["DiaryEntry"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("feeling", type: .nonNull(.scalar(String.self))),
        GraphQLField("date", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, content: String, feeling: String, date: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "DiaryEntry", "id": id, "content": content, "feeling": feeling, "date": date, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var feeling: String {
        get {
          return snapshot["feeling"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "feeling")
        }
      }

      public var date: String {
        get {
          return snapshot["date"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "date")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class UpdateDiaryEntryMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateDiaryEntry($input: UpdateDiaryEntryInput!, $condition: ModelDiaryEntryConditionInput) {\n  updateDiaryEntry(input: $input, condition: $condition) {\n    __typename\n    id\n    content\n    feeling\n    date\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: UpdateDiaryEntryInput
  public var condition: ModelDiaryEntryConditionInput?

  public init(input: UpdateDiaryEntryInput, condition: ModelDiaryEntryConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateDiaryEntry", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateDiaryEntry.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateDiaryEntry: UpdateDiaryEntry? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateDiaryEntry": updateDiaryEntry.flatMap { $0.snapshot }])
    }

    public var updateDiaryEntry: UpdateDiaryEntry? {
      get {
        return (snapshot["updateDiaryEntry"] as? Snapshot).flatMap { UpdateDiaryEntry(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateDiaryEntry")
      }
    }

    public struct UpdateDiaryEntry: GraphQLSelectionSet {
      public static let possibleTypes = ["DiaryEntry"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("feeling", type: .nonNull(.scalar(String.self))),
        GraphQLField("date", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, content: String, feeling: String, date: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "DiaryEntry", "id": id, "content": content, "feeling": feeling, "date": date, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var feeling: String {
        get {
          return snapshot["feeling"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "feeling")
        }
      }

      public var date: String {
        get {
          return snapshot["date"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "date")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class DeleteDiaryEntryMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteDiaryEntry($input: DeleteDiaryEntryInput!, $condition: ModelDiaryEntryConditionInput) {\n  deleteDiaryEntry(input: $input, condition: $condition) {\n    __typename\n    id\n    content\n    feeling\n    date\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: DeleteDiaryEntryInput
  public var condition: ModelDiaryEntryConditionInput?

  public init(input: DeleteDiaryEntryInput, condition: ModelDiaryEntryConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteDiaryEntry", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteDiaryEntry.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteDiaryEntry: DeleteDiaryEntry? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteDiaryEntry": deleteDiaryEntry.flatMap { $0.snapshot }])
    }

    public var deleteDiaryEntry: DeleteDiaryEntry? {
      get {
        return (snapshot["deleteDiaryEntry"] as? Snapshot).flatMap { DeleteDiaryEntry(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteDiaryEntry")
      }
    }

    public struct DeleteDiaryEntry: GraphQLSelectionSet {
      public static let possibleTypes = ["DiaryEntry"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("feeling", type: .nonNull(.scalar(String.self))),
        GraphQLField("date", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, content: String, feeling: String, date: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "DiaryEntry", "id": id, "content": content, "feeling": feeling, "date": date, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var feeling: String {
        get {
          return snapshot["feeling"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "feeling")
        }
      }

      public var date: String {
        get {
          return snapshot["date"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "date")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class CreateCommunityMessageMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateCommunityMessage($input: CreateCommunityMessageInput!, $condition: ModelCommunityMessageConditionInput) {\n  createCommunityMessage(input: $input, condition: $condition) {\n    __typename\n    id\n    content\n    sender\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: CreateCommunityMessageInput
  public var condition: ModelCommunityMessageConditionInput?

  public init(input: CreateCommunityMessageInput, condition: ModelCommunityMessageConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createCommunityMessage", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateCommunityMessage.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createCommunityMessage: CreateCommunityMessage? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createCommunityMessage": createCommunityMessage.flatMap { $0.snapshot }])
    }

    public var createCommunityMessage: CreateCommunityMessage? {
      get {
        return (snapshot["createCommunityMessage"] as? Snapshot).flatMap { CreateCommunityMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createCommunityMessage")
      }
    }

    public struct CreateCommunityMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["CommunityMessage"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("sender", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, content: String, sender: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "CommunityMessage", "id": id, "content": content, "sender": sender, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var sender: String {
        get {
          return snapshot["sender"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "sender")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class UpdateCommunityMessageMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateCommunityMessage($input: UpdateCommunityMessageInput!, $condition: ModelCommunityMessageConditionInput) {\n  updateCommunityMessage(input: $input, condition: $condition) {\n    __typename\n    id\n    content\n    sender\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: UpdateCommunityMessageInput
  public var condition: ModelCommunityMessageConditionInput?

  public init(input: UpdateCommunityMessageInput, condition: ModelCommunityMessageConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateCommunityMessage", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateCommunityMessage.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateCommunityMessage: UpdateCommunityMessage? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateCommunityMessage": updateCommunityMessage.flatMap { $0.snapshot }])
    }

    public var updateCommunityMessage: UpdateCommunityMessage? {
      get {
        return (snapshot["updateCommunityMessage"] as? Snapshot).flatMap { UpdateCommunityMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateCommunityMessage")
      }
    }

    public struct UpdateCommunityMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["CommunityMessage"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("sender", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, content: String, sender: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "CommunityMessage", "id": id, "content": content, "sender": sender, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var sender: String {
        get {
          return snapshot["sender"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "sender")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class DeleteCommunityMessageMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteCommunityMessage($input: DeleteCommunityMessageInput!, $condition: ModelCommunityMessageConditionInput) {\n  deleteCommunityMessage(input: $input, condition: $condition) {\n    __typename\n    id\n    content\n    sender\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: DeleteCommunityMessageInput
  public var condition: ModelCommunityMessageConditionInput?

  public init(input: DeleteCommunityMessageInput, condition: ModelCommunityMessageConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteCommunityMessage", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteCommunityMessage.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteCommunityMessage: DeleteCommunityMessage? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteCommunityMessage": deleteCommunityMessage.flatMap { $0.snapshot }])
    }

    public var deleteCommunityMessage: DeleteCommunityMessage? {
      get {
        return (snapshot["deleteCommunityMessage"] as? Snapshot).flatMap { DeleteCommunityMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteCommunityMessage")
      }
    }

    public struct DeleteCommunityMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["CommunityMessage"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("sender", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, content: String, sender: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "CommunityMessage", "id": id, "content": content, "sender": sender, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var sender: String {
        get {
          return snapshot["sender"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "sender")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class CreateEmergencyContactMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateEmergencyContact($input: CreateEmergencyContactInput!, $condition: ModelEmergencyContactConditionInput) {\n  createEmergencyContact(input: $input, condition: $condition) {\n    __typename\n    id\n    name\n    phone\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: CreateEmergencyContactInput
  public var condition: ModelEmergencyContactConditionInput?

  public init(input: CreateEmergencyContactInput, condition: ModelEmergencyContactConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createEmergencyContact", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateEmergencyContact.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createEmergencyContact: CreateEmergencyContact? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createEmergencyContact": createEmergencyContact.flatMap { $0.snapshot }])
    }

    public var createEmergencyContact: CreateEmergencyContact? {
      get {
        return (snapshot["createEmergencyContact"] as? Snapshot).flatMap { CreateEmergencyContact(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createEmergencyContact")
      }
    }

    public struct CreateEmergencyContact: GraphQLSelectionSet {
      public static let possibleTypes = ["EmergencyContact"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("phone", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, phone: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "EmergencyContact", "id": id, "name": name, "phone": phone, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var phone: String {
        get {
          return snapshot["phone"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phone")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class UpdateEmergencyContactMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateEmergencyContact($input: UpdateEmergencyContactInput!, $condition: ModelEmergencyContactConditionInput) {\n  updateEmergencyContact(input: $input, condition: $condition) {\n    __typename\n    id\n    name\n    phone\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: UpdateEmergencyContactInput
  public var condition: ModelEmergencyContactConditionInput?

  public init(input: UpdateEmergencyContactInput, condition: ModelEmergencyContactConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateEmergencyContact", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateEmergencyContact.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateEmergencyContact: UpdateEmergencyContact? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateEmergencyContact": updateEmergencyContact.flatMap { $0.snapshot }])
    }

    public var updateEmergencyContact: UpdateEmergencyContact? {
      get {
        return (snapshot["updateEmergencyContact"] as? Snapshot).flatMap { UpdateEmergencyContact(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateEmergencyContact")
      }
    }

    public struct UpdateEmergencyContact: GraphQLSelectionSet {
      public static let possibleTypes = ["EmergencyContact"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("phone", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, phone: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "EmergencyContact", "id": id, "name": name, "phone": phone, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var phone: String {
        get {
          return snapshot["phone"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phone")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class DeleteEmergencyContactMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteEmergencyContact($input: DeleteEmergencyContactInput!, $condition: ModelEmergencyContactConditionInput) {\n  deleteEmergencyContact(input: $input, condition: $condition) {\n    __typename\n    id\n    name\n    phone\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: DeleteEmergencyContactInput
  public var condition: ModelEmergencyContactConditionInput?

  public init(input: DeleteEmergencyContactInput, condition: ModelEmergencyContactConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteEmergencyContact", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteEmergencyContact.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteEmergencyContact: DeleteEmergencyContact? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteEmergencyContact": deleteEmergencyContact.flatMap { $0.snapshot }])
    }

    public var deleteEmergencyContact: DeleteEmergencyContact? {
      get {
        return (snapshot["deleteEmergencyContact"] as? Snapshot).flatMap { DeleteEmergencyContact(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteEmergencyContact")
      }
    }

    public struct DeleteEmergencyContact: GraphQLSelectionSet {
      public static let possibleTypes = ["EmergencyContact"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("phone", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, phone: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "EmergencyContact", "id": id, "name": name, "phone": phone, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var phone: String {
        get {
          return snapshot["phone"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phone")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class CreateAchievementMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateAchievement($input: CreateAchievementInput!, $condition: ModelAchievementConditionInput) {\n  createAchievement(input: $input, condition: $condition) {\n    __typename\n    id\n    title\n    description\n    dateAchieved\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: CreateAchievementInput
  public var condition: ModelAchievementConditionInput?

  public init(input: CreateAchievementInput, condition: ModelAchievementConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createAchievement", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateAchievement.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createAchievement: CreateAchievement? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createAchievement": createAchievement.flatMap { $0.snapshot }])
    }

    public var createAchievement: CreateAchievement? {
      get {
        return (snapshot["createAchievement"] as? Snapshot).flatMap { CreateAchievement(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createAchievement")
      }
    }

    public struct CreateAchievement: GraphQLSelectionSet {
      public static let possibleTypes = ["Achievement"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("description", type: .scalar(String.self)),
        GraphQLField("dateAchieved", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, title: String, description: String? = nil, dateAchieved: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "Achievement", "id": id, "title": title, "description": description, "dateAchieved": dateAchieved, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var description: String? {
        get {
          return snapshot["description"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var dateAchieved: String {
        get {
          return snapshot["dateAchieved"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dateAchieved")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class UpdateAchievementMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateAchievement($input: UpdateAchievementInput!, $condition: ModelAchievementConditionInput) {\n  updateAchievement(input: $input, condition: $condition) {\n    __typename\n    id\n    title\n    description\n    dateAchieved\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: UpdateAchievementInput
  public var condition: ModelAchievementConditionInput?

  public init(input: UpdateAchievementInput, condition: ModelAchievementConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateAchievement", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateAchievement.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateAchievement: UpdateAchievement? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateAchievement": updateAchievement.flatMap { $0.snapshot }])
    }

    public var updateAchievement: UpdateAchievement? {
      get {
        return (snapshot["updateAchievement"] as? Snapshot).flatMap { UpdateAchievement(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateAchievement")
      }
    }

    public struct UpdateAchievement: GraphQLSelectionSet {
      public static let possibleTypes = ["Achievement"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("description", type: .scalar(String.self)),
        GraphQLField("dateAchieved", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, title: String, description: String? = nil, dateAchieved: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "Achievement", "id": id, "title": title, "description": description, "dateAchieved": dateAchieved, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var description: String? {
        get {
          return snapshot["description"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var dateAchieved: String {
        get {
          return snapshot["dateAchieved"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dateAchieved")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class DeleteAchievementMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteAchievement($input: DeleteAchievementInput!, $condition: ModelAchievementConditionInput) {\n  deleteAchievement(input: $input, condition: $condition) {\n    __typename\n    id\n    title\n    description\n    dateAchieved\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: DeleteAchievementInput
  public var condition: ModelAchievementConditionInput?

  public init(input: DeleteAchievementInput, condition: ModelAchievementConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteAchievement", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteAchievement.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteAchievement: DeleteAchievement? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteAchievement": deleteAchievement.flatMap { $0.snapshot }])
    }

    public var deleteAchievement: DeleteAchievement? {
      get {
        return (snapshot["deleteAchievement"] as? Snapshot).flatMap { DeleteAchievement(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteAchievement")
      }
    }

    public struct DeleteAchievement: GraphQLSelectionSet {
      public static let possibleTypes = ["Achievement"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("description", type: .scalar(String.self)),
        GraphQLField("dateAchieved", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, title: String, description: String? = nil, dateAchieved: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "Achievement", "id": id, "title": title, "description": description, "dateAchieved": dateAchieved, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var description: String? {
        get {
          return snapshot["description"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var dateAchieved: String {
        get {
          return snapshot["dateAchieved"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dateAchieved")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class CreateReminderMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateReminder($input: CreateReminderInput!, $condition: ModelReminderConditionInput) {\n  createReminder(input: $input, condition: $condition) {\n    __typename\n    id\n    message\n    time\n    isEnabled\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: CreateReminderInput
  public var condition: ModelReminderConditionInput?

  public init(input: CreateReminderInput, condition: ModelReminderConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createReminder", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateReminder.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createReminder: CreateReminder? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createReminder": createReminder.flatMap { $0.snapshot }])
    }

    public var createReminder: CreateReminder? {
      get {
        return (snapshot["createReminder"] as? Snapshot).flatMap { CreateReminder(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createReminder")
      }
    }

    public struct CreateReminder: GraphQLSelectionSet {
      public static let possibleTypes = ["Reminder"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("message", type: .nonNull(.scalar(String.self))),
        GraphQLField("time", type: .nonNull(.scalar(String.self))),
        GraphQLField("isEnabled", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, message: String, time: String, isEnabled: Bool, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "Reminder", "id": id, "message": message, "time": time, "isEnabled": isEnabled, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var message: String {
        get {
          return snapshot["message"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "message")
        }
      }

      public var time: String {
        get {
          return snapshot["time"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "time")
        }
      }

      public var isEnabled: Bool {
        get {
          return snapshot["isEnabled"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "isEnabled")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class UpdateReminderMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateReminder($input: UpdateReminderInput!, $condition: ModelReminderConditionInput) {\n  updateReminder(input: $input, condition: $condition) {\n    __typename\n    id\n    message\n    time\n    isEnabled\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: UpdateReminderInput
  public var condition: ModelReminderConditionInput?

  public init(input: UpdateReminderInput, condition: ModelReminderConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateReminder", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateReminder.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateReminder: UpdateReminder? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateReminder": updateReminder.flatMap { $0.snapshot }])
    }

    public var updateReminder: UpdateReminder? {
      get {
        return (snapshot["updateReminder"] as? Snapshot).flatMap { UpdateReminder(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateReminder")
      }
    }

    public struct UpdateReminder: GraphQLSelectionSet {
      public static let possibleTypes = ["Reminder"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("message", type: .nonNull(.scalar(String.self))),
        GraphQLField("time", type: .nonNull(.scalar(String.self))),
        GraphQLField("isEnabled", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, message: String, time: String, isEnabled: Bool, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "Reminder", "id": id, "message": message, "time": time, "isEnabled": isEnabled, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var message: String {
        get {
          return snapshot["message"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "message")
        }
      }

      public var time: String {
        get {
          return snapshot["time"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "time")
        }
      }

      public var isEnabled: Bool {
        get {
          return snapshot["isEnabled"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "isEnabled")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class DeleteReminderMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteReminder($input: DeleteReminderInput!, $condition: ModelReminderConditionInput) {\n  deleteReminder(input: $input, condition: $condition) {\n    __typename\n    id\n    message\n    time\n    isEnabled\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: DeleteReminderInput
  public var condition: ModelReminderConditionInput?

  public init(input: DeleteReminderInput, condition: ModelReminderConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteReminder", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteReminder.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteReminder: DeleteReminder? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteReminder": deleteReminder.flatMap { $0.snapshot }])
    }

    public var deleteReminder: DeleteReminder? {
      get {
        return (snapshot["deleteReminder"] as? Snapshot).flatMap { DeleteReminder(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteReminder")
      }
    }

    public struct DeleteReminder: GraphQLSelectionSet {
      public static let possibleTypes = ["Reminder"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("message", type: .nonNull(.scalar(String.self))),
        GraphQLField("time", type: .nonNull(.scalar(String.self))),
        GraphQLField("isEnabled", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, message: String, time: String, isEnabled: Bool, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "Reminder", "id": id, "message": message, "time": time, "isEnabled": isEnabled, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var message: String {
        get {
          return snapshot["message"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "message")
        }
      }

      public var time: String {
        get {
          return snapshot["time"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "time")
        }
      }

      public var isEnabled: Bool {
        get {
          return snapshot["isEnabled"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "isEnabled")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class GetGoalQuery: GraphQLQuery {
  public static let operationString =
    "query GetGoal($id: ID!) {\n  getGoal(id: $id) {\n    __typename\n    id\n    description\n    targetDate\n    reason\n    dailyLimit\n    reward\n    createdAt\n    updatedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getGoal", arguments: ["id": GraphQLVariable("id")], type: .object(GetGoal.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getGoal: GetGoal? = nil) {
      self.init(snapshot: ["__typename": "Query", "getGoal": getGoal.flatMap { $0.snapshot }])
    }

    public var getGoal: GetGoal? {
      get {
        return (snapshot["getGoal"] as? Snapshot).flatMap { GetGoal(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getGoal")
      }
    }

    public struct GetGoal: GraphQLSelectionSet {
      public static let possibleTypes = ["Goal"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("description", type: .nonNull(.scalar(String.self))),
        GraphQLField("targetDate", type: .nonNull(.scalar(String.self))),
        GraphQLField("reason", type: .scalar(String.self)),
        GraphQLField("dailyLimit", type: .scalar(Int.self)),
        GraphQLField("reward", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, description: String, targetDate: String, reason: String? = nil, dailyLimit: Int? = nil, reward: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Goal", "id": id, "description": description, "targetDate": targetDate, "reason": reason, "dailyLimit": dailyLimit, "reward": reward, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var description: String {
        get {
          return snapshot["description"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var targetDate: String {
        get {
          return snapshot["targetDate"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "targetDate")
        }
      }

      public var reason: String? {
        get {
          return snapshot["reason"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "reason")
        }
      }

      public var dailyLimit: Int? {
        get {
          return snapshot["dailyLimit"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "dailyLimit")
        }
      }

      public var reward: String? {
        get {
          return snapshot["reward"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "reward")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class ListGoalsQuery: GraphQLQuery {
  public static let operationString =
    "query ListGoals($filter: ModelGoalFilterInput, $limit: Int, $nextToken: String) {\n  listGoals(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      description\n      targetDate\n      reason\n      dailyLimit\n      reward\n      createdAt\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var filter: ModelGoalFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelGoalFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listGoals", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListGoal.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listGoals: ListGoal? = nil) {
      self.init(snapshot: ["__typename": "Query", "listGoals": listGoals.flatMap { $0.snapshot }])
    }

    public var listGoals: ListGoal? {
      get {
        return (snapshot["listGoals"] as? Snapshot).flatMap { ListGoal(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listGoals")
      }
    }

    public struct ListGoal: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelGoalConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelGoalConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Goal"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("description", type: .nonNull(.scalar(String.self))),
          GraphQLField("targetDate", type: .nonNull(.scalar(String.self))),
          GraphQLField("reason", type: .scalar(String.self)),
          GraphQLField("dailyLimit", type: .scalar(Int.self)),
          GraphQLField("reward", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, description: String, targetDate: String, reason: String? = nil, dailyLimit: Int? = nil, reward: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Goal", "id": id, "description": description, "targetDate": targetDate, "reason": reason, "dailyLimit": dailyLimit, "reward": reward, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var description: String {
          get {
            return snapshot["description"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "description")
          }
        }

        public var targetDate: String {
          get {
            return snapshot["targetDate"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "targetDate")
          }
        }

        public var reason: String? {
          get {
            return snapshot["reason"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "reason")
          }
        }

        public var dailyLimit: Int? {
          get {
            return snapshot["dailyLimit"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "dailyLimit")
          }
        }

        public var reward: String? {
          get {
            return snapshot["reward"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "reward")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class GetDrinkRecordQuery: GraphQLQuery {
  public static let operationString =
    "query GetDrinkRecord($id: ID!) {\n  getDrinkRecord(id: $id) {\n    __typename\n    id\n    details\n    amount\n    content\n    feeling\n    location\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getDrinkRecord", arguments: ["id": GraphQLVariable("id")], type: .object(GetDrinkRecord.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getDrinkRecord: GetDrinkRecord? = nil) {
      self.init(snapshot: ["__typename": "Query", "getDrinkRecord": getDrinkRecord.flatMap { $0.snapshot }])
    }

    public var getDrinkRecord: GetDrinkRecord? {
      get {
        return (snapshot["getDrinkRecord"] as? Snapshot).flatMap { GetDrinkRecord(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getDrinkRecord")
      }
    }

    public struct GetDrinkRecord: GraphQLSelectionSet {
      public static let possibleTypes = ["DrinkRecord"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("details", type: .nonNull(.scalar(String.self))),
        GraphQLField("amount", type: .nonNull(.scalar(Int.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("feeling", type: .nonNull(.scalar(String.self))),
        GraphQLField("location", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, details: String, amount: Int, content: String, feeling: String, location: String? = nil, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "DrinkRecord", "id": id, "details": details, "amount": amount, "content": content, "feeling": feeling, "location": location, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var details: String {
        get {
          return snapshot["details"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "details")
        }
      }

      public var amount: Int {
        get {
          return snapshot["amount"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "amount")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var feeling: String {
        get {
          return snapshot["feeling"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "feeling")
        }
      }

      public var location: String? {
        get {
          return snapshot["location"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "location")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class ListDrinkRecordsQuery: GraphQLQuery {
  public static let operationString =
    "query ListDrinkRecords($filter: ModelDrinkRecordFilterInput, $limit: Int, $nextToken: String) {\n  listDrinkRecords(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      details\n      amount\n      content\n      feeling\n      location\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    nextToken\n  }\n}"

  public var filter: ModelDrinkRecordFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelDrinkRecordFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listDrinkRecords", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListDrinkRecord.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listDrinkRecords: ListDrinkRecord? = nil) {
      self.init(snapshot: ["__typename": "Query", "listDrinkRecords": listDrinkRecords.flatMap { $0.snapshot }])
    }

    public var listDrinkRecords: ListDrinkRecord? {
      get {
        return (snapshot["listDrinkRecords"] as? Snapshot).flatMap { ListDrinkRecord(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listDrinkRecords")
      }
    }

    public struct ListDrinkRecord: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelDrinkRecordConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelDrinkRecordConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["DrinkRecord"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("details", type: .nonNull(.scalar(String.self))),
          GraphQLField("amount", type: .nonNull(.scalar(Int.self))),
          GraphQLField("content", type: .nonNull(.scalar(String.self))),
          GraphQLField("feeling", type: .nonNull(.scalar(String.self))),
          GraphQLField("location", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, details: String, amount: Int, content: String, feeling: String, location: String? = nil, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "DrinkRecord", "id": id, "details": details, "amount": amount, "content": content, "feeling": feeling, "location": location, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var details: String {
          get {
            return snapshot["details"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "details")
          }
        }

        public var amount: Int {
          get {
            return snapshot["amount"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "amount")
          }
        }

        public var content: String {
          get {
            return snapshot["content"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "content")
          }
        }

        public var feeling: String {
          get {
            return snapshot["feeling"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "feeling")
          }
        }

        public var location: String? {
          get {
            return snapshot["location"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "location")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }
    }
  }
}

public final class GetDiaryEntryQuery: GraphQLQuery {
  public static let operationString =
    "query GetDiaryEntry($id: ID!) {\n  getDiaryEntry(id: $id) {\n    __typename\n    id\n    content\n    feeling\n    date\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getDiaryEntry", arguments: ["id": GraphQLVariable("id")], type: .object(GetDiaryEntry.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getDiaryEntry: GetDiaryEntry? = nil) {
      self.init(snapshot: ["__typename": "Query", "getDiaryEntry": getDiaryEntry.flatMap { $0.snapshot }])
    }

    public var getDiaryEntry: GetDiaryEntry? {
      get {
        return (snapshot["getDiaryEntry"] as? Snapshot).flatMap { GetDiaryEntry(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getDiaryEntry")
      }
    }

    public struct GetDiaryEntry: GraphQLSelectionSet {
      public static let possibleTypes = ["DiaryEntry"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("feeling", type: .nonNull(.scalar(String.self))),
        GraphQLField("date", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, content: String, feeling: String, date: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "DiaryEntry", "id": id, "content": content, "feeling": feeling, "date": date, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var feeling: String {
        get {
          return snapshot["feeling"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "feeling")
        }
      }

      public var date: String {
        get {
          return snapshot["date"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "date")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class ListDiaryEntriesQuery: GraphQLQuery {
  public static let operationString =
    "query ListDiaryEntries($filter: ModelDiaryEntryFilterInput, $limit: Int, $nextToken: String) {\n  listDiaryEntries(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      content\n      feeling\n      date\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    nextToken\n  }\n}"

  public var filter: ModelDiaryEntryFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelDiaryEntryFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listDiaryEntries", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListDiaryEntry.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listDiaryEntries: ListDiaryEntry? = nil) {
      self.init(snapshot: ["__typename": "Query", "listDiaryEntries": listDiaryEntries.flatMap { $0.snapshot }])
    }

    public var listDiaryEntries: ListDiaryEntry? {
      get {
        return (snapshot["listDiaryEntries"] as? Snapshot).flatMap { ListDiaryEntry(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listDiaryEntries")
      }
    }

    public struct ListDiaryEntry: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelDiaryEntryConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelDiaryEntryConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["DiaryEntry"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("content", type: .nonNull(.scalar(String.self))),
          GraphQLField("feeling", type: .nonNull(.scalar(String.self))),
          GraphQLField("date", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, content: String, feeling: String, date: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "DiaryEntry", "id": id, "content": content, "feeling": feeling, "date": date, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var content: String {
          get {
            return snapshot["content"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "content")
          }
        }

        public var feeling: String {
          get {
            return snapshot["feeling"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "feeling")
          }
        }

        public var date: String {
          get {
            return snapshot["date"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "date")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }
    }
  }
}

public final class GetCommunityMessageQuery: GraphQLQuery {
  public static let operationString =
    "query GetCommunityMessage($id: ID!) {\n  getCommunityMessage(id: $id) {\n    __typename\n    id\n    content\n    sender\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getCommunityMessage", arguments: ["id": GraphQLVariable("id")], type: .object(GetCommunityMessage.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getCommunityMessage: GetCommunityMessage? = nil) {
      self.init(snapshot: ["__typename": "Query", "getCommunityMessage": getCommunityMessage.flatMap { $0.snapshot }])
    }

    public var getCommunityMessage: GetCommunityMessage? {
      get {
        return (snapshot["getCommunityMessage"] as? Snapshot).flatMap { GetCommunityMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getCommunityMessage")
      }
    }

    public struct GetCommunityMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["CommunityMessage"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("sender", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, content: String, sender: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "CommunityMessage", "id": id, "content": content, "sender": sender, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var sender: String {
        get {
          return snapshot["sender"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "sender")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class ListCommunityMessagesQuery: GraphQLQuery {
  public static let operationString =
    "query ListCommunityMessages($filter: ModelCommunityMessageFilterInput, $limit: Int, $nextToken: String) {\n  listCommunityMessages(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      content\n      sender\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    nextToken\n  }\n}"

  public var filter: ModelCommunityMessageFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelCommunityMessageFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listCommunityMessages", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListCommunityMessage.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listCommunityMessages: ListCommunityMessage? = nil) {
      self.init(snapshot: ["__typename": "Query", "listCommunityMessages": listCommunityMessages.flatMap { $0.snapshot }])
    }

    public var listCommunityMessages: ListCommunityMessage? {
      get {
        return (snapshot["listCommunityMessages"] as? Snapshot).flatMap { ListCommunityMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listCommunityMessages")
      }
    }

    public struct ListCommunityMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelCommunityMessageConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelCommunityMessageConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["CommunityMessage"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("content", type: .nonNull(.scalar(String.self))),
          GraphQLField("sender", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, content: String, sender: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "CommunityMessage", "id": id, "content": content, "sender": sender, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var content: String {
          get {
            return snapshot["content"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "content")
          }
        }

        public var sender: String {
          get {
            return snapshot["sender"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "sender")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }
    }
  }
}

public final class GetEmergencyContactQuery: GraphQLQuery {
  public static let operationString =
    "query GetEmergencyContact($id: ID!) {\n  getEmergencyContact(id: $id) {\n    __typename\n    id\n    name\n    phone\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getEmergencyContact", arguments: ["id": GraphQLVariable("id")], type: .object(GetEmergencyContact.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getEmergencyContact: GetEmergencyContact? = nil) {
      self.init(snapshot: ["__typename": "Query", "getEmergencyContact": getEmergencyContact.flatMap { $0.snapshot }])
    }

    public var getEmergencyContact: GetEmergencyContact? {
      get {
        return (snapshot["getEmergencyContact"] as? Snapshot).flatMap { GetEmergencyContact(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getEmergencyContact")
      }
    }

    public struct GetEmergencyContact: GraphQLSelectionSet {
      public static let possibleTypes = ["EmergencyContact"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("phone", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, phone: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "EmergencyContact", "id": id, "name": name, "phone": phone, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var phone: String {
        get {
          return snapshot["phone"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phone")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class ListEmergencyContactsQuery: GraphQLQuery {
  public static let operationString =
    "query ListEmergencyContacts($filter: ModelEmergencyContactFilterInput, $limit: Int, $nextToken: String) {\n  listEmergencyContacts(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      name\n      phone\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    nextToken\n  }\n}"

  public var filter: ModelEmergencyContactFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelEmergencyContactFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listEmergencyContacts", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListEmergencyContact.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listEmergencyContacts: ListEmergencyContact? = nil) {
      self.init(snapshot: ["__typename": "Query", "listEmergencyContacts": listEmergencyContacts.flatMap { $0.snapshot }])
    }

    public var listEmergencyContacts: ListEmergencyContact? {
      get {
        return (snapshot["listEmergencyContacts"] as? Snapshot).flatMap { ListEmergencyContact(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listEmergencyContacts")
      }
    }

    public struct ListEmergencyContact: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelEmergencyContactConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelEmergencyContactConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["EmergencyContact"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("phone", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String, phone: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "EmergencyContact", "id": id, "name": name, "phone": phone, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var phone: String {
          get {
            return snapshot["phone"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "phone")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }
    }
  }
}

public final class GetAchievementQuery: GraphQLQuery {
  public static let operationString =
    "query GetAchievement($id: ID!) {\n  getAchievement(id: $id) {\n    __typename\n    id\n    title\n    description\n    dateAchieved\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getAchievement", arguments: ["id": GraphQLVariable("id")], type: .object(GetAchievement.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getAchievement: GetAchievement? = nil) {
      self.init(snapshot: ["__typename": "Query", "getAchievement": getAchievement.flatMap { $0.snapshot }])
    }

    public var getAchievement: GetAchievement? {
      get {
        return (snapshot["getAchievement"] as? Snapshot).flatMap { GetAchievement(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getAchievement")
      }
    }

    public struct GetAchievement: GraphQLSelectionSet {
      public static let possibleTypes = ["Achievement"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("description", type: .scalar(String.self)),
        GraphQLField("dateAchieved", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, title: String, description: String? = nil, dateAchieved: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "Achievement", "id": id, "title": title, "description": description, "dateAchieved": dateAchieved, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var description: String? {
        get {
          return snapshot["description"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var dateAchieved: String {
        get {
          return snapshot["dateAchieved"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dateAchieved")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class ListAchievementsQuery: GraphQLQuery {
  public static let operationString =
    "query ListAchievements($filter: ModelAchievementFilterInput, $limit: Int, $nextToken: String) {\n  listAchievements(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      title\n      description\n      dateAchieved\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    nextToken\n  }\n}"

  public var filter: ModelAchievementFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelAchievementFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listAchievements", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListAchievement.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listAchievements: ListAchievement? = nil) {
      self.init(snapshot: ["__typename": "Query", "listAchievements": listAchievements.flatMap { $0.snapshot }])
    }

    public var listAchievements: ListAchievement? {
      get {
        return (snapshot["listAchievements"] as? Snapshot).flatMap { ListAchievement(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listAchievements")
      }
    }

    public struct ListAchievement: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelAchievementConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelAchievementConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Achievement"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("description", type: .scalar(String.self)),
          GraphQLField("dateAchieved", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, title: String, description: String? = nil, dateAchieved: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "Achievement", "id": id, "title": title, "description": description, "dateAchieved": dateAchieved, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var title: String {
          get {
            return snapshot["title"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "title")
          }
        }

        public var description: String? {
          get {
            return snapshot["description"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "description")
          }
        }

        public var dateAchieved: String {
          get {
            return snapshot["dateAchieved"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "dateAchieved")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }
    }
  }
}

public final class GetReminderQuery: GraphQLQuery {
  public static let operationString =
    "query GetReminder($id: ID!) {\n  getReminder(id: $id) {\n    __typename\n    id\n    message\n    time\n    isEnabled\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getReminder", arguments: ["id": GraphQLVariable("id")], type: .object(GetReminder.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getReminder: GetReminder? = nil) {
      self.init(snapshot: ["__typename": "Query", "getReminder": getReminder.flatMap { $0.snapshot }])
    }

    public var getReminder: GetReminder? {
      get {
        return (snapshot["getReminder"] as? Snapshot).flatMap { GetReminder(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getReminder")
      }
    }

    public struct GetReminder: GraphQLSelectionSet {
      public static let possibleTypes = ["Reminder"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("message", type: .nonNull(.scalar(String.self))),
        GraphQLField("time", type: .nonNull(.scalar(String.self))),
        GraphQLField("isEnabled", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, message: String, time: String, isEnabled: Bool, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "Reminder", "id": id, "message": message, "time": time, "isEnabled": isEnabled, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var message: String {
        get {
          return snapshot["message"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "message")
        }
      }

      public var time: String {
        get {
          return snapshot["time"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "time")
        }
      }

      public var isEnabled: Bool {
        get {
          return snapshot["isEnabled"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "isEnabled")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class ListRemindersQuery: GraphQLQuery {
  public static let operationString =
    "query ListReminders($filter: ModelReminderFilterInput, $limit: Int, $nextToken: String) {\n  listReminders(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      message\n      time\n      isEnabled\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    nextToken\n  }\n}"

  public var filter: ModelReminderFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelReminderFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listReminders", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListReminder.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listReminders: ListReminder? = nil) {
      self.init(snapshot: ["__typename": "Query", "listReminders": listReminders.flatMap { $0.snapshot }])
    }

    public var listReminders: ListReminder? {
      get {
        return (snapshot["listReminders"] as? Snapshot).flatMap { ListReminder(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listReminders")
      }
    }

    public struct ListReminder: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelReminderConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelReminderConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Reminder"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("message", type: .nonNull(.scalar(String.self))),
          GraphQLField("time", type: .nonNull(.scalar(String.self))),
          GraphQLField("isEnabled", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, message: String, time: String, isEnabled: Bool, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "Reminder", "id": id, "message": message, "time": time, "isEnabled": isEnabled, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var message: String {
          get {
            return snapshot["message"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "message")
          }
        }

        public var time: String {
          get {
            return snapshot["time"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "time")
          }
        }

        public var isEnabled: Bool {
          get {
            return snapshot["isEnabled"]! as! Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "isEnabled")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }
    }
  }
}

public final class OnCreateGoalSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateGoal($filter: ModelSubscriptionGoalFilterInput) {\n  onCreateGoal(filter: $filter) {\n    __typename\n    id\n    description\n    targetDate\n    reason\n    dailyLimit\n    reward\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionGoalFilterInput?

  public init(filter: ModelSubscriptionGoalFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateGoal", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateGoal.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateGoal: OnCreateGoal? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateGoal": onCreateGoal.flatMap { $0.snapshot }])
    }

    public var onCreateGoal: OnCreateGoal? {
      get {
        return (snapshot["onCreateGoal"] as? Snapshot).flatMap { OnCreateGoal(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateGoal")
      }
    }

    public struct OnCreateGoal: GraphQLSelectionSet {
      public static let possibleTypes = ["Goal"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("description", type: .nonNull(.scalar(String.self))),
        GraphQLField("targetDate", type: .nonNull(.scalar(String.self))),
        GraphQLField("reason", type: .scalar(String.self)),
        GraphQLField("dailyLimit", type: .scalar(Int.self)),
        GraphQLField("reward", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, description: String, targetDate: String, reason: String? = nil, dailyLimit: Int? = nil, reward: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Goal", "id": id, "description": description, "targetDate": targetDate, "reason": reason, "dailyLimit": dailyLimit, "reward": reward, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var description: String {
        get {
          return snapshot["description"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var targetDate: String {
        get {
          return snapshot["targetDate"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "targetDate")
        }
      }

      public var reason: String? {
        get {
          return snapshot["reason"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "reason")
        }
      }

      public var dailyLimit: Int? {
        get {
          return snapshot["dailyLimit"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "dailyLimit")
        }
      }

      public var reward: String? {
        get {
          return snapshot["reward"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "reward")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnUpdateGoalSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateGoal($filter: ModelSubscriptionGoalFilterInput) {\n  onUpdateGoal(filter: $filter) {\n    __typename\n    id\n    description\n    targetDate\n    reason\n    dailyLimit\n    reward\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionGoalFilterInput?

  public init(filter: ModelSubscriptionGoalFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateGoal", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateGoal.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateGoal: OnUpdateGoal? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateGoal": onUpdateGoal.flatMap { $0.snapshot }])
    }

    public var onUpdateGoal: OnUpdateGoal? {
      get {
        return (snapshot["onUpdateGoal"] as? Snapshot).flatMap { OnUpdateGoal(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateGoal")
      }
    }

    public struct OnUpdateGoal: GraphQLSelectionSet {
      public static let possibleTypes = ["Goal"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("description", type: .nonNull(.scalar(String.self))),
        GraphQLField("targetDate", type: .nonNull(.scalar(String.self))),
        GraphQLField("reason", type: .scalar(String.self)),
        GraphQLField("dailyLimit", type: .scalar(Int.self)),
        GraphQLField("reward", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, description: String, targetDate: String, reason: String? = nil, dailyLimit: Int? = nil, reward: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Goal", "id": id, "description": description, "targetDate": targetDate, "reason": reason, "dailyLimit": dailyLimit, "reward": reward, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var description: String {
        get {
          return snapshot["description"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var targetDate: String {
        get {
          return snapshot["targetDate"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "targetDate")
        }
      }

      public var reason: String? {
        get {
          return snapshot["reason"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "reason")
        }
      }

      public var dailyLimit: Int? {
        get {
          return snapshot["dailyLimit"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "dailyLimit")
        }
      }

      public var reward: String? {
        get {
          return snapshot["reward"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "reward")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnDeleteGoalSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteGoal($filter: ModelSubscriptionGoalFilterInput) {\n  onDeleteGoal(filter: $filter) {\n    __typename\n    id\n    description\n    targetDate\n    reason\n    dailyLimit\n    reward\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionGoalFilterInput?

  public init(filter: ModelSubscriptionGoalFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteGoal", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteGoal.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteGoal: OnDeleteGoal? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteGoal": onDeleteGoal.flatMap { $0.snapshot }])
    }

    public var onDeleteGoal: OnDeleteGoal? {
      get {
        return (snapshot["onDeleteGoal"] as? Snapshot).flatMap { OnDeleteGoal(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteGoal")
      }
    }

    public struct OnDeleteGoal: GraphQLSelectionSet {
      public static let possibleTypes = ["Goal"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("description", type: .nonNull(.scalar(String.self))),
        GraphQLField("targetDate", type: .nonNull(.scalar(String.self))),
        GraphQLField("reason", type: .scalar(String.self)),
        GraphQLField("dailyLimit", type: .scalar(Int.self)),
        GraphQLField("reward", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, description: String, targetDate: String, reason: String? = nil, dailyLimit: Int? = nil, reward: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Goal", "id": id, "description": description, "targetDate": targetDate, "reason": reason, "dailyLimit": dailyLimit, "reward": reward, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var description: String {
        get {
          return snapshot["description"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var targetDate: String {
        get {
          return snapshot["targetDate"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "targetDate")
        }
      }

      public var reason: String? {
        get {
          return snapshot["reason"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "reason")
        }
      }

      public var dailyLimit: Int? {
        get {
          return snapshot["dailyLimit"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "dailyLimit")
        }
      }

      public var reward: String? {
        get {
          return snapshot["reward"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "reward")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnCreateDrinkRecordSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateDrinkRecord($filter: ModelSubscriptionDrinkRecordFilterInput) {\n  onCreateDrinkRecord(filter: $filter) {\n    __typename\n    id\n    details\n    amount\n    content\n    feeling\n    location\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionDrinkRecordFilterInput?

  public init(filter: ModelSubscriptionDrinkRecordFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateDrinkRecord", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateDrinkRecord.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateDrinkRecord: OnCreateDrinkRecord? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateDrinkRecord": onCreateDrinkRecord.flatMap { $0.snapshot }])
    }

    public var onCreateDrinkRecord: OnCreateDrinkRecord? {
      get {
        return (snapshot["onCreateDrinkRecord"] as? Snapshot).flatMap { OnCreateDrinkRecord(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateDrinkRecord")
      }
    }

    public struct OnCreateDrinkRecord: GraphQLSelectionSet {
      public static let possibleTypes = ["DrinkRecord"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("details", type: .nonNull(.scalar(String.self))),
        GraphQLField("amount", type: .nonNull(.scalar(Int.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("feeling", type: .nonNull(.scalar(String.self))),
        GraphQLField("location", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, details: String, amount: Int, content: String, feeling: String, location: String? = nil, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "DrinkRecord", "id": id, "details": details, "amount": amount, "content": content, "feeling": feeling, "location": location, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var details: String {
        get {
          return snapshot["details"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "details")
        }
      }

      public var amount: Int {
        get {
          return snapshot["amount"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "amount")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var feeling: String {
        get {
          return snapshot["feeling"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "feeling")
        }
      }

      public var location: String? {
        get {
          return snapshot["location"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "location")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnUpdateDrinkRecordSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateDrinkRecord($filter: ModelSubscriptionDrinkRecordFilterInput) {\n  onUpdateDrinkRecord(filter: $filter) {\n    __typename\n    id\n    details\n    amount\n    content\n    feeling\n    location\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionDrinkRecordFilterInput?

  public init(filter: ModelSubscriptionDrinkRecordFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateDrinkRecord", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateDrinkRecord.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateDrinkRecord: OnUpdateDrinkRecord? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateDrinkRecord": onUpdateDrinkRecord.flatMap { $0.snapshot }])
    }

    public var onUpdateDrinkRecord: OnUpdateDrinkRecord? {
      get {
        return (snapshot["onUpdateDrinkRecord"] as? Snapshot).flatMap { OnUpdateDrinkRecord(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateDrinkRecord")
      }
    }

    public struct OnUpdateDrinkRecord: GraphQLSelectionSet {
      public static let possibleTypes = ["DrinkRecord"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("details", type: .nonNull(.scalar(String.self))),
        GraphQLField("amount", type: .nonNull(.scalar(Int.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("feeling", type: .nonNull(.scalar(String.self))),
        GraphQLField("location", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, details: String, amount: Int, content: String, feeling: String, location: String? = nil, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "DrinkRecord", "id": id, "details": details, "amount": amount, "content": content, "feeling": feeling, "location": location, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var details: String {
        get {
          return snapshot["details"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "details")
        }
      }

      public var amount: Int {
        get {
          return snapshot["amount"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "amount")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var feeling: String {
        get {
          return snapshot["feeling"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "feeling")
        }
      }

      public var location: String? {
        get {
          return snapshot["location"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "location")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnDeleteDrinkRecordSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteDrinkRecord($filter: ModelSubscriptionDrinkRecordFilterInput) {\n  onDeleteDrinkRecord(filter: $filter) {\n    __typename\n    id\n    details\n    amount\n    content\n    feeling\n    location\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionDrinkRecordFilterInput?

  public init(filter: ModelSubscriptionDrinkRecordFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteDrinkRecord", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteDrinkRecord.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteDrinkRecord: OnDeleteDrinkRecord? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteDrinkRecord": onDeleteDrinkRecord.flatMap { $0.snapshot }])
    }

    public var onDeleteDrinkRecord: OnDeleteDrinkRecord? {
      get {
        return (snapshot["onDeleteDrinkRecord"] as? Snapshot).flatMap { OnDeleteDrinkRecord(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteDrinkRecord")
      }
    }

    public struct OnDeleteDrinkRecord: GraphQLSelectionSet {
      public static let possibleTypes = ["DrinkRecord"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("details", type: .nonNull(.scalar(String.self))),
        GraphQLField("amount", type: .nonNull(.scalar(Int.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("feeling", type: .nonNull(.scalar(String.self))),
        GraphQLField("location", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, details: String, amount: Int, content: String, feeling: String, location: String? = nil, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "DrinkRecord", "id": id, "details": details, "amount": amount, "content": content, "feeling": feeling, "location": location, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var details: String {
        get {
          return snapshot["details"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "details")
        }
      }

      public var amount: Int {
        get {
          return snapshot["amount"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "amount")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var feeling: String {
        get {
          return snapshot["feeling"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "feeling")
        }
      }

      public var location: String? {
        get {
          return snapshot["location"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "location")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnCreateDiaryEntrySubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateDiaryEntry($filter: ModelSubscriptionDiaryEntryFilterInput) {\n  onCreateDiaryEntry(filter: $filter) {\n    __typename\n    id\n    content\n    feeling\n    date\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionDiaryEntryFilterInput?

  public init(filter: ModelSubscriptionDiaryEntryFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateDiaryEntry", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateDiaryEntry.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateDiaryEntry: OnCreateDiaryEntry? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateDiaryEntry": onCreateDiaryEntry.flatMap { $0.snapshot }])
    }

    public var onCreateDiaryEntry: OnCreateDiaryEntry? {
      get {
        return (snapshot["onCreateDiaryEntry"] as? Snapshot).flatMap { OnCreateDiaryEntry(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateDiaryEntry")
      }
    }

    public struct OnCreateDiaryEntry: GraphQLSelectionSet {
      public static let possibleTypes = ["DiaryEntry"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("feeling", type: .nonNull(.scalar(String.self))),
        GraphQLField("date", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, content: String, feeling: String, date: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "DiaryEntry", "id": id, "content": content, "feeling": feeling, "date": date, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var feeling: String {
        get {
          return snapshot["feeling"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "feeling")
        }
      }

      public var date: String {
        get {
          return snapshot["date"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "date")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnUpdateDiaryEntrySubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateDiaryEntry($filter: ModelSubscriptionDiaryEntryFilterInput) {\n  onUpdateDiaryEntry(filter: $filter) {\n    __typename\n    id\n    content\n    feeling\n    date\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionDiaryEntryFilterInput?

  public init(filter: ModelSubscriptionDiaryEntryFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateDiaryEntry", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateDiaryEntry.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateDiaryEntry: OnUpdateDiaryEntry? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateDiaryEntry": onUpdateDiaryEntry.flatMap { $0.snapshot }])
    }

    public var onUpdateDiaryEntry: OnUpdateDiaryEntry? {
      get {
        return (snapshot["onUpdateDiaryEntry"] as? Snapshot).flatMap { OnUpdateDiaryEntry(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateDiaryEntry")
      }
    }

    public struct OnUpdateDiaryEntry: GraphQLSelectionSet {
      public static let possibleTypes = ["DiaryEntry"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("feeling", type: .nonNull(.scalar(String.self))),
        GraphQLField("date", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, content: String, feeling: String, date: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "DiaryEntry", "id": id, "content": content, "feeling": feeling, "date": date, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var feeling: String {
        get {
          return snapshot["feeling"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "feeling")
        }
      }

      public var date: String {
        get {
          return snapshot["date"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "date")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnDeleteDiaryEntrySubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteDiaryEntry($filter: ModelSubscriptionDiaryEntryFilterInput) {\n  onDeleteDiaryEntry(filter: $filter) {\n    __typename\n    id\n    content\n    feeling\n    date\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionDiaryEntryFilterInput?

  public init(filter: ModelSubscriptionDiaryEntryFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteDiaryEntry", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteDiaryEntry.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteDiaryEntry: OnDeleteDiaryEntry? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteDiaryEntry": onDeleteDiaryEntry.flatMap { $0.snapshot }])
    }

    public var onDeleteDiaryEntry: OnDeleteDiaryEntry? {
      get {
        return (snapshot["onDeleteDiaryEntry"] as? Snapshot).flatMap { OnDeleteDiaryEntry(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteDiaryEntry")
      }
    }

    public struct OnDeleteDiaryEntry: GraphQLSelectionSet {
      public static let possibleTypes = ["DiaryEntry"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("feeling", type: .nonNull(.scalar(String.self))),
        GraphQLField("date", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, content: String, feeling: String, date: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "DiaryEntry", "id": id, "content": content, "feeling": feeling, "date": date, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var feeling: String {
        get {
          return snapshot["feeling"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "feeling")
        }
      }

      public var date: String {
        get {
          return snapshot["date"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "date")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnCreateCommunityMessageSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateCommunityMessage($filter: ModelSubscriptionCommunityMessageFilterInput) {\n  onCreateCommunityMessage(filter: $filter) {\n    __typename\n    id\n    content\n    sender\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionCommunityMessageFilterInput?

  public init(filter: ModelSubscriptionCommunityMessageFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateCommunityMessage", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateCommunityMessage.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateCommunityMessage: OnCreateCommunityMessage? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateCommunityMessage": onCreateCommunityMessage.flatMap { $0.snapshot }])
    }

    public var onCreateCommunityMessage: OnCreateCommunityMessage? {
      get {
        return (snapshot["onCreateCommunityMessage"] as? Snapshot).flatMap { OnCreateCommunityMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateCommunityMessage")
      }
    }

    public struct OnCreateCommunityMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["CommunityMessage"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("sender", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, content: String, sender: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "CommunityMessage", "id": id, "content": content, "sender": sender, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var sender: String {
        get {
          return snapshot["sender"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "sender")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnUpdateCommunityMessageSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateCommunityMessage($filter: ModelSubscriptionCommunityMessageFilterInput) {\n  onUpdateCommunityMessage(filter: $filter) {\n    __typename\n    id\n    content\n    sender\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionCommunityMessageFilterInput?

  public init(filter: ModelSubscriptionCommunityMessageFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateCommunityMessage", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateCommunityMessage.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateCommunityMessage: OnUpdateCommunityMessage? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateCommunityMessage": onUpdateCommunityMessage.flatMap { $0.snapshot }])
    }

    public var onUpdateCommunityMessage: OnUpdateCommunityMessage? {
      get {
        return (snapshot["onUpdateCommunityMessage"] as? Snapshot).flatMap { OnUpdateCommunityMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateCommunityMessage")
      }
    }

    public struct OnUpdateCommunityMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["CommunityMessage"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("sender", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, content: String, sender: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "CommunityMessage", "id": id, "content": content, "sender": sender, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var sender: String {
        get {
          return snapshot["sender"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "sender")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnDeleteCommunityMessageSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteCommunityMessage($filter: ModelSubscriptionCommunityMessageFilterInput) {\n  onDeleteCommunityMessage(filter: $filter) {\n    __typename\n    id\n    content\n    sender\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionCommunityMessageFilterInput?

  public init(filter: ModelSubscriptionCommunityMessageFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteCommunityMessage", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteCommunityMessage.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteCommunityMessage: OnDeleteCommunityMessage? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteCommunityMessage": onDeleteCommunityMessage.flatMap { $0.snapshot }])
    }

    public var onDeleteCommunityMessage: OnDeleteCommunityMessage? {
      get {
        return (snapshot["onDeleteCommunityMessage"] as? Snapshot).flatMap { OnDeleteCommunityMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteCommunityMessage")
      }
    }

    public struct OnDeleteCommunityMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["CommunityMessage"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("sender", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, content: String, sender: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "CommunityMessage", "id": id, "content": content, "sender": sender, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var sender: String {
        get {
          return snapshot["sender"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "sender")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnCreateEmergencyContactSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateEmergencyContact($filter: ModelSubscriptionEmergencyContactFilterInput) {\n  onCreateEmergencyContact(filter: $filter) {\n    __typename\n    id\n    name\n    phone\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionEmergencyContactFilterInput?

  public init(filter: ModelSubscriptionEmergencyContactFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateEmergencyContact", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateEmergencyContact.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateEmergencyContact: OnCreateEmergencyContact? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateEmergencyContact": onCreateEmergencyContact.flatMap { $0.snapshot }])
    }

    public var onCreateEmergencyContact: OnCreateEmergencyContact? {
      get {
        return (snapshot["onCreateEmergencyContact"] as? Snapshot).flatMap { OnCreateEmergencyContact(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateEmergencyContact")
      }
    }

    public struct OnCreateEmergencyContact: GraphQLSelectionSet {
      public static let possibleTypes = ["EmergencyContact"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("phone", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, phone: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "EmergencyContact", "id": id, "name": name, "phone": phone, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var phone: String {
        get {
          return snapshot["phone"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phone")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnUpdateEmergencyContactSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateEmergencyContact($filter: ModelSubscriptionEmergencyContactFilterInput) {\n  onUpdateEmergencyContact(filter: $filter) {\n    __typename\n    id\n    name\n    phone\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionEmergencyContactFilterInput?

  public init(filter: ModelSubscriptionEmergencyContactFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateEmergencyContact", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateEmergencyContact.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateEmergencyContact: OnUpdateEmergencyContact? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateEmergencyContact": onUpdateEmergencyContact.flatMap { $0.snapshot }])
    }

    public var onUpdateEmergencyContact: OnUpdateEmergencyContact? {
      get {
        return (snapshot["onUpdateEmergencyContact"] as? Snapshot).flatMap { OnUpdateEmergencyContact(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateEmergencyContact")
      }
    }

    public struct OnUpdateEmergencyContact: GraphQLSelectionSet {
      public static let possibleTypes = ["EmergencyContact"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("phone", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, phone: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "EmergencyContact", "id": id, "name": name, "phone": phone, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var phone: String {
        get {
          return snapshot["phone"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phone")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnDeleteEmergencyContactSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteEmergencyContact($filter: ModelSubscriptionEmergencyContactFilterInput) {\n  onDeleteEmergencyContact(filter: $filter) {\n    __typename\n    id\n    name\n    phone\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionEmergencyContactFilterInput?

  public init(filter: ModelSubscriptionEmergencyContactFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteEmergencyContact", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteEmergencyContact.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteEmergencyContact: OnDeleteEmergencyContact? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteEmergencyContact": onDeleteEmergencyContact.flatMap { $0.snapshot }])
    }

    public var onDeleteEmergencyContact: OnDeleteEmergencyContact? {
      get {
        return (snapshot["onDeleteEmergencyContact"] as? Snapshot).flatMap { OnDeleteEmergencyContact(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteEmergencyContact")
      }
    }

    public struct OnDeleteEmergencyContact: GraphQLSelectionSet {
      public static let possibleTypes = ["EmergencyContact"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("phone", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, phone: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "EmergencyContact", "id": id, "name": name, "phone": phone, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var phone: String {
        get {
          return snapshot["phone"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phone")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnCreateAchievementSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateAchievement($filter: ModelSubscriptionAchievementFilterInput) {\n  onCreateAchievement(filter: $filter) {\n    __typename\n    id\n    title\n    description\n    dateAchieved\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionAchievementFilterInput?

  public init(filter: ModelSubscriptionAchievementFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateAchievement", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateAchievement.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateAchievement: OnCreateAchievement? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateAchievement": onCreateAchievement.flatMap { $0.snapshot }])
    }

    public var onCreateAchievement: OnCreateAchievement? {
      get {
        return (snapshot["onCreateAchievement"] as? Snapshot).flatMap { OnCreateAchievement(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateAchievement")
      }
    }

    public struct OnCreateAchievement: GraphQLSelectionSet {
      public static let possibleTypes = ["Achievement"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("description", type: .scalar(String.self)),
        GraphQLField("dateAchieved", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, title: String, description: String? = nil, dateAchieved: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "Achievement", "id": id, "title": title, "description": description, "dateAchieved": dateAchieved, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var description: String? {
        get {
          return snapshot["description"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var dateAchieved: String {
        get {
          return snapshot["dateAchieved"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dateAchieved")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnUpdateAchievementSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateAchievement($filter: ModelSubscriptionAchievementFilterInput) {\n  onUpdateAchievement(filter: $filter) {\n    __typename\n    id\n    title\n    description\n    dateAchieved\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionAchievementFilterInput?

  public init(filter: ModelSubscriptionAchievementFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateAchievement", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateAchievement.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateAchievement: OnUpdateAchievement? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateAchievement": onUpdateAchievement.flatMap { $0.snapshot }])
    }

    public var onUpdateAchievement: OnUpdateAchievement? {
      get {
        return (snapshot["onUpdateAchievement"] as? Snapshot).flatMap { OnUpdateAchievement(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateAchievement")
      }
    }

    public struct OnUpdateAchievement: GraphQLSelectionSet {
      public static let possibleTypes = ["Achievement"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("description", type: .scalar(String.self)),
        GraphQLField("dateAchieved", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, title: String, description: String? = nil, dateAchieved: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "Achievement", "id": id, "title": title, "description": description, "dateAchieved": dateAchieved, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var description: String? {
        get {
          return snapshot["description"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var dateAchieved: String {
        get {
          return snapshot["dateAchieved"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dateAchieved")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnDeleteAchievementSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteAchievement($filter: ModelSubscriptionAchievementFilterInput) {\n  onDeleteAchievement(filter: $filter) {\n    __typename\n    id\n    title\n    description\n    dateAchieved\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionAchievementFilterInput?

  public init(filter: ModelSubscriptionAchievementFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteAchievement", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteAchievement.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteAchievement: OnDeleteAchievement? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteAchievement": onDeleteAchievement.flatMap { $0.snapshot }])
    }

    public var onDeleteAchievement: OnDeleteAchievement? {
      get {
        return (snapshot["onDeleteAchievement"] as? Snapshot).flatMap { OnDeleteAchievement(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteAchievement")
      }
    }

    public struct OnDeleteAchievement: GraphQLSelectionSet {
      public static let possibleTypes = ["Achievement"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("description", type: .scalar(String.self)),
        GraphQLField("dateAchieved", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, title: String, description: String? = nil, dateAchieved: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "Achievement", "id": id, "title": title, "description": description, "dateAchieved": dateAchieved, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var description: String? {
        get {
          return snapshot["description"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var dateAchieved: String {
        get {
          return snapshot["dateAchieved"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dateAchieved")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnCreateReminderSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateReminder($filter: ModelSubscriptionReminderFilterInput) {\n  onCreateReminder(filter: $filter) {\n    __typename\n    id\n    message\n    time\n    isEnabled\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionReminderFilterInput?

  public init(filter: ModelSubscriptionReminderFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateReminder", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateReminder.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateReminder: OnCreateReminder? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateReminder": onCreateReminder.flatMap { $0.snapshot }])
    }

    public var onCreateReminder: OnCreateReminder? {
      get {
        return (snapshot["onCreateReminder"] as? Snapshot).flatMap { OnCreateReminder(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateReminder")
      }
    }

    public struct OnCreateReminder: GraphQLSelectionSet {
      public static let possibleTypes = ["Reminder"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("message", type: .nonNull(.scalar(String.self))),
        GraphQLField("time", type: .nonNull(.scalar(String.self))),
        GraphQLField("isEnabled", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, message: String, time: String, isEnabled: Bool, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "Reminder", "id": id, "message": message, "time": time, "isEnabled": isEnabled, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var message: String {
        get {
          return snapshot["message"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "message")
        }
      }

      public var time: String {
        get {
          return snapshot["time"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "time")
        }
      }

      public var isEnabled: Bool {
        get {
          return snapshot["isEnabled"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "isEnabled")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnUpdateReminderSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateReminder($filter: ModelSubscriptionReminderFilterInput) {\n  onUpdateReminder(filter: $filter) {\n    __typename\n    id\n    message\n    time\n    isEnabled\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionReminderFilterInput?

  public init(filter: ModelSubscriptionReminderFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateReminder", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateReminder.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateReminder: OnUpdateReminder? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateReminder": onUpdateReminder.flatMap { $0.snapshot }])
    }

    public var onUpdateReminder: OnUpdateReminder? {
      get {
        return (snapshot["onUpdateReminder"] as? Snapshot).flatMap { OnUpdateReminder(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateReminder")
      }
    }

    public struct OnUpdateReminder: GraphQLSelectionSet {
      public static let possibleTypes = ["Reminder"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("message", type: .nonNull(.scalar(String.self))),
        GraphQLField("time", type: .nonNull(.scalar(String.self))),
        GraphQLField("isEnabled", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, message: String, time: String, isEnabled: Bool, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "Reminder", "id": id, "message": message, "time": time, "isEnabled": isEnabled, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var message: String {
        get {
          return snapshot["message"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "message")
        }
      }

      public var time: String {
        get {
          return snapshot["time"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "time")
        }
      }

      public var isEnabled: Bool {
        get {
          return snapshot["isEnabled"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "isEnabled")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnDeleteReminderSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteReminder($filter: ModelSubscriptionReminderFilterInput) {\n  onDeleteReminder(filter: $filter) {\n    __typename\n    id\n    message\n    time\n    isEnabled\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionReminderFilterInput?

  public init(filter: ModelSubscriptionReminderFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteReminder", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteReminder.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteReminder: OnDeleteReminder? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteReminder": onDeleteReminder.flatMap { $0.snapshot }])
    }

    public var onDeleteReminder: OnDeleteReminder? {
      get {
        return (snapshot["onDeleteReminder"] as? Snapshot).flatMap { OnDeleteReminder(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteReminder")
      }
    }

    public struct OnDeleteReminder: GraphQLSelectionSet {
      public static let possibleTypes = ["Reminder"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("message", type: .nonNull(.scalar(String.self))),
        GraphQLField("time", type: .nonNull(.scalar(String.self))),
        GraphQLField("isEnabled", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, message: String, time: String, isEnabled: Bool, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "Reminder", "id": id, "message": message, "time": time, "isEnabled": isEnabled, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var message: String {
        get {
          return snapshot["message"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "message")
        }
      }

      public var time: String {
        get {
          return snapshot["time"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "time")
        }
      }

      public var isEnabled: Bool {
        get {
          return snapshot["isEnabled"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "isEnabled")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}