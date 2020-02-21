//
//  CarDetailheaderView.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 08/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage

class CarDetailheaderView: UIView {
    @IBOutlet var weakWrapperView: UIView!
    @IBOutlet var topview: UIView!
    @IBOutlet var centreview: UIView!
    @IBOutlet var wrapperView: UIView!
    @IBOutlet var amenitiesCollectionView: UICollectionView!
    @IBOutlet var rent_Lbl: CustomLabel!
    @IBOutlet var rating_Lbl: CustomLabel!
    @IBOutlet var time_Lbl: CustomLabel!
    @IBOutlet var drivername2Lbl: CustomLabel!
    @IBOutlet var driver_name: CustomLabel!
    @IBOutlet var driverimg: UIImageView!
    @IBOutlet var pricepermonthLbl: CustomLabel!
    @IBOutlet var priceperweekLbl: CustomLabel!
    @IBOutlet var priceperdayLbl: CustomLabel!
    @IBOutlet var CollectionView: UICollectionView!
    @IBOutlet var rating_View: TPFloatRatingView!
    @IBOutlet var pageControl: FXPageControl!
    
    @IBOutlet var monthwrapperView: UIView!
    @IBOutlet var monthLbl: UILabel!
    @IBOutlet var weeekofferLbl: UILabel!
    @IBOutlet var backward_Btn: UIButton!
    @IBOutlet var forwarBtn: UIButton!
    @IBOutlet var notes: CustomLabel!
    @IBOutlet var mapKit: MKMapView!
     @IBOutlet var milLbl: CustomLabel!
    @IBOutlet var tickimg: UIImageView!
    @IBOutlet var carnameLbl: CustomLabel!
    var CurrentPage:Int = Int()
    var objRecord:CarRecord = CarRecord()
    var pages: Int!

    @IBOutlet var bottomView: UIView!
    @IBOutlet var vehnumber: CustomLabel!
    @IBOutlet var VIN_NUMBER: CustomLabel!
    @IBOutlet var aboutcar: CustomLabel!
    
    var datasource:[[[String:Any]]] = [[[String:Any]]()]
    override func awakeFromNib() {
        let nibName = UINib(nibName: "SliderCollectionViewCell", bundle:nil)
        CollectionView.register(nibName, forCellWithReuseIdentifier: "SliderCollectionViewCellID")
        let AboutcarnibName = UINib(nibName: "JoinAboutCollectionViewCell", bundle:nil)
        amenitiesCollectionView.register(AboutcarnibName, forCellWithReuseIdentifier: "JoinAboutCollectionViewCellID")
        CollectionView.dataSource = self
        CollectionView.delegate = self
        amenitiesCollectionView.dataSource = self
        amenitiesCollectionView.delegate = self
        pageControl.selectedDotColor = Themes.sharedInstance.returnThemeColor()
        pageControl.dotColor = UIColor.lightGray
        pageControl.currentPage = 0
        CurrentPage = 0
        mapKit.isUserInteractionEnabled = false
         if(objRecord.features.count > 3)
        {
            backward_Btn.isHidden = false
            forwarBtn.isHidden = false
        }
        else
        {
            backward_Btn.isHidden = true
            forwarBtn.isHidden = true
        }
        weakWrapperView.rotate(angle: 315)
        monthwrapperView.rotate(angle: 315)
        backward_Btn.isHidden = false
        forwarBtn.isHidden = false
        datasource.removeAll()
        }
    
