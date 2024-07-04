// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "e000c1a77b983a5403c6351a46bb67d5"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Goal.self)
    ModelRegistry.register(modelType: DrinkRecord.self)
    ModelRegistry.register(modelType: DiaryEntry.self)
    ModelRegistry.register(modelType: CommunityMessage.self)
    ModelRegistry.register(modelType: EmergencyContact.self)
    ModelRegistry.register(modelType: Achievement.self)
    ModelRegistry.register(modelType: Reminder.self)
  }
}