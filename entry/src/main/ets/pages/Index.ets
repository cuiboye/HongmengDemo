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

          Button('singletonability').onClick(() => {
            // singletonability跳转
            let want: Want = {
              deviceId: '',//空字符串代表当前设备
              bundleName: 'com.example.myapplication',
              moduleName: 'entry',
              abilityName: 'MultitonabilityEntryAbility'
            }
            // 跳转
            this.context.startAbility(want)
          })

          Button('multitonability').onClick(() => {
                // multitonability跳转
            //跳转多次，会打开多个MultitonabilityEntryAbility，它的launchType为multiton
                let want: Want = {
                  deviceId: '',
                  bundleName: 'com.example.myapplication',
                  moduleName: 'entry',
                  abilityName: 'MultitonabilityEntryAbility'
                }
                // 跳转
                this.context.startAbility(want)
              })

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

          //持久化数据
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
