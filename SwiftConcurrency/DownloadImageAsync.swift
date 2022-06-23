//
//  DownloadImageAsync.swift
//  SwiftConcurrency
//
//  Created by karma on 6/23/22.
//

import SwiftUI
import Combine

class DownloadImageLoader {
     let url = URL(string: "https://picsum.photos/seed/picsum/250")!
    
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        return image
    }
    
    func downloadWithEscaping( completionHandler: @escaping(_ image: UIImage?,_ error: Error?) -> ()) {
//        guard let url = url else {
//            return
//        }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let image = self?.handleResponse(data: data, response: response) {
                completionHandler(image,nil)
            } else {
                completionHandler(nil,error)
            }
        }
        .resume()
    }
    
    func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError({ $0 })
            .eraseToAnyPublisher()
    }
    
    func downloadWithAsync() async throws -> UIImage? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            return handleResponse(data: data, response: response)
        } catch let error {
            throw error
        }
    }
    
}

class DownloadImageAsyncViewModel: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    @Published var image: UIImage? = nil
    let loader = DownloadImageLoader()
    
    func fetchImage() async {
        // downloading with escaping
        /*
        loader.downloadWithEscaping { [weak self] image, error in
            if let image = image {
                DispatchQueue.main.async {
                    self?.image = image
                }
                
            }
        }
         */
        
        // downloading with combine
        /*
        loader.downloadWithCombine()
            .receive(on: DispatchQueue.main)
            .sink {_ in
                
            } receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
            }
            .store(in: &cancellables)
         */
        
        // downloading with async await
        let image = try? await loader.downloadWithAsync()
        await MainActor.run {
            self.image = image
        }
    }
    
}

struct DownloadImageAsync: View {
    @StateObject private var vm = DownloadImageAsyncViewModel()
    
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
        }
        .onAppear {
            Task {
                await vm.fetchImage()
            }
        }
    }
}

struct DownloadImageAsync_Previews: PreviewProvider {
    static var previews: some View {
        DownloadImageAsync()
    }
}
