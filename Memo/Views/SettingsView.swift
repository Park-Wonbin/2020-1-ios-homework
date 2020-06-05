//
//  SettingsView.swift
//  Memo
//
//  Created by 박원빈 on 2020/06/05.
//  Copyright © 2020 PoApper. All rights reserved.
//

import SwiftUI

class ToggleModel {
    var useLock: Bool = UserDefaults.standard.bool(forKey: DefaultKeys.keyLock) {
        willSet {
            UserDefaults.standard.set(newValue, forKey: DefaultKeys.keyLock)
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var session: Session
    @State var model = ToggleModel()
    @State var showAlert = false
    
    var body: some View {
        List{
            Section(header: Text("General").padding(10)) {
            Toggle(isOn: $model.useLock) {
                    Text("Passcode lock").padding(10)
                }
            }
            Button(action: {
                self.showAlert = true
            }) {
                Text("Reset passcode").padding(10)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Reset passcode?"), message: Text("Restart 'Memo' to set a new passcode."), primaryButton: .destructive(Text("OK"), action: {
                    self.resetPasscode()
                }), secondaryButton: .cancel())
            }
        }
        .navigationBarTitle(Text("Settings"), displayMode: .inline)
    }
    
    private func resetPasscode() {
        session.deletePasswoed()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
