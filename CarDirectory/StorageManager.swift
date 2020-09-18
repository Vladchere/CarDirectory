//
//  StorageManager.swift
//  CarDirectory
//
//  Created by Vladislav on 18.09.2020.
//  Copyright © 2020 Vladislav Cheremisov. All rights reserved.
//

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CarDirectory")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {}
    
    // MARK: - Public Methods
    
    func fetchData() -> [Car] {
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch let error {
            print("Failed to fetch data", error)
            return []
        }
    }
    
    func save(carManufacturer: String?,
              carModel: String?,
              carYear: String?,
              carBody: String?,
              completion: (Car) -> Void) {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Car", in: viewContext) else { return }
        
        let car = NSManagedObject(entity: entity, insertInto: viewContext) as! Car
        
        car.manufacturer = carManufacturer == "" ? "Manufacturer not specified" : carManufacturer
        car.model = carModel
        car.year = carYear
        car.bodyType = carBody
        
        completion(car)
        
        saveContext()
    }
    
    func edit(_ car: Car,
              newManufacturer: String?,
              newModel: String?,
              newYear: String?,
              newBody: String?) {
        
        car.manufacturer = newManufacturer == "" ? "Manufacturer not specified" : newManufacturer
        car.model = newModel
        car.year = newYear
        car.bodyType = newBody
        
        saveContext()
    }
    
    func delete(_ car: Car) {
        viewContext.delete(car)
        saveContext()
    }
    
    // MARK: - Core Data Saving support

    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
