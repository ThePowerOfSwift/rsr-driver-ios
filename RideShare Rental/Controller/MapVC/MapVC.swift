//
//  MapVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 14/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class MapVC: UIViewController {
    var carListArray:NSMutableArray = NSMutableArray()
    @IBOutlet var CollectionView: UICollectionView!
    @IBOutlet var mapView: MKMapView!
    var currentPage:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nibName = UINib(nibName: "MapCollectionViewCell", bundle:nil)
        CollectionView.register(nibName, forCellWithReuseIdentifier: "MapCollectionViewCellID")
        CollectionView.dataSource = self
        CollectionView.delegate = self
        self.mapView.delegate = self
        plotMutliplePinsonMap()
        currentPage = 0



    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DidclickBack(_ sender: Any) {
        self.navigationController?.pop(animated: true)
    }
    
    deinit {
        
        switch (self.mapView.mapType) {
        case MKMapType.hybrid:
            self.mapView.mapType = MKMapType.standard
            break;
        case MKMapType.standard:
            self.mapView.mapType = MKMapType.hybrid
            break;
        default:
            break;
        }
        self.mapView.showsUserLocation = false
        self.mapView.delegate = nil
        self.mapView.removeFromSuperview()
        self.mapView = nil
    }
    
    
   func plotMutliplePinsonMap(){
    
  for i in 0..<carListArray.count {
    let objRec: CarRecord = carListArray[i] as! CarRecord
    let lat: Double =  Double(objRec.latitude)!
    let longitude: Double = Double(objRec.longitude)!
 let thumbnail = JPSThumbnail()
thumbnail.image = UIImage(named: "mapmarker")
thumbnail.tag = i
thumbnail.coordinate = CLLocationCoordinate2DMake(lat, longitude)
//thumbnail.disclosureBlock = {() -> Void in
// }
      mapView.addAnnotation(JPSThumbnailAnnotation(thumbnail: thumbnail) as MKAnnotation)
      }
    
var zoomRect: MKMapRect = MKMapRectNull
for annotation: MKAnnotation in mapView.annotations {
    let annotationPoint: MKMapPoint = MKMapPointForCoordinate(annotation.coordinate)
    let pointRect: MKMapRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1)
    zoomRect = MKMapRectUnion(zoomRect, pointRect)
}
mapView.setVisibleMapRect(zoomRect, animated: true)
 }
    func MoveonMap(objCityRecord:CarRecord)
    {
        
 
        let lat: Double = Double(objCityRecord.latitude)!
        let longitude: Double = Double(objCityRecord.longitude)!
        var coord = CLLocationCoordinate2D()
        coord.latitude = lat
        coord.longitude = longitude
        if lat != 0 {
 
            let userCoordinate = CLLocationCoordinate2D(latitude: Double(lat), longitude: Double(longitude))
            let eyeCoordinate =  CLLocationCoordinate2D(latitude: Double(lat), longitude: Double(longitude))
            
            let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: eyeCoordinate, eyeAltitude: 400)
            //Setup our Map View
            self.mapView.setCamera(mapCamera, animated: true)

         }
    }

    
    }

 extension MapVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MapCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapCollectionViewCellID", for: indexPath) as! MapCollectionViewCell
        let objRecord:CarRecord = carListArray[indexPath.row] as! CarRecord
        cell.car_name.text = "\(objRecord.car_make) \(objRecord.car_model) \(objRecord.year)"
        cell.price_perday.text = Themes.sharedInstance.Getcurrency() + "\(objRecord.rent_daily)"
        cell.price_perweekLbl.text = Themes.sharedInstance.Getcurrency() + "\(objRecord.rent_weekly)"
        cell.price_permonthLbl.text = Themes.sharedInstance.Getcurrency() + "\(objRecord.rent_monthly)"
        cell.car_image.sd_setImage(with: URL(string:objRecord.car_singleimage), placeholderImage: #imageLiteral(resourceName: "carplaceholder"))
        cell.user_img.sd_setImage(with: URL(string:objRecord.user_image), placeholderImage: #imageLiteral(resourceName: "avatar"))
        cell.ratingView.emptySelectedImage = UIImage(named: "halfstar")
        cell.ratingView.fullSelectedImage = UIImage(named: "fullstar")
        cell.ratingView.contentMode = .scaleAspectFill
        cell.ratingView.maxRating = 5
        cell.ratingView.minRating = 0
        cell.ratingView.rating = CGFloat(Double(objRecord.rating)!)
        cell.ratingView.editable = false
        cell.ratingView.halfRatings = false
        
        cell.bannerLbl.label.textColor = UIColor.white
        cell.bannerLbl.label.font = UIFont(name: Constant.sharedinstance.Regular, size: 11)
        cell.bannerLbl.rotate(angle: 310)
        if(objRecord.tag.count > 0)
        {
            cell.bannerLbl.labelText = objRecord.tag
            cell.bannerLbl.isHidden = false
            cell.tagimg.isHidden = false
            cell.bannerLbl.startAnimate()
            cell.bannerLbl.resumeAnimate()
        }
            
        else
        {
            cell.bannerLbl.isHidden = true
            cell.tagimg.isHidden = true
            cell.bannerLbl.pauseAnimate()
        }
 
         return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        currentPage = Int(ceil(x/w))
        if(currentPage <= carListArray.count-1)
        {
        let objRecord:CarRecord = carListArray[currentPage] as! CarRecord
         self.MoveonMap(objCityRecord: objRecord)
        }
         // Do whatever with currentPage.
            }

}


extension MapVC: MKMapViewDelegate {
func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    if view is JPSThumbnailAnnotationViewProtocol {
        let tag:Int =  (((view as? (NSObject & JPSThumbnailAnnotationViewProtocol))?.didSelectAnnotationView(inMap: mapView)))!
        if(tag != currentPage)
        {
        CollectionView.scrollToItem(at: IndexPath(row: tag, section: 0), at: .centeredHorizontally, animated: true)
        }

     }
}
func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
    
    if view is JPSThumbnailAnnotationViewProtocol {
     
        let tag:Int =   ((view as? (NSObject & JPSThumbnailAnnotationViewProtocol))?.didDeselectAnnotationView(inMap: mapView))!
        print(tag)
        if(tag != currentPage)
        {
        CollectionView.scrollToItem(at: IndexPath(row: tag, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}
    
func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is JPSThumbnailAnnotationProtocol {
        return (annotation as? (NSObject & JPSThumbnailAnnotationProtocol))?.annotationView(inMap: mapView)
        
    }
    return nil
}
}

