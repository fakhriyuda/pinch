//
//  InfoPanelView.swift
//  Pinch
//
//  Created by ISYS Macbook air 1 on 17/10/24.
//

import SwiftUI

struct InfoPanelView: View {
    
    var scale : CGFloat
    var offSet : CGSize
    @State var isInfoPanelVisible : Bool = false
    
    var body: some View {
        HStack{
            // MARK:  HOTSPOT
            Image(systemName: "circle.circle")
                .symbolRenderingMode(.hierarchical)
                .resizable()
                .frame(width: 30,height: 30)
                .onLongPressGesture(minimumDuration: 1){
                    withAnimation(.easeOut(duration: 1)){
                        isInfoPanelVisible.toggle()
                    }
                }
            Spacer()
            
            // MARK:  INFOPANEL
            
            HStack(spacing: 2){
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                Text(String(format: "%.5f", scale))
                Spacer()
                Image(systemName: "arrow.left.and.right")
                Text(String(format: "%.5f", offSet.width))
                Spacer()
                Image(systemName: "arrow.up.and.down")
                Text(String(format: "%.5f", offSet.height))
                Spacer()
            }
            .font(.footnote)
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .frame(maxWidth: 420)
            .opacity(isInfoPanelVisible ? 1 : 0)
            
            Spacer()
        }
    }
}

#Preview {
    InfoPanelView(scale: 1, offSet: .zero)
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
        .padding()
}
