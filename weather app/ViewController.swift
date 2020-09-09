//
//  ViewController.swift
//  weather app
//
//  Created by eric movchan on 16/08/2020.
//  Copyright © 2020 eric movchan. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import NVActivityIndicatorView
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    
    //MARK: - View Outlets
    
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var dayLabel:      UILabel!
    
    @IBOutlet var conditionImageView: UIImageView!
    @IBOutlet var conditionLabel:     UILabel!
    
    @IBOutlet var tempretureLabel:   UILabel!
    
    @IBOutlet var backGroundView: UIView!
    
    //variables
    let gradientLayer = CAGradientLayer()
    
    let apiKey = "4a378cb68a9b84d313711d0c255d09b1"
    var lat = 32.0853
    var lon = 34.7818
    var activityIndicator: NVActivityIndicatorView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backGroundView.layer.addSublayer(gradientLayer)
        
        //loading animation
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: .white, padding: 20.0)
        activityIndicator.backgroundColor = .black
        view.addSubview(activityIndicator)
        
        //location
        locationManager.requestWhenInUseAuthorization()
            if(CLLocationManager.locationServicesEnabled()){
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setBlueGradientBackGround()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric").responseJSON {
            response in
            self.activityIndicator.stopAnimating()
            if let responseStr = response.result.value{
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let iconName = jsonWeather["icon"].stringValue
                
                self.locationLabel.text = jsonResponse["name"].stringValue
                self.conditionImageView.image = UIImage(named: iconName)
                self.conditionLabel.text = jsonWeather["main"].stringValue
                self.tempretureLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                self.dayLabel.text = dateFormatter.string(from: date)
                
                let suffix = iconName.suffix(1)
                if(suffix == "n"){
                    self.setGreyGradientBackGround()
                }else{
                    self.setBlueGradientBackGround()
                }
                
            }
        }
        
    }

    func setBlueGradientBackGround(){
        let topColor = UIColor(red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255, green: 144.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor , bottomColor]
    }
    
    func setGreyGradientBackGround(){
        let topColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor , bottomColor]
    }

}

