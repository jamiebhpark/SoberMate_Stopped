// swiftlint:disable all
import Amplify
import Foundation

extension DiaryEntry {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case content
    case feeling
    case date
    case createdAt
    case updatedAt
    case _version
    case _deleted
    case _lastChangedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let diaryEntry = DiaryEntry.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "DiaryEntries"
    model.syncPluralName = "DiaryEntries"
    
    model.attributes(
      .primaryKey(fields: [diaryEntry.id])
    )
    
    model.fields(
      .field(diaryEntry.id, is: .required, ofType: .string),
      .field(diaryEntry.content, is: .required, ofType: .string),
      .field(diaryEntry.feeling, is: .required, ofType: .string),
      .field(diaryEntry.date, is: .required, ofType: .date),
      .field(diaryEntry.createdAt, is: .required, ofType: .dateTime),
      .field(diaryEntry.updatedAt, is: .required, ofType: .dateTime),
      .field(diaryEntry._version, is: .required, ofType: .int),
      .field(diaryEntry._deleted, is: .optional, ofType: .bool),
      .field(diaryEntry._lastChangedAt, is: .required, ofType: .int)
    )
    }
}

extension DiaryEntry: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}