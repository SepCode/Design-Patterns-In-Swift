/*:

结构型模式（Structural）
====================

> 在软件工程中结构型模式是设计模式，借由一以贯之的方式来了解元件间的关系，以简化设计。
>
>**来源：** [维基百科](https://zh.wikipedia.org/wiki/%E7%B5%90%E6%A7%8B%E5%9E%8B%E6%A8%A1%E5%BC%8F)

## 目录

* [行为型模式](Behavioral)
* [创建型模式](Creational)
* [结构型模式](Structural)
*/

/*:
 ### 理解:
 
 Adapter与Bridge

 Adapter(4.1)模式和Bridge(4.2)模式具有一些共同的特征。它们都给另一对象提供了一定程度上的间接性，因而有利于系统的灵活性。它们都涉及到从自身以外的一个接口向这个对象转发请求。
 这些模式的不同之处主要在于它们各自的用途。Adapter模式主要是为了解决两个已有接口之间不匹配的问题。它不考虑这些接口是怎样实现的，也不考虑它们各自可能会如何演化。这种方式不需要对两个独立设计的类中的任一个进行重新设计，就能够使它们协同工作。另
 一方面，Bridge模式则对抽象接口与它的(可能是多个)实现部分进行桥接。虽然这一模式允许你修改实现它的类，它仍然为用户提供了一个稳定的接口。Bridge模式也会在系统演化时适应新的实现。

 由于这些不同点，Adapter和Bridge模式通常被用于软件生命周期的不同阶段。当你发现两个不兼容的类必须同时工作时，就有必要使用Adapter模式，其目的一般是为了避免代码重复。此处耦合不可预见。相反，Bridge的使用者必须事先知道:一个抽象将有多个实现部分，并且抽象和实现两者是独立演化的。Adapter模式在类已经设计好后实施;而Bridge模式在设计类之前实施。这并不意味着Adapter模式不如Bridge模式，只是因为它们针对了不同的问题。

 你可能认为facade(参见Facade(4.5))是另外一组对象的适配器。但这种解释忽视了一个事实:即Facade定义一个新的接口，而Adapter则复用一个原有的接口。记住，适配器使两个已有的接口协同工作，而不是定义一个全新的接口。

 Composite、Decorator与Proxy

 Composite(4.3)模式和Decorator(4.4)模式具有类似的结构图，这说明它们都基于递归组合来组织可变数目的对象。这一共同点可能会使你认为，decorator对象是一个退化的composite，但这一观点没有领会Decorator模式要点。相似点仅止于递归组合，同样，这是因为这两个模式的目的不同。
 
 Decorator旨在使你能够不需要生成子类即可给对象添加职责。这就避免了静态实现所有功能组合，从而导致子类急剧增加。Composite则有不同的目的，它旨在构造类，使多个相关的对象能够以统一的方式处理，而多重对象可以被当作一个对象来处理。它重点不在于修饰，而在于表示。
 
 尽管它们的目的截然不同，但却具有互补性。因此Composite和Decorator模式通常协同使用。在使用这两种模式进行设计时，我们无需定义新的类，仅需将一些对象插接在一起即可构建应用。这时系统中将会有一个抽象类，它有一些composite子类和decorator子类，还有一些实现系统的基本构建模块。此时，composites和decorator将拥有共同的接口。从Decorator模式的角度看，composite是一个ConcreteComponent。而从composite模式的角度看，decorator则是一个Leaf。当然，他们不一定要同时使用，正如我们所见，它们的目的有很大的差别。
 
 另一种与Decorator模式结构相似的模式是Proxy(4.7)。这两种模式都描述了怎样为对象提供一定程度上的间接引用，proxy和decorator对象的实现部分都保留了指向另一个对象的指针，它们向这个对象发送请求。然而同样，它们具有不同的设计目的。
 像Decorator模式一样，Proxy模式构成一个对象并为用户提供一致的接口。但与
 Decorator模式不同的是，Proxy模式不能动态地添加或分离性质，它也不是为递归组合而设计的。它的目的是，当直接访问一个实体不方便或不符合需要时，为这个实体提供一个替代者，例如，实体在远程设备上，访问受到限制或者实体是持久存储的。
 
 在Proxy模式中，实体定义了关键功能，而Proxy提供(或拒绝)对它的访问。在Decorator模式中，组件仅提供了部分功能，而一个或多个Decorator负责完成其他功能。Decorator模式适用于编译时不能(至少不方便)确定对象的全部功能的情况。这种开放性使
 递归组合成为Decorator模式中一个必不可少的部分。而在Proxy模式中则不是这样，因为Proxy模式强调一种关系(Proxy与它的实体之间的关系)，这种关系可以静态的表达。
 
 模式间的这些差异非常重要，因为它们针对了面向对象设计过程中一些特定的经常发生问题的解决方法。但这并不意味着这些模式不能结合使用。可以设想有一个proxy-decorator，它可以给proxy添加功能，或是一个decorator-proxy用来修饰一个远程对象。尽管这种混合可能有用(我们手边还没有现成的例子)，但它们可以分割成一些有用的模式。
 */