    func reloadata()
    {
        datasource.removeAll()
        var arraycount:Int = objRecord.features.count/3
        print("the arr count is \(arraycount)......\(objRecord.features.count)")
        var data_source:NSMutableArray = NSMutableArray(array: objRecord.features)
        for i in 0..<arraycount
        {
            var array:[[String:Any]] = [[String:Any]]()
            if(data_source.count == 0)
            {
                break
            }
            else if(data_source.count >= 3)
            {
                for j in 0..<3
                {
                    let dict = data_source[j]
                    array.append(dict as! [String : Any])
                }
                data_source.removeObject(at: 0)
                data_source.removeObject(at: 0)
                data_source.removeObject(at: 0)
                datasource.append(array)
 
            }
            else
            {
                for j in 0..<data_source.count
                {
                    let dict = data_source[j]
                    array.append(dict as! [String : Any])
                }
                data_source.removeAllObjects()
                datasource.append(array)
                
            }
        }
        
        if(data_source.count != 0)
        {
            var array:[[String:Any]] = [[String:Any]]()
             for j in 0..<data_source.count
            {
                let dict = data_source[j]
                array.append(dict as! [String : Any])
            }
            data_source.removeAllObjects()
            datasource.append(array)
 
         }
    }
    func SetRatingView(value:CGFloat)
    {
        rating_View.emptySelectedImage = UIImage(named: "halfstar")
        rating_View.fullSelectedImage = UIImage(named: "fullstar")
        rating_View.contentMode = .scaleAspectFill
        rating_View.maxRating = 5
        rating_View.minRating = 0
        rating_View.rating = value
        rating_View.editable = false
        rating_View.halfRatings = false
   }
    deinit {
             switch (self.mapKit.mapType) {
             case MKMapType.hybrid:
                self.mapKit.mapType = MKMapType.standard
                break;
             case MKMapType.standard:
                self.mapKit.mapType = MKMapType.hybrid
                break;
            default:
                break;
            }
            self.mapKit.showsUserLocation = false
            self.mapKit.delegate = nil
            self.mapKit.removeFromSuperview()
            self.mapKit = nil
     }
    
    func Setmap()
    {
        DispatchQueue.main.async {
            let location = CLLocation(latitude: Double(self.objRecord.latitude)! , longitude: Double(self.objRecord.longitude)!)
           let userCoordinate = CLLocationCoordinate2D(latitude: Double(self.objRecord.latitude)!, longitude: Double(self.objRecord.longitude)!)
            let eyeCoordinate =  CLLocationCoordinate2D(latitude: Double(self.objRecord.latitude)!, longitude: Double(self.objRecord.longitude)!)
             let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: eyeCoordinate, eyeAltitude: 400)
            //Setup our Map View
            self.mapKit.setCamera(mapCamera, animated: true)
            self.addRadiusCircle(location:location)
         }
     }
 
    @IBAction func DidclickForward(_ sender: Any) {
        if(CurrentPage+1 < datasource.count)
        {
            let indexPath =  IndexPath.init(item: CurrentPage+1, section: 0)
            
            amenitiesCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.right, animated: true)
            CurrentPage = CurrentPage + 1
         }
        else
        {
            CurrentPage = datasource.count-1
        }
 
    }
    @IBAction func DidclickBackWard(_ sender: Any) {
        
        if(CurrentPage-1 >= 0)
        {
            let indexPath =  IndexPath.init(item: CurrentPage-1, section: 0)
             amenitiesCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: true)
            CurrentPage = CurrentPage - 1

         }
        else
        {
            CurrentPage = 0
        }

        
    }
}

