//
//  StatusView.swift
//  Marindeck
//
//  Created by a on 2022/01/05.
//


import SwiftUI



struct StatusView: View {
//    @Environment(\.presentationMode) var presentationMode
    
    init(){
    }
    
    var body: some View {
        VStack {
            HStack{
            Text("利用日数")
                    .frame(width: .infinity)
            Text("100日")
                .fontWeight(.bold)
                .font(.title)
                .frame(width: 100)
            }
            
            HStack{
            Text("利用日数")
                    .frame(width: .infinity)
            Text("101日")
                .fontWeight(.bold)
                .font(.title)
                .frame(width: 100)
            }
            
            HStack{
            Text("利用日数")
                    .frame(width: .infinity)
            Text("100日")
                .fontWeight(.bold)
                .font(.title)
                .frame(width: 100)
            }
            
            HStack{
            Text("利用日数")
                    .frame(width: .infinity)
            Text("100日")
                .fontWeight(.bold)
                .font(.title)
                .frame(width: 100)
            }
            
            
        }
    }
}


#if DEBUG
struct SatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView()
    }
}
#endif
