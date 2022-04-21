//
//  EditReminderVC.swift
//  Reminder
//
//  Created by Mohanraj on 14/04/22.
//

import UIKit
import CoreData

class AddReminderVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var viewText: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateView: UIView!
    
    var selectedReminder1: ReminderData? = nil
    
    var dateAndTime : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateView.layer.cornerRadius = 15
        self.viewText.layer.cornerRadius = 15
        
       datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        textView.text = "Add Note"
      //  titleLabel.text = "Edit Reminder"
        
        if (selectedReminder1 != nil)
        {
            titleLabel.text = selectedReminder1?.title
            textView.text = selectedReminder1?.notes
            datePicker.date = (selectedReminder1?.date)!
        }
    }
    
    @objc private func dateChanged() {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
       
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        if selectedReminder1 == nil{
            let entity = NSEntityDescription.entity(forEntityName: "ReminderData", in: context)
            let newReminder = ReminderData(entity: entity!, insertInto: context)
            newReminder.id = UUID().uuidString
            newReminder.title = titleLabel.text
            newReminder.notes = textView.text
            newReminder.date = datePicker.date
            do {
                try context.save()
             //   reminders.append(newReminder)
                navigationController?.popViewController(animated: true)
            } catch{
                print("context save error")
            }
        }else{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ReminderData")
            do{
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let reminder = result as! ReminderData
                    if (reminder == selectedReminder1)
                    {
                        reminder.title = titleLabel.text
                        reminder.notes = textView.text
                        reminder.date = datePicker.date
                        try context.save()
                        navigationController?.popViewController(animated: true)
                    }
                }
            } catch {
                print("Fetch Failed")
            }
            
        }
//        let RemVC = self.storyboard!.instantiateViewController(withIdentifier: "RemVC") as! ReminderListVC
//        self.navigationController?.pushViewController(RemVC, animated: true)
    }
   
    @IBAction func dateTimePicker(_ sender: UIDatePicker) {
      //  self.datePicker.endEditing(true)
    }
}

extension AddReminderVC : UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "Add Note" {
            textView.text = ""
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {

        if textView.text == "" {
            textView.text = "Add Note"
        }
        return true
    }
}

extension AddReminderVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if titleLabel.text == "" {
            titleLabel.text = ""
        }
        else  if titleLabel.text == "New Reminder"{
            titleLabel.text = ""
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        if titleLabel.text == "" {
            titleLabel.text = "New Reminder"
        }
        return true
    }
}
