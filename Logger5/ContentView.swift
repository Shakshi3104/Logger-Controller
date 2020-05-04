//
//  ContentView.swift
//  Logger5
//
//  Created by MacBook Air on 2019/10/11.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var logStarting = false
    @State private var timingChoice = 0
    @State private var autoChoice = 0
    @State private var username = ""
    @State private var label = ""
    
    @State private var magXLabel = "X"
    @State private var magYLabel = "Y"
    @State private var magZLabel = "Z"
    
    @ObservedObject var sensorLogger = SensorLogManager()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                // 保存ボタン
                Button(action: {
                    // 保存の処理を書く
                    
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
                Spacer()
                // 計測ボタン
                Button(action: {
                    self.logStarting.toggle()
                    
                    if self.logStarting {
                        self.sensorLogger.startUpdate(50.0)
                    }
                    else {
                        self.sensorLogger.stopUpdate()
                    }
                    
                }) {
                    if self.logStarting {
                        Image(systemName: "pause.circle")
                    }
                    else {
                        Image(systemName: "play.circle")
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            
            
            

            VStack {
                
                VStack {
                   Picker(selection: $timingChoice, label: Text("Timing")) {
                       Text("Immediately").tag(0)
                       Text("After 5 sec").tag(1)
                   }.pickerStyle(SegmentedPickerStyle())
                    
                   Picker(selection: $autoChoice, label: Text("Auto")) {
                       Text("Self").tag(0)
                       Text("Session").tag(1)
                   }.pickerStyle(SegmentedPickerStyle())
                }.padding(.horizontal, 25)
 
            }.padding(25)
            
            HStack {
                TextField("Subject Name", text: $username)

                TextField("Label", text: $label)
            }
            .padding(.leading, 80)
            
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Accelerometer")
                        .font(.headline)
                    
                    HStack {
                        
                        Text(String(format: "%.3f", self.sensorLogger.accX))
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text(String(format: "%.3f", self.sensorLogger.accY))
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text(String(format: "%.3f", self.sensorLogger.accZ))
                            .multilineTextAlignment(.leading)
                        
                    }.padding(.horizontal)
                }.padding(25)
                
                VStack(alignment: .leading) {
                    Text("Gyroscope")
                    .font(.headline)
                    
                    HStack {
                        Text(String(format: "%.3f", self.sensorLogger.gyrX))
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text(String(format: "%.3f", self.sensorLogger.gyrY))
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text(String(format: "%.3f", self.sensorLogger.gyrZ))
                            .multilineTextAlignment(.leading)
                    }.padding(.horizontal)
                }.padding(25)
                
                
                VStack(alignment: .leading) {
                    Text("Magnetometer")
                        .font(.headline)
                    
                    HStack {
                        Text(String(format: "%.2f", self.sensorLogger.magX))
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text(String(format: "%.2f", self.sensorLogger.magY))
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text(String(format: "%.2f", self.sensorLogger.magZ))
                            .multilineTextAlignment(.leading)
                    }.padding(.horizontal)
                }.padding(25)
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
