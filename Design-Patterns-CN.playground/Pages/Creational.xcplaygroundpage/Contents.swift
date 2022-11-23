/*:

 创建型模式
 ========
 
 > 创建型模式是处理对象创建的设计模式，试图根据实际情况使用合适的方式创建对象。基本的对象创建方式可能会导致设计上的问题，或增加设计的复杂度。创建型模式通过以某种方式控制对象的创建来解决问题。
 >
 >**来源：** [维基百科](https://zh.wikipedia.org/wiki/%E5%89%B5%E5%BB%BA%E5%9E%8B%E6%A8%A1%E5%BC%8F)
 
## 目录

* [行为型模式](Behavioral)
* [创建型模式](Creational)
* [结构型模式](Structural)
*/
import Foundation
/*:
🌰 抽象工厂（Abstract Factory）
-------------

抽象工厂模式提供了一种方式，可以将一组具有同一主题的单独的工厂封装起来。在正常使用中，客户端程序需要创建抽象工厂的具体实现，然后使用抽象工厂作为接口来创建这一主题的具体对象。

### 示例：

协议
*/

protocol BurgerDescribing {
    var ingredients: [String] { get }
}

struct CheeseBurger: BurgerDescribing {
    let ingredients: [String]
}

protocol BurgerMaking {
    func make() -> BurgerDescribing
}

// 工厂方法实现

final class BigKahunaBurger: BurgerMaking {
    func make() -> BurgerDescribing {
        return CheeseBurger(ingredients: ["Cheese", "Burger", "Lettuce", "Tomato"])
    }
}

final class JackInTheBox: BurgerMaking {
    func make() -> BurgerDescribing {
        return CheeseBurger(ingredients: ["Cheese", "Burger", "Tomato", "Onions"])
    }
}

/*:
抽象工厂
*/

enum BurgerFactoryType: BurgerMaking {

    case bigKahuna
    case jackInTheBox

    func make() -> BurgerDescribing {
        switch self {
        case .bigKahuna:
            return BigKahunaBurger().make()
        case .jackInTheBox:
            return JackInTheBox().make()
        }
    }
}
/*:
### 用法
*/
let bigKahuna = BurgerFactoryType.bigKahuna.make()
let jackInTheBox = BurgerFactoryType.jackInTheBox.make()
/*:
👷 生成器（Builder）
--------------

一种对象构建模式。它可以将复杂对象的建造过程抽象出来（抽象类别），使这个抽象过程的不同实现方法可以构造出不同表现（属性）的对象。

### 示例：
*/
final class DeathStarBuilder {

    var x: Double?
    var y: Double?
    var z: Double?

    typealias BuilderClosure = (DeathStarBuilder) -> ()

    init(buildClosure: BuilderClosure) {
        buildClosure(self)
    }
}

struct DeathStar : CustomStringConvertible {

    let x: Double
    let y: Double
    let z: Double

    init?(builder: DeathStarBuilder) {

        if let x = builder.x, let y = builder.y, let z = builder.z {
            self.x = x
            self.y = y
            self.z = z
        } else {
            return nil
        }
    }

    var description:String {
        return "Death Star at (x:\(x) y:\(y) z:\(z))"
    }
}
/*:
### 用法
*/
let empire = DeathStarBuilder { builder in
    builder.x = 0.1
    builder.y = 0.2
    builder.z = 0.3
}

let deathStar = DeathStar(builder:empire)
/*:
🏭 工厂方法（Factory Method）
-----------------------

定义一个创建对象的接口，但让实现这个接口的类来决定实例化哪个类。工厂方法让类的实例化推迟到子类中进行。[维基百科](https://zh.wikipedia.org/wiki/%E5%B7%A5%E5%8E%82%E6%96%B9%E6%B3%95)

### 示例：
*/
protocol CurrencyDescribing {
    var symbol: String { get }
    var code: String { get }
}

final class Euro: CurrencyDescribing {
    var symbol: String {
        return "€"
    }
    
    var code: String {
        return "EUR"
    }
}

final class UnitedStatesDolar: CurrencyDescribing {
    var symbol: String {
        return "$"
    }
    
    var code: String {
        return "USD"
    }
}

enum Country {
    case unitedStates
    case spain
    case uk
    case greece
}

enum CurrencyFactory {
    static func currency(for country: Country) -> CurrencyDescribing? {

        switch country {
            case .spain, .greece:
                return Euro()
            case .unitedStates:
                return UnitedStatesDolar()
            default:
                return nil
        }
        
    }
}
/*:
### 用法
*/
let noCurrencyCode = "No Currency Code Available"

