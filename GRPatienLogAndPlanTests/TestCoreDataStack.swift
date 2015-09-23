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
        
        let psc  = NSPersistentStoreCoordinator(managedObjectModel:self.model)
//        else {
//                fatalError()
//        }
//      let psc: NSPersistentStoreCoordinator? =
//      NSPersistentStoreCoordinator(managedObjectModel:
//        self.model)
      //var error: NSError? = nil
      
      var ps: NSPersistentStore?
      do {
        ps = try psc.addPersistentStoreWithType(
                NSInMemoryStoreType, configuration: nil,
                URL: nil, options: nil)
      } catch {
        fatalError()
      }
      
      if (ps == nil) {
        abort()
      }
      
      return psc
      }()
    
  }
}
