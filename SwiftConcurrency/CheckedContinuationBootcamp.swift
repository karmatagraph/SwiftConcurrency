//
//  CheckedContinuationBootcamp.swift
//  SwiftConcurrency
//
//  Created by karma on 6/23/22.
//

import SwiftUI


class CheckedContinuationBootcampNetworkManager {
    
    func getData(url: URL) async throws -> Data {
        do {
            let (data,_) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            throw error
        }
    }
    
    func getData2(url: URL) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    continuation.resume(returning: data)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
            }
            .resume()
        }
    }
    
    func getHeartImageFromDatabase(completionHandler: @escaping(_ image:UIImage)->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            completionHandler(UIImage(systemName: "heart.fill")!)
        }
    }
    
    // with throwing
    /*
    func getHeartImageFromDatabase() async throws -> UIImage {
        return try await withCheckedThrowingContinuation({ continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                if let image = UIImage(systemName: "heart.fill") {
                    continuation.resume(returning: image)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
            }
        })
    }
     */
    
    // without throwing
    func getHeartImageFromDatabase() async -> UIImage {
        return await withCheckedContinuation({ continuation in
            getHeartImageFromDatabase { image in
                continuation.resume(returning: image)
            }
        })
    }
    
}

class CheckedContinuationBootcampViewModel:ObservableObject {
    @Published var image: UIImage? = nil
    let manager = CheckedContinuationBootcampNetworkManager()
    
    func getImage() async {
        guard let url = URL(string: "https://picsum.photos/250") else { return }
        do {
            let data = try await manager.getData2(url: url)
            if let image = UIImage(data: data) {
                await MainActor.run(body: {
                    self.image = image
                })
            }
        } catch {
            print(error.localizedDescription,"--------------------error")
        }
    }
    
//    func getHeartImage() {
//        manager.getHeartImageFromDatabase { [weak self] image in
//            self?.image = image
//        }
//    }
    
    // throwing
    /*
    func getHeartImage() async {
        do {
            let data = try await manager.getHeartImageFromDatabase()
            await MainActor.run(body: {
                self.image = data
            })
        } catch let error {
            print(error.localizedDescription,"this error ----------------")
        }
    }
    */
    
    
    // just returning
    func getHeartImage() async {
        let image = await manager.getHeartImageFromDatabase()
        await MainActor.run(body: {
            self.image = image
        })
    }
}

struct CheckedContinuationBootcamp: View {
    @StateObject private var vm = CheckedContinuationBootcampViewModel()
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
//            await vm.getImage()
            await vm.getHeartImage()
        }
    }
}

struct CheckedContinuationBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CheckedContinuationBootcamp()
    }
}
