//
//  TaskGroupBootcamp.swift
//  SwiftConcurrency
//
//  Created by karma on 6/23/22.
//

import SwiftUI

class TaskGroupBootcampDataManager {
    let url = URL(string: "https://picsum.photos/250")!
    
    func fetchImageswithAsyncLet() async throws -> [UIImage] {
        async let fetchImage1 = fetchImages(url: "https://picsum.photos/250")
        async let fetchImage2 = fetchImages(url: "https://picsum.photos/250")
        async let fetchImage3 = fetchImages(url: "https://picsum.photos/250")
        async let fetchImage4 = fetchImages(url: "https://picsum.photos/250")
        
        let (image1,image2,image3,image4) = await(try fetchImage1,try fetchImage2,try fetchImage3,try fetchImage4)
        return [image1,image2,image3,image4]
    }
    
    func fetchImagesWithTaskGroups() async throws -> [UIImage] {
        let urlStrings = [
            "https://picsum.photos/250",
            "https://picsum.photos/250",
            "https://picsum.photos/250",
            "https://picsum.photos/250",
            "https://picsum.photos/250"
        ]
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            var images: [UIImage] = []
            images.reserveCapacity(urlStrings.count)
            for urlString in urlStrings {
                group.addTask {
                    try? await self.fetchImages(url: urlString)
                }
            }
            
            for try await image in group {
                if let image = image {
                    images.append(image)
                }
            }
            return images
        }
    }
    
    private func fetchImages(url: String) async throws -> UIImage {
        guard let url = URL(string: url) else { throw URLError(.badURL)}
        do {
            
            let (data,_) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
}

class TaskGroupBootcampViewModel: ObservableObject {
    let manager = TaskGroupBootcampDataManager()
    @Published var images: [UIImage] = []
    
    func getImages() async {
        if let images = try? await manager.fetchImagesWithTaskGroups() {
            await MainActor.run(body: {
                self.images.append(contentsOf: images)
            })
           
        }
    }
    
}

struct TaskGroupBootcamp: View {
    @StateObject private var vm = TaskGroupBootcampViewModel()
    
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        NavigationView{
            ScrollView{
                LazyVGrid(columns: columns) {
                    ForEach(vm.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Async let🔥")
            .task {
                await vm.getImages()
            }
        }
    }
}

struct TaskGroupBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TaskGroupBootcamp()
    }
}
