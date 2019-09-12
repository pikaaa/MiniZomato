//
//  LocationViewModel.swift
//  MiniZomato
//
//  Created by Priyanka Sabhagani on 10/09/19.
//  Copyright © 2019 Priyanka Sabhagani. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol RestaurantDataDelegate: class {
    func updateList(restaurants: [CellData])
}

enum FilterType{
    case cityName
    case location
}

final class LocationViewModel{
    private var locationManager: CLLocationManager = CLLocationManager()
    private let userKey: String = "4feaa2167c4dc6beadf629319423bd4b"
    weak var delegate: RestaurantDataDelegate?
    private var cellData: [CellData] = []
    private var countForImages: Int = 0
    
    func requestLocation(delegate: CLLocationManagerDelegate){
        locationManager.delegate = delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func hasLocationAccess() -> Bool{
        if CLLocationManager.locationServicesEnabled(){
            switch CLLocationManager.authorizationStatus(){
            case .denied, .notDetermined, .restricted:
                return false
            default:
                return true
            }
        }
        return false
    }
    
    func getLocationData(lat: Double = 19.017656, lon: Double = 72.856178, id: Int = 0, type: FilterType){
        cellData = []
        countForImages = 0
        NetworkWrapper.sharedInstance.delegate = self
        NetworkWrapper.sharedInstance.getLocationData(lat: lat, lon: lon, id: id, type: type)
    }
    
    func getImageFromURL(url: String, id: String, completion: @escaping (_ result: UIImage?, _ id: String) -> Void){
        NetworkWrapper.sharedInstance.getImageFromURL(url: url) { (img) in
            completion(img, id)
        }
    }
}


// MARK: - NetworkWrapperDelegate
extension LocationViewModel: NetworkWrapperDelegate{
    func didReceiveLocationData(data: Data) {
        do{
            let restaurants: Restaurants = try JSONDecoder().decode(Restaurants.self, from: data)
            for restaurant in restaurants.restaurants{
                let cell: CellData = CellData(id: restaurant.restaurant.id, name: restaurant.restaurant.name, cuisines: restaurant.restaurant.cuisines, average_cost_for_two: restaurant.restaurant.average_cost_for_two, user_rating: restaurant.restaurant.user_rating, image: nil)
                if let imageString: String = restaurant.restaurant.featured_image{
                    self.getImageFromURL(url: imageString, id: restaurant.restaurant.id, completion: { (image, id) in
                        for (index, cellForData) in self.cellData.enumerated(){
                            if cellForData.id == id{
                                self.countForImages = self.countForImages + 1
                                self.cellData[index].image = image
                            }
                        }
                        if self.countForImages == self.cellData.count{
                            self.delegate?.updateList(restaurants: self.cellData)
                        }
                    })
                }

                self.cellData.append(cell)
            }
            self.delegate?.updateList(restaurants: self.cellData)
        } catch{}
    }
}
