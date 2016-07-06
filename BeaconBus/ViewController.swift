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
        
        beaconStatus.textAlignment = .Center
        
        BeaconManager.instance.beaconListener = self;
        self.setupBeacon()
    }
    
    
    func readState(state: BeaconManager.State, shouldPay: Bool) {
        
        if(shouldPay){
            shouldPayLabel.text = "Give us your money"
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



}

	