CurrencyFactory.currency(for: .greece)?.code ?? noCurrencyCode
CurrencyFactory.currency(for: .spain)?.code ?? noCurrencyCode
CurrencyFactory.currency(for: .unitedStates)?.code ?? noCurrencyCode
CurrencyFactory.currency(for: .uk)?.code ?? noCurrencyCode
/*:
 🔂 单态（Monostate）
 ------------

  单态模式是实现单一共享的另一种方法。不同于单例模式，它通过完全不同的机制，在不限制构造方法的情况下实现单一共享特性。
  因此，在这种情况下，单态会将状态保存为静态，而不是将整个实例保存为单例。
 [单例和单态 - Robert C. Martin](http://staff.cs.utu.fi/~jounsmed/doos_06/material/SingletonAndMonostate.pdf)

### 示例:
*/
class Settings {

    enum Theme {
        case `default`
        case old
        case new
    }

    private static var theme: Theme?

    var currentTheme: Theme {
        get { Settings.theme ?? .default }
        set(newTheme) { Settings.theme = newTheme }
    }
}

class SubSettings: Settings {
    
}
/*:
### 用法:
*/
import SwiftUI

// 改变主题
let settings = Settings() // 开始使用主题 .old
settings.currentTheme = .new // 改变主题为 .new

// 界面一
let screenColor: Color = Settings().currentTheme == .old ? .gray : .white

// 界面二
let screenTitle: String = Settings().currentTheme == .old ? "Itunes Connect" : "App Store Connect"

// 界面三
let screenTheme = SubSettings().currentTheme
//: ### 理解:
//: 可以看出MonoState并不限定实例的个数，但是这些实例（包括子类的实例）都共用同一个静态变量theme.这也是MonoState和Singleton的最大区别。
/*:
🃏 原型（Prototype）
--------------

通过“复制”一个已经存在的实例来返回新的实例,而不是新建实例。被复制的实例就是我们所称的“原型”，这个原型是可定制的。[维基百科](https://zh.wikipedia.org/wiki/%E5%8E%9F%E5%9E%8B%E6%A8%A1%E5%BC%8F)

### 示例：
*/
class MoonWorker {

    let name: String
    var health: Int = 100

    init(name: String, health: Int = 100) {
        self.name = name
        self.health = health
    }

    func clone() -> MoonWorker {
        return MoonWorker(name: name, health: health)
    }
}

class EarthWorker: NSObject, NSCopying {
    
    let name: String
    var health: Int = 100

    required init(name: String, health: Int = 100) {
        self.name = name
        self.health = health
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return EarthWorker(name: name, health: health)
    }
}

class ChinaWorker: EarthWorker {
    var height: Int = 170
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let clone = super.copy() as! ChinaWorker
        clone.height = height
        return clone
    }
}
/*:
### 用法
*/
let prototype = MoonWorker(name: "Sam Bell")

var bell1 = prototype.clone()
bell1.health = 12

var bell2 = prototype.clone()
bell2.health = 23

var bell3 = prototype.clone()
bell3.health = 0

let person = ChinaWorker(name: "Man")

var man1 = person.copy() as! ChinaWorker
man1.health = 12
/*:
 ### 理解:
 原型模式多用于创建复杂的或者耗时的实例，因为这种情况下，复制一个已经存在的实例使程序运行更高效；或者创建值相等，只是命名不一样的同类数据。
 */

/*:
💍 单例（Singleton）
--------------

单例对象的类必须保证只有一个实例存在。许多时候整个系统只需要拥有一个的全局对象，这样有利于我们协调系统整体的行为。[维基百科](https://zh.wikipedia.org/wiki/%E5%8D%95%E4%BE%8B%E6%A8%A1%E5%BC%8F)

### 示例：
*/
//final可以声明类、属性、方法和下标。
//final声明的类不能被继承，final声明的属性、方法和下标不能被重写。
final class ElonMusk {

    static let shared = ElonMusk()

    private init() {
        // Private initialization to ensure just one instance is created.
    }
}
/*:
### 用法
*/
let elon = ElonMusk.shared // There is only one Elon Musk folks.
/*:
 ### 理解:
 实现单例模式的思路是：一个类能返回对象一个引用（永远是同一个）和一个获得该实例的方法（必须是静态方法，通常使用getInstance这个名称）；当我们调用这个方法时，如果类持有的引用不为空就返回这个引用，如果类保持的引用为空就创建该类的实例并将实例的引用赋予该类保持的引用；同时我们还将该类的构造函数定义为私有方法，这样其他处的代码就无法通过调用该类的构造函数来实例化该类的对象，只有通过该类提供的静态方法来得到该类的唯一实例。
 
 单例模式在多线程的应用场合下必须小心使用。如果当唯一实例尚未创建时，有两个线程同时调用创建方法，那么它们同时没有检测到唯一实例的存在，从而同时各自创建了一个实例，这样就有两个实例被构造出来，从而违反了单例模式中实例唯一的原则。 解决这个问题的办法是为指示类是否已经实例化的变量提供一个互斥锁（虽然这样会降低效率）。
 */
