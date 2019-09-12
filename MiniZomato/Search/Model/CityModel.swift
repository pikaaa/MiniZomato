//
//  CityModel.swift
//  MiniZomato
//
//  Created by Priyanka Sabhagani on 12/09/19.
//  Copyright © 2019 Priyanka Sabhagani. All rights reserved.
//

import Foundation

struct LocationSuggestions: Codable{
    var location_suggestions: [City]
}

struct City: Codable{
    var id: Int
    var name: String
}
