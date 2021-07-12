//
//  ViewController.swift
//  AlamofireTableview
//
//  Created by Ivan Velkov on 165//19.
//  Copyright © 2019 Ivan Velkov. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

final class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet private weak var TableView: UITableView!
    
    var userArray = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.TableView.delegate = self
        self.TableView.dataSource = self
       // self.TableView.rowHeight = UITableView.automaticDimension
       // self.TableView.estimatedRowHeight=44
        
        
        
        getUsersData()
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! TableViewCell
        if self.userArray.count  > 0{
            let eachuserarry = self.userArray[indexPath.row]
            cell.NameCell.text=eachuserarry.name
            cell.AgeCell.text = "\(eachuserarry.age!)"
          //  cell.imageView?.image = UIImage(contentsOfFile: eachuserarry.imageUrl!)
         let urlpicture = URL(string: eachuserarry.imageUrl!)
            let data = try? Data(contentsOf: urlpicture!)
            cell.imageView?.image = UIImage(data: data!)
        }
        return cell
        
    }
    
    
    
    private func getUsersData(){
        let url = URL(string: "https://randomuser.me/api/?results=4")
        _ = [
        "results": "6"]
        

        if let url = url {
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseData) in
               
                switch responseData.result {
                        
                        case .success:
                            print(responseData)
                            var jsonData: JSON?
                            
                            do {
                                jsonData = try JSON(data: responseData.data!)
                                
                            } catch _ {
                                // error
                            }
                            
                            if let jsonData = jsonData {
                                for (key, subJSON) in jsonData["results"]{
                                    let user = User()
                                    if let name = subJSON["name"]["first"].string{
                                        user.name = name
                                    }
                                    
                                    if let age = subJSON["dob"]["age"].int {
                                        user.age = age
                                    }
                                    
                                    if let url = subJSON["picture"]["medium"].string{
                                        user.imageUrl = url
                                    }
                                    self.userArray.append(user)
                                    print(self.userArray)
                                    self.TableView?.reloadData()
                                }
                                
                                print(self.userArray.count)
                                break
                            }
                            
                case .failure(_):
                            print("error when taking data")
                            print(responseData.error?.localizedDescription)
                            break
                        }
            }
            
        }
}
}

