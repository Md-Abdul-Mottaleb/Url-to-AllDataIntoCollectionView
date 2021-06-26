//
//  CollectionViewCell.swift
//  JSonDataIntoCollectionView
//
//  Created by MacBook Pro on 24/6/21.
//

import UIKit

//fetchImage()

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var gender: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var firstname: UILabel!
    
    @IBOutlet weak var lastname: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var dob: UILabel!
    
    @IBOutlet weak var number: UILabel!
    
    @IBOutlet weak var nat: UILabel!
    
    //@IBOutlet weak var imageView: UIImageView!

    private func fetchImage() {
        let imageURL = URL(string: "https://i.stack.imgur.com/9z6nS.png")
        var image: UIImage?
        if let url = imageURL {
            //All network operations has to run on different thread(not on main thread).
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData = NSData(contentsOf: url)
                //All UI operations has to run on main thread.
                DispatchQueue.main.async {
                    if imageData != nil {
                        image = UIImage(data: imageData as! Data)
                        self.image.image = image
                        self.image.sizeToFit()
                    } else {
                        image = nil
                    }
                }
            }
        }
    }

   
}

