// swiftlint:disable all
import Amplify
import Foundation

extension CommunityMessage {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case content
    case sender
    case createdAt
    case updatedAt
    case _version
    case _deleted
    case _lastChangedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let communityMessage = CommunityMessage.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "CommunityMessages"
    model.syncPluralName = "CommunityMessages"
    
    model.attributes(
      .primaryKey(fields: [communityMessage.id])
    )
    
    model.fields(
      .field(communityMessage.id, is: .required, ofType: .string),
      .field(communityMessage.content, is: .required, ofType: .string),
      .field(communityMessage.sender, is: .required, ofType: .string),
      .field(communityMessage.createdAt, is: .required, ofType: .dateTime),
      .field(communityMessage.updatedAt, is: .required, ofType: .dateTime),
      .field(communityMessage._version, is: .required, ofType: .int),
      .field(communityMessage._deleted, is: .optional, ofType: .bool),
      .field(communityMessage._lastChangedAt, is: .required, ofType: .int)
    )
    }
}

extension CommunityMessage: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}