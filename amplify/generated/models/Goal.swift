// swiftlint:disable all
import Amplify
import Foundation

public struct Goal: Model {
  public let id: String
  public var description: String
  public var targetDate: Temporal.Date
  public var reason: String?
  public var dailyLimit: Int?
  public var reward: String?
  public var createdAt: Temporal.DateTime
  public var updatedAt: Temporal.DateTime
  
  public init(id: String = UUID().uuidString,
      description: String,
      targetDate: Temporal.Date,
      reason: String? = nil,
      dailyLimit: Int? = nil,
      reward: String? = nil,
      createdAt: Temporal.DateTime,
      updatedAt: Temporal.DateTime) {
      self.id = id
      self.description = description
      self.targetDate = targetDate
      self.reason = reason
      self.dailyLimit = dailyLimit
      self.reward = reward
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}