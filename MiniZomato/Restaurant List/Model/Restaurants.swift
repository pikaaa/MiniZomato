//
//  Restaurants.swift
//  MiniZomato
//
//  Created by Priyanka Sabhagani on 10/09/19.
//  Copyright © 2019 Priyanka Sabhagani. All rights reserved.
//

import Foundation
import UIKit

struct Restaurants: Codable {
    var restaurants: [RestaurantData]
    var results_found: Int
}

struct RestaurantData: Codable {
    var restaurant: Restaurant
    
}

struct Restaurant: Codable {
    var id: String
    var name: String
    var cuisines: String?
    var average_cost_for_two: Int?
    var user_rating: Rating?
    var featured_image: String?
}

struct Rating: Codable {
    var aggregate_rating: String?
    var rating_text: String?
}

struct CellData{
    var id: String
    var name: String
    var cuisines: String?
    var average_cost_for_two: Int?
    var user_rating: Rating?
    var image: UIImage?
}
