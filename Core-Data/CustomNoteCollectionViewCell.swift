//
//  CustomNoteCollectionViewCell.swift
//  Core-Data
//
//  Created by Safhone Oung on 12/20/17.
//  Copyright © 2017 Safhone Oung. All rights reserved.
//

import UIKit

class CustomNoteCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    func configurationCell(title: String, note: String) {
        titleLabel.text = title
        noteLabel.text = note
    }
    
}
