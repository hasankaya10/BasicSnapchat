//
//  FeedViewController.swift
//  BasicSnapchat
//
//  Created by Hasan Kaya on 25.05.2022.
//

import UIKit
import Firebase
import SDWebImage
class FeedViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    var choosenSnap : SnapModel?
    var snapArray = [SnapModel]()
    let firestoreDatabase = Firestore.firestore()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getUserInfo()
        getSnapsFromFirebase()
    }
    override func viewWillAppear(_ animated: Bool) {
        getSnapsFromFirebase()
    }
    func getSnapsFromFirebase(){
        firestoreDatabase.collection("Snaps").order(by: "date" , descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                self.present(makeAlert(title: "Error", message: error?.localizedDescription ?? "Error"), animated: true)
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    self.snapArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents {
                        let documentId = document.documentID
                        
                        if let username = document.get("snapOwner") as? String {
                            if let imageUrlArray = document.get("imageUrlArray") as? [String] {
                                if let date = document.get("date") as? Timestamp {
                                    if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                        if difference >= 24 {
                                            // delete
                                            self.firestoreDatabase.collection("Snaps").document(documentId).delete()
                                        } else {
                                            let snap = SnapModel(username: username, imageUrlArray: imageUrlArray, date: date.dateValue(),timeDifference: 24 - difference )
                                            self.snapArray.append(snap)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC" {
            let destination = segue.destination as! SnapViewController
            destination.selectedSnap = self.choosenSnap
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.choosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }
    
    func getUserInfo(){
        firestoreDatabase.collection("UserInfo").whereField("email",isEqualTo: Auth.auth().currentUser?.email!).getDocuments { snapshot, error in
            if error != nil {
                self.present(makeAlert(title: "Error", message: error?.localizedDescription ?? "Hata"), animated: true)
            } else {
                if snapshot?.documents != nil && snapshot?.isEmpty == false {
                    for document in snapshot!.documents {
                        if let userName = document.get("username") as? String {
                            UserSingleton.sharedUserInfo.email = (Auth.auth().currentUser?.email)!
                            UserSingleton.sharedUserInfo.username = userName
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath ) as! FeedCell
        cell.usernameLabel.text = snapArray[indexPath.row].username
        cell.SnapimageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
        return cell
    }
    
}
