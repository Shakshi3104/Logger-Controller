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
    var motionManager: CMMotionManager?
    
    @Published var accX = 0.0
    @Published var accY = 0.0
    @Published var accZ = 0.0
    @Published var gyrX = 0.0
    @Published var gyrY = 0.0
    @Published var gyrZ = 0.0
    @Published var magX = 0.0
    @Published var magY = 0.0
    @Published var magZ = 0.0
    
    var timer = Timer()
    
    override init() {
        super.init()
        self.motionManager = CMMotionManager()
    }
    
    @objc private func startLogSensor() {
        
        if let data = motionManager?.accelerometerData {
            let x = data.acceleration.x
            let y = data.acceleration.y
            let z = data.acceleration.z
            
            self.accX = x
            self.accY = y
            self.accZ = z
        }
        else {
            self.accX = Double.nan
            self.accY = Double.nan
            self.accZ = Double.nan
        }
        
        if let data = motionManager?.gyroData {
            let x = data.rotationRate.x
            let y = data.rotationRate.y
            let z = data.rotationRate.z
            
            self.gyrX = x
            self.gyrY = y
            self.gyrZ = z
        }
        else {
            self.gyrX = Double.nan
            self.gyrY = Double.nan
            self.gyrZ = Double.nan
        }
        
        if let data = motionManager?.magnetometerData {
            let x = data.magneticField.x
            let y = data.magneticField.y
            let z = data.magneticField.z
            
            self.magX = x
            self.magY = y
            self.magZ = z
        }
        else {
            self.magX = Double.nan
            self.magY = Double.nan
            self.magZ = Double.nan
        }
        
        print("\(self.accX), \(self.accY), \(self.accZ)")
    }
    
    func startUpdate(_ freq: Double) {
        if motionManager!.isAccelerometerAvailable {
            motionManager?.startAccelerometerUpdates()
        }
        
        if motionManager!.isGyroAvailable {
            motionManager?.startGyroUpdates()
        }
        
        if motionManager!.isMagnetometerAvailable {
            motionManager?.startMagnetometerUpdates()
        }
        
        // プル型でデータ取得
        self.timer = Timer.scheduledTimer(timeInterval: 1.0 / freq,
                           target: self,
                           selector: #selector(self.startLogSensor),
                           userInfo: nil,
                           repeats: true)
        
    }
    
    func stopUpdate() {
        self.timer.invalidate()
        
        if motionManager!.isAccelerometerActive {
            motionManager?.stopAccelerometerUpdates()
        }
        
        if motionManager!.isGyroActive {
            motionManager?.stopGyroUpdates()
        }
        
        if motionManager!.isMagnetometerActive {
            motionManager?.stopMagnetometerUpdates()
        }
    }
    
}


class SensorLogger {
    
}
