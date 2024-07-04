// swiftlint:disable all
import Amplify
import Foundation

public struct DrinkRecord: Model {
  public let id: String
  public var details: String
  public var amount: Int
  public var content: String
  public var feeling: String
  public var location: String?
  public var createdAt: Temporal.DateTime
  public var updatedAt: Temporal.DateTime
  public var _version: Int
  public var _deleted: Bool?
  public var _lastChangedAt: Int
  
  public init(id: String = UUID().uuidString,
      details: String,
      amount: Int,
      content: String,
      feeling: String,
      location: String? = nil,
      createdAt: Temporal.DateTime,
      updatedAt: Temporal.DateTime,
      _version: Int,
      _deleted: Bool? = nil,
      _lastChangedAt: Int) {
      self.id = id
      self.details = details
      self.amount = amount
      self.content = content
      self.feeling = feeling
      self.location = location
      self.createdAt = createdAt
      self.updatedAt = updatedAt
      self._version = _version
      self._deleted = _deleted
      self._lastChangedAt = _lastChangedAt
  }
}