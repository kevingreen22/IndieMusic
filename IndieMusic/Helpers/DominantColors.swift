import Foundation
import UIKit
import SwiftUI



struct DominantColors {
    
    static func getDominantColors(image: UIImage) -> (UIColor, UIColor) {
        let smallImage = image.resized(to: CGSize(width: 100, height: 100))
        let kMeans = KMeansClusterer()
        let points = smallImage.getPixels().map({KMeansClusterer.Point(from: $0)})
        let clusters = kMeans.cluster(points: points, into: 3).sorted(by: {$0.points.count > $1.points.count})
        let colors = clusters.map(({$0.center.toUIColor()}))
        guard let mainColor = colors.first else { return (UIColor.gray, UIColor.black) }
        let secondaryColor = self.makeSecondaryColor(from: mainColor)
        
        return (mainColor, secondaryColor)
    }
    
    private static func makeSecondaryColor(from color : UIColor) -> UIColor {
        return color.hslColor.shiftHue(by: 0.5).shiftSaturation(by: -0.5).shiftBrightness(by: 0.5).uiColor
    }
    
}
    

class KMeansClusterer {
    
    func cluster(points : [Point], into k : Int) -> [Cluster] {
        var clusters = [Cluster]()
        for _ in 0 ..< k {
            var p = points.randomElement()
            while p == nil || clusters.contains(where: {$0.center == p}) {
                p = points.randomElement()
            }
            clusters.append(Cluster(center: p!))
        }
        
        for i in 0 ..< 10 {
            clusters.forEach {
                $0.points.removeAll()
            }
            for p in points {
                let closest = findClosest(for: p, from: clusters)
                closest.points.append(p)
            }
            var converged = true
            clusters.forEach {
                let oldCenter = $0.center
                $0.updateCenter()
                if oldCenter.distanceSquared(to: $0.center) > 0.001 {
                    converged = false
                }
            }
            if converged {
                print("Converged. Took \(i) iterations")
                break;
            }
        }
        return clusters
    }
    
    private func findClosest(for p : Point, from clusters: [Cluster]) -> Cluster {
        return clusters.min(by: {$0.center.distanceSquared(to: p) < $1.center.distanceSquared(to: p)})!
    }
}


extension KMeansClusterer {
    
    class Cluster {
        var points = [Point]()
        var center : Point
        
        init(center : Point) {
            self.center = center
        }
        
        func calculateCurrentCenter() -> Point {
            if points.isEmpty {
                return Point.zero
            }
            return points.reduce(Point.zero, +) / points.count
        }
        
        func updateCenter() {
            if points.isEmpty {
                return
            }
            let currentCenter = calculateCurrentCenter()
            center = points.min(by: {$0.distanceSquared(to: currentCenter) < $1.distanceSquared(to: currentCenter)})!
        }
    }
    
    struct Point : Equatable {
        let x : CGFloat
        let y : CGFloat
        let z : CGFloat
        
        init(_ x: CGFloat, _ y : CGFloat, _ z : CGFloat) {
            self.x = x
            self.y = y
            self.z = z
        }
        
        init(from color : UIColor) {
            var r : CGFloat = 0
            var g : CGFloat = 0
            var b : CGFloat = 0
            var a : CGFloat = 0
            
            if color.getRed(&r, green: &g, blue: &b, alpha: &a) {
                x = r
                y = g
                z = b
            } else {
                x = 0
                y = 0
                z = 0
            }
        }
        
        static let zero = Point(0, 0, 0)
        
        static func == (lhs: Point, rhs: Point) -> Bool {
            return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
        }
        
        static func +(lhs : Point, rhs : Point) -> Point {
            return Point(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
        }
        
        static func /(lhs : Point, rhs : CGFloat) -> Point {
            return Point(lhs.x / rhs, lhs.y / rhs, lhs.z / rhs)
        }
        
        static func /(lhs : Point, rhs : Int) -> Point {
            return lhs / CGFloat(rhs)
        }
        
        func distanceSquared(to p : Point) -> CGFloat {
            return (self.x - p.x) * (self.x - p.x)
                + (self.y - p.y) * (self.y - p.y)
                + (self.z - p.z) * (self.z - p.z)
        }
        
        func toUIColor() -> UIColor {
            return UIColor(red: x, green: y, blue: z, alpha: 1)
        }
        
    }
}







extension UIColor {
    convenience init(from hsl : HSLColor) {
        self.init(hue: hsl.hue, saturation: hsl.saturation, brightness: hsl.brightness, alpha: hsl.alpha)
    }
    var hslColor: HSLColor {
        get {
            return HSLColor(from: self)
        }
    }
}

struct HSLColor {
    let hue, saturation, brightness, alpha : CGFloat
    init(hue : CGFloat, saturation : CGFloat, brightness : CGFloat, alpha : CGFloat = 1) {
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.alpha = alpha
    }
    init(from color : UIColor) {
        var h : CGFloat = 0
        var s : CGFloat = 0
        var b : CGFloat = 0
        var a : CGFloat = 0
        if color.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            hue = h
            saturation = s
            brightness = b
            alpha = a
        } else {
            hue = 0
            saturation = 0
            brightness = 0
            alpha = 1
        }
    }
    var uiColor : UIColor {
        get {
            return UIColor(from: self)
        }
    }
    
    func shiftHue(by amount : CGFloat) -> HSLColor {
        return HSLColor(hue: shift(hue, by: amount), saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    func shiftBrightness(by amount : CGFloat) -> HSLColor {
        return HSLColor(hue: hue, saturation: saturation, brightness: shift(brightness, by: amount), alpha: alpha)
    }
    
    func shiftSaturation(by amount : CGFloat) -> HSLColor {
        return HSLColor(hue: hue, saturation: shift(saturation, by: amount), brightness: brightness, alpha: alpha)
    }
    
    private func shift(_ value : CGFloat, by amount : CGFloat) -> CGFloat {
        return abs((value + amount).truncatingRemainder(dividingBy: 1))
    }
    
}





extension UIImage {

    func resized(to size : CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        //disable HDR:
        format.preferredRange = .standard
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        let result = renderer.image { (context) in
            self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        }
        return result
    }
    
    func getPixels() -> [UIColor] {
        guard let cgImage = self.cgImage else {
            return []
        }
        assert(cgImage.bitsPerPixel == 32, "only support 32 bit images")
        assert(cgImage.bitsPerComponent == 8,  "only support 8 bit per channel")
        guard let imageData = cgImage.dataProvider?.data as Data? else {
            return []
        }
        let size = cgImage.width * cgImage.height
        let buffer = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: size)
        _ = imageData.copyBytes(to: buffer)
        var result = [UIColor]()
        result.reserveCapacity(size)
        for pixel in buffer {
            var r : UInt32 = 0
            var g : UInt32 = 0
            var b : UInt32 = 0
            if cgImage.byteOrderInfo == .orderDefault || cgImage.byteOrderInfo == .order32Big {
                r = pixel & 255
                g = (pixel >> 8) & 255
                b = (pixel >> 16) & 255
            } else if cgImage.byteOrderInfo == .order32Little {
                r = (pixel >> 16) & 255
                g = (pixel >> 8) & 255
                b = pixel & 255
            }
            let color = UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
            result.append(color)
        }
        return result
    }

}
