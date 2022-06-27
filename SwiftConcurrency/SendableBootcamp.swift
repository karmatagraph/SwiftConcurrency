//
//  SendableBootcamp.swift
//  SwiftConcurrency
//
//  Created by karma on 6/27/22.
//

import SwiftUI

actor CurrentUserManager {
    
    func updateDatabase(userInfo: MyClassUserInfo) {
        
    }
}

struct MyUserInfo: Sendable {
    let name: String
}

final class MyClassUserInfo: @unchecked Sendable {
    private var name: String
    let queue = DispatchQueue(label: "com.myApp.info")
    
    init(name: String) {
        self.name = name
    }
    func updateName(name: String) {
        queue.async {
            self.name = name
        }
    }
}

class SendableViewModel: ObservableObject {
    
    let manager = CurrentUserManager()
    
    func updateCurrentUserInfo() async {
        let info = MyClassUserInfo(name: "my info")
        await manager.updateDatabase(userInfo: info)
    }
}
struct SendableBootcamp: View {
    
    @StateObject private var vm = SendableViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .task {
                await vm.updateCurrentUserInfo()
            }
    }
}

struct SendableBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        SendableBootcamp()
    }
}
