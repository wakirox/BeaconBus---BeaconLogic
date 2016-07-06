//
//  ViewController.swift
//  BeaconBus
//
//  Created by Marius Gabriel  Magadan on 28/06/16.
//  Copyright © 2016 wakirox. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class ViewController: UIViewController ,CBPeripheralManagerDelegate{
    
    @IBOutlet weak var beaconStatus: UILabel!;

    @IBOutlet weak var shouldPayLabel: UILabel!
    
    
    let locationManager = CLLocationManager()
    let myBTManager = CBPeripheralManager()
    var lastStage = CLProximity.Unknown

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        beaconStatus.textAlignment = .Center
        
        BeaconManager.instance.beaconListener = self;
        self.setupBeacon()
    }
    
    
    func readState(state: BeaconManager.State, shouldPay: Bool) {
        
        if(shouldPay){
            shouldPayLabel.text = "Give us your money"
            
            sendUINotification("Dovresti pagare il bus")
        }else{
            sendUINotification(state.rawValue)
        }
        
        simpleAlert("Beacon", message: state.rawValue)
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        
        if peripheral.state == CBPeripheralManagerState.PoweredOff {
            
            simpleAlert("Beacon", message: "Turn On Your Device Bluetooh")
        }
    }
    
    
    func sendUINotification(state : String){
        
        if(UIApplication.sharedApplication().applicationState != .Active){
            let notification = UILocalNotification()
            notification.alertBody = state
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        }
    }



}

	