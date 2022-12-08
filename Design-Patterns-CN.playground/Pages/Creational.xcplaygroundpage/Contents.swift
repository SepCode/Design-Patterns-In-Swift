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

 提供一个创建一系列相关或相互依赖对象的接口，而无需指定它们具体的类。
 
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
protocol ProductsA {// 键盘
    func doSomething()
}

protocol ProductsB {// 显示器
    func doSomething()
}

protocol ProductsFactory { // 电脑
    func creatA() -> ProductsA // 键盘
    func creatB() -> ProductsB // 显示器
}

class ProductA1: ProductsA {// 联想键盘
    func doSomething() {
        print("ProductA1")
    }
}

class ProductA2: ProductsA {// 苹果键盘
    func doSomething() {
        print("ProductA2")
    }
}

class ProductB1: ProductsB {// 联想显示器
    func doSomething() {
        print("ProductB1")
    }
}

class ProductB2: ProductsB {// 苹果显示器
    func doSomething() {
        print("ProductB2")
    }
}

class Product1Factory: ProductsFactory {// 联想
    func creatA() -> ProductsA {
        return ProductA1()
    }
    
    func creatB() -> ProductsB {
        return ProductB1()
    }
}

class Product2Factory: ProductsFactory {// 苹果
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
 ![](abstract.png)
 
 ![](AbstractFactory.png)
 
 AbstractFactory模式有下面的一些优点和缺点:
 
 1)它分离了具体的类。 AbstractFactory模式帮助你控制一个应用创建的对象的类。因为
 一个工厂封装创建产品对象的责任和过程，它将客户与类的实现分离。客户通过它们的抽象接口操纵实例。产品的类名也在具体工厂的实现中被分离;它们不出现在客户代码中。
 
 2)它使得易于交换产品系列。 一个具体工厂类在一个应用中仅出现一次—即在它初始化的时候。这使得改变一个应用的具体工厂变得很容易。它只需改变具体的工厂即可使用不同的产品配置，这是因为一个抽象工厂创建了一个完整的产品系列，所以整个产品系列会立刻改变。在我们的用户界面的例子中，我们仅需转换到相应的工厂对象并重新创建接口，就可实现从Motif窗口组件转换为PresentationManager窗口组件。
 
 3)它有利于产品的一致性。 当一个系列中的产品对象被设计成一起工作时，一个应用一次只能使用同一个系列中的对象，这一点很重要。而AbstractFactory很容易实现这一点。
 
 4)难以支持新种类的产品。 难以扩展抽象工厂以生产新种类的产品。这是因为
 AbstractFactory接口确定了可以被创建的产品集合。支持新种类的产品就需要扩展该工厂接口，这将涉及AbstractFactory类及其所有子类的改变。我们会在实现一节讨论这个问题的一个解决办法。
 */

/*:
👷 生成器（Builder）
--------------

 将一个复杂对象的构建与它的表示分离，使得同样的构建过程可以创建不同的表示。

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
 ![](builder.png)
 
 ![](builder2.png)
 
 ![](builder1.png)
 
 1)它使你可以改变一个产品的内部表示。 Builder对象提供给导向器一个构造产品的抽象接口。该接口使得生成器可以隐藏这个产品的表示和内部结构。它同时也隐藏了该产品是如何装配的。因为产品是通过抽象接口构造的，你在改变该产品的内部表示时所要做的只是定义一个新的生成器。
 
 2)它将构造代码和表示代码分开。 Builder模式通过封装一个复杂对象的创建和表示方式提高了对象的模块性。客户不需要知道定义产品内部结构的类的所有信息;这些类是不出现在Builder接口中的。每个ConcreteBuilder包含了创建和装配一个特定产品的所有代码。这些代码只需要写一次;然后不同的Director可以复用它以在相同部件集合的基础上构作不同的Product。在前面的RTF例子中，我们可以为RTF格式以外的格式定义一个阅读器，比如一个SGMLReader，并使用相同的TextConverter生成SGML文档的ASCIIText、TeXText和TextWidget译本。
 
 3)它使你可对构造过程进行更精细的控制。 Builder模式与一下子就生成产品的创建型模式不同，它是在导向者的控制下一步一步构造产品的。仅当该产品完成时导向者才从生成器中取回它。因此Builder接口相比其他创建型模式能更好的反映产品的构造过程。这使你可以更精细的控制构建过程，从而能更精细的控制所得产品的内部结构。
 */
/*:
🏭 工厂方法（Factory Method）
-----------------------

 定义一个用于创建对象的接口，让子类决定实例化哪一个类。 Factory Method使一个类的 实例化延迟到其子类。

### 示例：
*/
// 1
protocol Product {//
    func doSomething()
}

protocol ProductFactory {//
    func creat() -> Product
}

class ProductA: Product {
    func doSomething() {//
        print("ProductA")
    }
}

class ProductB: Product {//
    func doSomething() {
        print("ProductB")
    }
}

class ProductAFactory: ProductFactory {
    func creat() -> Product {//
        return ProductA()
    }
}

class ProductBFactory: ProductFactory {
    func creat() -> Product {//
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
 
 ![](WX20221208-110807@2x.png)
 
 1)主要有两种不同的情况。 FactoryMethod模式主要有两种不同的情况:1)第一种情况
 是，Creator类是一个抽象类并且不提供它所声明的工厂方法的实现。2)第二种情况是，Creator是一个具体的类而且为工厂方法提供一个缺省的实现。也有可能有一个定义了缺省实现的抽象类，但这不太常见。

 第一种情况需要子类来定义实现，因为没有合理的缺省实现。它避免了不得不实例化不可预见类的问题。在第二种情况中，具体的Creator主要因为灵活性才使用工厂方法。它所遵循的准则是，“用一个独立的操作创建对象，这样子类才能重定义它们的创建方式。”这条准则保证了子类的设计者能够在必要的时候改变父类所实例化的对象的类。

 2)参数化工厂方法。 该模式的另一种情况使得工厂方法可以创建多种产品。工厂方法采用一个标识要被创建的对象种类的参数。工厂方法创建的所有对象将共享Product接口。

 一个参数化的工厂方法具有如下的一般形式，此处MyProduct和YourProduct是Product的子类:
 
 ![](WX20221208-105220@2x.png)

 
 重定义一个参数化的工厂方法使你可以简单而有选择性的扩展或改变一个Creator生产的产品。你可以为新产品引入新的标识符，或可以将已有的标识符与不同的产品相关联。

 例如，子类MyCreator可以交换MyProduct和YourProduct并且支持一个新的子类TheirProduct:
 
 ![](WX20221208-105252@2x.png)
 ![](WX20221208-105309@2x.png)
 
 注意这个操作所做的最后一件事是调用父类的Create。这是因为MyCreator::Create仅在对YOURS、MINE和THEIRS的处理上和父类不同。它对其他类不感兴趣。因此MyCreator扩展了所创建产品的种类，并且将除少数产品以外所有产品的创建职责延迟给了父类。

 3)特定语言的变化和问题。

 4)使用模板以避免创建子类。 正如我们已经提及的，工厂方法另一个潜在的问题是它们可能仅为了创建适当的Product对象而迫使你创建Creator子类。在C++中另一个解决方法是提供Creator的一个模板子类，它使用Product类作为模板参数:

 ![](WX20221208-105338@2x.png)

 5)命名约定。 使用命名约定是一个好习惯，它可以清楚地说明你正在使用工厂方法。例如，Macintosh的应用框架MacApp[App89]总是声明那些定义为工厂方法的抽象操作为Class*DoMakeClass()，此处Class是Product类。
 
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
