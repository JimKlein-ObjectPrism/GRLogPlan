import GRPatienLogAndPlan
import Foundation
import CoreData

//class Test: CoreDataStack
//{
//    <#properties and methods#>
//}
class TestCoreDataStack: CoreDataStack {
   override init() {
    super.init()
    
    self.psc = {
      var psc: NSPersistentStoreCoordinator? =
      NSPersistentStoreCoordinator(managedObjectModel:
        self.model)
      var error: NSError? = nil
      
      var ps = psc!.addPersistentStoreWithType(
        NSInMemoryStoreType, configuration: nil,
        URL: nil, options: nil, error: &error)
      
      if (ps == nil) {
        abort()
      }
      
      return psc!
      }()
    
  }
}