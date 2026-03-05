//
//  CameraPreview.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 21/12/2568 BE.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {

    @Binding var isActive: Bool
    @Binding var capturedImage: UIImage?   // ✅ เพิ่ม
    var shouldCapture: Bool = false        // ✅ trigger capture
    var scanMode: Bool = false
    var onScan: ((String) -> Void)? = nil

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate, AVCapturePhotoCaptureDelegate {
        let session = AVCaptureSession()
        let photoOutput = AVCapturePhotoOutput()  // ✅ เพิ่ม
        var onScan: ((String) -> Void)?
        var isScanning = true
        var onCapture: ((UIImage) -> Void)?       // ✅ เพิ่ม

        init(onScan: ((String) -> Void)?) {
            self.onScan = onScan
        }

        // ✅ delegate รับภาพที่ถ่าย
        func photoOutput(_ output: AVCapturePhotoOutput,
                         didFinishProcessingPhoto photo: AVCapturePhoto,
                         error: Error?) {
            guard error == nil,
                  let data = photo.fileDataRepresentation(),
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.onCapture?(image)
            }
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput,
                            didOutput metadataObjects: [AVMetadataObject],
                            from connection: AVCaptureConnection) {
            guard isScanning,
                  let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
                  let stringValue = metadataObject.stringValue else { return }
            isScanning = false
            onScan?(stringValue)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onScan: onScan)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let session = context.coordinator.session
        session.sessionPreset = .high

        guard
            let device = AVCaptureDevice.default(for: .video),
            let input = try? AVCaptureDeviceInput(device: device),
            session.canAddInput(input)
        else { return view }

        session.addInput(input)

        // ✅ เพิ่ม photoOutput เสมอ (ยกเว้น scanMode)
        if !scanMode {
            if session.canAddOutput(context.coordinator.photoOutput) {
                session.addOutput(context.coordinator.photoOutput)
            }
        }

        if scanMode {
            let metadataOutput = AVCaptureMetadataOutput()
            if session.canAddOutput(metadataOutput) {
                session.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: .main)
                metadataOutput.metadataObjectTypes = [.qr]
            }
        }

        // ✅ รับภาพแล้วใส่ binding
        context.coordinator.onCapture = { image in
            capturedImage = image
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(previewLayer)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        let session = context.coordinator.session

        if isActive {
            if !session.isRunning {
                DispatchQueue.global(qos: .userInitiated).async {
                    session.startRunning()
                }
            }
        } else {
            if session.isRunning { session.stopRunning() }
        }

        // ✅ ถ้า shouldCapture == true → ถ่ายภาพ
        if shouldCapture && session.isRunning {
            let settings = AVCapturePhotoSettings()
            context.coordinator.photoOutput.capturePhoto(with: settings,
                                                          delegate: context.coordinator)
        }
    }
}
