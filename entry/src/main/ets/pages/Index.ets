import router from '@ohos.router';
import { CommonHeader } from '../common/common_header';
import { APP_EXIT_INTERVAL, TIME } from '../common/constants/Constants';
import { ComponentWidget } from '../widget/component_widget';
import { ProgressTask } from './prop_link_demo';
import { PropPage } from './prop_page';
import { FirstWidget } from './provider_page';
import { StatePage } from './state_page';
import prompt from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import window from '@ohos.window';
import Want from '@ohos.app.ability.Want';
import data from '@ohos.telephony.data';
import worker from '@ohos.worker';

/**
 * 全局的自定义构建函数，页面内使用Component修饰的组件都可以用
 */
// @Builder function ListViewItem(item:string){
//   Row() {
//     Text(`元素为 ${item}`).fontSize(16)
//   }.backgroundColor(Color.Red).height(30).width(100)
// }


// 还未归纳的：
//1）Web
//2）stateStyles多态样式


/**
 * 全局的自定义样式
 * 全局的自定义样式的属性只能设置所有组件都有的属性才可以，如果是某个组件特有的属性则不支持，比如
 * Text的fontSize则不支持。
 * 如果想在全局的自定义样式中设置某个组件特有的属性，可以使用Extend
 */
@Styles function fillScreen() {
  .backgroundColor(Color.Red)
  .height(30)
  .width(100)
}

/**
 * 使用Extend设置某个组件特有的属性
 * 注意：@Extend只能写在全局中，不能写在局部中
 */
@Extend(Text) function priceText() {
  .fontSize(16)
  .fontColor(Color.Blue)
}

let wk = new worker.ThreadWorker("entry/ets/workers/worker.ts");

@Entry
@Component
struct Index {

  @State showImmersiveStatusBar: boolean = false;
  @State titleBarPadding: number = 0;
  array: Array<String> = ['a', 'b', 'c'];
  @State message: string = 'Hello World'
  @State totalNumber: number = 0

  // @Provide providerTotalNumber:number = 0;
  @Provide('providerTotalNumber') aaa: number = 0;
  @Provide('providerTotalNumber2') aaa2: number = 0;

  private clickBackTimeRecord: number = 0;

  searchArr:Array<String> = ['dskf','1dskf','2dskf','3dskf','4dskf','5dskf','6dskf','7dskf']

  @StorageProp('navigationHeight') navigationHeight: number = 0

  private context = getContext(this) as common.UIAbilityContext

  onPageShow(){
    //   //这是个全局设置，其他页面如果想显示状态栏，在显示其他页面的时候需要设置显示
    window.getLastWindow(this.context).then((windowClass) => {
      //
      windowClass.setWindowSystemBarProperties({
        statusBarColor: '#ff00a0e9',
        navigationBarColor: '#ff00a0e9',
        statusBarContentColor: '#ff00a0e9',
        navigationBarContentColor: '#ff00a0e9'
      })

      windowClass.setWindowSystemBarEnable(['status','navigation'], (err) => {

      });
    })
  }

  myClickHandler(): void {
    console.log('HarmonyOS Hello!')
  }

  /**
   * 局部的构建函数
   */
  @Builder ListViewItem(item: string) {
    Row() {
      Text(`元素为 ${item}`).priceText() //priceText为全局的自定义属性
    }.fillScreen() //fillScreen 自定义样式
  }

  /**
   * 局部的自定义样式
   */
  @Styles fillScreen(){
    .backgroundColor(Color.Red)
    .height(30)
    .width(100)
  }

  /**
   * onBackPress:物理返回键监听
   */
  onBackPress(){
    if (this.isShowToast()) {
      prompt.showToast({
        message: '再按一次退出程序',
        duration: TIME
      });
      this.clickBackTimeRecord = new Date().getTime();
      return true;
    }
    return false;
  }

  isShowToast(): boolean {
    return new Date().getTime() - this.clickBackTimeRecord > APP_EXIT_INTERVAL;
  }

