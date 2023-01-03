//
//  Reader.swift
//  FinalProject
//
//  Created by li on 2022/12/19.
//

import SwiftUI

struct ReaderPage: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var vm: ReaderViewModel
    
    @State var isMenuVisible = false

    var article: Article {
        vm.article!
    }
    
    var menuPanel: some View {
        VStack {
            if isMenuVisible { ReaderTopMenuPanel().transition(.offset(x: 0, y: -Screen.navigationBarHeight)) }
            Spacer()
            if isMenuVisible { ReaderBottomMenuPanel(progress: $vm.progress).transition(.offset(x: 0, y: Drawing.bottomMenuOffset + Screen.safeAreaInsets.bottom)) }
        }.ignoresSafeArea()
    }
    
    var content: some View {
        VStack(alignment: .leading) {
            Text(article.title).foregroundColor(ThemeColor.gray).font(.subheadline)
            ScrollView {
                VStack(alignment: .leading) {
                    Text(article.title).font(.largeTitle).padding(.vertical, Drawing.titleVerticalPadding)
                    Text(article.content)
                }.foregroundColor(ThemeColor.darkGray)
            }
            ReaderBottomView(vm: vm)
        }.padding()
    }
    
    var main: some View {
        ZStack {
            if colorScheme == .light {
                Image("read_bg").resizable().ignoresSafeArea()
            }
            content
            menuPanel
        }.onTapGesture {
            withAnimation {
                isMenuVisible = !isMenuVisible
            }
        }
    }
    
    var body: some View {
        Group {
            if vm.fetchStatus == .fetching {
                ProgressView()
            } else {
                main
            }
        }
    }
    
    private struct Drawing {
        static let bottomMenuOffset = 130.0
        static let titleVerticalPadding = 30.0
    }
}

struct ReaderBottomView: View {
    @ObservedObject var vm: ReaderViewModel
    @State var currentDate = Date()
    
    var currentDateDescription: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: currentDate)
    }
    
    var body: some View {
        HStack {
            Image("reader_battery")
            Spacer()
            Text(currentDateDescription) .font(.custom("Courier", size: 15)).foregroundColor(ThemeColor.gray).font(.subheadline).onReceive(vm.timer) { input in
                currentDate = input
            }
        }
    }
}

struct ReaderTopMenuPanel: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack {
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image("pub_back_gray").renderingMode(.template)
            }

            Spacer()
            Button {} label: {
                Image("read_icon_more").renderingMode(.template)
            }
        }
        .padding(Screen.horizontalSafeAreaInsets(padding: Drawing.horizontalPadding))
        .frame(height: height)
        .foregroundColor(ThemeColor.darkGray).padding(.top, Screen.safeAreaInsets.top).background(ThemeColor.card)
    }
    
    var height: CGFloat {
        verticalSizeClass == .compact ? 44 : 50
    }
    
    private struct Drawing {
        static let horizontalPadding = 15.0
    }
}

struct ReaderBottomMenuPanel: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    
    @Binding var progress: Double
    
    private func buildButton(title: String, iconName: String) -> some View {
        VStack {
            Image(iconName).renderingMode(.template)
            if verticalSizeClass == .regular {
                Text(title).font(.subheadline)
            }
        }.frame(maxWidth: .infinity)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {}) {
                    Image("read_icon_chapter_previous").renderingMode(.template)
                }
                Spacer(minLength: 30)
                Slider(value: $progress).accentColor(ThemeColor.primary)
                Spacer(minLength: 30)
                Button(action: {}) {
                    Image("read_icon_chapter_next").renderingMode(.template)
                }
            }
            HStack {
                buildButton(title: "目錄", iconName: "read_icon_catalog")
                buildButton(title: "亮度", iconName: "read_icon_brightness")
                buildButton(title: "字體", iconName: "read_icon_font")
                buildButton(title: "設置", iconName: "read_icon_setting")
            }
        }
        .padding(Screen.horizontalSafeAreaInsets())
        .foregroundColor(ThemeColor.dimGray).padding().padding(.bottom, Screen.safeAreaInsets.bottom).background(ThemeColor.card)
    }
}


struct ReaderPage_Previews: PreviewProvider {
    static var previews: some View {
        ReaderPage(vm: ReaderViewModel(bookId: "1")).preferredColorScheme(.dark)
    }
}
