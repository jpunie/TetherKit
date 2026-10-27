import Foundation

/// 「插上就连」的触发判定：纯逻辑，不碰 UI 与 XPC，方便单测。
///
/// 边沿触发：同一台设备（按总线地址识别）只尝试一次。失败或用户手动断开后
/// 不会再自动重试，否则取消指纹框会立刻又弹一次。设备拔掉后记忆清除，
/// 下次插上重新生效。
public struct AutoConnectGate: Sendable {
    private var attemptedDeviceID: String?

    public init() {}

    /// - Returns: 应该自动连接的设备 ID；不该触发返回 nil。
    public mutating func deviceToConnect(enabled: Bool,
                                         sessionIdle: Bool,
                                         busy: Bool,
                                         deviceIDs: [String]) -> String? {
        // 设备离场就忘掉，这样重新插上能再触发。
        if let attempted = attemptedDeviceID, !deviceIDs.contains(attempted) {
            attemptedDeviceID = nil
        }
        // 只在恰好一台设备时触发：多台时无法替用户选。
        guard enabled, sessionIdle, !busy,
              deviceIDs.count == 1, let id = deviceIDs.first,
              attemptedDeviceID != id else { return nil }
        attemptedDeviceID = id
        return id
    }
}

/// 一键连接用的默认静态配置。
public enum DefaultStaticProfile {
    public static let defaultAddress = "192.168.10.4"

    public static func configuration(address: String) -> NetworkConfiguration {
        NetworkConfiguration(mode: .manual, address: address, netmask: "255.255.255.0",
                             router: "", dnsServers: [], setDefaultRoute: false)
    }
}
