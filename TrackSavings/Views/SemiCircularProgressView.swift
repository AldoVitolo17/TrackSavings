//
//  CircularProgressView.swift
//  TrackSavings
//
//  Created by Gustavo Isaac Lopez Nunez on 20/02/24.
//

import SwiftUI
import SwiftData

struct SemiCircularProgressView: View {
    @State var progress: Double
    @State var image: String
    let ringDiameter = 250.0
    let width = 20.0
    
    private var rotationAngle: Angle {
        return Angle(degrees: (360.0 * progress))
    }
    
    var body: some View {
        ZStack {
            Path { path in
                path.addArc(center: CGPoint(x: ringDiameter / 2, y: ringDiameter / 2),
                            radius: CGFloat(ringDiameter / 2),
                            startAngle: .degrees(0),
                            endAngle: .degrees(180),
                            clockwise: true)
            }
            .stroke(Color("TextPrimaryColor"), style: StrokeStyle(lineWidth: width, lineCap: .round))
            .overlay() {
                VStack {
                    Image(systemName: "\(image)")
                        .font(.system(size: ringDiameter/3, weight: .bold, design:.rounded))
                    Text("\(progress*100, specifier: "%.f")%").fontWeight(.bold).font(.system(size: 37))
                }
            }
            
            Path { path in
                path.addArc(center: CGPoint(x: ringDiameter / 2, y: ringDiameter / 2),
                            radius: CGFloat(ringDiameter / 2),
                            startAngle: .degrees(180),
                            endAngle: .degrees(180 - (min(progress, 1.0) * 180)),
                            clockwise: true)
            }
            .stroke(Color("PrimaryColor"),
                    style: StrokeStyle(lineWidth: width, lineCap: .round)
            )
            .rotationEffect(Angle(degrees: 180))
            .scaleEffect(x: -1, y: 1, anchor: .center)
        }
        .frame(width: ringDiameter, height: ringDiameter)
        
    }
}

#Preview {
    SemiCircularProgressView(progress: 0.647, image: "car")
}