import Foundation
/*:
🔌 适配器（Adapter）
--------------

适配器模式有时候也称包装样式或者包装(wrapper)。将一个类的接口转接成用户所期待的。一个适配使得因接口不兼容而不能在一起工作的类能在一起工作，做法是将类自己的接口包裹在一个已存在的类中。[维基百科](https://zh.wikipedia.org/wiki/%E9%80%82%E9%85%8D%E5%99%A8%E6%A8%A1%E5%BC%8F)

### 示例：
*/
protocol NewDeathStarSuperLaserAiming {
    var angleV: Double { get }
    var angleH: Double { get }
}
/*:
**被适配者**
*/
struct OldDeathStarSuperlaserTarget {
    let angleHorizontal: Float
    let angleVertical: Float

    init(angleHorizontal: Float, angleVertical: Float) {
        self.angleHorizontal = angleHorizontal
        self.angleVertical = angleVertical
    }
}
/*:
**适配器**
*/
struct NewDeathStarSuperlaserTarget: NewDeathStarSuperLaserAiming {

    private let target: OldDeathStarSuperlaserTarget

    var angleV: Double {
        return Double(target.angleVertical)
    }

    var angleH: Double {
        return Double(target.angleHorizontal)
    }

    init(_ target: OldDeathStarSuperlaserTarget) {
        self.target = target
    }
}
/*:
### 用法
*/
let target = OldDeathStarSuperlaserTarget(angleHorizontal: 14.0, angleVertical: 12.0)
let newFormat = NewDeathStarSuperlaserTarget(target)

newFormat.angleH
newFormat.angleV
/*:
 ### 理解:
 
 结构型类模式采用继承机制来 组合接口或实现。一个简单的例子是采用多重继承方法将两个以上的类组合成一个类，结果 这个类包含了所有父类的性质。这一模式尤其有助于多个独立开发的类库协同工作。
 
 ![adapter](adapter.png)

 - 你想使用一个已经存在的类，而它的接口不符合你的需求。
 - 你想创建一个可以复用的类，该类可以与其他不相关的类或不可预见的类（即那些接口可能不一定兼容的类）协同工作。
 - （仅适用于对象Adapter ）你想使用一些已经存在的子类，但是不可能对每一个都进行子类化以匹配它们的接口。对象适配器可以适配它的父类接口。
 */

/*:
🌉 桥接（Bridge）
-----------

桥接模式将抽象部分与实现部分分离，使它们都可以独立的变化。[维基百科](https://zh.wikipedia.org/wiki/%E6%A9%8B%E6%8E%A5%E6%A8%A1%E5%BC%8F)

### 示例：
*/
protocol Switch {
    var appliance: Appliance { get set }
    func turnOn()
}

protocol Appliance {
    func run()
}

final class RemoteControl: Switch {
    var appliance: Appliance

    func turnOn() {
        self.appliance.run()
    }
    
    init(appliance: Appliance) {
        self.appliance = appliance
    }
}

final class TV: Appliance {
    func run() {
        print("tv turned on");
    }
}

