//
//  ViewController.swift
//  ShoppingList
//
//  Created by Koray Urun on 27.06.2025.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    
    var isimDizisi = [String]()
    var idDizisi = [UUID]()
    
    var secilenIsim = ""
    var secilenUUID : UUID?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.add, target: self, action: #selector(eklemeButonuTiklandi))

        verileriAl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(verileriAl), name: NSNotification.Name(rawValue: "veriGirildi"), object: nil)
        
    }
    
    
    @objc func verileriAl() {
        
        isimDizisi.removeAll(keepingCapacity: false)
        idDizisi.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Alisveris")
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let sonuclar = try context.fetch(fetchRequest)
            if sonuclar.count>0{
                
                for sonuc in sonuclar as! [NSManagedObject]{
                    
                    if let isim = sonuc.value(forKey: "isim") as? String{
                        isimDizisi.append(isim)
                    }
                    
                    if let id = sonuc.value(forKey: "id") as? UUID{
                        idDizisi.append(id)
                    }
                  
                }
                
                tableView.reloadData()
        
                
            }
            
            
        }catch {
            print("Hata var")
        }
        
        
    }
    
    
    
    
    
    

    
    @objc func eklemeButonuTiklandi() {
        secilenIsim = ""
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isimDizisi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = isimDizisi[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            if let destinationVC = segue.destination as? DetailesViewController {
                destinationVC.secilenUrunIsmi = secilenIsim
                destinationVC.secilenUrunUUID = secilenUUID
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        secilenIsim = isimDizisi[indexPath.row]
        secilenUUID = idDizisi[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Alisveris")
            let uuidString = idDizisi[indexPath.row].uuidString
            fetchRequest.predicate = NSPredicate(format: "id == %@", uuidString)
            fetchRequest.returnsObjectsAsFaults = false
            
            
            do{
                let sonuclar = try context.fetch(fetchRequest)
                if sonuclar.count > 0 {
                    for sonuc in sonuclar as! [NSManagedObject] {
                        
                        if let id = sonuc.value(forKey: "id") as? UUID {
                            if id == idDizisi[indexPath.row] {
                                context.delete(sonuc)
                                isimDizisi.remove(at:indexPath.row)
                                idDizisi.remove(at:indexPath.row)
                                
                                self.tableView.reloadData()
                                
                                do{
                                    try context.save()
                                }catch{
                                    
                                }
                                break
                                
                            }
                        }
                    }
                }
                
                
            }catch {
                print("hata")
            }
            
        }
    }
    
    

}

