//
//  Plant.swift
//  Twig
//
//  Created by Zach Merrill on 2021-03-27.
//

import UIKit
import CoreData

class Plant : NSManagedObject {
    // MARK: Accessors
    class func existsWithName(_ name:String) -> Bool {
        let request : NSFetchRequest<Plant> = Plant.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", name)
        let context = AppDelegate.viewContext
        let plants = try? context.fetch(request)
        if (plants?.isEmpty)! {
            return false
        } else {
            return true
        }
    } // existsWithName
    
    class func getAllPlants() -> [Plant]? {
        //let request : NSFetchRequest<Plant> = Plant.fetchRequest()
        //request.predicate = NSPredicate(format: "name = %@", name)
        let plantRequest = NSFetchRequest<Plant>(entityName: "Plant")
        let context = AppDelegate.viewContext
        let plants = try? context.fetch(plantRequest)
        if (plants?.isEmpty)! {
            return nil
        } else {
            print(plants)
            return plants
        }
    }
    
    
    func getRoom(_ name: String) -> Room? {
        let request : NSFetchRequest<Room> = Room.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", name)
        let context = AppDelegate.viewContext
        let rooms = try? context.fetch(request)
        if (rooms?.isEmpty)! {
            return nil // should probably guard for this
            // Maybe create the room if it doesn't already exist?
        }else{
            return rooms![0] as Room
        }
    }
    
    class func getPlant(_ name: String) -> Plant? {
        let request : NSFetchRequest<Plant> = Plant.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", name)
        let context = AppDelegate.viewContext
        let plants = try? context.fetch(request)
        if (plants?.isEmpty)! {
            return nil // should probably guard for this
            // Maybe create the room if it doesn't already exist?
        }else{
            return plants![0] as Plant
        }
    } // getPlant
    
    // MARK: Mutators
    func set(name: String, room: String,heat: Int, water: Int, sun_light: Int, plant_description: String){
        self.name = name
        self.belongs_to = getRoom(room)!
        self.heat = Int16(heat)
        self.water = Int16(water)
        self.sun_light = Int16(sun_light)
        self.plant_description = plant_description
    } // set
    
    class func create(name:String, room:String, heat: Int, water: Int, sun_light: Int, plant_description: String) {
        let context = AppDelegate.viewContext
        if !Plant.existsWithName(name) {
            print("Adding new plant: \(name) to room: \(room)")
            let plant = Plant(context: context)
            plant.set(name: name, room: room, heat: heat, water: water, sun_light: sun_light, plant_description: plant_description)
        }
    } // create
    
    class func delete(_ name:String) {
        let request : NSFetchRequest<Plant> = Plant.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", name)
        let context = AppDelegate.viewContext
        // For now, get all plants with that name and delete them
        // TODO: Get specific plant for room
        // Currently causes an exception to be thrown because it is unsure which
        // plants should be deleted
        if let plants = try? context.fetch(request) {
            for plant in plants {
                print("Deleting plant \(plant.name!)")
                context.delete(plant)
            }
        }
    } // delete
    
    func save(context : NSManagedObjectContext)
    {
        do{
            try context.save()
        }
        catch{
            
        }
    } // save
}
