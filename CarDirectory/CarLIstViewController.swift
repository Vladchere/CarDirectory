//
//  CarLIstViewController.swift
//  CarDirectory
//
//  Created by Vladislav on 17.09.2020.
//  Copyright © 2020 Vladislav Cheremisov. All rights reserved.
//

import UIKit
import CoreData

class CarLIstViewController: UITableViewController {
    
    private let cellID = "cell"
    private var cars = StorageManager.shared.fetchData()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupView()
    }
    
    // Setup view
    private func setupView() {
        view.backgroundColor = .white
        setupNavigationBar()
    }
    
    // Setup navigation bar
    private func setupNavigationBar() {
        
        // Set title for navigation bar
        title = "Car List"
        
        // Set large title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Navigation bar appearance
        let navBarApperance = UINavigationBarAppearance()
        navBarApperance.configureWithOpaqueBackground()
        navBarApperance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarApperance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarApperance.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.75)
        
        navigationController?.navigationBar.standardAppearance = navBarApperance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarApperance
        
        // Add button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewCar))
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addNewCar() {
        showAlert()
    }
}

// MARK: - UITableViewDataSource

extension CarLIstViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cars.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellID)
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        
        let car = cars[indexPath.row]
        
        cell.textLabel?.text = "\(car.manufacturer ?? "") \(car.model ?? "")"
        cell.detailTextLabel?.text = "Year of issue: \(car.year ?? "")\nBody type: \(car.bodyType ?? "")"
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CarLIstViewController {
    
    // Edit task
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let car = cars[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        showAlert(car: car) {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    // Delete task
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let car = cars[indexPath.row]
        
        if editingStyle == .delete {
            cars.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            StorageManager.shared.delete(car)
        }
    }
}

// MARK: - Alert Controller
extension CarLIstViewController {
    
    private func showAlert(car: Car? = nil, completion: (() -> Void)? = nil) {
        
        var title = "New Car"
        var message = "Enter car information"
        
        if car != nil {
            title = "Details car"
            message = "You can update information"
        }
        
        let alert = AlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.action(car: car) { newDetails in
            if let car = car, let completion = completion {
                StorageManager.shared.edit(car,
                                           newManufacturer: newDetails[0],
                                           newModel: newDetails[1],
                                           newYear: newDetails[2],
                                           newBody: newDetails[3])
                completion()
            } else {
                StorageManager.shared.save(carManufacturer: newDetails[0],
                                           carModel: newDetails[1],
                                           carYear: newDetails[2],
                                           carBody: newDetails[3]) { car in
                    self.cars.append(car)
                    self.tableView.insertRows(
                        at: [IndexPath(row: self.cars.count - 1, section: 0)],
                        with: .automatic
                    )
                }
            }
        }
        
        present(alert, animated: true)
    }
}


