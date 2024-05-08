/**
 * multiton启动模式,多实例模式
 */
@Entry
@Component
struct MultitonAbilityPage {
  @State message: string = 'Hello World'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}

// Stage模型
// 1. 组件分类
// 1）UIAbility组件：UIAbility组件是一种包含UI界面的应用组件，主要用于和用户交互。
// UIAbility组件是系统调度的基本单元，为应用提供绘制界面的窗口；一个UIAbility组件中可以通过多个页面来实现一个功能模块。每一个UIAbility组件实例，都对应于一个最近任务列表中的任务。
//
// 为使应用能够正常使用UIAbility，需要在module.json5(entry/src/main/module.json5)的abilities标签中声明UIAbility的名称、入口、标签等相关信息。
//
// 2)UIAbility的生命周期
// UIAbility的生命周期包括Create、Foreground、Background、Destroy四个状态。
// onCreate:Create状态为在应用加载过程中，UIAbility实例创建完成时触发，系统会调用onCreate()回调。可以在该回调中进行页面初始化操作，例如变量定义资源加载等，用于后续的UI界面展示。
//
// Foreground和Background状态分别在UIAbility实例切换至前台和切换至后台时触发
//
// onForeground()回调，在UIAbility的UI界面可见之前，如UIAbility切换至前台时触发。可以在onForeground()回调中申请系统需要的资源
//
// 可以在onBackground()回调中释放UI界面不可见时无用的资源，或者在此回调中执行较为耗时的操作，例如状态保存等。
//
// Destroy状态在UIAbility实例销毁时触发。可以在onDestroy()回调中进行系统资源的释放、数据的保存等操作。
//
//
// onWindowStageCreate:UIAbility实例创建完成之后，在进入Foreground之前，系统会创建一个WindowStage。WindowStage创建完成后会进入onWindowStageCreate()回调，通过loadContent()方法设置应用要加载的页面并根据需要订阅WindowStage的事件
//
// onWindowStageDestroy:对应于onWindowStageCreate()回调。在UIAbility实例销毁之前，则会先进入onWindowStageDestroy()回调，可以在该回调中释放UI界面资源。例如在onWindowStageDestroy()中注销获焦/失焦等WindowStage事件。
//
//
// 3）UIAbility的启动模式
//
// singleton启动模式：singleton启动模式为单实例模式，也是默认情况下的启动模式。每次调用startAbility()方法时，如果应用进程中该类型的UIAbility实例已经存在，则复用系统中的UIAbility实例。系统中只存在唯一一个该UIAbility实例，即在最近任务列表中只存在一个该类型的UIAbility实例。
//
// 应用的UIAbility实例已创建，该UIAbility配置为单实例模式，再次调用startAbility()方法启动该UIAbility实例，此时只会进入该UIAbility的onNewWant()回调，不会进入其onCreate()和onWindowStageCreate()生命周期回调。
//
// 如果需要使用singleton启动模式，在module.json5配置文件中的"launchType"字段配置为"singleton"即可。
//
//
//
// multiton启动模式：multiton启动模式为多实例模式，每次调用startAbility()方法时，都会在应用进程中创建一个新的该类型UIAbility实例。即在最近任务列表中可以看到有多个该类型的UIAbility实例。这种情况下可以将UIAbility配置为multiton
// 注意：这个模式虽然叫做多实例模式，但它在系统中也只存在唯一一个该UIAbility实例，但是它与singleton模式不同的是，再次调用startAbility方法时，它会替换原来的UIAbility实例，并且会进入onCreate和onWindowStateCreate生命周期。
// specified启动模式
//
// https://blog.csdn.net/m0_68349563/article/details/136605430
// https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V2/application-model-description-0000001493584092-V2