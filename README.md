<h1 align="center">
  <br>
  <img src="Glimpse/Assets.xcassets/AppIcon.appiconset/appicon.png" alt="Glimpse" width="150">
  <br>
  Glimpse
  <br>
</h1>

<h3 align="center">A tiny mirror for your Mac</h3>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-15%2B-black.svg" alt="macOS 15+">
  <img src="https://img.shields.io/badge/Swift-SwiftUI-black.svg" alt="Swift & SwiftUI">
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-black.svg" alt="MIT License">
  </a>
</p>

<p align="center">
  Glimpse is a tiny, native macOS mirror that lives in your menu bar.
  <br>
  Open it with one click, see yourself, and get on with your day.
</p>

<p align="center">
  <img
    src="https://github.com/user-attachments/assets/YOUR-SCREENSHOT-ID"
    alt="Glimpse preview"
    width="700"
  >
</p>

---

## Features

| Feature | Description |
|---|---|
| **Instant mirror** | See yourself with one click. |
| **Built-in camera** | Uses your Mac's built-in camera. |
| **Mirrored preview** | Flips the camera horizontally, just like a physical mirror. |
| **Menu Bar utility** | Lives quietly in your Menu Bar without cluttering your Dock. |
| **Native macOS app** | Built entirely with SwiftUI and AVFoundation. |
| **Click outside to close** | The mirror disappears when you're done. |
| **Private by design** | Camera frames are processed locally and are never uploaded. |
| **Lightweight** | No accounts, servers, subscriptions, or unnecessary background services. |

## How it works

1. **Open**

   Click the Glimpse icon in your Menu Bar.

2. **Look**

   A live preview from your Mac's camera appears instantly.

3. **See yourself**

   The preview is horizontally mirrored so it behaves like a physical mirror.

4. **Close**

   Click anywhere outside the mirror to dismiss it.

That's it.

No setup. No account. No browser tab.

Just a quick glimpse.

---

## Installation

### Requirements

- macOS 15 Sequoia or later
- Apple Silicon or Intel Mac
- A built-in or connected camera

### Download

> Releases will be available here once the first version is published.

<p align="center">
  <a href="https://github.com/YOUR_USERNAME/glimpse/releases/latest">
    <img
      width="200"
      src="https://img.shields.io/badge/Download%20for%20Mac-000000?style=for-the-badge&logo=apple&logoColor=white"
      alt="Download for Mac"
    >
  </a>
</p>

Download the latest `.dmg`, open it, and drag **Glimpse** to `/Applications`.

Then launch Glimpse and look for its icon in your Menu Bar.

---

## Permissions

Glimpse only requests the permissions it needs.

| Permission | Why |
|---|---|
| **Camera** | Required to display your live mirror preview. |

Camera frames are used only to display the live preview.

Glimpse does not intentionally upload camera frames to a server or store them on disk.

---

## Privacy

Glimpse is designed to be local-first.

### Camera

Your camera feed stays on your Mac.

The live camera stream is captured using Apple's **AVFoundation** framework and displayed directly in the app.

Glimpse does not require:

- An account
- Cloud storage
- A remote server
- Internet access for the mirror itself

### No image storage

Glimpse does not intentionally save camera frames or photographs to disk.

The camera exists only for the live mirror experience.

### No tracking

Glimpse does not need analytics or tracking to provide its core functionality.

---

## Technology

Glimpse is intentionally built using Apple's native frameworks.

- **Swift**
- **SwiftUI**
- **AVFoundation**
- **AppKit**
- **Core Image** *(optional / future use)*

The app uses `MenuBarExtra` to provide a native Menu Bar experience and `AVCaptureSession` for camera capture.

No Electron.

No web wrapper.

No third-party UI framework.

Just a small native Mac app.

---

## Architecture

```text
Glimpse/
├── GlimpseApp.swift
│
├── Camera/
│   ├── CameraManager.swift
│   └── CameraPreview.swift
│
├── Views/
│   └── MirrorView.swift
│
├── Models/
│   └── CameraState.swift
│
└── Assets/
    └── Assets.xcassets