# Default 3D Models Folder (Offline Assets)

Letakkan file aset 3D offline bawaan aplikasi di folder ini:

1. **Untuk Spline 3D:**
   - File berekstensi `.splineswift` (contoh: `miniroom.splineswift`).
   - Diunduh dari Spline Editor: `Export > iOS > Download .splineswift`.

2. **Untuk RealityKit:**
   - File berekstensi `.usdz` (contoh: `vintage_watch.usdz`).
   - Diunduh dari Spline Editor (`Export > 3D Model > USDZ`) atau Apple AR Gallery.

> **Penting di Xcode:**
> Pastikan saat memasukkan file ke dalam project Xcode, centang **"Add to targets: PocketCurator"** agar file masuk ke dalam **App Bundle** utama dan bisa diakses saat perangkat offline tanpa internet.