  //在TypeScript中，空字符串，0，nul,undefined
  build() {
    Column(){
      //状态栏以及标题栏
      CommonHeader()
      Scroll(){
        Column() {

          // PropPage({totalNumber:this.totalNumber})

          //@State的操作
          StatePage()

          //Flex 流式布局
          Flex({ justifyContent: FlexAlign.Start, wrap: FlexWrap.Wrap }) {
            if (this.searchArr.length > 0) {
              ForEach(this.searchArr, (item: string) => {
                Text(`${item}`)
                  .fontSize($r("app.float.flex_font_size"))
                  .borderStyle(BorderStyle.Solid)
                  .borderWidth($r('app.float.border_width'))
                  .borderColor('#00a0e9')
                  .borderRadius($r('app.float.border_radius'))
                  .backgroundColor(Color.Red)
                  .padding({
                    top: 3,
                    bottom: 3,
                    left: 5,
                    right: 5
                  })
                  .margin({
                    top: $r("app.float.flex_layout_margin"),
                    right: $r("app.float.flex_layout_margin")
                  })
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(5)
              }, (item: string) => JSON.stringify(item))
            }
          }
          .margin({
            left: $r('app.float.margin_left'),
            right: $r('app.float.margin_left')
          })
          .padding({ bottom: $r('app.float.margin_left') })

          //@Link 传递的变量的引用必须使用 $
          PropPage({ totalNumber: $totalNumber })
          Row() {
            Text(`${this.totalNumber}`)
            Button('测试@Prop状态管理').onClick(() => {
              this.totalNumber++
            })
          }

          //Provider和Consume
          Column() {
            Row() {
              Text(`${this.aaa}`)
              Button('测试Provider和Consume').onClick(() => {
                this.aaa++
              })
            }

            FirstWidget()
          }
          Button('媒体查询-多屏幕适配').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/media_page',
              },
              router.RouterMode.Standard, //跳转模式 Single/Stantard
            )
          })
          Button('@State @Prop @Link的Demo').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/prop_link_demo',
              },
              router.RouterMode.Standard, //跳转模式 Single/Stantard
            )
          })

          //=========== singleton模式 start ===========
          //需要将MultitonabilityEntryAbility的launchType设置为 singleton
          Button('singletonability').onClick(() => {
            // singletonability跳转
            let want: Want = {
              deviceId: '',//空字符串代表当前设备
              bundleName: 'com.example.myapplication',
              moduleName: 'entry',
              abilityName: 'MultitonabilityEntryAbility'
            }
            this.context.startAbility(want)
              .catch(err => {

              })
          })
          //=========== singleton模式 end ===========

          //=========== multiton模式 start ===========
          //需要将MultitonabilityEntryAbility的launchType设置为 multiton
          Button('multitonability').onClick(() => {
                // multitonability跳转
                let want: Want = {
                  deviceId: '',
                  bundleName: 'com.example.myapplication',
                  moduleName: 'entry',
                  abilityName: 'MultitonabilityEntryAbility'
                }
                this.context.startAbility(want)
              })
          //=========== multiton模式 end ===========

          //=========== standard模式 start ===========
          //需要将MultitonabilityEntryAbility的launchType设置为 standard
          Button('standardability').onClick(() => {
            // standardability跳转
            let want: Want = {
              deviceId: '',
              bundleName: 'com.example.myapplication',
              moduleName: 'entry',
              abilityName: 'MultitonabilityEntryAbility'
            }
            this.context.startAbility(want)
          })
          //=========== standard模式 end ===========

          //=========== specified模式 start ===========
          //测试这个功能：
          //1）需要在 module.json5 中将MultitonabilityEntryAbility的launchType设置为 specified
          //2）需要在 module.json5 的 module 这个标签下添加  "srcEntry": './ets/multitonability/MyAbilityStage.ts',
          Button(`创建指定实例模式-打开文档1`).onClick(() => {
            // 跳转的目的地want
            let want: Want = {
              deviceId: '',
              bundleName: 'com.example.myapplication',
              moduleName: 'entry',
              abilityName: 'MultitonabilityEntryAbility',
              parameters: {//参数
                instanceKey: '文档1'
              }
            }
            this.context.startAbility(want)
         })

          Button(`创建指定实例模式-打开文档2`).onClick(() => {
            // 跳转的目的地want
            let want: Want = {
              deviceId: '',
              bundleName: 'com.example.myapplication',
              moduleName: 'entry',
              abilityName: 'MultitonabilityEntryAbility',
              //这个参数需要和MyAbilityStage中的instanceKey参数一致
              parameters: {
                instanceKey: '文档2'
              }
            }
            this.context.startAbility(want)
          })
          //=========== specified模式 end ===========


          Button(`启动新的Ability并接收返回的参数`).onClick(() => {
            // 跳转的目的地want
            let want: Want = {
              deviceId: '',
              bundleName: 'com.example.myapplication',
              moduleName: 'entry',
              abilityName: 'MultitonabilityEntryAbility',
            }
            this.context.startAbilityForResult(want).then(data=>{
              if(data.resultCode == 1001){
                //取出Ability返回的信息
                let result = data.want.parameters.backParams;
                console.info(`Ability返回的result为：${result}`)
              }
            })
          })

          //启动其它的应用，启动的页面为默认的页面
          Button(`启动其它应用的UIAbility`).onClick(() => {//MyApplication22项目
            let wantInfo = {
              deviceId: '', // deviceId为空表示本设备
              // 如果希望隐式仅在特定的捆绑包中进行查询，请取消下面的注释。
              bundleName: 'com.example.myapplication2',
              action: 'ohos.want.action.viewData',
              // entities可以被省略。
              entities: ['entity.system.default'],
            }
            // context为调用方UIAbility的AbilityContext
            this.context.startAbility(wantInfo).then(() => {

            }).catch((err) => {

            })
          })

          //可以打开其它应用的具体的某个页面
          //需要在其它应用的EntryAbility的onCreate方法中接收want，并在windowStage.loadContent判断跳转哪个页面
          Button(`打开Ability中指定的页面`).onClick(() => {//MyApplication22项目
            let wantInfo = {
              deviceId: '', // deviceId为空表示本设备
              bundleName: 'com.example.myapplication2',
              abilityName: 'EntryAbility',
              moduleName: 'entry', // moduleName非必选
              parameters: { // 自定义参数传递页面信息
                router: 'SecondPage',
              },
            }
            // context为调用方UIAbility的AbilityContext
            this.context.startAbility(wantInfo).then(() => {
              //then为回调，从其它Ability返回到当前Ability后的操作可以在这里处理
            }).catch((err) => {
              console.info(err)
            })
          })

          //使用Want打开链接
          Button(`使用Want打开链接`).onClick(() => {
            let wantInfo = {
              // bundleName: 'com.example.myapplication',
              action: 'ohos.want.action.viewData',
              entities: [ 'entity.system.browsable' ],
              uri: 'http://www.baidu.com',
              type: 'text/plain',
            };
            this.context.startAbility(wantInfo).then(() => {
            }).catch((err) => {
              console.info(err)
            })
          })

          //发送消息到worker线程
          Button(`发送消息到worker线程`).onClick(() => {
            // 发送消息到worker线程
            wk.postMessage("message from main thread.")

            // 处理来自worker线程的消息
            wk.onmessage = (message) =>{
              console.info("message from worker: " + message.data)
              // 根据业务按需停止worker线程
              wk.terminate()
            }
          })



          //=========== EventHub start ===========
          Button('EventHub').onClick(() => {
            //使用 eventHub.emit 来发送消息
            this.context.eventHub.emit('eventTest')
          })
          //=========== EventHub end ===========


          Button('@Observed和@ObjectLink的Demo').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/boseved_page',
              },
              router.RouterMode.Standard, //跳转模式 Single/Stantard
              err => {
                if (err) {
                  console.log('路由失败')
                  console.log(err.code + '')
                  console.log(err.message)
                  console.log(err.name)
                }
              },
            )
          })

          Button('布局学习').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/layout_demo',
              },
              router.RouterMode.Standard, //跳转模式 Single/Stantard
              err => {
                if (err) {
                  console.log('路由失败')
                  console.log(err.code + '')
                  console.log(err.message)
                  console.log(err.name)
                }
              },
            )
          })

          //List
          Button('List列表').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/list_page',
              },
              router.RouterMode.Standard,
            )
          })

          //Grid
          Button('Grid列表').onClick(() => {
            router.pushUrl(
              {
                url:'pages/grid_demo'
              },
            )
          })

          //List的分组列表
          Button('List的分组列表').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/list_page2',
              },
              router.RouterMode.Standard,
            )
          })

          //滚动列表
          Button('滚动列表').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/scroll_page',
              },
              router.RouterMode.Standard,
            )
          })

          //Swiper轮播图
          Button('Swiper轮播图').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/swiper_demo_page',
              },
              router.RouterMode.Standard,
            )
          })

          //各种组件
          Button('各种组件').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/widget_page',
              },
              router.RouterMode.Standard,
            )
          })

          //路由操作
          Button('路由操作').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/routerdemo/first_router',
              },
            )
          })

          //持久化数据
          Button('持久化数据').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/savedata/save_data_demo',
              },
            )
          })

          //stateStyles-多态样式
          Button('stateStyles-多态样式').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/wajiu/MutilStylePage',
              },
            )
          })

          Button('动画').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/animate/animate_main_page',
              },
            )
          })
          Button('通过LocalStorage.GetShared()在页面之间更新值').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/LocalStorageSharePage',
              },
            )
          })

          Button('挖酒项目').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/wajiu/page/wajiu_main_page',
              },
            )
          })
          Button('二级联动+MVVM模式').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/SecondLevelLinkagePage',
              },
            )
          })
          Button('Webview Demo').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/WebviewPage',
              },
            )
          })
        }
      }.layoutWeight(1)
      //底部安全区域的高度
      Row()
        .height(px2vp(this.navigationHeight))
        .width('100%')
        .backgroundColor(Color.White)
    }
  }
}

