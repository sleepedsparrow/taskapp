//
//  inputViewController.swift
//  taskapp
//
//  Created by 加藤桃香 on 2020/12/06.
//  Copyright © 2020 momoka.kato. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class inputViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryTextField: UITextField!
    
     var task: Task!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        categoryTextField.text = task.category
        datePicker.date = task.date
        // Do any additional setup after loading the view.
    }
    
   override func viewWillDisappear(_ animated: Bool) {
       try! realm.write {
           self.task.title = self.titleTextField.text!
           self.task.contents = self.contentsTextView.text
           self.task.date = self.datePicker.date
        self.task.category = self.categoryTextField.text!
           self.realm.add(self.task, update: .modified)
       }
    setNotification(task: task)
       super.viewWillDisappear(animated)
   }
    
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        
        if task.contents == "" {
            content.body = "(内容なし)"
        } else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        // identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
        let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)

        // ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録 OK")  // error が nil ならローカル通知の登録に成功したと表示します。errorが存在すればerrorを表示します。
        }
        
        center.getPendingNotificationRequests{ (requests: [UNNotificationRequest]) in for request in requests{
           print("/---------------")
           print(request)
           print("---------------/")
            }
            
        }
        
        
    }
    
    

    
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
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
