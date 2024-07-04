// swiftlint:disable all
import Amplify
import Foundation

public struct DiaryEntry: Model {
  public let id: String
  public var content: String
  public var feeling: String
  public var date: Temporal.Date
  public var createdAt: Temporal.DateTime
  public var updatedAt: Temporal.DateTime
  public var _version: Int
  public var _deleted: Bool?
  public var _lastChangedAt: Int
  
  public init(id: String = UUID().uuidString,
      content: String,
      feeling: String,
      date: Temporal.Date,
      createdAt: Temporal.DateTime,
      updatedAt: Temporal.DateTime,
      _version: Int,
      _deleted: Bool? = nil,
      _lastChangedAt: Int) {
      self.id = id
      self.content = content
      self.feeling = feeling
      self.date = date
      self.createdAt = createdAt
      self.updatedAt = updatedAt
      self._version = _version
      self._deleted = _deleted
      self._lastChangedAt = _lastChangedAt
  }
}