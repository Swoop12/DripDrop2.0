//
//  ViewController.swift
//  DripDrop2.0
//
//  Created by DevMountain on 12/13/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var tempuratureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var dayOfTheWeekCollectionView: UICollectionView!
    
    var dailyWeathers: [DailyWeather] = []{
        didSet{
            dayOfTheWeekCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayOfTheWeekCollectionView.delegate = self
        dayOfTheWeekCollectionView.dataSource = self
        
        LocationController.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            LocationController.locationManager.delegate = self
            LocationController.locationManager.startUpdatingLocation()
        }
    }
    
    func fetchWeaherFor(location: CLLocation){
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        WeatherController.fetchWeatherAt(latitude: lat, longitude: long) { (weatherService) in
            guard let currentWeather = weatherService?.currentWeather,
                let dailyWeathers = weatherService?.weeklyWeather.dailyWeathers else { return }
            DispatchQueue.main.async {
                self.updateCurrentWeatherViews(for: currentWeather)
                self.dailyWeathers = dailyWeathers
            }
        }
    }
    
    func updateCurrentWeatherViews(for currentWeather: CurrentWeather){
        tempuratureLabel.text = "\(currentWeather.temperature)º"
        summaryLabel.text = currentWeather.summary
    }
}

extension WeatherViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        fetchWeaherFor(location: location)
    }
}

extension WeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyWeathers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as! WeatherCollectionViewCell
        let dailyWeather = dailyWeathers[indexPath.row]
        cell.dailyWeather = dailyWeather
        cell.dayLabel.text = dayOfTheWeek(for: indexPath)
        return cell
        
    }
    
    func dayOfTheWeek(for indexPath: IndexPath) -> String{
        let rightNow = Date()
        let components = Calendar.current.dateComponents([.weekday], from: rightNow)
        var weekDay = components.weekday! + indexPath.row
        if weekDay > 6 { weekDay = 0 }
        return Calendar.current.weekdaySymbols[weekDay]
    }
}

