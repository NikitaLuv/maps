//
//  MapVC.swift
//  Maps
//
//  Created by nikita on 12.01.2021.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    let location = CLLocationManager()
    
    @IBOutlet weak var MapKit: MKMapView!
    
    struct Points {
        var lat = 0.0
        var lon = 0.0
        var name = ""
    }
    
    var pointArray = [Points]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        location.delegate = self
        MapKit.delegate = self
        
        location.startUpdatingLocation()
        pointPositions()
        pointsPositionalCollege()
        infoAction()
        
        MapKit.userLocation.title = "I'm here"
        MapKit.userLocation.subtitle = "You find me"
        MapKit.showsUserLocation = true
    }
    
    
    func mapView(_ MapKit: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.coordinate.latitude != MapKit.userLocation.coordinate.latitude && annotation.coordinate.longitude != MapKit.userLocation.coordinate.longitude {
            let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker")
            
            marker.canShowCallout = true
            let infoButton = UIButton(type: .detailDisclosure)
            infoButton.addTarget(self, action: #selector(infoAction), for: .touchUpInside)
            marker.rightCalloutAccessoryView = infoButton
            marker.calloutOffset = CGPoint(x: -5, y: 5)
            return marker
        }
        return nil
    }
    
    @objc func infoAction() {
        print("Info")
    }
    
    // Функция, которая будет принимать координаты и приближать карту.
    func mapToCoordinate(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        MapKit.setRegion(region, animated: true)
    }
    
    // Функция, которая которая будет проверять обновление координат.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            mapToCoordinate(coordinate: location)
        }
    }
    
    // Фукниця для хранения массива и названием отделение коллажа
    func pointsPositionalCollege() {
        let arrayLat = [55.818176, 55.844996, 55.860595, 55.860337]
        let arrayLon = [37.496261, 37.520960, 37.492089, 37.517689]
        let arrayName = ["ЦИКТ", "ЦПиРБ", "ЦАВТ", "ЦТЭК"]
        
        for number in 0..<arrayLat.count {
            pointArray.append(Points(lat: arrayLat[number], lon: arrayLon[number], name: arrayName[number]))
        }
    }
    
    // Функция для отрисовки массива.
    func pointPositions() {
        for number in 0..<pointArray.count {
            let point = MKPointAnnotation()
            point.title = pointArray[number].name
            point.coordinate = CLLocationCoordinate2D(latitude: pointArray[number].lat, longitude: pointArray[number].lon)
            MapKit.addAnnotation(point)
        }
    }
}
