//
//  ContentView.swift
//  Logger5
//
//  Created by MacBook Air on 2019/10/11.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Accelerometer")
            Text("Gyroscope")
            Text("Magnetometer")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
