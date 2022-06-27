//
//  GlobalActorBootcamp.swift
//  SwiftConcurrency
//
//  Created by karma on 6/27/22.
//

import SwiftUI

@globalActor struct MyFirstGlobalActor {
    static var shared = MyNewDataManager()
}

actor MyNewDataManager {
//    static let instance = MyNewDataManager()
    func getDataFromDatabase() -> [String] {
        return ["one","two","three","four","Five"]
    }
    
}

class GlobalActorViewModel: ObservableObject {
    
    let manager = MyFirstGlobalActor.shared
    @MainActor @Published var dataArray: [String] = []
    
    
    // marking/isolating to the actor
    @MyFirstGlobalActor func getData() async {
        
        // HEAVY COMPLEX METHODS
        
        
        Task {
            let data = await manager.getDataFromDatabase()
            await MainActor.run {
                self.dataArray = data
            }
        }
    }
    
}

struct GlobalActorBootcamp: View {
    
    @StateObject private var vm = GlobalActorViewModel()
    var body: some View {
        ScrollView {
            VStack{
                ForEach(vm.dataArray, id: \.self) { text in
                    Text(text)
                        .font(.headline)
                }
            }
        }
        .task {
            await vm.getData()
        }
    }
    
}

struct GlobalActorBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        GlobalActorBootcamp()
    }
}
