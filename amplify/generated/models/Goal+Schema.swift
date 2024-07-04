// swiftlint:disable all
import Amplify
import Foundation

extension Goal {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case description
    case targetDate
    case reason
    case dailyLimit
    case reward
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let goal = Goal.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Goals"
    model.syncPluralName = "Goals"
    
    model.attributes(
      .primaryKey(fields: [goal.id])
    )
    
    model.fields(
      .field(goal.id, is: .required, ofType: .string),
      .field(goal.description, is: .required, ofType: .string),
      .field(goal.targetDate, is: .required, ofType: .date),
      .field(goal.reason, is: .optional, ofType: .string),
      .field(goal.dailyLimit, is: .optional, ofType: .int),
      .field(goal.reward, is: .optional, ofType: .string),
      .field(goal.createdAt, is: .required, ofType: .dateTime),
      .field(goal.updatedAt, is: .required, ofType: .dateTime)
    )
    }
}

extension Goal: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}