//
//  UploadViewController.swift
//  BasicSnapchat
//
//  Created by Hasan Kaya on 25.05.2022.
//

import UIKit
import Firebase
import FirebaseStorage
class UploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var uploadImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        uploadImage.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func chooseImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true,completion: nil)
    }
    @IBAction func UploadTouched(_ sender: Any) {
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        let mediaFolder = storageReferance.child("media")
        
        if let data = uploadImage.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReferance = mediaFolder.child("\(uuid).jpg")
            imageReferance.putData(data, metadata: nil) { storageMetaData, error in
                if error != nil {
                    self.present(makeAlert(title: "Error", message: error?.localizedDescription ?? "Error an occured"), animated: true)
                } else {
                    imageReferance.downloadURL { url, error in
                        if error != nil {
                            self.present(makeAlert(title: "Error", message: error?.localizedDescription ?? "Error an occured"), animated: true)
                        } else {
                            let imageUrl = url?.absoluteString
                            let firestore = Firestore.firestore()
                            firestore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { snapshot, error in
                                if error != nil {
                                    self.present(makeAlert(title: "Error", message: error?.localizedDescription ?? "Error"), animated: true)
                                } else {
                                    if snapshot?.isEmpty == false && snapshot != nil {
                                        for document in snapshot!.documents {
                                            let documentId = document.documentID
                                            
                                            if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                                imageUrlArray.append(imageUrl!)
                                                let additionalArray = ["imageUrlArray" : imageUrlArray] as [String : Any]
                                                firestore.collection("Snaps").document(documentId).setData(additionalArray, merge: true) { error in
                                                    if error == nil {
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.uploadImage.image = UIImage(named: "uploadImage")
                                                    } else {
                                                        self.present(makeAlert(title: "Error", message: error?.localizedDescription ?? "Hata"), animated: true)
                                                    }
                                                }
                                            }
                                            
                                        }
                                        
                                    } else {
                                        let userDictionary = [
                                            "snapOwner" : UserSingleton.sharedUserInfo.username, "imageUrlArray" : [imageUrl!],
                                            "date" : FieldValue.serverTimestamp()] as [String : Any ]
                                        firestore.collection("Snaps").addDocument(data: userDictionary) { error in
                                            if error != nil {
                                                self.present(makeAlert(title: "Error", message: "Error an occured "), animated: true)
                                            } else {
                                                self.tabBarController?.selectedIndex = 0
                                                self.uploadImage.image = UIImage(named: "uploadImage")
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
        
    }
    
   

}
