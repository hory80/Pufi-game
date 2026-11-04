import Foundation
import ImageIO
import CoreGraphics

// Strip an entirely opaque alpha channel without resampling or changing RGB values.
// Preserve the original simctl PNG next to the original recordings.
let root = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true).resolvingSymlinksInPath()
let manager = FileManager.default
let upload = root.appendingPathComponent("upload")
let files = manager.enumerator(at: upload, includingPropertiesForKeys: nil)!
var count = 0
for case let url as URL in files where url.pathExtension == "png" && !url.lastPathComponent.hasSuffix(".tmp.png") {
    let currentSource = CGImageSourceCreateWithURL(url as CFURL, nil)!
    let currentProperties = CGImageSourceCopyPropertiesAtIndex(currentSource, 0, nil)! as NSDictionary
    let relative = url.pathComponents.suffix(4).joined(separator: "/")
    let original = root.appendingPathComponent("originals").appendingPathComponent(relative)
    try manager.createDirectory(at: original.deletingLastPathComponent(), withIntermediateDirectories: true)
    if (currentProperties[kCGImagePropertyHasAlpha] as? Bool) != true {
        if !manager.fileExists(atPath: original.path) {
            try Data(contentsOf: url).write(to: original, options: .atomic)
        }
        continue
    }
    try Data(contentsOf: url).write(to: original, options: .atomic)
    let source = CGImageSourceCreateWithURL(original as CFURL, nil)!
    let image = CGImageSourceCreateImageAtIndex(source, 0, nil)!
    guard image.bitsPerComponent == 8, image.bitsPerPixel == 32,
          let bytes = image.dataProvider?.data else { fatalError("Unexpected simulator PNG format: \(url.path)") }
    let data = bytes as Data
    let alpha = image.alphaInfo
    let first = alpha == .first || alpha == .premultipliedFirst
    guard first || alpha == .last || alpha == .premultipliedLast else { fatalError("Unexpected alpha layout") }
    let offset = first ? 0 : 3
    for y in 0..<image.height {
        for x in 0..<image.width {
            precondition(data[y * image.bytesPerRow + x * 4 + offset] == 255, "Transparent pixel: cannot losslessly strip alpha")
        }
    }
    let flags = CGBitmapInfo(rawValue: (image.bitmapInfo.rawValue & ~CGBitmapInfo.alphaInfoMask.rawValue) |
        (first ? CGImageAlphaInfo.noneSkipFirst.rawValue : CGImageAlphaInfo.noneSkipLast.rawValue))
    let opaque = CGImage(width: image.width, height: image.height,
        bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: image.bytesPerRow,
        space: image.colorSpace!, bitmapInfo: flags, provider: image.dataProvider!,
        decode: image.decode, shouldInterpolate: false, intent: image.renderingIntent)!
    let temp = url.deletingPathExtension().appendingPathExtension("tmp.png")
    let encoded = NSMutableData()
    let destination = CGImageDestinationCreateWithData(encoded, "public.png" as CFString, 1, nil)!
    CGImageDestinationAddImage(destination, opaque, nil)
    precondition(CGImageDestinationFinalize(destination))
    try (encoded as Data).write(to: temp, options: .atomic)
    let checkSource = CGImageSourceCreateWithURL(temp as CFURL, nil)!
    let properties = CGImageSourceCopyPropertiesAtIndex(checkSource, 0, nil)! as NSDictionary
    precondition((properties[kCGImagePropertyHasAlpha] as? Bool) != true)
    _ = try manager.replaceItemAt(url, withItemAt: temp)
    count += 1
}
print("\(count) simulator PNG files exported without alpha; originals preserved")
