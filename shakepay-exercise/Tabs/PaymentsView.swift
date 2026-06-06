import SwiftUI

private struct Recipient: Identifiable {
    let id = UUID()
    let name: String
    let handle: String
    let initials: String
    let color: Color
}

struct PaymentsView: View {
    @State private var searchText = ""
    @State private var showEducation = true
    @State private var showScanner = false

    private let recipients: [Recipient] = [
        Recipient(name: "Theodore Calvin",   handle: "@theodore",  initials: "TC", color: Color(hex: 0x2A6BDE)),
        Recipient(name: "Satoshi Nakamoto",  handle: "@satoshi",   initials: "SN", color: Color(hex: 0xF7931A)),
        Recipient(name: "Maggie Smith",      handle: "@maggie",    initials: "MS", color: Color(hex: 0x6F7CF7)),
    ]

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            VStack(spacing: 0) {
                navBar
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        searchField
                        if showEducation { educationCard }
                        recipientSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 110)
                }
            }
        }
        .fullScreenCover(isPresented: $showScanner) {
            QRScannerView()
        }
    }

    // MARK: Nav

    private var navBar: some View {
        ZStack {
            Text("Payments")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            HStack {
                Spacer()
                Button { showScanner = true } label: {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                }
            }
            .padding(.horizontal, 12)
        }
        .frame(height: 56)
        .padding(.top, 8)
    }

    // MARK: Search

    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
            TextField("", text: $searchText, prompt:
                Text("@shaketag, address, invoice, or ENS")
                    .foregroundColor(AppTheme.textMuted)
                    .font(.system(size: 15)))
                .font(.system(size: 15))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(AppTheme.card))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(AppTheme.stroke, lineWidth: 1))
    }

    // MARK: Education card (dismissible, non-blocking)

    private var educationCard: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle().fill(AppTheme.accentBlue.opacity(0.12)).frame(width: 40, height: 40)
                Image(systemName: "person.2.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppTheme.accentBlue)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Pay friends on Shakepay")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                Text("Send cash or crypto instantly using a shaketag, address, invoice, or ENS.")
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.textMuted)
                    .fixedSize(horizontal: false, vertical: true)
                Button {} label: {
                    HStack(spacing: 4) {
                        Text("Learn how")
                            .font(.system(size: 13, weight: .bold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .foregroundColor(AppTheme.accentBlue)
                }
                .padding(.top, 2)
            }
            Spacer()
            Button {
                withAnimation(.easeOut(duration: 0.2)) { showEducation = false }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(AppTheme.textMuted)
                    .frame(width: 28, height: 28)
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(AppTheme.card))
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(AppTheme.stroke, lineWidth: 1))
        .transition(.opacity.combined(with: .move(edge: .top)))
    }

    // MARK: Suggested recipients

    private var recipientSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Suggested")
                .font(.system(size: 14, weight: .bold))
                .tracking(0.6)
                .foregroundColor(AppTheme.textMuted)
            VStack(spacing: 10) {
                ForEach(recipients) { r in
                    recipientRow(r)
                }
            }
        }
    }

    private func recipientRow(_ r: Recipient) -> some View {
        Button {} label: {
            HStack(spacing: 14) {
                Circle()
                    .fill(r.color)
                    .frame(width: 46, height: 46)
                    .overlay(Text(r.initials)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white))
                VStack(alignment: .leading, spacing: 3) {
                    Text(r.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    Text(r.handle)
                        .font(.system(size: 13))
                        .foregroundColor(AppTheme.textMuted)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(AppTheme.textMuted)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(AppTheme.card))
            .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(AppTheme.stroke, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}
