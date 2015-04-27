//
//  InterfaceController.swift
//  Weather WatchKit Extension
//
//  Created by Luke de Castro on 2/19/15.
//  Copyright (c) 2015 Luke de Castro. All rights reserved.
//

import WatchKit
import Foundation
import CoreLocation


class InterfaceController: WKInterfaceController, CLLocationManagerDelegate {
    var manager = CLLocationManager()
    var userLocationCity = String()
    var vc = ViewController()
    var watchWeather = String()
    var arrayWeather = [String()]
    var newWatchWeather = String()
    
    @IBOutlet var cityLabel: WKInterfaceLabel!
    @IBOutlet var weatherLabel: WKInterfaceLabel!
    @IBOutlet var weatherImage: WKInterfaceImage!
    
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
    
    @IBAction func searchButton() {
        self.manager.stopUpdatingLocation()
        self.weatherLabel.setText("Loading")
        self.cityLabel.setText("Loading")
        presentTextInputControllerWithSuggestions([self.userLocationCity, "Cupertino", "New York"], allowedInputMode: WKTextInputMode.Plain) { (object: [AnyObject]!) -> Void in
            if object != nil {
                
            var userInput = object[0] as! String
            var userWeather = self.vc.getWeather(userInput)
                
            var userArrayWeather = userWeather.componentsSeparatedByString("\n\n")
            var newUserWeather = "\(userArrayWeather[0])"
                
            self.changeImage(userArrayWeather[0])
                self.cityLabel.setText(userInput)
            self.weatherLabel.setText(self.vc.getWeather(userInput))
            } else {
                self.manager.startUpdatingLocation()
            }
        }
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
                self.cityLabel.setText(self.userLocationCity)
                
                self.arrayWeather = self.watchWeather.componentsSeparatedByString("\n\n")
                self.newWatchWeather = "\(self.arrayWeather[0])"
                
                self.weatherLabel.setText(self.newWatchWeather)
                
                
            }
        })
        changeImage(newWatchWeather)
        
        
}
    func changeImage(weather: String) {
    var convertedWatchWeather: NSString = NSString(string: weather)
    self.weatherImage.setImage(UIImage(named:"Blue-Sky-Wallpaper-.jpg"))
    
    if convertedWatchWeather.containsString("snow") {
    self.weatherImage.setImage(UIImage(named:"snow.jpeg"))
    }
    else if convertedWatchWeather.containsString("rain") {
    self.weatherImage.setImage(UIImage(named:"rain_cloud.jpg"))
    }
    else if convertedWatchWeather.containsString("cloudy") {
    self.weatherImage.setImage(UIImage(named:"cloudy.jpg"))
    }
    else if convertedWatchWeather.containsString("sun") {
    self.weatherImage.setImage(UIImage(named:"sunny.jpg"))
    }
    else {
    self.weatherImage.setImage(UIImage(named: "Blue-Sky-Wallpaper-.jpg"))
    }
    }
}