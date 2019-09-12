//
//  NetworkWrapper.swift
//  MiniZomato
//
//  Created by Priyanka Sabhagani on 12/09/19.
//  Copyright © 2019 Priyanka Sabhagani. All rights reserved.
//

import UIKit

protocol NetworkWrapperDelegate: class {
    func didReceiveLocationData(data: Data)
    func didReceiveLocationSuggestions(data: Data)
}

extension NetworkWrapperDelegate{
    func didReceiveLocationData(data: Data){}
    func didReceiveLocationSuggestions(data: Data){}
}

final class NetworkWrapper{
    static let sharedInstance: NetworkWrapper = NetworkWrapper()
    private let userKey: String = "4feaa2167c4dc6beadf629319423bd4b"
    private let baseURL: String = "https://developers.zomato.com/api/v2.1/"
    weak var delegate: NetworkWrapperDelegate?
    
    func getLocationData(lat: Double = 19.017656, lon: Double = 72.856178, id: Int = 0, type: FilterType){
        var urlString: String = ""
        switch type {
        case .cityName:
            urlString = "\(baseURL)search?&entity_type=city&entity_id=\(id)"
        case .location:
            urlString = "\(baseURL)search?lat=\(lat)&lon=\(lon)"
        }
        if let url: URL = URL(string: urlString){
            hitRequest(url: url, addHeader: true) { (data, err) in
                if let data: Data = data{
                    self.delegate?.didReceiveLocationData(data: data)
                }
            }
        }
    }
    
    func getImageFromURL(url: String, completion: @escaping (_ result: UIImage?) -> Void){
        if let url: URL = URL(string: url){
            hitRequest(url: url, addHeader: false) { (data, _) in
                if let data: Data = data{
                    completion(UIImage(data: data))
                }else{
                    completion(nil)
                }
            }
        }
    }
    
    func getLocationSuggestions(city: String){
        if let url: URL = URL(string: "\(baseURL)cities?q=\(city)"){
            hitRequest(url: url, addHeader: true) { (data, err) in
                if let data: Data = data{
                    self.delegate?.didReceiveLocationSuggestions(data: data)
                }
            }
        }
    }
    
    func hitRequest(url: URL, addHeader: Bool, completionHandler: @escaping (Data?, Error?) -> Void){
        var urlRequest: URLRequest = URLRequest(url: url)
        if addHeader{
            urlRequest.addValue(userKey, forHTTPHeaderField: "user-key")
        }
        URLSession.shared.dataTask(with: urlRequest) { (data, response, err) in
            completionHandler(data, err)
        }.resume()
    }
}
