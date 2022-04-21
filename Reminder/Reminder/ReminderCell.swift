//
//  TableViewCell.swift
//  Reminder
//
//  Created by Mohanraj on 14/04/22.
//

import UIKit

class ReminderCell: UITableViewCell {
    
    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
