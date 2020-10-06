import SignalFfi
import Foundation

class SignedPreKeyRecord: ClonableHandleOwner {
    override class func destroyNativeHandle(_ handle: OpaquePointer) {
        signal_signed_pre_key_record_destroy(handle)
    }

    override class func cloneNativeHandle(_ newHandle: inout OpaquePointer?, currentHandle: OpaquePointer?) -> SignalFfiErrorRef? {
        return signal_signed_pre_key_record_clone(&newHandle, currentHandle)
    }

    init(bytes: [UInt8]) throws {
        var handle: OpaquePointer?
        try CheckError(signal_signed_pre_key_record_deserialize(&handle, bytes, bytes.count))
        super.init(owned: handle!)
    }

    init(id: UInt32,
         timestamp: UInt64,
         priv_key: PrivateKey,
         signature: [UInt8]) throws {
        let pub_key = try priv_key.getPublicKey();
        var handle: OpaquePointer?
        try CheckError(signal_signed_pre_key_record_new(&handle, id, timestamp,
                                                        pub_key.nativeHandle(), priv_key.nativeHandle(),
                                                        signature, signature.count));
        super.init(owned: handle!)
    }

    internal override init(unowned handle: OpaquePointer?) {
        super.init(unowned: handle)
    }

    func serialize() throws -> [UInt8] {
        return try invokeFnReturningArray(fn: { (b,bl) in signal_signed_pre_key_record_serialize(nativeHandle(),b,bl) })
    }

    func getId() throws -> UInt32 {
        return try invokeFnReturningInteger(fn: { (i) in signal_signed_pre_key_record_get_id(nativeHandle(), i) })
    }

    func getTimestamp() throws -> UInt64 {
        return try invokeFnReturningInteger(fn: { (i) in signal_signed_pre_key_record_get_timestamp(nativeHandle(), i) })
    }

    func getPublicKey() throws -> PublicKey {
        return try invokeFnReturningPublicKey(fn: { (k) in signal_signed_pre_key_record_get_public_key(k, nativeHandle()) })
    }

    func getPrivateKey() throws -> PrivateKey {
        return try invokeFnReturningPrivateKey(fn: { (k) in signal_signed_pre_key_record_get_private_key(k, nativeHandle()) })
    }

    func getSignature() throws -> [UInt8] {
        return try invokeFnReturningArray(fn: { (b,bl) in signal_signed_pre_key_record_get_signature(nativeHandle(),b,bl) })
    }
}