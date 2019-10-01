//
//  ViewControllerOne.swift
//  PeopleAndAppleStockPrices
//
//  Created by Phoenix McKnight on 8/30/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation
import UIKit

class RandomUserViewController:UIViewController {
    @IBOutlet weak var randomUserTableView: UITableView!
    
    @IBOutlet weak var searchingBar: UISearchBar!
    var rgbColor = RGBValue()
    var randomUser = [Results]() {
        didSet {
            DispatchQueue.main.async {
                
                self.randomUserTableView.reloadData()
                
            }
        }
    }
    var searchBarText: String? = nil {
        didSet {
            self.randomUserTableView.reloadData()
        }
    }
    var emptyImage:UIImage? = nil {
        didSet {
            getData()
        randomUserTableView.reloadData()
        }
        
    }
    var searchResults: [Results] {
        get {
            guard let searchString = searchBarText else {
                return randomUser
            }
            guard searchString != "" else {
                return randomUser
            }
            return randomUser.filter {$0.name.getName().lowercased().replacingOccurrences(of: " ", with: "").contains(searchString.lowercased().replacingOccurrences(of: " ", with: ""))}
            
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        getData()
    }
    private func getData() {
        UserAPIClient.shared.getUsers { (results) in
            switch results {
            case .success(let user):
                self.randomUser =  user.sorted(by: {$0.name.first < $1.name.first})
            case .failure(let failure):
                print("could not retrieve Data \(failure)")
            }
        }
    }
}

extension RandomUserViewController: UITableViewDelegate{}
extension RandomUserViewController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        colorGenerator()
        searchBarText = searchBar.text
        self.navigationItem.title = showResults.showResults(int: searchResults.count)
        
    }
}



extension RandomUserViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = randomUserTableView.dequeueReusableCell(withIdentifier: "randomUser") as! UserTableViewCell
        cell.userLabe.text = searchResults[indexPath.row].name.getName()
        cell.pickImageFunction = {
               let imagePicker = UIImagePickerController()

                 imagePicker.sourceType = .photoLibrary
                 imagePicker.allowsEditing = true
                 imagePicker.delegate = self
                 self.present(imagePicker,animated: true,completion: nil)
            cell.userImageView.image = self.emptyImage
        }
        
        
            ImageHelper.shared.getImage(urlStr: searchResults[indexPath.row].picture.large) {
                (results) in
                DispatchQueue.main.async {
                    switch results {
                    case .failure(let error):
                        print(error)
                    case .success(let picture):
                        cell.activityOutlet.stopAnimating()
                        cell.userImageView.image = picture
                        
                    }
                }
            }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = randomUserTableView.dequeueReusableCell(withIdentifier: "randomUser") as! UserTableViewCell
        cell.pickImageFunction()
       
        }
//        let imagePicker = UIImagePickerController()
//
//        imagePicker.sourceType = .photoLibrary
//        imagePicker.allowsEditing = true
//        imagePicker.delegate = self
//        self.present(imagePicker,animated: true,completion: nil)
        
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }
    
    func setUp() {
        randomUserTableView.dataSource = self
        randomUserTableView.delegate = self
        searchingBar.delegate = self
        self.navigationItem.title = "Contacts"
        colorGenerator()
        
    }
    func colorGenerator(){
        rgbColor = RGBValue()
        self.view.backgroundColor = rgbColor.createRGBColor()
        
    }
}

extension RandomUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            //couldn't get image :(
            return
        }
        self.emptyImage = image
        
        dismiss(animated: true, completion: nil)
        
    }
}
