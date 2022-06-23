//
//  TaskBootcamp.swift
//  SwiftConcurrency
//
//  Created by karma on 6/23/22.
//

import SwiftUI

class TaskBootcampViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil

    func fetchImage() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        do {
            guard let url = URL(string: "https://picsum.photos/seed/picsum/250") else { return }
            let (data,_) = try await URLSession.shared.data(from: url)
            await MainActor.run(body: {
                self.image = UIImage(data: data)
                print("image returned successfully")
            })
           
        } catch let error {
            print(error.localizedDescription, " <------------------this error")
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/seed/picsum/250") else { return }
            let (data,_) = try await URLSession.shared.data(from: url)
            await MainActor.run(body: {
                self.image2 = UIImage(data: data)
            })
        } catch let error {
            print(error.localizedDescription, " <------------------this error")
        }
    }
    
}

struct TaskBootcamp: View {
    @StateObject private var vm = TaskBootcampViewModel()
    @State private var fetchImageTask: Task<(),Never>? = nil
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
            if let image = vm.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
        }.task {
            await vm.fetchImage()
            await vm.fetchImage2()
        }
//        .onDisappear{
//            fetchImageTask?.cancel()
//        }
//        .onAppear {
//
//        }
    }
}

struct TaskBootcampHomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("Click me") {
                    TaskBootcamp()
                }
            }
        }
    }
}

struct TaskBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TaskBootcamp()
    }
}