//需要记录的：
//1.EventHub
//2.UIAbility组件相关
//3.LocalStorage
//4.AppStorage
//5.使用Want跳转Ability/打开链接/分享
//6.应用上下文context
//7)stateStyles多态样式
//8）线程 Emitter和EventHub的使用场景没有搞明白
//EventHub：EventHub提供了线程内发送和处理事件的能力，包括对事件订阅、取消订阅、触发事件等。
//Emitter：Emitter主要提供线程间发送和处理事件的能力，包括对持续订阅事件或单次订阅事件的处理、取消订阅事件、发送事件到事件队列等。

//操作符
//https://blog.csdn.net/a42626423/article/details/136067258


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
// UIAbility的启动模式是指UIAbility实例在启动时的不同呈现状态。
//
// singleton启动模式：singleton启动模式为单实例模式，也是默认情况下的启动模式。每次调用startAbility()方法时，如果应用进程中该类型的UIAbility实例已经存在，则复用系统中的UIAbility实例。系统中只存在唯一一个该UIAbility实例，即在最近任务列表中只存在一个该类型的UIAbility实例。
//
// 应用的UIAbility实例已创建，该UIAbility配置为单实例模式，再次调用startAbility()方法启动该UIAbility实例，此时只会进入该UIAbility的onNewWant()回调，不会进入其onCreate()和onWindowStageCreate()生命周期回调。
//
// 如果需要使用singleton启动模式，在module.json5配置文件中的"launchType"字段配置为"singleton"即可。
//
//
//
// multiton启动模式：
// 官网的解释：
// multiton启动模式为多实例模式，每次调用startAbility()方法时，都会在应用进程中创建一个新的该类型UIAbility实例。即在最近任务列表中可以看到有多个该类型的UIAbility实例。这种情况下可以将UIAbility配置为multiton。
// 官网的这个解释是错误的，实际中启动的Ability只会有一个。
// 注意：这个模式虽然叫做多实例模式，但它在系统中也只存在唯一一个该UIAbility实例，但是它与singleton模式不同的是，再次调用startAbility方法时，它会替换原来的UIAbility实例，并且会进入onCreate和onWindowStateCreate生命周期。
//
//
// specified启动模式：specified启动模式为指定实例模式，针对一些特殊场景使用（例如文档应用中每次新建文档希望都能新建一个文档实例，重复打开一个已保存的文档希望打开的都是同一个文档实例）。
//
// 在UIAbility实例创建之前，允许开发者为该实例创建一个唯一的字符串Key，创建的UIAbility实例绑定Key之后，后续每次调用startAbility()方法时，都会询问应用使用哪个Key对应的UIAbility实例来响应startAbility()请求。运行时由UIAbility内部业务决定是否创建多实例，如果匹配有该UIAbility实例的Key，则直接拉起与之绑定的UIAbility实例（此时再次启动该UIAbility时，只会进入该UIAbility的onNewWant()回调，不会进入其onCreate()和onWindowStageCreate()生命周期回调。），否则创建一个新的UIAbility实例。
//
// standard：standard启动模式为多实例模式，每次调用startAbility()方法时，都会在应用进程中创建一个新的该类型UIAbility实例。即在最近任务列表中可以看到有多个该类型的UIAbility实例。
// 这也就意味着，如果任务列表中存在该实例时，再次调用startAbility方法会进入onCreate和onWindowStateCreate生命周期。
// 注意：每次启动Ability都会启动一个新的，会有多个Ability。
//
//
// 4）UIAbility组件
//
// UIAbility组件的基本用法包括：指定UIAbility的启动页面以及获取UIAbility的上下文UIAbilityContext。
//
// 应用中的UIAbility在启动过程中，需要指定启动页面，否则应用启动后会因为没有默认加载页面而导致白屏。可以在UIAbility的onWindowStageCreate()生命周期回调中，通过WindowStage对象的loadContent()方法设置启动页面。
//
// 5）获取UIAbility的上下文信息
// UIAbility类拥有自身的上下文信息，该信息为UIAbilityContext类的实例，UIAbilityContext类拥有abilityInfo、currentHapModuleInfo等属性。通过UIAbilityContext可以获取UIAbility的相关配置信息，如包代码路径、Bundle名称、Ability名称和应用程序需要的环境状态等属性信息，以及可以获取操作UIAbility实例的方法（如startAbility()、connectServiceExtensionAbility()、terminateSelf()等）。
// 如何获取UIAbility的上下文信息？
//
// 在UIAbility中可以通过this.context获取UIAbility实例的上下文信息。
//
// export default class EntryAbility extends UIAbility {
//   onCreate(want, launchParam) {
//     // 获取UIAbility实例的上下文
//     let context = this.context;
//   }
// }
//
// 在页面中获取UIAbility实例的上下文信息，包括导入依赖资源context模块和在组件中定义一个context变量两个部分。
// private context = getContext(this) as common.UIAbilityContext
//
// 6)UIAbility组件与UI的数据同步
// 第一种使用 EventHub,可以用于UIAbility和UI以及UI和UI之间
// EventHub提供了UIAbility组件/ExtensionAbility组件级别的事件机制，以UIAbility组件/ExtensionAbility组件为中心提供了订阅、取消订阅和触发事件的数据通信能力。
//
// 第二种使用 globalThis
// globalThis是ArkTS引擎实例内部的一个全局对象，引擎内部的UIAbility/ExtensionAbility/Page都可以使用，因此可以使用globalThis全局对象进行数据同步。
//
// UIAbility和Page之间使用globalThis
//
// Button(`创建指定实例模式-打开文档1`).onClick(() => {
//   // 跳转的目的地want
//   let want: Want = {
//     deviceId: '',
//     bundleName: 'com.example.myapplication',
//     moduleName: 'entry',
//     abilityName: 'MultitonabilityEntryAbility',
//     parameters: {//参数
//       instanceKey: '文档1'
//     }
//   }
//   this.context.startAbility(want)
// })
//
// //调用startAbility()方法启动一个UIAbility实例时，被启动的UIAbility创建完成后会进入onCreate()生命周期回调，且在onCreate()生命周期回调中能够接受到传递过来的want参数，可以将want参数绑定到globalThis上。
// export default class MultitonabilityEntryAbility extends UIAbility {
//   async onCreate(want, launchParam) {
//     //这里接收跳转MultitonabilityEntryAbility传递过来的参数
//     globalThis.entryAbilityWant = want;
//   }
// }
//
// //在UI界面中即可通过globalThis获取到want参数信息。
// struct MultitonAbilityPage {
//   @State message: string = 'Hello World'
//
//   aboutToAppear(){
//     //这里接收的是在MultitonabilityEntryAbility中接收的want
//     let want:Want =  globalThis.entryAbilityWant
//     console.info("entryAbilityWant",want.parameters.instanceKey)
//   }
// }
//
//
// UIAbility和UIAbility之间使用globalThis
//
// 同一个应用中UIAbility和UIAbility之间的数据传递，可以通过将数据绑定到全局变量globalThis上进行同步，如在AbilityA中将数据保存在globalThis，然后跳转到AbilityB中取得该数据：
//
// import UIAbility from '@ohos.app.ability.UIAbility'
//
// export default class AbilityA extends UIAbility {
//   onCreate(want, launch) {
//     globalThis.entryAbilityStr = 'AbilityA'; // AbilityA存放字符串“AbilityA”到globalThis
//     // ...
//   }
// }
//
// import UIAbility from '@ohos.app.ability.UIAbility'
//
// export default class AbilityB extends UIAbility {
//   onCreate(want, launch) {
//     // AbilityB从globalThis读取name并输出
//     console.info('name from entryAbilityStr: ' + globalThis.entryAbilityStr);
//     // ...
//   }
// }
//
// * Stage模型下进程内的UIAbility组件共享ArkTS引擎实例，使用globalThis时需要避免存放相同名称的对象。例如AbilityA和AbilityB可以使用globalThis共享数据，在存放相同名称的对象时，先存放的对象会被后存放的对象覆盖。
// * FA模型因为每个UIAbility组件之间引擎隔离，不会存在该问题。
// * 对于绑定在globalThis上的对象，其生命周期与ArkTS虚拟机实例相同，建议在使用完成之后将其赋值为null，以减少对应用内存的占用。
//
//
// 7）使用AppStorage/LocalStorage进行数据同步
// ArkUI提供了AppStorage和LocalStorage两种应用级别的状态管理方案，可用于实现应用级别和UIAbility级别的数据同步。使用这些方案可以方便地管理应用状态，提高应用性能和用户体验。其中，AppStorage是一个全局的状态管理器，适用于多个UIAbility共享同一状态数据的情况；而LocalStorage则是一个局部的状态管理器，适用于单个UIAbility内部使用的状态数据。通过这两种方案，开发者可以更加灵活地控制应用状态，提高应用的可维护性和可扩展性。
//
// 应用逻辑使用LocalStorage
// let storage = new LocalStorage({ 'PropA': 47 }); // 创建新实例并使用给定对象初始化
// let propA = storage.get('PropA') // propA == 47
// let link1 = storage.link('PropA'); //link方法双向同步 link1.get() == 47
// let link2 = storage.link('PropA'); // link2.get() == 47
// let prop = storage.prop('PropA'); //prop方法单向同步  prop.get() = 47
// link1.set(48); //link1.get() == link2.get() == prop.get() == 48
// prop.set(1); //prop.get()=1; 但是 link1.get() == link2.get() == 48
// link1.set(49); //link1.get() == link2.get() == prop.get() == 49
//
//
// 除了应用程序逻辑使用LocalStorage，还可以借助LocalStorage相关的两个装饰器@LocalStorageProp和@LocalStorageLink，在UI组件内部获取到LocalStorage实例中存储的状态变量。===>查看 LocalStoragePage
// 这个类。
//
// 8）Ability组件间的交互（设备内）
// 启动应用内的UIAbility：
//
// //通过调用startAbility()方法启动UIAbility
// let want: Want = {
//   deviceId: '',//空字符串代表当前设备
//   bundleName: 'com.example.myapplication',
//   moduleName: 'entry',
//   abilityName: 'MultitonabilityEntryAbility’,
//   parameters: {//参数
//     instanceKey: '文档1'
//   }
// }
// this.context.startAbility(want)
//   .catch(err => {
//
//   })
//
// //在Ability的生命周期回调函数中接收传递过来的参数
// import UIAbility from '@ohos.app.ability.UIAbility';
// import Window from '@ohos.window';
//
// export default class FuncAbility extends UIAbility {
//   onCreate(want, launchParam) {
//     // 接收调用方UIAbility传过来的参数
//     let info = want?. parameters?.instanceKey;
//
//   }
// }
// 在Ability业务完成之后，如需要停止当前UIAbility实例，在Ability中通过调用terminateSelf()方法实现
// // context为需要停止的UIAbility实例的AbilityContext
// //无参数
// this.context.terminateSelf((err) => {
//   // ...
// });
//
// //返回参数
// let abilityResult = {
//   resultCode: 1001,
//   want: {
//     bundleName: 'com.example.myapplication',
//     abilityName: 'EntryAbility',
//     moduleName: 'entry',
//     parameters: {
//       backParams: '来自MultitonabilityEntryAbility',
//     },
//   },
// }
// // context为被调用方UIAbility的AbilityContext
// this.context.terminateSelfWithResult(abilityResult, (err) => {
//
// });
// //接收参数
// let want: Want = {
//   deviceId: '',
//   bundleName: 'com.example.myapplication',
//   moduleName: 'entry',
//   abilityName: 'MultitonabilityEntryAbility',
// }
// this.context.startAbilityForResult(want).then(data=>{
//   if(data.resultCode == 1001){
//     //取出Ability返回的信息
//     let result = data.want.parameters.backParams;
//     console.info(`Ability返回的result为：${result}`)
//   }
// })
//
//
// 启动其它应用的UIAbility
//
// 启动其他应用的UIAbility，推荐使用隐式Want启动。系统会根据调用方的want参数来识别和启动匹配到的应用UIAbility。
//
//
// 启动UIAbility有显式Want启动和隐式Want启动两种方式。
//
// 显式Want启动：启动一个确定应用的UIAbility，在want参数中需要设置该应用bundleName和abilityName，当需要拉起某个明确的UIAbility时，通常使用显式Want启动方式。
// 隐式Want启动：根据匹配条件由用户选择启动哪一个UIAbility，即不明确指出要启动哪一个UIAbility（abilityName参数未设置），在调用startAbility()方法时，其入参want中指定了一系列的entities字段（表示目标UIAbility额外的类别信息，如浏览器、视频播放器）和actions字段（表示要执行的通用操作，如查看、分享、应用详情等）等参数信息，然后由系统去分析want，并帮助找到合适的UIAbility来启动。当需要拉起其他应用的UIAbility时，开发者通常不知道用户设备中应用的安装情况，也无法确定目标应用的bundleName和abilityName，通常使用隐式Want启动方式。
// 1）将多个待匹配的文档应用安装到设备，在其对应UIAbility的module.json5配置文件中
// "abilities": [
// {
//   "skills": [
//   {
//         "entities": ["entity.system.default"],
//         "actions": ["ohos.want.action.viewData"]
//       },
//   ],
// }
// ]
//
// 2）在调用方want参数中的entities和action需要被包含在待匹配UIAbility的skills配置的entities和actions中。系统匹配到符合entities和actions参数条件的UIAbility后，会弹出选择框展示匹配到的UIAbility实例列表供用户选择使用。
// let wantInfo = {
//   deviceId: '', // deviceId为空表示本设备
//   // 如果希望隐式仅在特定的捆绑包中进行查询，请取消下面的注释。
//   // bundleName: 'com.example.myapplication',
//   action: 'ohos.want.action.viewData',
//   // entities可以被省略。
//   entities: ['entity.system.default'],
// }
//
// // context为调用方UIAbility的AbilityContext
// this.context.startAbility(wantInfo).then(() => {
//   // ...
// }).catch((err) => {
//   // ...
// })
//
// 在操作完成之后，如需要停止当前UIAbility实例，通过调用terminateSelf()方法实现。
// // context为需要停止的UIAbility实例的AbilityContext
// this.context.terminateSelf((err) => {
//
// });
// 应用间的Ability传递参数和接受返回参数和在应用间使用是一样的。
//
//
// 启动Ability的指定页面：
// 查看代码
//
//
// ExtensionAbility组件包含FormExtensionAbility和WorkSchedulerExtensionAbility
//
//
//
//
// AbilityStage相关：
// AbilityStage是一个Module级别的组件容器，应用的HAP在首次加载时会创建一个AbilityStage实例，可以对该Module进行初始化等操作。
// AbilityStage与Module一一对应，即一个Module拥有一个AbilityStage。
//
// 如何创建一个AbilityStage
// * 		在工程Module对应的ets目录下，右键选择“New > Directory”，新建一个目录并命名为myabilitystage。
// * 		在myabilitystage目录，右键选择“New > TypeScript File”，新建一个TypeScript文件并命名为MyAbilityStage.ts。
// * 		打开MyAbilityStage.ts文件，导入AbilityStage的依赖包，自定义类继承AbilityStage并加上需要的生命周期回调，示例中增加了一个onCreate()生命周期回调。
// import AbilityStage from '@ohos.app.ability.AbilityStage';
//
// export default class MyAbilityStage extends AbilityStage {
//   onCreate() {
//     // 应用的HAP在首次加载的时，为该Module初始化操作
//   }
//   onAcceptWant(want) {
//     // 仅specified模式下触发
//     return "MyAbilityStage";
//   }
// }
// 在module.json5配置文件中，通过配置srcEntry参数来指定模块对应的代码路径，以作为HAP加载的入口。
// {
//   "module": {
//     "name": "entry",
//     "type": "entry",
//     "srcEntry": "./ets/myabilitystage/MyAbilityStage.ts",
//     ...
//   }
// }
//
// onCreate()生命周期回调：在开始加载对应Module的第一个UIAbility实例之前会先创建AbilityStage，并在AbilityStage创建完成之后执行其onCreate()生命周期回调。AbilityStage模块提供在Module加载的时候，通知开发者，可以在此进行该Module的初始化（如资源预加载，线程创建等）能力。
// onAcceptWant()事件回调：UIAbility指定实例模式（specified）启动时候触发的事件回调，具体使用请参见UIAbility启动模式综述。
// onConfigurationUpdated()事件回调：当系统全局配置发生变更时触发的事件，系统语言、深浅色等，配置项目前均定义在Configuration类中。
// onMemoryLevel()事件回调：当系统调整内存时触发的事件。
//
//
// 应用上下文Context：
// 可以参考https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V2/application-context-stage-0000001427744560-V2
//
// 信息传递载体Want:
// 1）启动Ability
// 2)打开链接
// 3）分享
//
// 进程应用中（同一包名）的所有UIAbility运行在同一个独立进程中；		WebView拥有独立的渲染进程。
// 一个进程中包含了主线程（ArkTS引擎实例）和其它的Worker线程（ArkTS引擎实例）
//
//
//
// 线程：HarmonyOS应用中每个进程都会有一个主线程，除主线程外，还有一类与主线程并行的独立线程Worker，主要用于执行耗时操作，但不可以直接操作UI。Worker线程在主线程中创建，与主线程相互独立。最多可以创建8个Worker：
// Emitter主要用于主线程和Worker线程、Worker线程和Worker线程之间的事件同步。
// UIAbility组件与UI均在主线程中。
//
// 在鸿蒙系统中，ArkTS引擎用于管理主线程上的UI渲染。
//
// worker线程：
// 需要注意的是，Worker中不能直接更新Page。
// Worker的开发步骤如下：
// 1.在工程的模块级build-profile.json5文件的buildOption属性中添加配置信息。
// "buildOption": {
//   "sourceOption": {"workers": ["./src/main/ets/workers/worker.ts"]}
// }
// 2.根据build-profile.json5中的配置创建对应的worker.ts文件。
// import worker from '@ohos.worker';
//
// let parent = worker.workerPort;
//
// // 处理来自主线程的消息
// parent.onmessage = function(message) {
//   console.info("onmessage: " + message)
//   // 发送消息到主线程
//   parent.postMessage("message from worker thread.")
// }
// 3.主线程中使用如下方式初始化和使用worker。
// import worker from '@ohos.worker';
//
// let wk = new worker.ThreadWorker("entry/ets/workers/worker.ts");
//
// // 发送消息到worker线程
// wk.postMessage("message from main thread.")
//
// // 处理来自worker线程的消息
// wk.onmessage = function(message) {
//   console.info("message from worker: " + message)
//
//   // 根据业务按需停止worker线程
//   wk.terminate()
// }
