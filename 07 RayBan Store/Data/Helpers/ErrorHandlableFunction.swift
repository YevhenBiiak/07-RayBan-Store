//
//  ErrorHandlableFunction.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 08.02.2023.
//

func with<T>(_ errorHandler: (Error) -> Error, _ code: () async throws -> T) async throws -> T {
    do    { return try await code() }
    catch { throw errorHandler(error) }
}

func with<T>(_ errorHandler: (Error) -> Error, _ code: () throws -> T) throws -> T {
    do    { return try code() }
    catch { throw errorHandler(error) }
}

func with(_ errorHandler: (Error) async -> Void, _ code: () async throws -> Void) async {
    do    { try await code() }
    catch { await errorHandler(error) }
}
