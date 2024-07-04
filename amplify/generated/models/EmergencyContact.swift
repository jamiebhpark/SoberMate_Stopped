// swiftlint:disable all
import Amplify
import Foundation

public struct EmergencyContact: Model {
  public let id: String
  public var name: String
  public var phone: String
  public var createdAt: Temporal.DateTime
  public var updatedAt: Temporal.DateTime
  public var _version: Int
  public var _deleted: Bool?
  public var _lastChangedAt: Int
  
  public init(id: String = UUID().uuidString,
      name: String,
      phone: String,
      createdAt: Temporal.DateTime,
      updatedAt: Temporal.DateTime,
      _version: Int,
      _deleted: Bool? = nil,
      _lastChangedAt: Int) {
      self.id = id
      self.name = name
      self.phone = phone
      self.createdAt = createdAt
      self.updatedAt = updatedAt
      self._version = _version
      self._deleted = _deleted
      self._lastChangedAt = _lastChangedAt
  }
}