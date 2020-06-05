//
//  MemoView.swift
//  Memo
//
//  Created by 박원빈 on 2020/05/17.
//  Copyright © 2020 PoApper. All rights reserved.
//

import SwiftUI

struct MemoView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var mode

    var memo: MemoEntity?
    @State var title: String = ""
    @State var content: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                TextField("Title", text: $title)
                    .padding([.top, .leading, .trailing], 20)
                    .font(.title)
                MultilineTextField("Content", text: $content)
                Spacer()
            }
        }
        .onAppear(perform: {
            self.title = self.memo?.title ?? ""
            self.content = self.memo?.content ?? ""
        })
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: save) {
            Text("Save")
        })
    }
    
    func save() {
        if (memo == nil) {
            // Create new note
            let newMemo = MemoEntity(context: self.context)
            newMemo.title = title
            newMemo.content = content
            newMemo.date = Date()
            newMemo.id = UUID()
            
            do {
                try self.context.save()
            } catch {
                // Error
            }
        } else {
            // Update note
            memo?.title = title
            memo?.content = content
            
            do {
                try self.context.save()
            } catch {
                // Error
            }
        }
        // Return to previous window
        self.mode.wrappedValue.dismiss()
    }
}

struct MemoView_Previews: PreviewProvider {
    static var previews: some View {
       let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       // Test Data
       let memo = MemoEntity(context: context)
       memo.title = "Test"
       memo.content = "This is a sample memo."
       memo.date = Date()
       memo.id = UUID()
           
        return MemoView(memo: memo).environment(\.managedObjectContext, context)
               .environmentObject(Session())
    }
}
