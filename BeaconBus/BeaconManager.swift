//
//  BeaconManager.swift
//  BeaconBus
//
//  Created by Marius Gabriel  Magadan on 29/06/16.
//  Copyright © 2016 wakirox. All rights reserved.
//

import Foundation
import CoreLocation

class BeaconManager{
    
    
    static let instance = BeaconManager();
    
    static let BEACON_BUS : Int = 0;
    static let BEACON_STOP : Int = 1;
    
    var beaconListener : BeaconListener?
    
    var currentState = State.OUT_OF_RANGE
    
    enum State : String {
        case AT_BUS_STOP = "AT_BUS_STOP" //alla fermata
        case IN_BUS = "IN_BUS" //sul bus
        case STOP_CROSSING = "STOP_CROSSING" //sul bus attraversando una fermata
        case OUT_OF_RANGE = "OUT_OF_RANGE"
    }
    
    var beacons : [CLBeacon] = []
    
    func setBeacons(newBeacons : [CLBeacon]){
        self.beacons = newBeacons
        analyzeSimpleSituation()
    }
    
    /**
     *se tutti i beacon in range sono di tipo FERMATA
     */
    func isOnlyBusStop() -> Bool{
        if(beacons.count==0){return false}
        for i in 0...(beacons.count-1) {
            if beacons[i].minor != BeaconManager.BEACON_STOP {
                return false;
            }
        }
        return true;
    }
    
    func thereIsAtLeastOneBusStop() -> Bool{
        
        for i in 0...(beacons.count-1) {
            if beacons[i].minor == BeaconManager.BEACON_STOP {
                return true;
            }
        }
        return false;
        
    }
    
    
    
    /**
     *Verifica la situazione corrente
     */
    func analyzeSimpleSituation(){
        
        
        if(isOnlyBusStop()){
            /**
            Se mi trovo in range solamente di beacon di tipo fermata
            */
            
            changeCurrentState(State.AT_BUS_STOP)
            
        }else if(beacons.count==1 && beacons[0].minor == BeaconManager.BEACON_BUS)	{
            
            /**
            Se mi trovo nel range di un solo beacon di tipo bus si può suporre di essere a bordo del bus?
            */
            
            changeCurrentState(.IN_BUS);
            
        }else if(beacons.count >= 2 && !isOnlyBusStop() && thereIsAtLeastOneBusStop() && beacons[0].minor == BeaconManager.BEACON_BUS && currentState == .IN_BUS){
            /**
             Passando la prima fermata:
             - se sono nel range di più beacon
             - se il più vicino è di tipo bus
             - se il precedente è di tipo bus
             - se ce ne sta almeno una di tipo FERMATA ma non tutte
            */
            
            changeCurrentState(.STOP_CROSSING)
        }else{
            
            changeCurrentState(.OUT_OF_RANGE)
            
        }
        
    }
    
    func changeCurrentState(state: State){
        
        let pay : Bool = currentState == .IN_BUS || state == 		.STOP_CROSSING
        
        if(state != currentState && state != .OUT_OF_RANGE){
            self.currentState = state;	
        }else{
            return
        }
        
        beaconListener?.readState(state, shouldPay: pay)
    
    }



}
