//
//  UseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 02.09.2022.
//

import Foundation

// placeholder
protocol Type {}

extension Never: Type {}
protocol RequestModel: Type {}
protocol ResponseModel: Type {}

// available Response and Return types
protocol ReturnType {}

extension Int: ResponseModel, ReturnType {}
extension Bool: ResponseModel, ReturnType {}
extension String: ResponseModel, ReturnType {}

class UseCase<Request: Type, Response: Type, Return: Type> {
    
    func execute(_ request: Request, completionHandler: @escaping (Result<Response>) -> Void)
        where Request: RequestModel, Response: ResponseModel, Return == Never {
            
        fatalError("method \(#function) is not implemented")
    }
    
    func execute(completionHandler: @escaping (Result<Response>) -> Void)
        where Request == Never, Response: ResponseModel, Return == Never {
            fatalError("method \(#function) is not implemented")
    }
    
    func execute() -> Return
        where Request == Never, Response == Never, Return: ReturnType {
            fatalError("method \(#function) is not implemented")
    }
    
    func execute()
        where Request == Never, Response == Never, Return == Never {
            fatalError("method \(#function) is not implemented")
    }
}
