//
//  AsyncLetBootcamp.swift
//  SwiftConcurrency
//
//  Created by karma on 6/23/22.
//

import SwiftUI

struct AsyncLetBootcamp: View {
    @State private var images: [UIImage] = []
    let url = URL(string: "https://picsum.photos/250")
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        NavigationView{
            ScrollView{
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Async let🔥")
            .onAppear {
//                self.images.append(UIImage(systemName: "heart.fill")!)
                Task {
                    do{
                        async let fetchImage1 = fetchImages()
                        async let fetchImage2 = fetchImages()
                        async let fetchImage3 = fetchImages()
                        async let fetchImage4 = fetchImages()
                        
                        let (image1,image2,image3,image4) = await (try fetchImage1,try fetchImage2,try fetchImage3,try fetchImage4)
//                        await MainActor.run {
                            self.images.append(contentsOf: [image1,image2,image3,image4])
//                        }
                        
//                        let image1 = try await fetchImages()
//                        await MainActor.run {
//                            self.images.append(image1)
//                        }
//                        let image2 = try await fetchImages()
//                        await MainActor.run {
//                            self.images.append(image2)
//                        }
//                        let image3 = try await fetchImages()
//                        await MainActor.run {
//                            self.images.append(image3)
//                        }
//                        let image4 = try await fetchImages()
//                        await MainActor.run {
//                            self.images.append(image4)
//                        }
                        
                    } catch {
                        
                    }
                }
            }
        }
    }
    
    func fetchImages() async throws -> UIImage {
        do {
            guard let url = url else { return UIImage()}
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

struct AsyncLetBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncLetBootcamp()
    }
}
