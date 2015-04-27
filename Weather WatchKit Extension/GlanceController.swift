//
//  GlanceController.swift
//  Weather WatchKit Extension
//
//  Created by Luke de Castro on 2/19/15.
//  Copyright (c) 2015 Luke de Castro. All rights reserved.
//

import WatchKit
import Foundation
import CoreLocation


class GlanceController: WKInterfaceController, CLLocationManagerDelegate {
    
    var userLocationCity = String()
    var vc = ViewController()
    var manager = CLLocationManager()
    var watchWeather = String()
    var arrayWeather = [String()]
    
    @IBOutlet var watchCityLabel: WKInterfaceLabel!
    @IBOutlet var watchWeatherLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var userLocation: CLLocation = locations[0] as! CLLocation
        
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: {
            (placemark, error) in
            if (error != nil) {
                println(error)
            }
            else {
                let p: CLPlacemark = CLPlacemark(placemark: placemark[0] as! CLPlacemark)
                
                self.userLocationCity = p.locality
                println(p.locality)
                self.watchWeather = self.vc.getWeather(self.userLocationCity)
                self.watchCityLabel.setText(self.userLocationCity)
                
                self.arrayWeather = self.watchWeather.componentsSeparatedByString("\n\n")
                var newWatchWeather = self.arrayWeather[0]
                
                self.watchWeatherLabel.setText(newWatchWeather)
            
            }
        })
    }

}
