//
//  ViewController.swift
//  JSonDataIntoCollectionView
//
//  Created by MacBook Pro on 24/6/21.
//

import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

//var Array = ["A","A","A","A","A","A","A","A","A","A"]
//extension UIImage {
//
//    //NOTE: This is not thread safe, please run it on a background thread.
//    convenience init?(fromFile filePath:String) {
//        guard let url = URL(string: filePath) else {
//            return nil
//        }
//
//        self.init(fromURL: url)
//    }
//
//    //NOTE: This is not thread safe, please run it on a background thread.
//    convenience init?(fromURL url:URL) {
//        let imageData: Data
//
//        do {
//            imageData = try Data(contentsOf: url)
//        } catch {
//            return nil
//        }
//
//        self.init(data: imageData)
//    }
//
//}
//

//do {
//        let data = try Data.init(contentsOf: URL.init(string: "https://randomuser.me/api/?page=1&results=10")!)
//        let img = UIImage.init(data: data)
//        DispatchQueue.main.async {
//            sell.image.image = img
//            //imageview.image = img
//            sell.contentView.addSubview(sell.image)
//            //sell.image.image = friendsArray[indexPath.row].picture?.thumbnail
//
//        }
//    } catch let erroer {
//        print(erroer.localizedDescription)
//    }

class ViewController: UIViewController , UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
   
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var friendsArray = [RResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        
        GetFriends()
    }
    
    func GetFriends(){
        
        var request = URLRequest(url: URL(string: "https://randomuser.me/api/?page=1&results=10")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
          
            return
          }
          //print(String(data: data, encoding: .utf8)!)
            
            if let jsonResponse = try? JSONDecoder().decode(FriendsResponseModel.self, from: data) {
                DispatchQueue.main.async {
                    self.friendsArray = jsonResponse.results!
                    
                    print(self.friendsArray)
                    self.collectionView.reloadData()
                }
                
                
            }
        }
        
        

        task.resume()

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friendsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sell = collectionView.dequeueReusableCell(withReuseIdentifier: "xell", for: indexPath) as! CollectionViewCell
        
        let urlString = "https://randomuser.me/api/"
        let urll = urlString + (friendsArray[indexPath.row].picture?.thumbnail)!
        sell.image.downloaded(from: urll)
       // let url = URL(string: urlString)
       // sell.image.image = friendsArray[indexPath.row]
        //sell.image.downloaded(from: url!)
        
        sell.gender.text = friendsArray[indexPath.row].gender
        
        sell.name.text = friendsArray[indexPath.row].name?.title
        sell.firstname.text = friendsArray[indexPath.row].name?.first
        sell.lastname.text = friendsArray[indexPath.row].name?.last
        
        sell.location.text = friendsArray[indexPath.row].location?.street?.name
        sell.email.text = friendsArray[indexPath.row].email
        sell.dob.text = friendsArray[indexPath.row].dob?.date
        sell.number.text = friendsArray[indexPath.row].phone
        sell.nat.text = friendsArray[indexPath.row].nat
        //sell.image.image = friendsArray[indexPath.row].picture?.thumbnail
        return sell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //let container = self.width - 0
     //   let cc = container / 1
        
        return CGSize(width: 390, height: 350)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    

    
}

