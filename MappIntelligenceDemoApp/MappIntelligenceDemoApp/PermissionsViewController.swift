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
import CoreBluetooth
import LocalAuthentication

class PermissionsViewController: UIViewController, CLLocationManagerDelegate, CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var consoleLog = ""

        switch central.state {
        case .poweredOff:
            consoleLog = "BLE is powered off"
        case .poweredOn:
            consoleLog = "BLE is poweredOn"
        case .resetting:
            consoleLog = "BLE is resetting"
        case .unauthorized:
            consoleLog = "BLE is unauthorized"
        case .unknown:
            consoleLog = "BLE is unknown"
        case .unsupported:
            consoleLog = "BLE is unsupported"
        default:
            consoleLog = "default"
        }
        print(consoleLog)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

            self.peripheral = peripheral
            self.peripheral?.delegate = self
            
            centralManager?.connect(peripheral, options: nil)
            centralManager?.stopScan()
     }
    
    
    var locationManager: CLLocationManager?
    var centralManager: CBCentralManager?
    var peripheral: CBPeripheral?

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
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        //self?.unlockSecretMessage()
                    } else {
                        // error
                    }
                }
            }
        } else {
            // no biometry
        }
    }
    
    @IBAction func MicrophonePermission(_ sender: Any) {
        switch AVAudioSession.sharedInstance().recordPermission {
            case .granted:
                print("Permission granted")
            case .denied:
                print("Permission denied")
            case .undetermined:
                print("Request permission here")
                AVAudioSession.sharedInstance().requestRecordPermission({ granted in
                    // Handle granted
                })
            @unknown default:
                print("Unknown case")
            }
    }
    
    
    @IBAction func testBluetoothPermission(_ sender: Any) {
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
}
