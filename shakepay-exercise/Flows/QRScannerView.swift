import SwiftUI
import AVFoundation

// MARK: - Camera preview (UIKit bridge)

private final class CameraPreviewLayer: UIView {
    override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
    var previewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
}

private struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> CameraPreviewLayer {
        let view = CameraPreviewLayer()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: CameraPreviewLayer, context: Context) {
        uiView.previewLayer.session = session
    }
}

// MARK: - Session manager

private final class ScannerSession: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    let session = AVCaptureSession()
    @Published var scannedCode: String?
    @Published var authDenied = false

    override init() {
        super.init()
        setup()
    }

    private func setup() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:          configure()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted { self?.configure() } else { self?.authDenied = true }
                }
            }
        default:
            DispatchQueue.main.async { self.authDenied = true }
        }
    }

    private func configure() {
        session.beginConfiguration()
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            session.commitConfiguration(); return
        }
        session.addInput(input)
        let output = AVCaptureMetadataOutput()
        if session.canAddOutput(output) {
            session.addOutput(output)
            output.setMetadataObjectsDelegate(self, queue: .main)
            output.metadataObjectTypes = [.qr]
        }
        session.commitConfiguration()
        DispatchQueue.global(qos: .userInitiated).async { self.session.startRunning() }
    }

    func stop() { if session.isRunning { session.stopRunning() } }

    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput objects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        if let obj = objects.first as? AVMetadataMachineReadableCodeObject,
           let str = obj.stringValue {
            scannedCode = str
        }
    }
}

// MARK: - Viewfinder corner shape

private struct ViewfinderCorners: Shape {
    let cornerRadius: CGFloat
    let armLength: CGFloat

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let r = cornerRadius
        let a = armLength

        // Top-left
        p.move(to: CGPoint(x: rect.minX, y: rect.minY + a))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY + r))
        p.addQuadCurve(to: CGPoint(x: rect.minX + r, y: rect.minY),
                       control: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.minX + a, y: rect.minY))

        // Top-right
        p.move(to: CGPoint(x: rect.maxX - a, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX - r, y: rect.minY))
        p.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + r),
                       control: CGPoint(x: rect.maxX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + a))

        // Bottom-right
        p.move(to: CGPoint(x: rect.maxX, y: rect.maxY - a))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - r))
        p.addQuadCurve(to: CGPoint(x: rect.maxX - r, y: rect.maxY),
                       control: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.maxX - a, y: rect.maxY))

        // Bottom-left
        p.move(to: CGPoint(x: rect.minX + a, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX + r, y: rect.maxY))
        p.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY - r),
                       control: CGPoint(x: rect.minX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - a))

        return p
    }
}

// MARK: - Main scanner view

struct QRScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var scanner = ScannerSession()

    var body: some View {
        ZStack {
            // Full-bleed camera or dark fallback
            if scanner.authDenied {
                Color.black.ignoresSafeArea()
            } else {
                CameraPreview(session: scanner.session)
                    .ignoresSafeArea()
            }

            // Dimmed surround
            GeometryReader { geo in
                let size = min(geo.size.width, geo.size.height) * 0.68
                let cx = geo.size.width / 2
                let cy = geo.size.height * 0.44
                let box = CGRect(x: cx - size / 2, y: cy - size / 2, width: size, height: size)

                // Dark vignette outside viewfinder
                Rectangle()
                    .fill(Color.black.opacity(0.55))
                    .ignoresSafeArea()
                    .mask(
                        Rectangle()
                            .ignoresSafeArea()
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .frame(width: size, height: size)
                                    .position(x: cx, y: cy)
                                    .blendMode(.destinationOut)
                            )
                            .compositingGroup()
                    )

                // Corner brackets
                ViewfinderCorners(cornerRadius: 20, armLength: 36)
                    .stroke(Color.white, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .frame(width: size, height: size)
                    .position(x: cx, y: cy)

                // Label below viewfinder
                if scanner.authDenied {
                    Text("Camera access is required.\nPlease enable it in Settings.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .position(x: cx, y: box.maxY + 52)
                } else {
                    Text("Scan a crypto address or Lightning invoice")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 4)
                        .position(x: cx, y: box.maxY + 52)
                }
            }

            // Cancel button pinned to bottom
            VStack {
                Spacer()
                Button {
                    scanner.stop()
                    dismiss()
                } label: {
                    Text("Cancel")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            Capsule().fill(Color.white.opacity(0.18))
                        )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
        .onChange(of: scanner.scannedCode) { code in
            if code != nil {
                scanner.stop()
                dismiss()
            }
        }
    }
}
