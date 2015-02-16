//
//  ViewController.swift
//  Weather
//
//  Created by Luke de Castro on 2/14/15.
//  Copyright (c) 2015 Luke de Castro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var url = NSURL(string: "")
    var weather = ""
    
    @IBOutlet var leftImage: UIImageView!
    @IBOutlet var rightImage: UIImageView!
    
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var cityName: UILabel!
    @IBOutlet var forecastLabel: UILabel!
    @IBAction func findButtonPressed(sender: AnyObject) {
        var newCityName = cityTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "-")
        
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
                        //println(urlContentArray[1])
                        var secondContentArray = urlContentArray[1].componentsSeparatedByString("</span>")
                        //println(secondContentArray[0])
                        self.weather = secondContentArray[0] as String
                        //self.weather = self.weather.stringByReplacingOccurrencesOfString(".", withString: "\n")
                        self.weather = self.weather.stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                        
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
                    self.forecastLabel.text = self.weather
                    self.cityName.text = self.cityTextField.text
                    self.cityTextField.text = ""
                    
                    var newWeather = NSString(string: self.weather)
                    
                    if newWeather.containsString("snow") {
                        self.leftImage.image = UIImage(named: "snow.jpeg")
                        self.rightImage.image = UIImage(named: "snow.jpeg")
                    }
                    else if newWeather.containsString("rain") {
                        self.leftImage.image = UIImage(named: "rain.jpg")
                        self.rightImage.image = UIImage(named: "rain.jpg")
                    }
                    else if newWeather.containsString("cloudy") {
                        self.leftImage.image = UIImage(named: "cloudy.jpg")
                        self.rightImage.image = UIImage(named: "cloudy.jpg")
                    }
                    else if newWeather.containsString("sun") {
                        self.leftImage.image = UIImage(named: "sunny.jpg")
                        self.rightImage.image = UIImage(named: "sunny.jpg")
                    }
                    else {
                        self.leftImage.image = nil
                        self.rightImage.image = nil
                    }
                    
                }
                }
            })
            task.resume()
        }
        else {
            showError()
        }
        
    }
    func showError() {
        forecastLabel.text = "Was not able to find forecast for " + cityTextField.text + ". \nTry deleting any spaces in the search field"
        cityName.text = "Error"
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        cityName.text = "Put in a city name"
        forecastLabel.text = ""
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

}

