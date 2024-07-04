// swiftlint:disable all
import Amplify
import Foundation

public struct Achievement: Model {
  public let id: String
  public var title: String
  public var description: String?
  public var dateAchieved: Temporal.Date
  public var createdAt: Temporal.DateTime
  public var updatedAt: Temporal.DateTime
  public var _version: Int
  public var _deleted: Bool?
  public var _lastChangedAt: Int
  
  public init(id: String = UUID().uuidString,
      title: String,
      description: String? = nil,
      dateAchieved: Temporal.Date,
      createdAt: Temporal.DateTime,
      updatedAt: Temporal.DateTime,
      _version: Int,
      _deleted: Bool? = nil,
      _lastChangedAt: Int) {
      self.id = id
      self.title = title
      self.description = description
      self.dateAchieved = dateAchieved
      self.createdAt = createdAt
      self.updatedAt = updatedAt
      self._version = _version
      self._deleted = _deleted
      self._lastChangedAt = _lastChangedAt
  }
}