//
//  MyExpandableTableViewSectionHeader.swift
//  LUExpandableTableViewExample
//
//  Created by Laurentiu Ungur on 24/11/2016.
//  Copyright © 2016 Laurentiu Ungur. All rights reserved.
//

import UIKit
import LUExpandableTableView

final class MytransactionView: LUExpandableTableViewSectionHeader {
    // MARK: - Properties
    
    @IBOutlet var totalAmt: CustomLabel!
    @IBOutlet var total_Lbl: CustomLabel!
    @IBOutlet var car_Lbl: CustomLabel!
    @IBOutlet var wrapperView: UIView!
    @IBOutlet weak var expandCollapseButton: UIButton!
 
    override var isExpanded: Bool {
        didSet {
             expandCollapseButton?.setTitle(isExpanded ? "Close" : "Detail", for: .normal)
        }
    }
    
    // MARK: - Base Class Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
     }
    
    // MARK: - IBActions
    @IBAction func collpse(_ sender: Any) {
        delegate?.expandableSectionHeader(self, shouldExpandOrCollapseAtSection: section)
        
 

    }
    
   
    
    // MARK: - Private Functions
    
    @objc private func didTapOnLabel(_ sender: UIGestureRecognizer) {
        // Send the message to his delegate that was selected
        delegate?.expandableSectionHeader(self, wasSelectedAtSection: section)
    }
}
