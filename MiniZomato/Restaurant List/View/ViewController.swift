//
//  ViewController.swift
//  MiniZomato
//
//  Created by Priyanka Sabhagani on 10/09/19.
//  Copyright © 2019 Priyanka Sabhagani. All rights reserved.
//

import UIKit
import CoreLocation

final class ViewController: UIViewController {
    private let viewModel: LocationViewModel = LocationViewModel()
    private var restaurantsList: [CellData] = []
    private var filterType: FilterType = .location
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        tableView.register(UINib(nibName: "RestaurantsTableViewCell", bundle: nil), forCellReuseIdentifier: "RestaurantsTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if filterType == .location{
            if viewModel.hasLocationAccess(){
                requestLocation()
            } else{
                showAlert(title: "Oops!", message: "We're not allowed to detect location.", actionTitle: "Allow access")
            }
        }
    }
    
    private func requestLocation(){
       viewModel.requestLocation(delegate: self)
    }
    
    private func showAlert(title: String?, message: String, actionTitle: String){
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let allowAction: UIAlertAction = UIAlertAction(title: actionTitle, style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    self.requestLocation()
                })
            }
            
        }
        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.filterType = .cityName
            self.viewModel.getLocationData(id: 3, type: .cityName)
        })
        alert.addAction(allowAction)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editLocationTapped(_ sender: UIBarButtonItem) {
        let searchController: SearchController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchController") as! SearchController
        searchController.delegate = self
        self.navigationController?.pushViewController(searchController, animated: true)
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lat: Double = locations.first?.coordinate.latitude, let long = locations.first?.coordinate.longitude{
            viewModel.getLocationData(lat: lat, lon: long, type: .location )
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RestaurantsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RestaurantsTableViewCell", for: indexPath) as! RestaurantsTableViewCell
        let restaurant: CellData = restaurantsList[indexPath.row]
        cell.configureCell(nameLabel: restaurant.name, image: restaurant.image, ratingLabel: restaurant.user_rating?.aggregate_rating, cuisine: restaurant.cuisines, costForTwo: restaurant.average_cost_for_two)
        return cell
    }
}

// MARK: - RestaurantDataDelegate
extension ViewController: RestaurantDataDelegate{
    func updateList(restaurants : [CellData]) {
        restaurantsList = restaurants
        DispatchQueue.main.async {
            self.loader.isHidden = true
            self.tableView.reloadData()
        }
    }
}

// MARK: - SearchDelegate
extension ViewController: SearchDelegate{
    func didReceiveCity(city: City) {
        DispatchQueue.main.async {
            self.loader.isHidden = false
        }
        filterType = .cityName
        viewModel.getLocationData(id: city.id, type: .cityName)
    }
}
