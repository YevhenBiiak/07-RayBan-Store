//
//  RequestStack.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 15.02.2023.
//

import Foundation
import Semaphore

class RequestStack {
    
    private let semaphore: AsyncSemaphore
    private var stack: [Int] = []
    
    init(capacity: Int) {
        semaphore = AsyncSemaphore(value: capacity)
    }
    
    func add(_ index: Int) async {
        await semaphore.wait()
        stack.append(index)
    }
    
    func remove(_ index: Int) {
        guard let i = stack.firstIndex(of: index) else { return }
        stack.remove(at: i)
        semaphore.signal()
    }
    
    func notContains(_ index: Int) -> Bool {
        !stack.contains(index)
    }
}