final class VacuumCleaner: Appliance {
    func run() {
        print("vacuum cleaner turned on")
    }
}
/*:
### 用法
*/
let tvRemoteControl = RemoteControl(appliance: TV())
tvRemoteControl.turnOn()

let fancyVacuumCleanerRemoteControl = RemoteControl(appliance: VacuumCleaner())
fancyVacuumCleanerRemoteControl.turnOn()

/*:
 ### 理解:
 - 把事物对象和其具体行为、具体特征分离开来，使它们可以各自独立的变化。事物对象仅是一个抽象的概念。如“圆形”、“三角形”归于抽象的“形状”之下，而“画圆”、“画三角”归于实现行为的“画图”类之下，然后由“形状”调用“画图”。
 - 你不希望在抽象和它的实现部分之间有一个固定的绑定关系。例如在程序运行时刻实现部分可以被选择或者切换。

 - 类的抽象以及它的实现都应该可以通过生成子类的方法加以扩充。这时Bridge 模式使你可以对不同的抽象接口和实现部分进行组合，并分别对它们进行扩充。

 - 对一个抽象的实现部分的修改应对客户不产生影响，即客户的代码不必重新编译。

 */
/*:
🌿 组合（Composite）
--------------

将对象组合成树形结构以表示‘部分-整体’的层次结构。组合模式使得用户对单个对象和组合对象的使用具有一致性。

### 示例：

组件（Component）
*/
protocol Shape {
    func draw(fillColor: String)
}
/*:
叶子节点（Leafs）
*/
final class Square: Shape {
    func draw(fillColor: String) {
        print("Drawing a Square with color \(fillColor)")
    }
}

final class Circle: Shape {
    func draw(fillColor: String) {
        print("Drawing a circle with color \(fillColor)")
    }
}

/*:
组合
*/
final class Whiteboard: Shape {

    private lazy var shapes = [Shape]()

    init(_ shapes: Shape...) {
        self.shapes = shapes
    }

    func draw(fillColor: String) {
        for shape in self.shapes {
            shape.draw(fillColor: fillColor)
        }
    }
}
/*:
### 用法
*/
var whiteboard = Whiteboard(Circle(), Square())
whiteboard.draw(fillColor: "Red")
/*:
 ### 理解:
 - 你想表示对象的部分-整体层次结构。

 - 你希望用户忽略组合对象与单个对象的不同，用户将统一地使用组合结构中的所有对象。
 
 */
/*:
🍧 修饰（Decorator）
--------------

修饰模式，是面向对象编程领域中，一种动态地往一个类中添加新的行为的设计模式。
就功能而言，修饰模式相比生成子类更为灵活，这样可以给某个对象而不是整个类添加一些功能。

### 示例：
*/
protocol CostHaving {
    var cost: Double { get }
}

protocol IngredientsHaving {
    var ingredients: [String] { get }
}

typealias BeverageDataHaving = CostHaving & IngredientsHaving

struct SimpleCoffee: BeverageDataHaving {
    let cost: Double = 1.0
    let ingredients = ["Water", "Coffee"]
}

protocol BeverageHaving: BeverageDataHaving {
    var beverage: BeverageDataHaving { get }
}

struct Milk: BeverageHaving {

    let beverage: BeverageDataHaving

    var cost: Double {
        return beverage.cost + 0.5
    }

    var ingredients: [String] {
        return beverage.ingredients + ["Milk"]
    }
}

struct WhipCoffee: BeverageHaving {

    let beverage: BeverageDataHaving

    var cost: Double {
        return beverage.cost + 0.5
    }

