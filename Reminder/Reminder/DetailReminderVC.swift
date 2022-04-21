//
//  DetailReminderVC.swift
//  Reminder
//
//  Created by Mohanraj on 16/04/22.
//

import UIKit

class DetailReminderVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var detailView: UIView!
    
    var selectedReminder: ReminderData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateData()
        self.detailView.layer.cornerRadius = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UpdateData()
    }
    
    func UpdateData(){
        if (selectedReminder != nil)
        {
            titleLabel.text = selectedReminder?.title
            notesLabel.text = selectedReminder?.notes
            
            let thisReminder : ReminderData!
            thisReminder = selectedReminder
            
            //MARK: Date format
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "dd MMMM yyyy"
            //  dateFormatter1.dateStyle = .medium
            let somedateString1 = dateFormatter1.string(from: thisReminder.date!)
            timerLabel.text = somedateString1
            
            //MARK: Time format
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            let somedateString = dateFormatter.string(from: thisReminder.date!)
            dateLabel.text = somedateString
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditVc" {
            let reminderDetail = segue.destination as? AddReminderVC
            
            let selectedReminder1 : ReminderData!
            selectedReminder1 = self.selectedReminder
            
            reminderDetail?.selectedReminder1 = selectedReminder1
        }
    }

    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "EditVc", sender: self)
    }
    
}
