//
//  ViewController.swift
//  taskapp
//
//  Created by 加藤桃香 on 2020/12/06.
//  Copyright © 2020 momoka.kato. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    let realm = try! Realm()
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date",ascending: true)
    
    
       override func viewDidLoad() {
           super.viewDidLoad()
           
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.showsCancelButton = true
           // Do any additional setup after loading the view.
       }
    

    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
              let inputViewController:inputViewController = segue.destination as! inputViewController

              if segue.identifier == "cellSegue" {
                  let indexPath = self.tableView.indexPathForSelectedRow
                  inputViewController.task = taskArray[indexPath!.row]
              } else {
                  let task = Task()

                  let allTasks = realm.objects(Task.self)
                  if allTasks.count != 0 {
                      task.id = allTasks.max(ofProperty: "id")! + 1
                  }

                  inputViewController.task = task
              }
          }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //データの数(＝セルの数)を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    //各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //再利用可能なcellを得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let task = taskArray[indexPath.row]
        cell.textLabel?.text = task.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString: String = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
        
        
        return cell
    }
    
    //各セルを選択したときに実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }
    
    //セルが削除可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return.delete
    }
    
    //Deleteボタンが押されたときに呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = self.taskArray[indexPath.row]
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])
            
            
            try! realm.write{
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            center.getPendingNotificationRequests{ (requests: [UNNotificationRequest]) in
                for request in requests{
                    print("/---------------")
                    print(request)
                    print("---------------/")

                }
        }
    }

}
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchWord = searchBar.text else { return }
        let searchResult = realm.objects(Task.self).filter("category == '\(searchWord)'")
        
        if searchBar.text != "" {
         taskArray = searchResult
        }else {
         taskArray = realm.objects(Task.self)
         }
        tableView.reloadData()
         print("searchResult=", searchResult)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        taskArray = realm.objects(Task.self)
        searchBar.text = ""
        tableView.reloadData()
    }
    

}
