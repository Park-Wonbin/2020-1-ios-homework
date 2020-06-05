//
//  MemoExtension.swift
//  Memo
//
//  Created by 박원빈 on 2020/06/05.
//  Copyright © 2020 PoApper. All rights reserved.
//

import Foundation
import CoreData

extension MemoEntity: Identifiable {
    static func getAll() -> NSFetchRequest<MemoEntity> {
        let request: NSFetchRequest<MemoEntity> = MemoEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return request
    }
    
    static func getId(id: UUID) -> NSFetchRequest<MemoEntity> {
        let request: NSFetchRequest<MemoEntity> = MemoEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.predicate = predicate
        return request
    }
}
