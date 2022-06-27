//
//  AsyncPublisherBootcamp.swift
//  SwiftConcurrency
//
//  Created by karma on 6/27/22.
//

import SwiftUI

actor AsyncPublisherDataManager {
    @Published var myData: [String] = []
    
    func addData() async {
        myData.append("Apple")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Banana")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Cantelope")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Durian")
    }
}

class AsyncPublisherBootcampViewModel: ObservableObject {
    let manager = AsyncPublisherDataManager()
    @MainActor @Published var dataArray: [String] = []
    
    init() {
        addSubscriber()
    }
    
    private func addSubscriber() {
        Task {
            await MainActor.run(body: {
                self.dataArray = ["ONE"]
            })
            
            for await value in await manager.$myData.values {
                await MainActor.run(body: {
                    self.dataArray = value
                })
            }
            
            await MainActor.run(body: {
                self.dataArray = ["TWO"]
            })
        }
    }
    
    func start() async {
         await manager.addData()
    }
}

struct AsyncPublisherBootcamp: View {
    @StateObject private var vm = AsyncPublisherBootcampViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.dataArray, id: \.self) { text in
                    Text(text)
                        .font(.headline)
                }
            }
        }
        .task {
            await vm.start()
        }
    }
}

struct AsyncPublisherBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncPublisherBootcamp()
    }
}
