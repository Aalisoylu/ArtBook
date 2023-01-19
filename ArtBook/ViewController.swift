//
//  ViewController.swift
//  ArtBook
//
//  Created by Muhammed Ali SOYLU on 13.12.2022.
//

import UIKit

import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var nameArray = [String]()
    var idArray = [UUID]()
    
    var selectedPainting = ""
    var selectedPaintingId : UUID?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
        
    }
    
    
    
    //uygulama ekranım gözüktüğünde bu işlemi yap
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
    }
    
    
    @objc func getData(){
        
        nameArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)

        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(fetchRequest)
            
            for result in results as! [NSManagedObject]{
                if let name = result.value(forKey: "name") as? String{
                    self.nameArray.append(name)
                }
                
                if let id = result.value(forKey: "id") as? UUID{
                    self.idArray.append(id)
                }
                
                self.tableView.reloadData()
            }
        }
        catch{
            print("Error")
        }
        
    }
    
    @objc func addButtonClicked(){
        
        performSegue(withIdentifier: "DetailsVC", sender: nil)
    }
    
    //satır sayımızı belirtiyoruz
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    
    //diğer sayfaya veri aktarımı için prepareforsegue ve didselectrow
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsVC" {
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.chosenPainting = selectedPainting
            destinationVC.chosenPaintingId = selectedPaintingId
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPainting = nameArray[indexPath.row]
        selectedPaintingId = idArray[indexPath.row]
        performSegue(withIdentifier: "DetailsVC", sender: nil)
    }
    
     
    


}

