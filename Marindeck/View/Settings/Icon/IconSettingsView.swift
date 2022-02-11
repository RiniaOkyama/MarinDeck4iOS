//
//  IconSettings.swift
//  Marindeck
//
//  Created by Rinia on 2021/12/31.
//

import SwiftUI

struct Icon: Hashable {
    let iconName: String
    let iconTitle: String
    let iconFlag: String?
}

struct IconSettingsListItem: View {
    let icon: Icon
    let isSelected: Bool

    var body: some View {
        HStack {
            Image(icon.iconName)
                .resizable()
                .frame(width: 48, height: 48)
                .cornerRadius(8)
            Text(icon.iconTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color(UIColor.labelColor))
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .frame(width: 12.0, height: 12.0)
                    .foregroundColor(Color(UIColor.labelColor))
            }
        }
        .frame(height: 54)
    }
}

struct IconSettingsView: View {
    @Environment(\.presentationMode) var presentationMode

    init() {
        UITableView.appearance().backgroundColor = .secondaryBackgroundColor
    }

    //    @State private var icons = ["DefaultIcon": "白","BlackIcon": "黒","RainbowIcon": "ゲーミング"]
    let icons: [Icon] = [
        .init(iconName: "DefaultIcon", iconTitle: "白", iconFlag: nil),
        .init(iconName: "BlackIcon", iconTitle: "黒", iconFlag: "BlackIcon"),
        .init(iconName: "RainbowIcon", iconTitle: "ゲーミング", iconFlag: "RainbowIcon")
    ]

    @State private var alternateIconName = UIApplication.shared.alternateIconName

    var body: some View {
        ZStack {
            // TODO:  NavigatonViewのタイトルを設定しても表示されない
            //        NavigationView {
            List {
                ForEach(icons, id: \.self) { icon in
                    IconSettingsListItem(icon: icon, isSelected: alternateIconName == icon.iconFlag )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            UIApplication.shared.setAlternateIconName(icon.iconFlag, completionHandler: nil)
                            updateIconName()
                        }
                        .listRowBackground(Color(UIColor.secondaryBackgroundColor))
                }
            }
            .onAppear {
                updateIconName()
            }
            //        }
            //        .navigationBarTitle(Text("Users"))
        }
    }

    func updateIconName() {
        alternateIconName = UIApplication.shared.alternateIconName
    }
}

struct IconSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        IconSettingsView()
    }
}
