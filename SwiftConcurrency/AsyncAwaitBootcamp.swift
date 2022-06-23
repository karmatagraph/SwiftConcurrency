//
//  AsyncAwaitBootcamp.swift
//  SwiftConcurrency
//
//  Created by karma on 6/23/22.
//

import SwiftUI

class AsyncAwaitBootcampViewModel: ObservableObject {
    @Published var dataArray: [String] = []
    
    func addTitle1() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dataArray.append("title1: \(Thread.current)")
        }
    }
    
    func addTitle2() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let title = "title2 \(Thread.current)"
            DispatchQueue.main.async {
                self.dataArray.append(title)
                let title3 = "title3 \(Thread.current)"
                self.dataArray.append(title3)
            }
        }
    }
    
    func addAuthor1() async {
        let author1 = "author 1: \(Thread.current)"
        self.dataArray.append(author1)
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let author2 = "author 2: \(Thread.current)"
        await MainActor.run {
            self.dataArray.append(author2)
            let author3 = "author 3: \(Thread.current)"
            self.dataArray.append(author3)

        }
        await addSomething()
    }
    
    func addSomething() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let something1 = "something 1: \(Thread.current)"
        await MainActor.run {
            self.dataArray.append(something1)
            let something2 = "something 2: \(Thread.current)"
            self.dataArray.append(something2)

        }
    }
    
}

struct AsyncAwaitBootcamp: View {
    @StateObject private var vm = AsyncAwaitBootcampViewModel()
    
    var body: some View {
        List{
            ForEach(vm.dataArray, id: \.self) { data in
                Text(data)
            }
        }
        .onAppear {
//            vm.addTitle1()
//            vm.addTitle2()
            Task {
                await vm.addAuthor1()
                let finaltext = "finaltext: \(Thread.current)"
                vm.dataArray.append(finaltext)
            }
        }
    }
}

struct AsyncAwaitBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncAwaitBootcamp()
    }
}
