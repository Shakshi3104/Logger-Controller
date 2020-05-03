//
//  SensorLogger.swift
//  Logger
//
//  Created by MacBook Air on 2019/05/23.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import Foundation
import CoreMotion
import Combine

class SensorManager: NSObject, ObservableObject {
    let willChange = PassthroughSubject<Void, Never>()
    
    var motionManager: CMMotionManager?
    
    @Published var accX = 0.0
    @Published var accY = 0.0
    @Published var accZ = 0.0
    @Published var gyrX = 0.0
    @Published var gyrY = 0.0
    @Published var gyrZ = 0.0
    
    override init() {
        super.init()
        motionManager = CMMotionManager()
    }
    
    func startUpdate(_ freq: Double) {
        // Accelerometer
        if motionManager!.isAccelerometerAvailable {
            motionManager?.accelerometerUpdateInterval = 1 / freq
            motionManager?.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: { (data, error) in
                let x = data?.acceleration.x
                let y = data?.acceleration.y
                let z = data?.acceleration.z
                
                self.accX = x!
                self.accY = y!
                self.accZ = z!
                self.willChange.send()
            })
        }
        else {
            self.accX = Double.nan
            self.accY = Double.nan
            self.accZ = Double.nan
        }
        
        // Gyroscope
        if motionManager!.isGyroAvailable {
            motionManager?.gyroUpdateInterval = 1 / freq
            motionManager?.startGyroUpdates(to: OperationQueue.current!, withHandler: { (data, error) in
                let x = data?.rotationRate.x
                let y = data?.rotationRate.y
                let z = data?.rotationRate.z
                
                self.gyrX = x!
                self.gyrY = y!
                self.gyrZ = z!
                self.willChange.send()
            })
        }
        else {
            self.gyrX = Double.nan
            self.gyrY = Double.nan
            self.gyrZ = Double.nan
        }
        
        // Magnetometer
        
    }
    
    func stopUpdate() {
        if motionManager!.isAccelerometerActive {
            motionManager?.stopAccelerometerUpdates()
        }
        
        if motionManager!.isGyroActive {
            motionManager?.stopGyroUpdates()
        }
    }
    
}


class SensorLogger {
    
}
