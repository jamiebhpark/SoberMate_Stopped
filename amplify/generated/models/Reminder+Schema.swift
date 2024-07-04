// swiftlint:disable all
import Amplify
import Foundation

extension Reminder {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case message
    case time
    case isEnabled
    case createdAt
    case updatedAt
    case _version
    case _deleted
    case _lastChangedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let reminder = Reminder.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Reminders"
    model.syncPluralName = "Reminders"
    
    model.attributes(
      .primaryKey(fields: [reminder.id])
    )
    
    model.fields(
      .field(reminder.id, is: .required, ofType: .string),
      .field(reminder.message, is: .required, ofType: .string),
      .field(reminder.time, is: .required, ofType: .dateTime),
      .field(reminder.isEnabled, is: .required, ofType: .bool),
      .field(reminder.createdAt, is: .required, ofType: .dateTime),
      .field(reminder.updatedAt, is: .required, ofType: .dateTime),
      .field(reminder._version, is: .required, ofType: .int),
      .field(reminder._deleted, is: .optional, ofType: .bool),
      .field(reminder._lastChangedAt, is: .required, ofType: .int)
    )
    }
}

extension Reminder: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}