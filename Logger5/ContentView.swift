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
    
    @State private var accXLabel = "X"
    @State private var accYLabel = "Y"
    @State private var accZLabel = "Z"
    @State private var gyrXLabel = "X"
    @State private var gyrYLabel = "Y"
    @State private var gyrZLabel = "Z"
    @State private var magXLabel = "X"
    @State private var magYLabel = "Y"
    @State private var magZLabel = "Z"
    
    private let motionLogger = DeprecatedSensorLogger()
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // 保存の処理を書く
                    
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            .padding(.trailing, 250)

            VStack {
                HStack {
                    if logStarting {
                        Text("Now Logging")
                        
                        /*計測開始*/
                        
                    }
                    
                    Toggle(isOn: $logStarting) {
                        Text("")
                    }
                }.padding(15)
                
                
                VStack {
                   Picker(selection: $timingChoice, label: Text("Timing")) {
                       Text("Immediately").tag(0)
                       Text("After 5 sec").tag(1)
                   }.pickerStyle(SegmentedPickerStyle())
                    
                   Picker(selection: $autoChoice, label: Text("Auto")) {
                       Text("Self").tag(0)
                       Text("Session").tag(2)
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
                        Text("\(self.accXLabel)")
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("\(self.accYLabel)")
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("\(self.accZLabel)")
                            .multilineTextAlignment(.leading)
                        
                    }.padding(.horizontal)
                }.padding(25)
                
                VStack(alignment: .leading) {
                    Text("Gyroscope")
                    .font(.headline)
                    
                    HStack {
                        Text("\(self.gyrXLabel)")
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("\(self.gyrYLabel)")
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("\(self.gyrZLabel)")
                            .multilineTextAlignment(.leading)
                    }.padding(.horizontal)
                }.padding(25)
                
                
                VStack(alignment: .leading) {
                    Text("Magnetometer")
                        .font(.headline)
                    
                    HStack {
                        Text("\(self.magXLabel)")
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("\(self.magYLabel)")
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("\(self.magZLabel)")
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
