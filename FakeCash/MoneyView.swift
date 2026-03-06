import SwiftUI

struct MoneyView: View {
    @ObservedObject var account: AccountModel
    @Binding var showEdit: Bool
    @State private var balanceHidden = false
    @State private var toastMessage: String? = nil

    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    DarkHeaderSection(account: account, showEdit: $showEdit)
                    WhiteCardSection(account: account, balanceHidden: $balanceHidden, onToast: showToast)
                    MoreForYouSection(onToast: showToast)
                    AddMoneySection(onToast: showToast)
                    DisclosureSection()
                    Color.clear.frame(height: 90)
                }
            }
            .background(Color(hex: "f0f0f0"))

            if let msg = toastMessage {
                VStack {
                    Spacer().frame(height: 70)
                    Text(msg)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color(hex: "1c1c1e"))
                        .cornerRadius(14)
                        .shadow(color: .black.opacity(0.3), radius: 10)
                    Spacer()
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.2), value: toastMessage != nil)
                .zIndex(10)
            }
        }
    }

    func showToast(_ message: String) {
        withAnimation { toastMessage = message }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { toastMessage = nil }
        }
    }
}

// MARK: - Dark Header

struct DarkHeaderSection: View {
    @ObservedObject var account: AccountModel
    @Binding var showEdit: Bool

    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                colors: [Color(hex: "161616"), Color(hex: "262626")],
                startPoint: .top, endPoint: .bottom
            )
            .frame(height: 175)

            VStack(spacing: 0) {
                Spacer().frame(height: 56)

                // Nav row
                HStack(alignment: .center) {
                    Text("Money")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, 16)

                    Button(action: { showEdit = true }) {
                        ZStack(alignment: .topTrailing) {
                            Circle()
                                .fill(LinearGradient(
                                    colors: [Color(hex: "1a4a8a"), Color(hex: "0d2d5e")],
                                    startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Text(account.profileEmoji)
                                        .font(.system(size: 18))
                                )
                                .overlay(Circle().stroke(Color.gray.opacity(0.5), lineWidth: 1.5))
                            if account.notificationCount > 0 {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 17, height: 17)
                                    .overlay(
                                        Text("\(account.notificationCount)")
                                            .font(.system(size: 9, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                                    .overlay(Circle().stroke(Color(hex: "161616"), lineWidth: 2))
                                    .offset(x: 5, y: -5)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)

                // Card chip row
                HStack {
                    HStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.white.opacity(0.25))
                            .frame(width: 22, height: 16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.white.opacity(0.7))
                                    .frame(width: 8, height: 6)
                            )
                        Text("•• \(account.cardLastFour)")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(Color.white.opacity(0.13))
                    .cornerRadius(20)

                    Spacer()

                    Text(account.cashtag)
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "aaaaaa"))
                }
                .padding(.horizontal, 20)
            }
        }
        .frame(height: 175)
    }
}

// MARK: - White Card Section

struct WhiteCardSection: View {
    @ObservedObject var account: AccountModel
    @Binding var balanceHidden: Bool
    var onToast: (String) -> Void

    var body: some View {
        ZStack(alignment: .top) {
            Color.white
                .cornerRadius(28, corners: [.topLeft, .topRight])

            VStack(alignment: .leading, spacing: 0) {
                // Balance header
                HStack {
                    HStack(spacing: 6) {
                        Text("Cash balance •• \(account.accountLastFour)")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.black)
                    }
                    .onTapGesture { onToast("Account ••\(account.accountLastFour)") }
                    Spacer()
                    Button(action: { balanceHidden.toggle() }) {
                        Image(systemName: "eye.slash")
                            .font(.system(size: 20))
                            .foregroundColor(Color(hex: "888888"))
                    }
                }
                .padding(.horizontal, 22)
                .padding(.top, 24)
                .padding(.bottom, 6)

                // Balance
                Text(balanceHidden ? "••••••" : account.balanceDisplay)
                    .font(.system(size: 52, weight: .bold))
                    .foregroundColor(.black)
                    .tracking(-2)
                    .padding(.horizontal, 22)
                    .padding(.bottom, 28)
                    .onTapGesture { onToast("Tap profile avatar to edit balance") }

                // Buttons row
                HStack(spacing: 12) {
                    ActionButton(title: "Add money") { onToast("Add money tapped") }
                    ActionButton(title: "Withdraw")  { onToast("Withdraw tapped") }
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 14)

                // Green status row
                HStack(spacing: 10) {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(hex: "00D632"), lineWidth: 2.5)
                        .frame(width: 18, height: 30)
                    Text("Green status")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    Spacer()
                    Text(account.greenStatusText)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color(hex: "888888"))
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 16)
                .background(Color(hex: "f7f7f7"))
                .cornerRadius(16)
                .padding(.horizontal, 22)
                .padding(.bottom, 24)
                .onTapGesture { onToast("Green status: \(account.greenStatusText)") }
            }
        }
        .offset(y: -14)
    }
}

// MARK: - More for You

struct MoreForYouSection: View {
    var onToast: (String) -> Void

