//
//  SearchController.swift
//  MiniZomato
//
//  Created by Priyanka Sabhagani on 12/09/19.
//  Copyright © 2019 Priyanka Sabhagani. All rights reserved.
//

import UIKit

protocol SearchDelegate: class {
    func didReceiveCity(city: City)
}

final class SearchController: UIViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    private var viewModel: SearchViewModel = SearchViewModel()
    weak var delegate: SearchDelegate?
    private var cities: [City] = []
    private var searchedText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        cities = viewModel.getCities()
    }
}

extension SearchController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = cities[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didReceiveCity(city: cities[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            reassignToStaticCities()
            return
        }
        searchedText = searchText
        viewModel.getLocationSuggestions(city: searchText)
    }
}

extension SearchController: SearchViewModelDelegate{
    func didReceiveLocationSuggestions(cities: [City]) {
        if cities.isEmpty, !searchedText.isEmpty, searchedText.count > 1{
            let alert = UIAlertController(title: nil, message: "No such city found!", preferredStyle: .alert)
            
            let action: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { (_) in
                self.reassignToStaticCities()
            }
            alert.addAction(action)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            self.cities = cities
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func reassignToStaticCities(){
        self.cities = viewModel.getCities()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

