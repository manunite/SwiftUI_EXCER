//
//  ContentView.swift
//  SwiftUI_Test
//
//  Created by heogj123 on 2021/11/29.
//

import SwiftUI

private struct OffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = .zero
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

struct ScrollViewOffset<Content: View>: View {
  let content: () -> Content
  let onOffsetChange: (CGFloat) -> Void

  init(@ViewBuilder content: @escaping () -> Content,
       onOffsetChange: @escaping (CGFloat) -> Void) {
    self.content = content
    self.onOffsetChange = onOffsetChange
  }

  var body: some View {
    ScrollView(showsIndicators: false) {
      offsetReader
      content().padding(.top, -8) // places the real content as if our `offsetReader` was not there.
    }
    .coordinateSpace(name: "frameLayer")
    .onPreferenceChange(OffsetPreferenceKey.self, perform: onOffsetChange)
  }

  var offsetReader: some View {
    GeometryReader { proxy in
      Color.clear
        .preference(
          key: OffsetPreferenceKey.self,
          value: proxy.frame(in: .named("frameLayer")).minY
        )
    }
    .frame(height: 0) // 👈🏻 make sure that the reader doesn't affect the content height
  }
}

struct DescriptionView: View {
  var name: String = ""
  init(param: String) {
    name = param
  }
  
  var body: some View {
    ZStack() {
      Color.indigo
      VStack {
        Text("\(name)")
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding([.leading, .trailing], 15)
          .padding(.top, 10)
          .font(.system(size: 30))
        
        Spacer(minLength: 5)
        
        Text("DescriptionsDescriptionsDescriptionsDescriptionsDescriptions")
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding([.leading, .trailing], 15)
          .font(.system(size: 17))
        
        Spacer(minLength: 5)
        
        Text("DescriptionsDescriptionsDescriptionsDescriptionsDescriptions")
          .frame(maxWidth: .infinity, alignment: .leading).padding([.leading, .trailing], 15)
          .font(.system(size: 14))
        
        Spacer(minLength: 20)
        
        HStack {
          Spacer()
          Image("IMG_3197").resizable().aspectRatio(contentMode: .fit)
            .frame(width: 140, height: 170)
          Spacer()
          Image("IMG_3197").resizable().aspectRatio(contentMode: .fit)
            .frame(width: 140, height: 170)
          Spacer()
        }
        
        Spacer(minLength: 10)
        Text("GPS Info")
          .frame(maxWidth: .infinity, alignment: .leading).padding([.leading, .trailing], 15)
          .font(.system(size: 14))
        
        Spacer(minLength: 55)
      }
    }
  }
}

struct CellView: View {
  var mainImage: Image = Image("IMG_3197")
  @State var scaleVal: CGFloat = 1.0
  
  var body: some View {
    ZStack(alignment: .top) {
      Color.purple.edgesIgnoringSafeArea(.all)
      VStack {
        mainImage
          .resizable()
          .aspectRatio(contentMode: .fit)
          .scaleEffect(scaleVal)
      }
      ScrollViewOffset {
        Color.clear.padding(.bottom, UIScreen.screenHeight * 0.59)
        DescriptionView(param: "HI")
      } onOffsetChange: { val in
//        NSLog("\(val)")
        let offset: CGFloat = val
        if offset <= 0.0 {
          return
        }
        self.scaleVal = (offset / UIScreen.screenHeight * 0.59) + 1.0
      }
      
    }.frame(width: UIScreen.screenWidth,
            height: UIScreen.screenHeight)
  }
}

struct ContentView: View {
    var body: some View {
      VStack {
        GeometryReader { geometry in
          ScrollView(.horizontal) {
            LazyHStack(alignment: .center,spacing: 0) {
              ForEach(1...10, id: \.self) { _ in
                //              Text("Row \($0)")
                CellView()
              }
            }.gesture(DragGesture()
                        .onChanged({ value in
              //            self.isGestureActive = true
              //            self.offset = value.translation.width + -geometry.size.width * CGFloat(self.selection ?? 1)
              NSLog("changed: \(value.location)")
            }).onEnded({ value in
              NSLog("ended: \(value.location)")
            }))
          }.frame(width: UIScreen.screenWidth,
                  height: UIScreen.screenHeight,
                  alignment: .center)
          
          //        CellView().padding([.leading, .trailing], 10)
        }
      }
      
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
