//
//  CircularProgressView.swift
//  TrackSavings
//
//  Created by Gustavo Isaac Lopez Nunez on 20/02/24.
//

import SwiftUI

struct CircularProgressView: View {
    @State var progress: Double
    @State var image: String
    let ringDiameter = 50.0
    let width = 8.0
    
    private var rotationAngle: Angle {
        return Angle(degrees: (360.0 * progress))
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(hue: 0.0, saturation: 0.0, brightness: 0.9), lineWidth: width)
                .overlay() {
                    Image(systemName: "\(image)")
                        .font(.system(size: ringDiameter/3, weight: .bold, design:.rounded))
                }
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color("PrimaryColor"),
                        style: StrokeStyle(lineWidth: width, lineCap: .round)
                )
                .rotationEffect(Angle(degrees: -90))
        }
        .frame(width: ringDiameter, height: ringDiameter)
        
    }
}

#Preview {
    CircularProgressView(progress: 0.3, image: "car")
}
