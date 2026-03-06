import SwiftUI

struct ContentView: View {
    @StateObject var account = AccountModel()
    @State private var selectedTab: Int = 0
    @State private var showEdit = false

    var body: some View {
        ZStack(alignment: .bottom) {
            MoneyView(account: account, showEdit: $showEdit)
                .ignoresSafeArea()

            BottomTabBar(account: account, selectedTab: $selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
        .sheet(isPresented: $showEdit) {
            EditAccountSheet(account: account)
        }
    }
}
