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
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                if logStarting {
                    Text("Under Logging")
                }
                Spacer()
                
                VStack {
                    Toggle(isOn: $logStarting) {
                        Text("")
                    }
                    Picker(selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/, label: Text("Timing")) {
                        Text("Immediately").tag(1)
                        Text("After 5 sec").tag(2)
                    }.pickerStyle(SegmentedPickerStyle())
                    Picker(selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/, label: Text("Auto")) {
                        Text("Self").tag(1)
                        Text("Session").tag(2)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                }
                Spacer()
                
            }.padding(.leading)
            
            VStack(alignment: .leading) {
                Text("Accelerometer")
                Text("Gyroscope")
                Text("Magnetometer")
            }.padding(.leading)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
