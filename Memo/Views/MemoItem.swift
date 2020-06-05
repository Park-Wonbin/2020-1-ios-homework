//
//  MemoItem.swift
//  Memo
//
//  Created by 박원빈 on 2020/05/17.
//  Copyright © 2020 PoApper. All rights reserved.
//

import SwiftUI

struct MemoItem: View {
    var memo: MemoEntity
    
    static let df: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM. dd."
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(memo.title ?? "")
                .font(.system(size: 20, weight: .bold))
            HStack{
                Spacer()
                Text("\(memo.date!, formatter: Self.df)")
                    .font(.system(size: 15))
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.trailing)
            }
            Text(memo.content ?? "")
                .font(.system(size: 18))
        }
        .padding()
    }
}

struct MemoItem_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Test Data
        let memo = MemoEntity(context: context)
        memo.title = "Test"
        memo.content = "This is a sample memo."
        memo.date = Date()
        memo.id = UUID()
            
        return MemoItem(memo: memo).environment(\.managedObjectContext, context)
                .environmentObject(Session())
    }
}
