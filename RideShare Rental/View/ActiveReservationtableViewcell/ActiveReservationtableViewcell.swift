//
//  ActiveReservationtableViewcell.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 13/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit

class ActiveReservationtableViewcell: UITableViewCell {
    @IBOutlet weak var bookDoc: CustomButton!
    @IBOutlet weak var reviewBtn: CustomButton!
    @IBOutlet var separator_Lbl: UILabel!
    @IBOutlet var extendedwrapperView: UIView!
    @IBOutlet var extdetail: CustomButton!
    @IBOutlet var extrental2: CustomButton!
    @IBOutlet var address: CustomLabel!
    @IBOutlet var spendimg: UIImageView!
    @IBOutlet var insimg: UIImageView!
    @IBOutlet var waitimg: UIImageView!
    @IBOutlet var carname: CustomLabel!
    @IBOutlet var notes_Lbl: CustomLabel!
    @IBOutlet var yearLbl: CustomLabel!
    @IBOutlet var model_Lbl: CustomLabel!
    @IBOutlet var name_Lbl: CustomLabel!
    @IBOutlet var make_Lbl: CustomLabel!
    @IBOutlet var plate_Lbl: CustomLabel!
    @IBOutlet var vehicle_Lbl: CustomLabel!
    @IBOutlet var vin_Lbl: CustomLabel!
    @IBOutlet var invoice: CustomButton!
    @IBOutlet var doc_Btn: CustomButton!
     @IBOutlet var extrent_Btn: CustomButton!
    @IBOutlet var mytrans_Btn: CustomButton!
    @IBOutlet var time_Lbl: CustomLabel!
    @IBOutlet var price_Lbl: CustomLabel!
    @IBOutlet var end_date: CustomLabel!
    @IBOutlet var start_date: CustomLabel!
    @IBOutlet var profpicimg: CustomimageView!
    @IBOutlet var car_Image: UIImageView!
    @IBOutlet var remain_Lbl: CustomLabel!
    @IBOutlet var spend_Lbl: CustomLabel!
    @IBOutlet var insur_Lbl: CustomLabel!
    @IBOutlet var waiting_Lbl: CustomLabel!
    @IBOutlet var wrapperView: UIView!
    var timer:Timer?
    
    var refDate:Date = Date()

    override func awakeFromNib() {
        super.awakeFromNib()
        
    
    }
    
    func StartClock(date:Date)
    {
                let calendar = Calendar.current
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateTime:String = formatter.string(from: Date())
        let Currdate:Date = Themes.sharedInstance.StrtoDate(str: dateTime, dateFormat: "yyyy-MM-dd HH:mm:ss", timeformat: "GMT")
        
         let units: Set<Calendar.Component> = [.day, .hour, .minute, .second]
       let components = calendar.dateComponents(units, from: Currdate, to: date)
        self.time_Lbl.text = "\(String(describing: components.day!))d \(String(describing:components.hour!))h \(String(describing: components.minute!))m \(String(describing: components.second!))s"
        print(Currdate)
        print(date)

         if(date > Currdate)
        {
            refDate = date
             timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.Rutimer)), userInfo: nil, repeats: true)
          }
        else
         {
            let LateComponents = calendar.dateComponents(units, from:date , to: Currdate)
            if(String(describing: LateComponents.day!) == "0" || String(describing: LateComponents.day!) == "1" )
            {
                self.time_Lbl.text = "Late (\(String(describing: LateComponents.day!+1)) day)"
                
            }
            else
            {
                self.time_Lbl.text = "Late (\(String(describing: LateComponents.day!+1)) days)"
            }
          }
      }
    
    @objc func Rutimer()
    {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date:String = formatter.string(from: Date())
          let Currdate:Date = Themes.sharedInstance.StrtoDate(str: date, dateFormat: "yyyy-MM-dd HH:mm:ss", timeformat: "GMT")
            let units: Set<Calendar.Component> = [.day, .hour, .minute, .second]
     let components = calendar.dateComponents(units, from:Currdate , to: refDate)
        if(refDate > Currdate)
        {
    self.time_Lbl.text = "\(String(describing: components.day!))d \(String(describing:components.hour!))h \(String(describing: components.minute!))m \(String(describing: components.second!))s"
        }
        else
        {
             let LateComponents = calendar.dateComponents(units, from:refDate , to: Currdate)
            if(String(describing: LateComponents.day!) == "0" || String(describing: LateComponents.day!) == "1" )
            {
                self.time_Lbl.text = "Late (\(String(describing: LateComponents.day!)) day)"

            }
            else
            {
                self.time_Lbl.text = "Late (\(String(describing: LateComponents.day!)) days)"
             }
            timer?.invalidate()
            timer = nil

        }

    }
    deinit {
        timer?.invalidate()
        timer = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
