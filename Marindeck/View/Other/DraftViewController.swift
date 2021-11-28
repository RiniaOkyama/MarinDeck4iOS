//
//  DraftViewController.swift
//  Marindeck
//
//  Created by Rinia on 2021/11/28.
//

import SwiftUI


struct DraftView: View {
    @Environment(\.presentationMode) var presentationMode
    
    typealias selectedCompletion = (_ index: Int) -> ()
    let selected: selectedCompletion?
    let drafts: [Draft]
    
    init(selected: selectedCompletion? = nil, drafts: [Draft]) {
        self.selected = selected
        self.drafts = drafts
    }
    
    var body: some View {
        VStack {
            if drafts.isEmpty {
                Text("下書きがありません。")
            }else {
                List {
                    ForEach(0 ..< drafts.count) { index in
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


struct DraftView_Previews: PreviewProvider {
    static var previews: some View {
        DraftView(selected: nil, drafts: [])
    }
}
