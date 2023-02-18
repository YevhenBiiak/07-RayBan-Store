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
    private var stack: [IndexPath] = []
    
    init(capacity: Int) {
        semaphore = AsyncSemaphore(value: capacity)
    }
    
    func add(_ indexPath: IndexPath) async {
        await semaphore.wait()
        stack.append(indexPath)
    }
    
    func remove(_ indexPath: IndexPath) {
        guard let index = stack.firstIndex(of: indexPath) else { return }
        stack.remove(at: index)
        semaphore.signal()
    }
    
    func notContains(_ indexPath: IndexPath) -> Bool {
        !stack.contains(indexPath)
    }
}
