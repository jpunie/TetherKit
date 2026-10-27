import XCTest
@testable import TetherKitIPC

final class AutoConnectTests: XCTestCase {
    func testTriggersOncePerPlug() {
        var gate = AutoConnectGate()
        func ask(_ ids: [String], enabled: Bool = true) -> String? {
            gate.deviceToConnect(enabled: enabled, sessionIdle: true, busy: false, deviceIDs: ids)
        }
        XCTAssertNil(ask(["1.2"], enabled: false))
        XCTAssertEqual(ask(["1.2"]), "1.2")
        XCTAssertNil(ask(["1.2"]))
        XCTAssertNil(ask([]))
        XCTAssertEqual(ask(["1.2"]), "1.2")
        XCTAssertNil(ask(["1.3", "1.4"]))
    }

    func testDefaultProfile() {
        let c = DefaultStaticProfile.configuration(address: "192.168.10.4")
        XCTAssertEqual(c.mode, .manual)
        XCTAssertEqual(c.netmask, "255.255.255.0")
    }
}
