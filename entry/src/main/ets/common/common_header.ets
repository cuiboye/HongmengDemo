
import { StatusBarManager } from './StatusBarManager';
/**
 * 自定义header
 */
@Component
export struct CommonHeader{
  @StorageProp('topStatusHeight') topStatusHeight: number = 0
  showTitleBar:boolean = true;

  build() {
    Column() {
      //状态栏
      Row()
        .width('100%')
        .height(px2vp(this.topStatusHeight))
        .backgroundColor($r('app.color.f56e1d'))
      if(this.showTitleBar){
        Column() {
          Column() {
            Text('这是标题')
              .fontSize(20)
              .fontColor(Color.White)
          }
          .height(50)
          .justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .backgroundColor($r('app.color.f56e1d'))
      }
    }
    // .height('100%')
  }
}