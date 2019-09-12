//
//  SearchViewModel.swift
//  MiniZomato
//
//  Created by Priyanka Sabhagani on 12/09/19.
//  Copyright © 2019 Priyanka Sabhagani. All rights reserved.
//

import Foundation

protocol SearchViewModelDelegate: class {
    func didReceiveLocationSuggestions(cities: [City])
}

final class SearchViewModel{
    weak var delegate: SearchViewModelDelegate?
    
    private let cities: [City] = [
        City(id: 24, name: "Allahabad"),
        City(id: 3, name: "Mumbai"),
        City(id: 1, name: "Delhi"),
        City(id: 4, name: "Bengaluru"),
        City(id: 7, name: "Chennai"),
        City(id: 9, name: "Kochi"),
        City(id: 6, name: "Hyderabad"),
        City(id: 2, name: "Kolkata"),
        City(id: 38, name: "Surat"),
        City(id: 26, name: "Bhopal"),
        City(id: 11303, name: "Ajmer"),
        City(id: 15, name: "Gangtok"),
        City(id: 11335, name: "Amravati"),
        City(id: 12, name: "Chandigarh"),
        City(id: 35, name: "Dehradun"),
        City(id: 10, name: "Jaipur"),
    ]
    
    func getCities() -> [City]{
        return cities
    }
    
    func getLocationSuggestions(city: String){
        NetworkWrapper.sharedInstance.delegate = self
        NetworkWrapper.sharedInstance.getLocationSuggestions(city: city)
    }
}


// MARK: - NetworkWrapperDelegate
extension SearchViewModel: NetworkWrapperDelegate{
    func didReceiveLocationSuggestions(data: Data) {
        do{
            let locationSuggestions: LocationSuggestions = try JSONDecoder().decode(LocationSuggestions.self, from: data)
            delegate?.didReceiveLocationSuggestions(cities: locationSuggestions.location_suggestions)
        }catch{}
    }
}
