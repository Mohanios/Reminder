//
//  NotesCell.swift
//  Reminder
//
//  Created by Mohanraj on 14/04/22.
//

import UIKit

class NotesCell: UITableViewCell {

    @IBOutlet weak var notesTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
