import SwiftUI
import TetherKitIPC

/// 「插上就连」开关与默认静态 IP。
struct AutoConnectRow: View {
    @Bindable var model: AppModel

    var body: some View {
        VStack(alignment: .leading, spacing: Design.Spacing.small) {
            Toggle(L(.autoConnectToggle), isOn: $model.autoConnectEnabled)
            HStack {
                Text(L(.autoConnectAddressLabel))
                    .font(.callout)
                    .foregroundStyle(.secondary)
                TextField(DefaultStaticProfile.defaultAddress, text: $model.defaultStaticAddress)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(.callout, design: .monospaced))
            }
        }
        .padding(.horizontal, Design.Spacing.small)
    }
}
