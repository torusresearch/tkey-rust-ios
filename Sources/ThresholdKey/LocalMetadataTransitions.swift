//
//  LocalMetadataTransitions.swift
//  
//
//  Created by David Main on 2023/01/11.
//

import Foundation

#if canImport(lib)
    import lib
#endif

public final class LocalMetadataTransitions {
    private(set) var pointer: OpaquePointer?

    public init(pointer: OpaquePointer) {
        self.pointer = pointer
    }

    public init(json: String) throws {
        var errorCode: Int32 = -1
        let jsonPointer = UnsafeMutablePointer<Int8>(mutating: (json as NSString).utf8String)
        let result = withUnsafeMutablePointer(to: &errorCode, { error in
            local_metadata_transitions_from_json(jsonPointer, error)
                })
        guard errorCode == 0 else {
            throw RuntimeError("Error in ShareStore")
            }
        pointer = result
    }

    public func export() throws -> String {
        var errorCode: Int32 = -1
        let result = withUnsafeMutablePointer(to: &errorCode, { error in
            local_metadata_transitions_to_json(pointer, error)
                })
        guard errorCode == 0 else {
            throw RuntimeError("Error in ShareStore")
            }
        let value = String.init(cString: result!)
        string_free(result)
        return value
    }
    
    deinit {
        local_metadata_transitions_free(pointer)
    }
}
