//
//  docatchBootcamp.swift
//  SwiftConcurrency
//
//  Created by karma on 6/22/22.
//

import SwiftUI

// docatch
// try
// throws

class DataManager{
    let isActive = false
    
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return ("new text",nil)
        } else {
            return (nil, URLError(.badURL))
        }
    }
    
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("new text")
        } else {
            return .failure(URLError(.appTransportSecurityRequiresSecureConnection))
        }
    }
    
    func getTitle3() throws -> String {
        if isActive {
            return "newtext"
        } else {
            throw URLError(.backgroundSessionInUseByAnotherProcess)
        }
    }
    
}

class DocatchBootcampViewModel: ObservableObject {
    // typically in this one one should use dependency injection
    let manager = DataManager()
    @Published var text: String = "start text"
    
    func fetchTitle() {
        /*
        let returnedValue = manager.getTitle()
        if let newTitle = returnedValue.title {
            self.text = newTitle
        } else if let error = returnedValue.error?.localizedDescription {
            self.text = error
        }
         */
        /*
        let result = manager.getTitle2()
        switch result {
        case .success(let newTitle):
            self.text = newTitle
        case .failure(let error):
            self.text = error.localizedDescription
        }
         */
//        guard let newTitle = try? manager.getTitle3() else {
//
//            return
//        }
//        self.text = newTitle
        
        do {
            text = try manager.getTitle3()
        } catch let error {
            text = error.localizedDescription
        }
        
    }
    
    
    
}

struct DocatchBootcamp: View {
    @StateObject private var vm = DocatchBootcampViewModel()
    
    var body: some View {
        Text(vm.text)
            .frame(width: 300, height: 300)
            .background(.blue)
            .onTapGesture {
                vm.fetchTitle()
            }
    }
    
}

struct DocatchBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        DocatchBootcamp()
    }
}
