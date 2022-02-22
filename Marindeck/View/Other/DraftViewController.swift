//
//  DraftViewController.swift
//  Marindeck
//
//  Created by Rinia on 2021/11/28.
//

import SwiftUI

struct DraftView: View {
    @Environment(\.presentationMode) var presentationMode

    typealias selectedCompletion = (_ index: Int) -> Void
    let selected: selectedCompletion?
    let drafts: [Draft]

    init(selected: selectedCompletion? = nil, drafts: [Draft]) {
        self.selected = selected
        self.drafts = drafts
    }

    var body: some View {
        VStack {
            if drafts.isEmpty {
                Text("下書きがありません。\n\nネイティブのツイート画面から\n下書き保存ができます。")
                    .multilineTextAlignment(.center)
            } else {
                List {
                    ForEach(0 ..< drafts.count) { index in
                        if #available(iOS 15.0, *) {
                            Text(drafts[index].text)
                                // 開発環境がiOS14.5なのでデバッグできない。
                                //                                .swipeActions(edge: .trailing) {
                                //                                    Button(role: .destructive) {
                                //                                        print("delete action.")
                                //                                    } label: {
                                //                                        Image(systemName: "trash.fill")
                                //                                    }
                                //                                }
                                .onTapGesture {
                                    presentationMode.wrappedValue.dismiss()
                                    selected?(index)
                                }
                        } else {
                            Text(drafts[index].text)
                                .onTapGesture {
                                    presentationMode.wrappedValue.dismiss()
                                    selected?(index)
                                }
                        }
                    }
                }
            }
        }
    }
}

struct DraftView_Previews: PreviewProvider {
    static var previews: some View {
        DraftView(selected: nil, drafts: [])
    }
}