    let items: [(String, String, String)] = [
        ("🪙", "Bitcoin",   "Learn and invest"),
        ("💵", "Paychecks", "Get paid faster"),
        ("🌹", "Savings",   "Up to 3.25% interest"),
        ("📈", "Stocks",    "Invest with $1"),
        ("💎", "Pools",     "Collect money with anyone"),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("More for you")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.black)
                .padding(.horizontal, 22)
                .padding(.top, 24)
                .padding(.bottom, 18)

            ForEach(items, id: \.1) { icon, label, sub in
                HStack(spacing: 14) {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(hex: "f0f0f0"))
                        .frame(width: 52, height: 52)
                        .overlay(Text(icon).font(.system(size: 26)))

                    VStack(alignment: .leading, spacing: 3) {
                        Text(label)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.black)
                        Text(sub)
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "888888"))
                    }
                    Spacer()
                    Button(action: { onToast("Starting \(label)") }) {
                        Text("Start")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 9)
                            .background(Color(hex: "f0f0f0"))
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 22)
                .contentShape(Rectangle())
                .onTapGesture { onToast("\(label) tapped") }
            }
        }
        .background(Color.white)
        .padding(.top, 2)
    }
}

// MARK: - Add Money

struct AddMoneySection: View {
    var onToast: (String) -> Void

    let items: [(String, String)] = [
        ("arrow.down.to.line",   "Direct deposit"),
        ("arrow.2.circlepath",   "Get bank or wire transfer"),
        ("banknote",             "Deposit paper money"),
        ("doc.viewfinder",       "Deposit check"),
        ("repeat",               "Auto reload"),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Add money")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.black)
                .padding(.horizontal, 22)
                .padding(.top, 24)
                .padding(.bottom, 6)

            ForEach(Array(items.enumerated()), id: \.1.1) { idx, item in
                let (icon, label) = item
                VStack(spacing: 0) {
                    HStack(spacing: 16) {
                        Image(systemName: icon)
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .frame(width: 28)
                        Text(label)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Color(hex: "bbbbbb"))
                    }
                    .padding(.horizontal, 22)
                    .padding(.vertical, 20)
                    .contentShape(Rectangle())
                    .onTapGesture { onToast("\(label) tapped") }

                    if idx < items.count - 1 {
                        Divider().padding(.leading, 66)
                    }
                }
            }
        }
        .background(Color.white)
        .padding(.top, 12)
    }
}

// MARK: - Disclosure

struct DisclosureSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            (Text("Your balance is eligible for FDIC pass-through insurance through Wells Fargo Bank, N.A., Sutton Bank, and/or The Bancorp Bank, N.A., Members FDIC for up to $250,000 per customer when aggregated with all other deposits held in the same legal capacity at each bank, if certain conditions are met. The FDIC insures your balance only in the event that the bank(s) identified above holding your funds fails. See the ")
             + Text("Cash App Terms of Service.").underline())
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(Color(hex: "888888"))

            Text("Cash App is a financial services platform, and not an FDIC-insured bank. Prepaid debit cards issued by Sutton Bank, Member FDIC. Cash App Visa® Debit Flex Cards issued by Sutton Bank, Member FDIC, and The Bancorp Bank, N.A., pursuant to a license from Visa U.S.A. Inc.")
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(Color(hex: "888888"))

            (Text("Banking services provided by Cash App's bank partner(s). Brokerage services by Cash App Investing LLC. member FINRA, subsidiary of Block, Inc. Bitcoin services by Block. Inc. Tax filing services by Cash App Taxes. ")
             + Text("Disclosures").underline())
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(Color(hex: "888888"))
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 28)
        .background(Color.white)
        .padding(.top, 12)
    }
}

// MARK: - Bottom Tab Bar

struct BottomTabBar: View {
    @ObservedObject var account: AccountModel
    @Binding var selectedTab: Int

    var body: some View {
        HStack {
            Spacer()
            Button(action: { selectedTab = 0 }) {
                Text(account.balanceRounded)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(selectedTab == 0 ? .black : Color(hex: "888888"))
            }
            Spacer()
            Button(action: { selectedTab = 1 }) {
                Text("$")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(selectedTab == 1 ? .black : Color(hex: "aaaaaa"))
            }
            Spacer()
            ZStack(alignment: .topTrailing) {
                Button(action: { selectedTab = 2 }) {
                    Image(systemName: "clock")
                        .font(.system(size: 22))
                        .foregroundColor(selectedTab == 2 ? .black : Color(hex: "aaaaaa"))
                }
                if account.notificationCount > 0 {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 16, height: 16)
                        .overlay(
                            Text("\(account.notificationCount)")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .offset(x: 9, y: -9)
                }
            }
            Spacer()
        }
        .padding(.top, 12)
        .padding(.bottom, 34)
        .background(
            Color.white
                .ignoresSafeArea(edges: .bottom)
        )
        .overlay(Divider(), alignment: .top)
    }
}

// MARK: - Action Button

struct ActionButton: View {
    let title: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color(hex: "eeeeee"))
                .cornerRadius(16)
        }
    }
}
