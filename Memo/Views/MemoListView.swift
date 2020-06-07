//
//  MemoListView.swift
//  Memo
//
//  Created by 박원빈 on 2020/05/17.
//  Copyright © 2020 PoApper. All rights reserved.
//

import SwiftUI
import CoreData
import SwiftUIRefresh

struct MemoListView: View {
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var session: Session
    
    // Dirty hack to refresh list
    @State private var refreshingID = UUID()
    
    @State var isNewMemo: Bool = false
    @State private var isShowing = false

    var memosRequest: FetchRequest<MemoEntity>
    var memos: FetchedResults<MemoEntity> {memosRequest.wrappedValue}
    
    init() {
        self.memosRequest = FetchRequest(fetchRequest: MemoEntity.getAll())
    }
    
    var body: some View {
        NavigationView{
            VStack {
                List{
                    ForEach(memos) {memo in
                        NavigationLink(destination: MemoView(memo: memo)){
                            MemoItem(memo: memo)
                            .contextMenu {
                                Button(action: {
                                    self.context.delete(memo)
                                    
                                    do {
                                        try self.context.save()
                                    } catch {
                                        // Fatal error
                                        // Do something
                                    }
                                }) {
                                    HStack {
                                        Text("Delete")
                                        Image(systemName: "trash.circle.fill")
                                    }
                                }.foregroundColor(.red)
                            }
                        }
                        .id(self.refreshingID)
                    }
                    .onDelete(perform: deleteItems)
                }
                .pullToRefresh(isShowing: $isShowing) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.isShowing = false
                    }
                }
                .onAppear(perform: {
                    self.refreshingID = UUID()
                })
                .navigationBarTitle(Text("Memo"))
                .navigationBarItems(trailing:EditButton())
                
                HStack {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    NavigationLink(destination: MemoView(memo: nil), isActive: $isNewMemo) {
                         Image(systemName: "pencil")
                             .foregroundColor(Color.blue)
                    }
                }
                .padding()
                .font(.system(size: 25, weight: .semibold))
            }
        }
        .onAppear(perform: {
            self.isNewMemo = self.session.newMemo
        })
    }
    
    func deleteItems(at offsets: IndexSet) {
        for i in offsets {
            context.delete(memos[i])
        }
        
        do {
            try context.save()
        } catch {
            // Fatal error
            // Do something
        }
    }
}

struct MemoListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Test Data
        let memo = MemoEntity(context: context)
        memo.title = "Test"
        memo.content = "This is a sample memo."
        memo.date = Date()
        memo.id = UUID()
            
        return MemoListView().environment(\.managedObjectContext, context)
                .environmentObject(Session())
    }
}
