//
//  ViewController.swift
//  Reminder
//
//  Created by Mohanraj on 14/04/22.
//

import UIKit
import CoreData


class ReminderListVC: UITableViewController {

    @IBOutlet weak var segmentButton: UISegmentedControl!
    
    var reminders = [ReminderData]()
    
    var filteredReminders: [ReminderData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchReminders()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
        FliterData()
    }
    
    var filter:Filter = .today
    var futureData:Filter = .future
    var allData:Filter = .all
    
    enum Filter:Int{
        case today
        case future
        case all
        
        func shouldInclude(date: Date) -> Bool {
            let isInToday = Locale.current.calendar.isDateInToday(date)
            switch self {
            case .today:
                return isInToday
            case .future:
                return (date > Date()) && !isInToday
            case .all:
                return true
            }
        }
    }

    func fetchReminders(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ReminderData")
        
        do {
            let results = try context.fetch(request) as? [ReminderData]
            self.reminders = results ?? []
//            for result in results {
//                let reminders = result as! ReminderData
//                reminders = reminders
                self.tableView.reloadData()
//            }
        } catch {
            print("Fetch Failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailVC" {
            
            let indexpath = tableView.indexPathForSelectedRow!
            let reminderDetail = segue.destination as? DetailReminderVC
            
            let selectedReminder : ReminderData!
            selectedReminder = filteredReminders[indexpath.row]
            
            reminderDetail?.selectedReminder = selectedReminder
            
            tableView.deselectRow(at: indexpath, animated: true)
        }
    }
    
    func FliterData(){
        switch segmentButton.selectedSegmentIndex {
            
        case 0:
            filteredReminders = reminders.filter { filter.shouldInclude(date: $0.date!) }.sorted { $0.date! < $1.date! }
            tableView.reloadData()
            
        case 1:
            filteredReminders = reminders.filter { futureData.shouldInclude(date: $0.date!)}.sorted { $0.date! < $1.date! }
            tableView.reloadData()
    
        case 2:
            filteredReminders = reminders.filter{ allData.shouldInclude(date: $0.date!)}.sorted { $0.date! < $1.date! }
            tableView.reloadData()
        default:
            break
        }
    }
    
    @IBAction func fliterButtonPressed(_ sender: UISegmentedControl){
        FliterData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let RemVC = self.storyboard!.instantiateViewController(withIdentifier: "addRemVC") as! AddReminderVC
        self.navigationController?.pushViewController(RemVC, animated: true)
    }
    
}

extension ReminderListVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredReminders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "remainderCell", for: indexPath) as! ReminderCell
        let thisReminder : ReminderData!
        thisReminder = filteredReminders[indexPath.row]
        cell.titelLabel.text = thisReminder.title
        
        //MARK: Date format
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd MMMM yyyy"
      //  dateFormatter1.dateStyle = .medium
        let somedateString1 = dateFormatter1.string(from: thisReminder.date!)
        cell.dateLabel.text = somedateString1
        
      
        //MARK: Time format
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        let somedateString = dateFormatter.string(from: thisReminder.date!)
        cell.timeLabel.text = somedateString
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "DetailVC", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            // remove the deleted item from the model
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            context.delete(reminders[indexPath.row])
            reminders.remove(at: indexPath.row)
            try! context.save()
            
            // remove the deleted item from the filteredModel
            if segmentButton.selectedSegmentIndex == 0 {
                filteredReminders.remove(at: indexPath.row)

            }else if segmentButton.selectedSegmentIndex == 1 {
                filteredReminders.remove(at: indexPath.row)

            }else {
                filteredReminders.remove(at: indexPath.row)
            }
            
            do{
                try context.save()
            }catch{
                print("Delete Failed")
            }
            // remove the deleted item from the `UITableView`
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            return
            
        }
    }
}
