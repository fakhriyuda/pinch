//
//  ContentView.swift
//  Pinch
//
//  Created by ISYS Macbook air 1 on 17/10/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK:  Property
    @State private var isAnimating : Bool = false
    @State private var imageScale : CGFloat = 1
    @State private var imageOffset : CGSize = .zero
    @GestureState private var magnifyBy = 1.0
    @State private var isDrawerOpen : Bool = false
    
    let pages : [Page] = pagesData
    @State private var pageIndex : Int = 1
    // MARK:  Function
    
    func resetImageState(){
        return withAnimation(.spring(duration: 1)){
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    func currentPage() -> String {
        return pages[pageIndex - 1].imageName
    }
    
    // MARK:  Content
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.clear
                
                Image(currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding()
                    .shadow(color: .black.opacity(0.3), radius: 12, x: 2,y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
                // MARK:  Tap Gesture
                    .onTapGesture(count: 2) {
                        if imageScale == 1 {
                            withAnimation(.spring){
                                imageScale = 5
                            }
                        }else{
                            resetImageState()
                        }
                    }
                // MARK:  Drag Gesture
                    .gesture(
                        DragGesture()
                            .onChanged{value in
                                withAnimation(.linear(duration: 1)){
                                    imageOffset = value.translation
                                }
                            }
                            .onEnded{_ in
                                if imageScale <= 1{
                                    resetImageState()
                                }
                            }
                    )
                
            }
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{
                withAnimation(.linear(duration: 1)){
                    isAnimating = true
                }
            }
            // MARK:   Top Infopanel
            .overlay(
                InfoPanelView(scale: imageScale, offSet: imageOffset)
                    .padding(.horizontal)
                    .padding(.top,30)
                ,alignment: .top
            )
            // MARK:  Controls
            .overlay(
                Group{
                    HStack{
                        Button{
                            if imageScale > 1 {
                                imageScale -= 1
                            }
                        } label: {
                            ControlImageView(icon: "minus.magnifyingglass")
                        }
                        Button{
                            resetImageState()
                        } label: {
                            ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        Button{
                            if imageScale < 5 {
                                imageScale += 1
                                if imageScale == 5 {
                                    imageScale = 5
                                }
                            }
                        } label: {
                            ControlImageView(icon: "plus.magnifyingglass")
                        }
                    }
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .opacity(isAnimating ? 1 : 0)
                }
                    .padding(.bottom,30)
                ,alignment: .bottom
            )
            // MARK:  Magnification
            .gesture(
                MagnificationGesture()
                    .updating($magnifyBy){value, gestureState, transaction in
                        withAnimation(.spring(duration: 1)){
                            if imageScale >= 1 && imageScale <= 5 {
                                imageScale = value
                            } else if imageScale > 5 {
                                imageScale = 5
                            }
                        }
                    }
                    .onEnded{_ in
                        if imageScale > 5{
                            imageScale = 5
                        } else if imageScale < 1 {
                            resetImageState()
                        }
                    }
                
            )
            // MARK:  Drawer
            .overlay(alignment: .topTrailing){
                HStack(spacing: 12){
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height:40)
                        .padding(8)
                        .foregroundStyle(Color.secondary)
                        .onTapGesture {
                            withAnimation(.easeOut){
                                isDrawerOpen.toggle()
                            }
                        }
                    
                    ForEach(pages){ item in
                        Image(item.thumbnailName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                            .onTapGesture{
                                isAnimating = true
                                pageIndex = item.id
                                
                            }
                    }
                    
                    Spacer()
                    
                }
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                .background(.ultraThinMaterial)
                .frame(width: 260)
                .clipShape(RoundedRectangle( cornerRadius: 16))
                .opacity(isAnimating ? 1 : 0)
                .padding(.top, (UIScreen.current?.bounds.size.height)! / 12)
                .offset(x: isDrawerOpen ? 20 : 215)
            }
        }
    }
}
extension UIWindow{
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}
extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}



#Preview {
    ContentView()
}
