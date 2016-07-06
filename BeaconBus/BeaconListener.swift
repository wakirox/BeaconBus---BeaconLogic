//
//  BeaconListener.swift
//  BeaconBus
//
//  Created by Marius Gabriel  Magadan on 29/06/16.
//  Copyright © 2016 wakirox. All rights reserved.
//

import Foundation
import CoreLocation

protocol BeaconListener : CLLocationManagerDelegate{
    
    func readState(state : BeaconManager.State, shouldPay: Bool)
}