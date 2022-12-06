/*:

设计模式（Swift 5.0 实现）
======================

([Design-Patterns-CN.playground.zip](https://raw.githubusercontent.com/ochococo/Design-Patterns-In-Swift/master/Design-Patterns-CN.playground.zip)).

👷 源项目由 [@nsmeme](http://twitter.com/nsmeme) (Oktawian Chojnacki) 维护。

🇨🇳 中文版由 [@binglogo](https://twitter.com/binglogo) 整理翻译。

## 目录

* [行为型模式](Behavioral)
* [创建型模式](Creational)
* [结构型模式](Structural)
*/
import Foundation

print("您好！")

/*:
 ### 理解:
 
 
 ![](designpatterns.png)
 
 我们根据两条准则对模式进行分类
 
 第一是 目的 准则，即模式是用来完成什么工作的。模式依据其目的可分为创建型(Creational)、结构型(Structural)、或行为型(Behavioral)三种。创建型模式与对象的创建有关;结构型模式处理类或对象的组合;行为型模式对类或对象怎样交互和怎样分配职责进行描述。
 
 第二是 范围 准则，指定模式主要是用于类还是用于对象。类模式处理类和子类之间的关系，这些关系通过继承建立，是静态的，在编译时刻便确定下来了。对象模式处理对象间的关系，这些关系在运行时刻是可以变化的，更具动态性。从某种意义上来说，几乎所有模式都使用继承机制，所以“类模式”只指那些集中于处理类间关系的模式，而大部分模式都属于对象模式的范畴。
 
 创建型类模式将对象的部分创建工作延迟到子类，而创建型对象模式则将它延迟到另一个对象中。结构型类模式使用继承机制来组合类，而结构型对象模式则描述了对象的组装方式。行为型类模式使用继承描述算法和控制流，而行为型对象模式则描述一组对象怎样协作完成单个对象所无法完成的任务。

*/
