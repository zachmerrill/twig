//
//  EncyclopediaViewController.swift
//  Twig
//
//  Created by Zach Merrill on 2021-03-25.
//

import UIKit
import CoreData

class EncyclopediaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private let context = AppDelegate.viewContext
    let segueId = "PlantViewSegue"
    let reuseIdentifier = "encyclopediaReuseIdentifier"
    private let addPlantIdentifier = "AddPlantSegueIdentifier"
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var plantsFiltered = [Plant]()
    
    override func viewWillAppear(_ animated: Bool) {
        print("VIEW APPEARED")
        if let plants = Plant.getAllPlants() {
            plantsFiltered = plants
        } else {
            plantsFiltered = [Plant]()
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFetchedResultsController()
        tableView.rowHeight = 44
        if let plants = Plant.getAllPlants() {
            plantsFiltered = plants
        } else {
            plantsFiltered = [Plant]()
        }
        
    }
    
    // MARK: NSFetchedResultsController Functions
    func initializeFetchedResultsController() {
        let request : NSFetchRequest<Plant> = Plant.fetchRequest()
        let fetchSort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [fetchSort]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil) as? NSFetchedResultsController<NSFetchRequestResult>
        
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    // MARK: TableView
    //Filerts the table views array
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        plantsFiltered = Plant.getAllPlants()!
        .filter({ plant -> Bool in
                if searchText.isEmpty { return true }
                return plant.name!.lowercased().contains(searchText.lowercased())
            }
        )
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plantsFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? EncyclopediaTableViewCell

        let plant = plantsFiltered[indexPath.row]
        // fill cells plant name
        cell?.nameLabel.text = plant.name
        return cell!
    }
    
    //Start segue to the view card view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let plant = plantsFiltered[indexPath.row]
        performSegue(withIdentifier: segueId, sender: plant)
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId{
            let detailVc = segue.destination as! PlantViewController
            detailVc.initWithPlantNamed((sender as! Plant).name ?? "Undefined")
        }
    } // prepareForSegue
}


