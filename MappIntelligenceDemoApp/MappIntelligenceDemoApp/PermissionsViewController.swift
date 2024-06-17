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

class PermissionsViewController: UIViewController, CLLocationManagerDelegate, CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
                   case .unauthorized:
            if #available(iOS 13.0, *) {
                switch central.authorization {
                case .allowedAlways: break
                case .denied: break
                case .restricted: break
                case .notDetermined: break
                @unknown default:
                    break;
                }
            } else {
                // Fallback on earlier versions
            }
        case .unknown: break
        case .unsupported: break
        case .poweredOn:
        self.centralManager?.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
        case .poweredOff: break
        case .resetting: break
                   @unknown default:
            break;
                   }
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
        let alertController = UIAlertController(
                    title: "Enable Face ID/Touch ID",
                    message: "To use biometric authentication, you need to enable Face ID/Touch ID for this app in your device settings.",
                    preferredStyle: .alert
                )
                let settingsAction = UIAlertAction(title: "Go to Settings", style: .default) { _ in
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    }
                }
                alertController.addAction(settingsAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
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
