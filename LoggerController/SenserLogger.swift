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

import GameController


func getTimestamp() -> String {
    let format = DateFormatter()
    format.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
    return format.string(from: Date())
}

class SensorManager: NSObject, ObservableObject, ReactToMotionEvents {
    var motionManager: CMMotionManager?
    var data = SensorData()
    
    var controllers: [GCController]?
    
    // iPhone
    @Published var accX = 0.0
    @Published var accY = 0.0
    @Published var accZ = 0.0
    @Published var gyrX = 0.0
    @Published var gyrY = 0.0
    @Published var gyrZ = 0.0
    @Published var magX = 0.0
    @Published var magY = 0.0
    @Published var magZ = 0.0
    
    // Game Controller
    @Published var isControllerConnected = false
    
    @Published var controllerAccX = 0.0
    @Published var controllerAccY = 0.0
    @Published var controllerAccZ = 0.0
    @Published var controllerGyrX = 0.0
    @Published var controllerGyrY = 0.0
    @Published var controllerGyrZ = 0.0
    
    var timer = Timer()
    
    override init() {
        super.init()
        self.motionManager = CMMotionManager()
        self.controllers = GCController.controllers()
        
        if self.controllers!.count > 0 {
            self.isControllerConnected = true
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.motionDelegate = self
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
        
        // センサデータを記録する
        let timestamp = getTimestamp()
        
        self.data.append(time: timestamp, x: self.accX, y: self.accY, z: self.accZ, sensorType: .phoneAccelerometer)
        self.data.append(time: timestamp, x: self.gyrX, y: self.gyrY, z: self.gyrZ, sensorType: .phoneGyroscope)
        self.data.append(time: timestamp, x: self.magX, y: self.magY, z: self.magZ, sensorType: .phoneMagnetometer)
    }
    
    // GCMotion
    func motionUpdate(motion: GCMotion) {
        let accX = motion.userAcceleration.x + motion.gravity.x
        let accY = motion.userAcceleration.y + motion.gravity.y
        let accZ = motion.userAcceleration.z + motion.gravity.z
        
        self.controllerAccX = accX
        self.controllerAccY = accY
        self.controllerAccZ = accZ
        
        if motion.hasRotationRate {
            let gyrX = motion.rotationRate.x
            let gyrY = motion.rotationRate.y
            let gyrZ = motion.rotationRate.z
            
            self.controllerGyrX = gyrX
            self.controllerGyrY = gyrY
            self.controllerGyrZ = gyrZ
        }
        else {
            self.controllerGyrX = Double.nan
            self.controllerGyrY = Double.nan
            self.controllerGyrZ = Double.nan
        }
        
        print("GCMotion: \(self.controllerAccX), \(self.controllerAccY), \(self.controllerAccZ)")
    }
    
    func startUpdate(_ freq: Double) {
        if self.motionManager!.isAccelerometerAvailable {
            self.motionManager?.startAccelerometerUpdates()
        }
        
        if self.motionManager!.isGyroAvailable {
            self.motionManager?.startGyroUpdates()
        }
        
        if self.motionManager!.isMagnetometerAvailable {
            self.motionManager?.startMagnetometerUpdates()
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
        
        if self.motionManager!.isAccelerometerActive {
            self.motionManager?.stopAccelerometerUpdates()
        }
        
        if self.motionManager!.isGyroActive {
            self.motionManager?.stopGyroUpdates()
        }
        
        if self.motionManager!.isMagnetometerActive {
            self.motionManager?.stopMagnetometerUpdates()
        }
    }
    
}
