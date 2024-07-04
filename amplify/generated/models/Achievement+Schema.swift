// swiftlint:disable all
import Amplify
import Foundation

extension Achievement {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case title
    case description
    case dateAchieved
    case createdAt
    case updatedAt
    case _version
    case _deleted
    case _lastChangedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let achievement = Achievement.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Achievements"
    model.syncPluralName = "Achievements"
    
    model.attributes(
      .primaryKey(fields: [achievement.id])
    )
    
    model.fields(
      .field(achievement.id, is: .required, ofType: .string),
      .field(achievement.title, is: .required, ofType: .string),
      .field(achievement.description, is: .optional, ofType: .string),
      .field(achievement.dateAchieved, is: .required, ofType: .date),
      .field(achievement.createdAt, is: .required, ofType: .dateTime),
      .field(achievement.updatedAt, is: .required, ofType: .dateTime),
      .field(achievement._version, is: .required, ofType: .int),
      .field(achievement._deleted, is: .optional, ofType: .bool),
      .field(achievement._lastChangedAt, is: .required, ofType: .int)
    )
    }
}

extension Achievement: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}