extension CarDetailheaderView:MKMapViewDelegate
{
    func addRadiusCircle(location: CLLocation){
        self.mapKit.delegate = self
        let circle = MKCircle.init(center: location.coordinate, radius: 80 as CLLocationDistance)
          self.mapKit.add(circle)
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circle = MKCircleRenderer(overlay: overlay)

        if overlay is MKCircle {
            circle.strokeColor = UIColor(red:0.73, green:0.91, blue:1.00, alpha:0.75)
            
            circle.fillColor = UIColor(red:0.73, green:0.91, blue:1.00, alpha:0.75)

                         circle.lineWidth = 2
                        return circle
                    } else {
                        return circle
                    }
    }
    
 
}
extension CarDetailheaderView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    if(collectionView == CollectionView)
    {
    return 0.0
    }
    else
    {
    return 0.0
     }
}
    
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Add inset to the collection view if there are not enough cells to fill the width.
    if(collectionView == CollectionView)
    {
        return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)

    }
    else
    {
//        let cellSpacing: CGFloat? = (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing
//        let cellWidth: CGFloat? = 110
//        let cellCount: Int = collectionView.numberOfItems(inSection: section)
//        var inset: CGFloat = (collectionView.bounds.size.width - (CGFloat(cellCount) * (cellWidth! + cellSpacing!))) * 0.5
//        inset = max(inset, 0.0)
        return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)

    }
}
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
}
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if(collectionView == CollectionView)
    {
    return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    else
    {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)

    }
}
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == CollectionView)
        {
            return objRecord.car_images.count
        }
        else
        {
            return datasource.count

        }
        return 0
     }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var Cell:UICollectionViewCell = UICollectionViewCell()
        if(collectionView == CollectionView)
        {
        let cell:SliderCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCollectionViewCellID", for: indexPath) as! SliderCollectionViewCell
            let dict:NSDictionary = objRecord.car_images[indexPath.row] as!  NSDictionary
            cell.slider_image.sd_setImage(with: URL(string:Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "image"))), placeholderImage: #imageLiteral(resourceName: "carplaceholder"))

            Cell = cell
        }
        else
        {
            let cell:JoinAboutCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "JoinAboutCollectionViewCellID", for: indexPath) as! JoinAboutCollectionViewCell
            let dict:[[String:Any]] = datasource[indexPath.row]
            if(datasource.count == 1)
            {
                cell.wrapperView.frame.origin.x = 0
                 if(dict.count == 1)
                {
                    cell.wrapperView.frame.origin.x = cell.wrapperView.frame.origin.x+80

                }
                else  if(dict.count == 2)
                {
                    cell.wrapperView.frame.origin.x = cell.wrapperView.frame.origin.x+50
                 }
                
            }
          
            else
            {
                cell.wrapperView.frame.origin.x = 0

            }
            cell.featureimg1.isHidden = false
            cell.nameLbl1.isHidden = false
            cell.featureimg2.isHidden = false
            cell.nameLbl2.isHidden = false
            cell.featureimg3.isHidden = false
            cell.nameLbl3.isHidden = false
            if(dict.count == 2)
            {
                let dict1:[String:Any] = dict[0]
                let dict2:[String:Any] = dict[1]

              cell.featureimg3.isHidden = true
              cell.nameLbl3.isHidden = true
                cell.nameLbl1.text = Themes.sharedInstance.CheckNullvalue(Passed_value: dict1["name"])
                cell.featureimg1.sd_setImage(with: URL(string:Themes.sharedInstance.CheckNullvalue(Passed_value: dict1["image"])), placeholderImage: #imageLiteral(resourceName: "carplaceholder"))
                cell.nameLbl2.text = Themes.sharedInstance.CheckNullvalue(Passed_value: dict2["name"])
                cell.featureimg2.sd_setImage(with: URL(string:Themes.sharedInstance.CheckNullvalue(Passed_value: dict2["image"])), placeholderImage: #imageLiteral(resourceName: "carplaceholder"))
            }
            if(dict.count == 3)
            {
                let dict1:[String:Any] = dict[0]
                let dict2:[String:Any] = dict[1]
                let dict3:[String:Any] = dict[2]
                
                cell.nameLbl1.text = Themes.sharedInstance.CheckNullvalue(Passed_value: dict1["name"])
                cell.featureimg1.sd_setImage(with: URL(string:Themes.sharedInstance.CheckNullvalue(Passed_value: dict1["image"])), placeholderImage: #imageLiteral(resourceName: "carplaceholder"))
                 cell.nameLbl2.text = Themes.sharedInstance.CheckNullvalue(Passed_value: dict2["name"])
                cell.featureimg2.sd_setImage(with: URL(string:Themes.sharedInstance.CheckNullvalue(Passed_value: dict2["image"])), placeholderImage: #imageLiteral(resourceName: "carplaceholder"))
                cell.nameLbl3.text = Themes.sharedInstance.CheckNullvalue(Passed_value: dict3["name"])
                cell.featureimg3.sd_setImage(with: URL(string:Themes.sharedInstance.CheckNullvalue(Passed_value: dict3["image"])), placeholderImage: #imageLiteral(resourceName: "carplaceholder"))


            }
            if(dict.count == 1)
            {
                let dict1:[String:Any] = dict[0]  

                cell.featureimg2.isHidden = true
                cell.nameLbl2.isHidden = true
                cell.featureimg3.isHidden = true
                cell.nameLbl3.isHidden = true
                 cell.nameLbl1.text = Themes.sharedInstance.CheckNullvalue(Passed_value: dict1["name"])
                cell.featureimg1.sd_setImage(with: URL(string:Themes.sharedInstance.CheckNullvalue(Passed_value: dict1["image"])), placeholderImage: #imageLiteral(resourceName: "carplaceholder"))

            }
            
            if(dict.count == 0)
            {
                cell.featureimg1.isHidden = true
                cell.nameLbl1.isHidden = true
                cell.featureimg2.isHidden = true
                cell.nameLbl2.isHidden = true
                cell.featureimg3.isHidden = true
                cell.nameLbl3.isHidden = true

            }
            Cell = cell
        }
        return Cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        pageControl.currentPage = currentPage
        CurrentPage = currentPage
        // Do whatever with currentPage.
    }

    
    
}
