//
//  ViewController.swift
//  Weather
//
//  Created by Luke de Castro on 2/14/15.
//  Copyright (c) 2015 Luke de Castro. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    var url = NSURL(string: "")
    var weather = ""
    var manager = CLLocationManager()
    var userLocationCity = ""
    var maxTemperature = String()
    var minTemperature = String()
    
    @IBOutlet var backGroundImage: UIImageView!
    
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var cityName: UILabel!
    @IBOutlet var forecastLabel: UILabel!
    @IBOutlet var maxTemp: UILabel!
    @IBOutlet var minTemp: UILabel!
    
    @IBAction func findButtonPressed(sender: AnyObject) {
        
        self.view.endEditing(true)
        
        if cityTextField.text == "" { showError() } else {
            var newCityName = cityTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "-")
            
            var cityArray = newCityName.componentsSeparatedByString("-")
            
            if cityArray[cityArray.count - 1] == ""  {
                newCityName = newCityName.substringToIndex(newCityName.endIndex.predecessor())
            }
            if cityArray[0] == "" {
                newCityName = newCityName.substringFromIndex(newCityName.startIndex.successor())
            }
            
            url = NSURL(string: "http://www.weather-forecast.com/locations/\(newCityName)/forecasts/latest/")
            //println(url)
            if url != nil {
                var task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler:  { (data, response, error) -> Void in
                    var urlError = false
                    
                    if error == nil {
                        var urlContent = NSString(data: data, encoding: NSUTF8StringEncoding) as NSString!
                        //println(urlContent)
                        var urlContentArray = urlContent.componentsSeparatedByString("<span class=\"phrase\">")
                        
                        if urlContentArray.count > 1 {
                            var secondContentArray = urlContentArray[1].componentsSeparatedByString("</span>")
                            
                            self.weather = secondContentArray[0] as! String
                            
                            
                            self.minTemp.hidden = false
                            self.maxTemp.hidden = false
                            
                            self.weather = self.weather.stringByReplacingOccurrencesOfString(".", withString: "\n\n")
                            self.weather = self.weather.stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                            
                            var maxTemperatureFirst = self.weather.componentsSeparatedByString("max")
                            var maxTemperatureSecond = maxTemperatureFirst[1].componentsSeparatedByString("C")
                            self.maxTemperature = maxTemperatureSecond[0]
                            
                            
                            var minTemperatureFirst = self.weather.componentsSeparatedByString(" min ")
                            var minTemperatureSecond = minTemperatureFirst[1].componentsSeparatedByString("C")
                            self.minTemperature = minTemperatureSecond[0]
                            
                            
                            self.weather = self.weather.stringByReplacingOccurrencesOfString("Mon", withString: "Monday")
                            self.weather = self.weather.stringByReplacingOccurrencesOfString("Tue", withString: "Tuesday")
                            self.weather = self.weather.stringByReplacingOccurrencesOfString("Wed", withString: "Wednesday")
                            self.weather = self.weather.stringByReplacingOccurrencesOfString("Thu", withString: "Thursday")
                            self.weather = self.weather.stringByReplacingOccurrencesOfString("Fri", withString: "Friday")
                            self.weather = self.weather.stringByReplacingOccurrencesOfString("Sat", withString: "Saturday")
                            self.weather = self.weather.stringByReplacingOccurrencesOfString("Sun", withString: "Sunday")
                            
                            self.weather = self.weather.stringByReplacingOccurrencesOfString(" W ", withString: " West ")
                            self.weather = self.weather.stringByReplacingOccurrencesOfString(" N ", withString: " North ")
                            self.weather = self.weather.stringByReplacingOccurrencesOfString(" S ", withString: " South ")
                            self.weather = self.weather.stringByReplacingOccurrencesOfString(" E ", withString: " East ")
                            
                        } else {
                            urlError = true
                        }
                        
                    } else {
                       urlError = true
                    }
                    dispatch_async(dispatch_get_main_queue() ) {
                        if urlError == true {
                            self.showError()
                        } else {
                            println(self.weather)
                            
                            
                            
                            
                            
                            var newWeather = NSString(string: self.weather)
                            
                            if newWeather.containsString("snow") {
                                self.updateBackgroundImage("snow.jpeg")
                            }
                            else if newWeather.containsString("rain") {
                                self.updateBackgroundImage("rain_cloud.jpg")
                                self.forecastLabel.textColor = UIColor.blackColor()
                            }
                            else if newWeather.containsString("cloudy") {
                                self.updateBackgroundImage("cloudy.jpg")
                                self.forecastLabel.textColor = UIColor.blackColor()
                            }
                            else if newWeather.containsString("sun") {
                                self.updateBackgroundImage("sunny.jpg")
                            }
                            else {
                                self.backGroundImage.image = UIImage(named: "Blue-Sky-Wallpaper-.jpg")
                                self.forecastLabel.textColor = UIColor.blackColor()
                            }
                            
                            UIView.animateWithDuration(0.5, animations: {
                            self.forecastLabel.alpha = 0
                            self.cityName.alpha = 0
                            self.maxTemp.alpha = 0
                            self.minTemp.alpha = 0
                                })
                            
                            self.maxTemp.text = self.maxTemperature + "C"
                            self.minTemp.text = self.minTemperature + "C"
                            
                            self.forecastLabel.text = self.weather
                            self.cityName.text = self.cityTextField.text
                            self.cityTextField.text = ""
                            
                            UIView.animateWithDuration(1, animations: {
                                self.forecastLabel.alpha = 1
                                self.cityName.alpha = 1
                                self.minTemp.alpha = 0.6
                                self.maxTemp.alpha = 1
                           })
                        }
                    }
                })
                task.resume()
                
            }
            else {
                showError()
            }
        }
    }

    func showError() {
        forecastLabel.text = "Was not able to find forecast for " + cityTextField.text + "."
        cityName.text = "Error"
        self.view.endEditing(true)
        minTemp.hidden = true
        maxTemp.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Core Location
        minTemp.text = ""
        maxTemp.text = ""
        minTemp.hidden = true
        maxTemp.hidden = true
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        cityName.text = "Please enter a city name"
        forecastLabel.text = ""
        forecastLabel.alpha = 0
        
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
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
            }
        })
    }
    @IBAction func myLocationActivate(sender: AnyObject) {
        cityTextField.text = userLocationCity
        if cityTextField.text == "" {
            var noLocationAlert = UIAlertView()
            noLocationAlert.title = "Error"
            noLocationAlert.message = "The location does not seem to be working at this time. \nPlease try again later."
            noLocationAlert.addButtonWithTitle("Ok")
            noLocationAlert.show()
        }
    }
    func updateBackgroundImage(bImage: String) {
        UIView.animateWithDuration(1, animations: {
            self.backGroundImage.alpha = 0
        })
        backGroundImage.image = UIImage(named: bImage)
        UIView.animateWithDuration(1, animations: {
        self.backGroundImage.alpha = 0.8
            self.forecastLabel.textColor = UIColor.blackColor()
        })
        
    }
    func getWeather(input: String) -> String {
        if input == "" { println("nothing in the search box") } else {
            var newCityName = input.stringByReplacingOccurrencesOfString(" ", withString: "-")
            
            var cityArray = newCityName.componentsSeparatedByString("-")
            
            if cityArray[cityArray.count - 1] == ""  {
                newCityName = newCityName.substringToIndex(newCityName.endIndex.predecessor())
            }
            if cityArray[0] == "" {
                newCityName = newCityName.substringFromIndex(newCityName.startIndex.successor())
            }
            
            url = NSURL(string: "http://www.weather-forecast.com/locations/\(newCityName)/forecasts/latest")
            //println(url)
            if url != nil {
                var task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler:  { (data, response, error) -> Void in
                    var urlError = false
                    
                    if error == nil {
                        var urlContent = NSString(data: data, encoding: NSUTF8StringEncoding) as NSString!
                        //println(urlContent)
                        var urlContentArray = urlContent.componentsSeparatedByString("<span class=\"phrase\">")
                        
                        if urlContentArray.count > 1 {
                            var secondContentArray = urlContentArray[1].componentsSeparatedByString("</span>")
                            
                            self.weather = secondContentArray[0] as! String
                            self.weather = self.weather.stringByReplacingOccurrencesOfString(".", withString: "\n\n")
                            self.weather = self.weather.stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                            
                            self.weather = self.weather.stringByReplacingOccurrencesOfString("Mon", withString: "Monday")
                            self.weather = self.weather.stringByReplacingOccurrencesOfString("Tue", withString: "Tuesday")
                            self.weather = self.weather.stringByReplacingOccurrencesOfString("Wed", withString: "Wednesday")
                            self.weather = self.weather.stringByReplacingOccurrencesOfString("Thu", withString: "Thursday")
                            self.weather = self.weather.stringByReplacingOccurrencesOfString("Fri", withString: "Friday")
                            self.weather = self.weather.stringByReplacingOccurrencesOfString("Sat", withString: "Saturday")
                            self.weather = self.weather.stringByReplacingOccurrencesOfString("Sun", withString: "Sunday")
                            
                            self.weather = self.weather.stringByReplacingOccurrencesOfString(" W ", withString: " West ")
                            self.weather = self.weather.stringByReplacingOccurrencesOfString(" N ", withString: " North ")
                            self.weather = self.weather.stringByReplacingOccurrencesOfString(" S ", withString: " South ")
                            self.weather = self.weather.stringByReplacingOccurrencesOfString(" E ", withString: " East ")
                            
                        } else {
                            urlError = true
                        }
                        
                    } else {
                        urlError = true
                    }
                    if urlError == true {
                        self.showError()
                    } else {
                        println(self.weather)
                        
                    }
                })
                task.resume()
                
            }
            else {
                showError()
            }
        }
        return weather
}
}

