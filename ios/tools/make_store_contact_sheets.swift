import AppKit
import ImageIO
let root=URL(fileURLWithPath:CommandLine.arguments[1],isDirectory:true).resolvingSymlinksInPath()
let languages=["ro","de","en","fr","it","es","pt","nl","pl","hu","uk","ru"]
func image(_ url:URL)->CGImage { CGImageSourceCreateImageAtIndex(CGImageSourceCreateWithURL(url as CFURL,nil)!,0,nil)! }
func save(_ context:CGContext,_ url:URL) throws {
 let data=NSMutableData();let d=CGImageDestinationCreateWithData(data,"public.jpeg" as CFString,1,nil)!
 CGImageDestinationAddImage(d,context.makeImage()!,[kCGImageDestinationLossyCompressionQuality:0.88] as CFDictionary)
 precondition(CGImageDestinationFinalize(d));try (data as Data).write(to:url,options:.atomic)
}
func context(_ w:Int,_ h:Int)->CGContext {
 let c=CGContext(data:nil,width:w,height:h,bitsPerComponent:8,bytesPerRow:0,space:CGColorSpace(name:CGColorSpace.sRGB)!,bitmapInfo:CGImageAlphaInfo.noneSkipLast.rawValue)!
 c.setFillColor(CGColor(gray:0.94,alpha:1));c.fill(CGRect(x:0,y:0,width:w,height:h));return c
}
func label(_ text:String,_ x:Int,_ y:Int,_ c:CGContext) {
 NSGraphicsContext.saveGraphicsState();NSGraphicsContext.current=NSGraphicsContext(cgContext:c,flipped:false)
 (text as NSString).draw(at:NSPoint(x:x,y:y),withAttributes:[.font:NSFont.systemFont(ofSize:18,weight:.semibold),.foregroundColor:NSColor.black])
 NSGraphicsContext.restoreGraphicsState()
}
let fm=FileManager.default;let review=root.appendingPathComponent("review");try fm.createDirectory(at:review,withIntermediateDirectories:true)
for lang in languages {
 let c=context(1800,1460)
 for family in ["iphone","ipad"] {
  let base=root.appendingPathComponent("upload/\(lang)/\(family)/screenshots")
  let urls=try fm.contentsOfDirectory(at:base,includingPropertiesForKeys:nil).filter{$0.pathExtension=="png"}.sorted{$0.lastPathComponent<$1.lastPathComponent}
  let w=family=="iphone" ? 180 : 390, h=family=="iphone" ? 391 : 292, x0=family=="iphone" ? 0 : 600
  label("\(lang) — \(family)",x0+8,1425,c)
  for (i,url) in urls.enumerated() {
   let x=x0+(i%3)*(w+6), y=1400-(i/3)*(h+50)-h
   c.draw(image(url),in:CGRect(x:x,y:y,width:w,height:h));label(url.deletingPathExtension().lastPathComponent,x,y-25,c)
  }
 }
 try save(c,review.appendingPathComponent("\(lang)-screenshots.jpg"))
 let v=context(1800,1300)
 for family in ["iphone","ipad"] {
  let base=review.appendingPathComponent("frames/\(lang)/\(family)/previews")
  let urls=(try? fm.contentsOfDirectory(at:base,includingPropertiesForKeys:nil))?.filter{$0.pathExtension=="jpg"}.sorted{$0.lastPathComponent<$1.lastPathComponent} ?? []
  let w=family=="iphone" ? 552 : 1200, h=family=="iphone" ? 400 : 300, x=family=="iphone" ? 0 : 590
  label("\(lang) — \(family): 5s, 15s, 25s",x+6,1270,v)
  for(i,url) in urls.enumerated(){v.draw(image(url),in:CGRect(x:x,y:1250-(i+1)*(h+10),width:w,height:h))}
 }
 try save(v,review.appendingPathComponent("\(lang)-previews.jpg"))
}
print("24 review sheets written (not for upload)")
