//
//  HPBar.swift
//  HackSlash
//
//  Created by Felipe  Elsner Silva on 15/05/23.
//

import Foundation
import UIKit
import SwiftUI
import UserNotifications

struct HPBar: View {
    @State var lastCoordinateValue: CGFloat = 0.0
    var sliderRange: ClosedRange<Double> = 1...100
    var thumbColor: Color = Color("HP")
    var minTrackColor: Color = Color("HP")
    var maxTrackColor: Color = Color.white.opacity(0.2)
    @ObservedObject var viewManager: HPBarManager = HPBarManager()
    
    
    var body: some View {
        GeometryReader { gr in
            let thumbHeight = gr.size.height * 1.3
            let thumbWidth = gr.size.width * 0.03
            let radius = gr.size.height * 0.5
//            let radius = 0.0
            let minValue = gr.size.width * 0.015
            let maxValue = (gr.size.width * 0.98) - thumbWidth
            
            let scaleFactor = (maxValue - minValue) / (sliderRange.upperBound - sliderRange.lowerBound)
            let lower = sliderRange.lowerBound
            let sliderVal = (self.viewManager.value - lower) * scaleFactor + minValue
            
            ZStack {
                Rectangle()
                    .foregroundColor(maxTrackColor)
                    .frame(width: gr.size.width+5, height: gr.size.height * 0.95)
                    .clipShape(RoundedRectangle(cornerRadius: radius))
                HStack {
                    Rectangle()
                        .foregroundColor(minTrackColor)
                    .frame(width: sliderVal, height: gr.size.height * 0.95)
                    Spacer()
                }
                .clipShape(RoundedRectangle(cornerRadius: radius))
                HStack {
                    Circle()
                        .foregroundColor(thumbColor)
//                        .frame(width: thumbWidth, height: thumbHeight)
//                        .frame(height: thumbHeight+5)
                        .frame(height: thumbHeight)
                        .offset(x: sliderVal-5)
//                        .gesture(
//                            DragGesture(minimumDistance: 0)
//                                .onChanged { v in
//                                    if (abs(v.translation.width) < 0.1) {
//                                        self.lastCoordinateValue = sliderVal
//                                    }
//                                    if v.translation.width > 0 {
//                                        let nextCoordinateValue = min(maxValue, self.lastCoordinateValue + v.translation.width)
//                                        self.value = ((nextCoordinateValue - minValue) / scaleFactor)  + lower
//                                    } else {
//                                        let nextCoordinateValue = max(minValue, self.lastCoordinateValue + v.translation.width)
//                                        self.value = ((nextCoordinateValue - minValue) / scaleFactor) + lower
//                                    }
//                               }
//                        )
                    Spacer()
                }
            }
        }
    }
}

class HPBarManager: ObservableObject{
    @Published var value: Double = 100.0
    let notificationCenter = NotificationCenter.default
    
    init(){
        self.notificationCenter.addObserver(self, selector: #selector(RecievedDamage), name: Notification.Name("playerDamage"), object: nil)
    }
    
    @objc func RecievedDamage(){
        value -= Double(Constants.spiderDamage)
    }
}
