//
//  PasswordScreen.swift
//  Memo
//
//  Created by 박원빈 on 2020/05/15.
//  Copyright © 2020 PoApper. All rights reserved.
//

import SwiftUI

struct PasswordScreen: View {
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var session: Session
    @State var text = "Enter Passcode"
    @State private var password: Array<Int?> = [nil, nil, nil, nil]

    var body: some View {
        VStack {
            Spacer()
            Text(text)
                .padding(.bottom)
                .onAppear {
                    if (!self.session.passWordIsSet()) {
                        self.text = "Enter New Passcode"
                    }
                }
            PasswordView(password: $password)
            Spacer()
            KeypadView(text: $text, password: $password)
            Spacer()
        }
        .foregroundColor(colorScheme == .light ? Color.black : Color.white)
    }
}

struct PasswordView: View {
    @Binding var password: Array<Int?>
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: password[0] == nil ? "circle" : "circle.fill")
            Image(systemName: password[1] == nil ? "circle" : "circle.fill")
            Image(systemName: password[2] == nil ? "circle" : "circle.fill")
            Image(systemName: password[3] == nil ? "circle" : "circle.fill")
        }
    }
}

struct KeypadView: View {
    @EnvironmentObject var session: Session
    @Binding var text: String
    @Binding var password: Array<Int?>
    @State var digit = 0
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 40) {
            HStack(spacing: 20) {
                Button(action: { self.keyPressed(key: 1) }) {
                    Image(systemName: "1.circle")
                }
                Button(action: { self.keyPressed(key: 2) }) {
                    Image(systemName: "2.circle")
                }
                Button(action: { self.keyPressed(key: 3) }) {
                    Image(systemName: "3.circle")
                }
            }
            HStack(spacing: 20) {
                Button(action: { self.keyPressed(key: 4) }) {
                    Image(systemName: "4.circle")
                }
                Button(action: { self.keyPressed(key: 5) }) {
                    Image(systemName: "5.circle")
                }
                Button(action: { self.keyPressed(key: 6) }) {
                    Image(systemName: "6.circle")
                }
            }
            HStack(spacing: 20) {
                Button(action: { self.keyPressed(key: 7) }) {
                    Image(systemName: "7.circle")
                }
                Button(action: { self.keyPressed(key: 8) }) {
                    Image(systemName: "8.circle")
                }
                Button(action: { self.keyPressed(key: 9) }) {
                    Image(systemName: "9.circle")
                }
            }
            HStack(spacing: 20) {
                Button(action: { self.keyPressed(key: 0) }) {
                    Image(systemName: "0.circle")
                }
                Button(action: { self.keyPressed(key: -1) }) {
                    Image(systemName: "arrow.uturn.left.circle")
                }
            }
        }
        .font(.system(size: 70, weight: .ultraLight))
    }
    
    private func keyPressed(key: Int) -> Void {
        if key == -1 && digit > 0 {
            digit -= 1
            password[digit] = nil
        } else if (key >= 0 && key <= 9) && digit < 4 {
            password[digit] = key
            digit += 1
        }
        
        if digit ==  4 {
            let input = "\(password[0]!)\(password[1]!)\(password[2]!)\(password[3]!)"
            
            if (!session.passWordIsSet()) {
                session.setPassword(input)
                session.isAuth = true
            } else if (!session.auth(password: input)) {
                text = "Wrong Passcode"
                password = [nil, nil, nil, nil]
                digit = 0
            }
        }
    }
}

struct PasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        PasswordScreen().environmentObject(Session())
    }
}
