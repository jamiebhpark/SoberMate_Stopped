// swiftlint:disable all
import Amplify
import Foundation

public struct Reminder: Model {
  public let id: String
  public var message: String
  public var time: Temporal.DateTime
  public var isEnabled: Bool
  public var createdAt: Temporal.DateTime
  public var updatedAt: Temporal.DateTime
  public var _version: Int
  public var _deleted: Bool?
  public var _lastChangedAt: Int
  
  public init(id: String = UUID().uuidString,
      message: String,
      time: Temporal.DateTime,
      isEnabled: Bool,
      createdAt: Temporal.DateTime,
      updatedAt: Temporal.DateTime,
      _version: Int,
      _deleted: Bool? = nil,
      _lastChangedAt: Int) {
      self.id = id
      self.message = message
      self.time = time
      self.isEnabled = isEnabled
      self.createdAt = createdAt
      self.updatedAt = updatedAt
      self._version = _version
      self._deleted = _deleted
      self._lastChangedAt = _lastChangedAt
  }
}