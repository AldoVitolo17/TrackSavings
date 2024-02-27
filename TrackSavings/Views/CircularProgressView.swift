//
//  CircularProgressView.swift
//  TrackSavings
//
//  Created by Gustavo Isaac Lopez Nunez on 20/02/24.
//

import SwiftUI
import SwiftData

struct CircularProgressView: View {
    @State var progress: Double
    @State var image: String
    let ringDiameter = 150.0
    let width = 15.0
    
    private var rotationAngle: Angle {
        return Angle(degrees: (360.0 * progress))
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color("TextPrimaryColor"), lineWidth: 10)
                .overlay() {
                    Image(systemName: "\(image)")
                        .font(.system(size: ringDiameter/3, weight: .bold, design:.rounded))
                }
//            Circle()
//                .trim(from: 0, to: progress)
//                .stroke(Color("PrimaryColor"),
//                        style: StrokeStyle(lineWidth: width, lineCap: .round)
//                )
//                .rotationEffect(Angle(degrees: -90))
        }
        .frame(width: ringDiameter, height: ringDiameter)
        
    }
}

#Preview {
    CircularProgressView(progress: 0.3, image: "car")
}
