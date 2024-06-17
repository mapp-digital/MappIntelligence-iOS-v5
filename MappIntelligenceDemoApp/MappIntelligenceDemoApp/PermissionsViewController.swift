//
//  PermissionsViewController.swift
//  MappIntelligenceDemoApp
//
//  Created by Stefan Stevanovic on 17.6.24..
//  Copyright © 2024 Mapp Digital US, LLC. All rights reserved.
//

import UIKit
import Photos
import CoreLocation

class PermissionsViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager?.delegate = self
    }
    
    @IBAction func cameraPermission(_ sender: Any) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
               if response {
                   //access granted
               } else {

               }
           }
    }
    
    @IBAction func locationPermission(_ sender: Any) {
        locationManager?.requestAlwaysAuthorization()
    }
    
    
    @IBAction func galleryPermission(_ sender: Any) {
        let photos = PHPhotoLibrary.authorizationStatus()
            if photos == .notDetermined {
                PHPhotoLibrary.requestAuthorization({status in
                    if status == .authorized{
                        //...
                    } else {}
                })
            }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                }
            }
        }
    }
    @IBAction func FaceIDPermission(_ sender: Any) {
    }
    
    @IBAction func MicrophonePermission(_ sender: Any) {
    }
    
    
    @IBAction func testBluetoothPermission(_ sender: Any) {
    }
}
