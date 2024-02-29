//
//  SemiCircularProgressModel.swift
//  TrackSavings
//
//  Created by Aldo Vitolo on 29/02/24.
//

import SwiftUI

struct SemiCircularProgressModel: View {
    var body: some View {
        Path { path in
            let center = CGPoint(x: 150, y: 100)
            let radius: CGFloat = 50
            let startAngle: Angle = .degrees(0)
            let endAngle: Angle = .degrees(180)
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        }
        .stroke(Color.green, lineWidth: 10)
    }
}

#Preview {
    SemiCircularProgressModel()
}
