//
//  StructClassActorBootcamp.swift
//  SwiftConcurrency
//
//  Created by karma on 6/24/22.
//

import SwiftUI

struct StructClassActorBootcamp: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                runTest()
            }
    }
}

struct StructClassActorBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        StructClassActorBootcamp()
    }
}

struct MyStruct {
    var title: String
}

class MyClass {
    var title: String = ""
    
    init(title: String) {
        self.title = title
    }
    
}

extension StructClassActorBootcamp {
    func runTest() {
        print("test started")
//        structTest1()
//        divider()
//        classTest1()
        
        structTest2()
    }
    
    private func divider() {
        print("""
       ------------------------------------)
    """)}
    
    private func structTest1() {
        let objectA = MyStruct(title: "starting title")
        print("Object A: ",objectA.title)
        var objectB = objectA
        print("Object B: ",objectB.title)
        
        objectB.title = "second title"
        print("Object B title changed")
        print("Object A: ",objectA.title)
        print("Object B: ",objectB.title)

    }
    
    private func classTest1() {
        let objectA = MyClass(title: "starting title")
        print("Object A: ",objectA.title)
        let objectB = objectA
        print("ObjectB: ", objectB.title)
        
        objectB.title = "second title"
        print("Object B title changed")
        print("Object A: ",objectA.title)
        print("Object B: ",objectB.title)
        
    }
    
}

// this is an immuatable struct
struct CustomStruct {
    let title: String
    func updateTitle() {
        
    }
}

extension StructClassActorBootcamp {
    private func structTest2() {
        print("struct test 2")
        var struct1 = MyStruct(title: "title1")
        print("struct 1:", struct1.title)
        struct1.title = "title2"
        print("struct 1:", struct1.title)

//        var struct2 = CustomStruct(title: "titel1")
//        print("struct 2:", struct2.title)

//        struct2 = CustomStruct(title: "title2")
//        print("struct 2:", struct2.title)

    }
}
