import Foundation
import ImageIO
import CoreGraphics
let root=URL(fileURLWithPath:CommandLine.arguments[1],isDirectory:true).resolvingSymlinksInPath()
let upload=root.appendingPathComponent("upload")
let enumerator=FileManager.default.enumerator(at:upload,includingPropertiesForKeys:nil)!
func read(_ url:URL)->CGImage {
 guard let source=CGImageSourceCreateWithURL(url as CFURL,nil), let image=CGImageSourceCreateImageAtIndex(source,0,nil) else { FileHandle.standardError.write(Data(("Cannot decode "+url.path+"\n").utf8));exit(1) };return image
}
var count=0
for case let url as URL in enumerator where url.pathExtension=="png" {
 let relative=url.pathComponents.suffix(4).joined(separator: "/")
 let a=read(root.appendingPathComponent("originals/"+relative)), b=read(url)
 if a.width != b.width || a.height != b.height { FileHandle.standardError.write(Data(("Dimensions differ: "+relative+"\n").utf8));exit(1) }
 let aa=a.dataProvider!.data! as Data, bb=b.dataProvider!.data! as Data
 let aFirst=a.alphaInfo == .first || a.alphaInfo == .premultipliedFirst || a.alphaInfo == .noneSkipFirst
 let bFirst=b.alphaInfo == .first || b.alphaInfo == .premultipliedFirst || b.alphaInfo == .noneSkipFirst
 aa.withUnsafeBytes { ar in bb.withUnsafeBytes { br in
  let ap=ar.bindMemory(to:UInt8.self), bp=br.bindMemory(to:UInt8.self)
  for y in 0..<a.height { for x in 0..<a.width {
   let i=y*a.bytesPerRow+x*a.bitsPerPixel/8+(aFirst ? 1:0), j=y*b.bytesPerRow+x*b.bitsPerPixel/8+(bFirst ? 1:0)
   for c in 0..<3 { if ap[i+c] != bp[j+c] {
    let message="RGB mismatch: \(relative) at \(x),\(y) channel \(c): \(ap[i+c]) vs \(bp[j+c]); formats \(a.bitsPerPixel)/\(a.alphaInfo.rawValue) vs \(b.bitsPerPixel)/\(b.alphaInfo.rawValue)\n"
    FileHandle.standardError.write(Data(message.utf8));exit(1)
   } }
  } }
 } }
 count+=1
}
print("PASS: \(count) screenshots have exactly the same RGB pixels as their native simctl originals")
