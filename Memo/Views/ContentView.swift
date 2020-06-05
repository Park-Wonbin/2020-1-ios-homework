//
//  ContentView.swift
//  Memo
//
//  Created by 박원빈 on 2020/05/17.
//  Copyright © 2020 PoApper. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: Session
    
    @ViewBuilder
    var body: some View {
        if (session.isAuth || !UserDefaults.standard.bool(forKey: DefaultKeys.keyLock)) {
            MemoListView()
        } else {
            PasswordScreen()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Session())
    }
}
