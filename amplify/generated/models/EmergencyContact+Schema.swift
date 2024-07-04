// swiftlint:disable all
import Amplify
import Foundation

extension EmergencyContact {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case name
    case phone
    case createdAt
    case updatedAt
    case _version
    case _deleted
    case _lastChangedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let emergencyContact = EmergencyContact.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "EmergencyContacts"
    model.syncPluralName = "EmergencyContacts"
    
    model.attributes(
      .primaryKey(fields: [emergencyContact.id])
    )
    
    model.fields(
      .field(emergencyContact.id, is: .required, ofType: .string),
      .field(emergencyContact.name, is: .required, ofType: .string),
      .field(emergencyContact.phone, is: .required, ofType: .string),
      .field(emergencyContact.createdAt, is: .required, ofType: .dateTime),
      .field(emergencyContact.updatedAt, is: .required, ofType: .dateTime),
      .field(emergencyContact._version, is: .required, ofType: .int),
      .field(emergencyContact._deleted, is: .optional, ofType: .bool),
      .field(emergencyContact._lastChangedAt, is: .required, ofType: .int)
    )
    }
}

extension EmergencyContact: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}