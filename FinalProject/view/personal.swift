//
//  personal.swift
//  FinalProject
//
//  Created by li on 2022/12/19.
//

import SwiftUI

struct MePage: View {
    
    var body: some View {
        NavigationView{
            ScrollView {
                LazyVStack {
                    MeHeader()
                    MeCell(title: "錢包", iconName: "me_wallet")
                    MeCell(title: "消費紀錄", iconName: "me_record")
                    MeCell(title: "購買記錄", iconName: "me_buy")
                    MeCell(title: "會員", iconName: "me_vip")
                    MeCell(title: "歷史紀錄", iconName: "me_date")
                    MeCell(title: "我的收藏", iconName: "me_favorite")
                    MeCell(title: "設置", iconName: "me_setting")
                    MeCell(title: "Github", iconName: "me_action")/*.onTapGesture {
                        UIApplication.shared.open(URL(string: "")!)
                    }*/
                }
            }.background(ThemeColor.card)
        }
    }
}

struct MeHeader: View {
    var body: some View {
        HStack {
            ZStack {
                Image("placeholder_avatar")
                RoundedRectangle(cornerRadius: Drawing.radius).strokeBorder().foregroundColor(ThemeColor.blue.opacity(0.5))
            }.frame(width: Drawing.radius * 2, height: Drawing.radius * 2, alignment: .center)
            
            Spacer(minLength: 20)
            VStack(alignment: .leading, spacing: 10) {
                NavigationLink(
                    destination: SignInView(),
                    label: {
                        Text("登入")
                    })
                HStack {
                    buildItem(title: "餘額", value: "0.0")
                    Spacer()
                    buildItem(title: "優惠", value: "0")
                    Spacer()
                    buildItem(title: "月票", value: "0")
                    Spacer()
                }
            }
        }.padding(.all, 20)
    }
    
    private func buildItem(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(value).bold()
            Text(title).font(.caption).foregroundColor(ThemeColor.gray)
        }
    }
    
    private struct Drawing {
        static let radius = 30.0
    }
}

struct MeCell: View {
    let title: String
    let iconName: String
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Image(iconName)
                Text(title)
                Spacer()
                Image("arrow_right")
            }.padding(.horizontal).frame(height: Drawing.cellHeight)
            Divider().padding(.leading, Drawing.dividerPaddingLeading)
        }
    }
    
    private struct Drawing {
        static let cellHeight = 50.0
        static let dividerPaddingLeading = 50.0
    }
}

struct MePage_Previews: PreviewProvider {
    static var previews: some View {
        MePage().preferredColorScheme(.dark)
    }
}