    var ingredients: [String] {
        return beverage.ingredients + ["Whip"]
    }
}
/*:
### 用法
*/
var someCoffee: BeverageDataHaving = SimpleCoffee()
print("Cost: \(someCoffee.cost); Ingredients: \(someCoffee.ingredients)")
someCoffee = Milk(beverage: someCoffee)
print("Cost: \(someCoffee.cost); Ingredients: \(someCoffee.ingredients)")
someCoffee = WhipCoffee(beverage: someCoffee)
print("Cost: \(someCoffee.cost); Ingredients: \(someCoffee.ingredients)")
/*:
🎁 外观（Facade）
-----------

外观模式为子系统中的一组接口提供一个统一的高层接口，使得子系统更容易使用。

### 示例：
*/
final class Defaults {

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    subscript(key: String) -> String? {
        get {
            return defaults.string(forKey: key)
        }

        set {
            defaults.set(newValue, forKey: key)
        }
    }
}
/*:
### 用法
*/
let storage = Defaults()

// Store
storage["Bishop"] = "Disconnect me. I’d rather be nothing"

// Read
storage["Bishop"]
/*:
🍃 享元（Flyweight）
--------------

使用共享物件，用来尽可能减少内存使用量以及分享资讯给尽可能多的相似物件；它适合用于当大量物件只是重复因而导致无法令人接受的使用大量内存。

### 示例：
*/
// 特指咖啡生成的对象会是享元
struct SpecialityCoffee {
    let origin: String
}

protocol CoffeeSearching {
    func search(origin: String) -> SpecialityCoffee?
}

// 菜单充当特制咖啡享元对象的工厂和缓存
final class Menu: CoffeeSearching {

    private var coffeeAvailable: [String: SpecialityCoffee] = [:]

    func search(origin: String) -> SpecialityCoffee? {
        if coffeeAvailable.index(forKey: origin) == nil {
            coffeeAvailable[origin] = SpecialityCoffee(origin: origin)
        }

        return coffeeAvailable[origin]
    }
}

final class CoffeeShop {
    private var orders: [Int: SpecialityCoffee] = [:]
    private let menu: CoffeeSearching

    init(menu: CoffeeSearching) {
        self.menu = menu
    }

    func takeOrder(origin: String, table: Int) {
        orders[table] = menu.search(origin: origin)
    }

    func serve() {
        for (table, origin) in orders {
            print("Serving \(origin) to table \(table)")
        }
    }
}
/*:
### 用法
*/
let coffeeShop = CoffeeShop(menu: Menu())

coffeeShop.takeOrder(origin: "Yirgacheffe, Ethiopia", table: 1)
coffeeShop.takeOrder(origin: "Buziraguhindwa, Burundi", table: 3)

coffeeShop.serve()
/*:
☔ 保护代理模式（Protection Proxy）
------------------

在代理模式中，创建一个类代表另一个底层类的功能。
保护代理用于限制访问。

### 示例：
*/
protocol DoorOpening {
    func open(doors: String) -> String
}

final class HAL9000: DoorOpening {
    func open(doors: String) -> String {
        return ("HAL9000: Affirmative, Dave. I read you. Opened \(doors).")
    }
}

final class CurrentComputer: DoorOpening {
    private var computer: HAL9000!

    func authenticate(password: String) -> Bool {

        guard password == "pass" else {
            return false
        }

        computer = HAL9000()

        return true
    }

    func open(doors: String) -> String {

        guard computer != nil else {
            return "Access Denied. I'm afraid I can't do that."
        }

        return computer.open(doors: doors)
    }
}
/*:
### 用法
*/
let computer = CurrentComputer()
let podBay = "Pod Bay Doors"

computer.open(doors: podBay)

computer.authenticate(password: "pass")
computer.open(doors: podBay)
/*:
🍬 虚拟代理（Virtual Proxy）
----------------

在代理模式中，创建一个类代表另一个底层类的功能。
虚拟代理用于对象的需时加载。

### 示例：
*/
protocol HEVSuitMedicalAid {
    func administerMorphine() -> String
}

final class HEVSuit: HEVSuitMedicalAid {
    func administerMorphine() -> String {
        return "Morphine administered."
    }
}

final class HEVSuitHumanInterface: HEVSuitMedicalAid {

    lazy private var physicalSuit: HEVSuit = HEVSuit()

    func administerMorphine() -> String {
        return physicalSuit.administerMorphine()
    }
}
/*:
### 用法
*/
let humanInterface = HEVSuitHumanInterface()
humanInterface.administerMorphine()
