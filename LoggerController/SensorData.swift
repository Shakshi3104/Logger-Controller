//
//  SensorData.swift
//  Logger5
//
//  Created by MacBook Air on 2020/08/24.
//  Copyright © 2020 MacBook Air. All rights reserved.
//

import Foundation

// センサーの種類
enum SensorType {
    case phoneAccelerometer
    case phoneGyroscope
    case phoneMagnetometer
    case watchAccelerometer
    case watchGyroscope
    case headphoneAccelerometer
    case headphoneGyroscope
}

// CSVファイル用のデータ保持
struct SensorData {
    var accelerometerData: String
    var gyroscopeData: String
    var magnetometerData: String
    
    
    private let column = "time,x,y,z\n"
    
    
    init() {
        self.accelerometerData = self.column
        self.gyroscopeData = self.column
        self.magnetometerData = self.column
    }
    
    // センサデータを記録する
    mutating func append(time: String, x: Double, y: Double, z: Double, sensorType: SensorType) {
        var line = time + ","
        line.append(String(x) + ",")
        line.append(String(x) + ",")
        line.append(String(x) + "\n")
        
        switch sensorType {
        case .phoneAccelerometer:
            self.accelerometerData.append(line)
        case .phoneGyroscope:
            self.gyroscopeData.append(line)
        case .phoneMagnetometer:
            self.magnetometerData.append(line)
        default:
            print("No data of \(sensorType) is available.")
        }
    }
    
    // 保存したファイルパスを取得する
    mutating func getURLs(label: String, subject: String) -> [URL] {
        let format = DateFormatter()
        format.dateFormat = "yyyyMMddHHmmss"
        let time = format.string(from: Date())
        
        /* 一時ファイルを保存する場所 */
        let tmppath = NSHomeDirectory() + "/tmp"
        
        let apd = "\(time)_\(label)_\(subject)" // 付加する文字列(時間+ラベル+ユーザ名)
        // ファイル名を生成
        let accelerometerFilepath = tmppath + "/accelermeter_\(apd).csv"
        let gyroFilepath = tmppath + "/gyroscope_\(apd).csv"
        let magnetFilepath = tmppath + "/magnetometer_\(apd).csv"
        
        // ファイルを書き出す
        do {
            try self.accelerometerData.write(toFile: accelerometerFilepath, atomically: true, encoding: String.Encoding.utf8)
            try self.gyroscopeData.write(toFile: gyroFilepath, atomically: true, encoding: String.Encoding.utf8)
            try self.magnetometerData.write(toFile: magnetFilepath, atomically: true, encoding: String.Encoding.utf8)
        }
        catch let error as NSError{
            print("Failure to Write File\n\(error)")
        }
        
        /* 書き出したcsvファイルの場所を取得 */
        var urls = [URL]()
        urls.append(URL(fileURLWithPath: accelerometerFilepath))
        urls.append(URL(fileURLWithPath: gyroFilepath))
        urls.append(URL(fileURLWithPath: magnetFilepath))
                
        // データをリセットする
        self.reset()
        
        return urls
    }
    
    // データをリセットする
    mutating func reset() {
            self.accelerometerData = self.column
            self.gyroscopeData = self.column
            self.magnetometerData = self.column
        }
}
