//
//  RestaurantsTableViewCell.swift
//  MiniZomato
//
//  Created by Priyanka Sabhagani on 10/09/19.
//  Copyright © 2019 Priyanka Sabhagani. All rights reserved.
//

import UIKit

final class RestaurantsTableViewCell: UITableViewCell{
   
    @IBOutlet weak var imageLoader: UIActivityIndicatorView!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cuisines: UILabel!
    @IBOutlet weak var costForTwoLabel: UILabel!
    
    func configureCell(nameLabel: String, image: UIImage?, ratingLabel: String?, cuisine: String?, costForTwo: Int?){
        self.nameLabel.text = nameLabel
        if let _: UIImage = image{
            imageLoader.isHidden = true
            self.imageview.image = image
        }else{
            imageLoader.isHidden = false
            imageLoader.startAnimating()
            self.imageview.image = nil
        }
        
        if let rating: String = ratingLabel{
            self.ratingLabel.text = "Rating: \(rating)"
        }
       
        if let costForTwo: Int = costForTwo{
            self.costForTwoLabel.text = "Cost for two: \(costForTwo)"
        }
        
        self.cuisines.text = cuisine
    }
}
