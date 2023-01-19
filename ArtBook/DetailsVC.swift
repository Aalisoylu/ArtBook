//
//  DetailsVC.swift
//  ArtBook
//
//  Created by Muhammed Ali SOYLU on 13.12.2022.
//

import UIKit
import CoreData

class DetailsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var artistField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    
    var chosenPainting = ""
    var chosenPaintingId :UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if chosenPainting != "" {
            
        }
        else{
            //resim seçilmedi
        }
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
       
        imageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageTapRecognizer)
                                        
    }
    

    @objc func selectImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            imageView.image = info[.originalImage] as? UIImage
            self.dismiss(animated: true, completion: nil)
        }
    
    
                                                        
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    

    @IBAction func saveClicked(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newImage = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
        
        //Add attributes
        if let year = Int(yearField.text!){
            newImage.setValue(year, forKey: "year")
        }
        
        newImage.setValue(UUID(), forKey: "id")
        
        let data = imageView.image?.jpegData(compressionQuality: 0.5)
        newImage.setValue(data, forKey: "image")
        
        do{
            try context.save()
                print("success")
        }
        catch {
            print("error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newdata"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
        

    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
