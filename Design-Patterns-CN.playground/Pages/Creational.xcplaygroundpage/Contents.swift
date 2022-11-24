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

抽象工厂模式提供了一种方式，可以将一组具有同一主题的单独的工厂封装起来。在正常使用中，客户端程序需要创建抽象工厂的具体实现，然后使用抽象工厂作为接口来创建这一主题的具体对象。[维基百科](https://zh.wikipedia.org/wiki/%E6%8A%BD%E8%B1%A1%E5%B7%A5%E5%8E%82)

### 示例：

协议
*/
// 1
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
// 2
protocol ProductsA {// 五菱宏光车
    func doSomething()
}

protocol ProductsB {// 比亚迪车
    func doSomething()
}

protocol ProductsFactory { // 车厂
    func creatA() -> ProductsA
    func creatB() -> ProductsB
}

class ProductA1: ProductsA {// 五菱mini
    func doSomething() {
        print("ProductA1")
    }
}

class ProductA2: ProductsA {// 五菱面包
    func doSomething() {
        print("ProductA2")
    }
}

class ProductB1: ProductsB {// 比亚迪mini
    func doSomething() {
        print("ProductB1")
    }
}

class ProductB2: ProductsB {// 比亚迪面包
    func doSomething() {
        print("ProductB2")
    }
}

class Product1Factory: ProductsFactory {// mini车厂
    func creatA() -> ProductsA {
        return ProductA1()
    }
    
    func creatB() -> ProductsB {
        return ProductB1()
    }
}

class Product2Factory: ProductsFactory {// 面包车车厂
    func creatA() -> ProductsA {
        return ProductA2()
    }
    
    func creatB() -> ProductsB {
        return ProductB2()
    }
}

// 3
import UIKit

protocol ShowManager {
    func show() -> UIView
    func showScroll() -> UIScrollView
}

class ShareV: UIView {
    
}

class CardV: UIView {
    
}

class ShareScrollV: UIScrollView {
    
}

class CardScrollV: UIScrollView {
    
}

class ShareVManager: ShowManager {
    func showScroll() -> UIScrollView {
        let view = ShareScrollV()
        //...
        return view
    }
    
    func show() -> UIView {
        let view = ShareView()
        //...
        return view
    }
}

class CardVManager: ShowManager {
    func showScroll() -> UIScrollView {
        let view = CardScrollV()
        //...
        return view
    }
    
    func show() -> UIView {
        let view = CardView()
        //...
        return view
    }
}
/*:
### 用法
*/
// 1
let bigKahuna = BurgerFactoryType.bigKahuna.make()
let jackInTheBox = BurgerFactoryType.jackInTheBox.make()

// 2
Product1Factory().creatA().doSomething()
Product2Factory().creatB().doSomething()

// 3
let shareV = ShareVManager().show()
//UIApplication.shared.keyWindow?.addSubview(shareV)
let shareScrollV = ShareVManager().showScroll()
shareScrollV.scrollsToTop = true
//UIApplication.shared.keyWindow?.addSubview(shareScrollV)

/*:
 ### 理解:
 ![](AbstractFactory.gif)
 抽象工厂模式提供了一种方式，可以将一组具有同一主题的单独的工厂封装起来。
 
 普通工厂中，根据产品类型分为ProductA、ProductB和ProductC。但是如果有多种分类方式，比如按照产品的生产商分类，ProductA可能和ProductC为一类。这样就用到了抽象工厂模式
 */

/*:
👷 生成器（Builder）
--------------

一种对象构建模式。它可以将复杂对象的建造过程抽象出来（抽象类别），使这个抽象过程的不同实现方法可以构造出不同表现（属性）的对象。

### 示例：
*/
// 1
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

// 2


class Car {
    var part1 = 0
    var part2 = 0
    var part3 = 0
}

protocol ProductBuilder {
    func build1()
    func build2()
    func build3()
    func getProduct() -> Car
}

class Director {
    var builder: ProductBuilder?
    
    init(builder: ProductBuilder) {
        self.builder = builder
    }
    
    func construct() {
        builder?.build1()
        builder?.build2()
        builder?.build3()
    }
}

class ProductABuilder: ProductBuilder {
    private let car = Car()
    func getProduct() -> Car {
        return car
    }
    
    func build1() {
        car.part1 = 1
    }
    
    func build2() {
        car.part1 = 2
    }
    
    func build3() {
        car.part1 = 3
    }
    
}

class ProductBBuilder: ProductBuilder {
    private let car = Car()
    func getProduct() -> Car {
        return car
    }
    
    func build1() {
        car.part1 = 4
    }
    
    func build2() {
        car.part1 = 5
    }
    
    func build3() {
        car.part1 = 6
    }
}

/*:
### 用法
*/
// 1
let empire = DeathStarBuilder { builder in
    builder.x = 0.1
    builder.y = 0.2
    builder.z = 0.3
}

let deathStar = DeathStar(builder:empire)

// 2
let builderA = ProductABuilder()
let diretorA = Director(builder: builderA)
diretorA.construct()
let product = builderA.getProduct()
/*:
 ### 理解:
 ![](Builder.gif)
 抽象工厂模式与生成器相似，因为它也可以创建复杂对象。主要的区别是生成器模式着重于一步步构造一个复杂对象。而抽象工厂模式着重于多个系列的产品对象（简单的或是复杂的）。生成器在最后的一步返回产品，而对于抽象工厂来说，产品是立即返回的。
 */
/*:
🏭 工厂方法（Factory Method）
-----------------------

定义一个创建对象的接口，但让实现这个接口的类来决定实例化哪个类。工厂方法让类的实例化推迟到子类中进行。[维基百科](https://zh.wikipedia.org/wiki/%E5%B7%A5%E5%8E%82%E6%96%B9%E6%B3%95)

### 示例：
*/
// 1
protocol Product {// 车
    func doSomething()
}

protocol ProductFactory {// 车厂
    func creat() -> Product
}

class ProductA: Product {
    func doSomething() {// mini
        print("ProductA")
    }
}

class ProductB: Product {// 面包车
    func doSomething() {
        print("ProductB")
    }
}

class ProductAFactory: ProductFactory {
    func creat() -> Product {// mini车厂
        return ProductA()
    }
}

class ProductBFactory: ProductFactory {
    func creat() -> Product {// 面包车车厂
        return ProductB()
    }
}


// 2
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

// 3
import UIKit

protocol ShowViewManager {
    func show() -> UIView
}

class ShareView: UIView {
    
}

class CardView: UIView {
    
}

class ShareViewManager: ShowViewManager {
    func show() -> UIView {
        let view = ShareView()
        //...
        return view
    }
}

class CardViewManager: ShowViewManager {
    func show() -> UIView {
        let view = CardView()
        //...
        return view
    }
}
/*:
### 用法
*/
// 1
let factory1 = ProductAFactory()
let product1 = factory1.creat()
product1.doSomething()

let factory2 = ProductBFactory()
let product2 = factory2.creat()
product2.doSomething()

// 2
let noCurrencyCode = "No Currency Code Available"

CurrencyFactory.currency(for: .greece)?.code ?? noCurrencyCode
CurrencyFactory.currency(for: .spain)?.code ?? noCurrencyCode
CurrencyFactory.currency(for: .unitedStates)?.code ?? noCurrencyCode
CurrencyFactory.currency(for: .uk)?.code ?? noCurrencyCode

// 3
let shareManager = ShareViewManager()
let shareView = shareManager.show()
//UIApplication.shared.keyWindow?.addSubview(shareView)

let cardManager = ShareViewManager()
let cardView = cardManager.show()
//UIApplication.shared.keyWindow?.addSubview(cardView)
/*:
 ### 理解:
 - 创建对象需要大量重复的代码。可以把这些代码写在工厂基类中。
 - 创建对象需要访问某些信息，而这些信息不应该包含在复合类中。
 - 创建对象的生命周期必须集中管理，以保证在整个程序中具有一致的行为。 对象创建时会有很多参数来决定如何创建出这个对象。
 - 创建对象可能是一个pool里的，不是每次都凭空创建一个新的。而pool的大小等参数可以用另外的逻辑去控制。比如连接池对象，线程池对象
 - 简化一些常规的创建过程。根据配置去创建一个对象也很复杂；但可能95%的情况只创建某个特定类型的对象。这时可以弄个函数直接省略那些配置过程。如Java的线程池的相关创建api（如Executors.newFixedThreadPool等）
 - 创建一个对象有复杂的依赖关系，比如Foo对象的创建依赖A，A又依赖B，B又依赖C……。于是创建过程是一组对象的的创建和注入。
 - 知道怎么创建一个对象，但是无法把控创建的时机。需要把“如何创建”的代码塞给“负责决定什么时候创建”的代码。后者在适当的时机，回调执行创建对象的函数。
 
 */
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
//TODO: 优化子类复制父类属性
class EarthWorker: NSObject, NSCopying {
    
    let name: String
    var health: Int = 100

    init(name: String, health: Int = 100) {
        self.name = name
        self.health = health
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return EarthWorker(name: name, health: health)
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

let person = EarthWorker(name: "Man")

var man1 = person.copy() as! EarthWorker
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
