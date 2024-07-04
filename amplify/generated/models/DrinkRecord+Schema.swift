// swiftlint:disable all
import Amplify
import Foundation

extension DrinkRecord {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case details
    case amount
    case content
    case feeling
    case location
    case createdAt
    case updatedAt
    case _version
    case _deleted
    case _lastChangedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let drinkRecord = DrinkRecord.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "DrinkRecords"
    model.syncPluralName = "DrinkRecords"
    
    model.attributes(
      .primaryKey(fields: [drinkRecord.id])
    )
    
    model.fields(
      .field(drinkRecord.id, is: .required, ofType: .string),
      .field(drinkRecord.details, is: .required, ofType: .string),
      .field(drinkRecord.amount, is: .required, ofType: .int),
      .field(drinkRecord.content, is: .required, ofType: .string),
      .field(drinkRecord.feeling, is: .required, ofType: .string),
      .field(drinkRecord.location, is: .optional, ofType: .string),
      .field(drinkRecord.createdAt, is: .required, ofType: .dateTime),
      .field(drinkRecord.updatedAt, is: .required, ofType: .dateTime),
      .field(drinkRecord._version, is: .required, ofType: .int),
      .field(drinkRecord._deleted, is: .optional, ofType: .bool),
      .field(drinkRecord._lastChangedAt, is: .required, ofType: .int)
    )
    }
}

extension DrinkRecord: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}