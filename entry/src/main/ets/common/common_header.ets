
import { StatusBarManager } from './StatusBarManager';
@Component
export struct CommonHeader{
  @State showImmersiveStatusBar: boolean = false;
  @Prop titleBarPadding: number;//注意:prop修饰
  build() {
    Column() {
      Column() {
        Column() {
          Text('这是标题')
            .fontSize(20)
            .fontColor(Color.White)
        }
        .height(50)
        .justifyContent(FlexAlign.Center)
      }
      .padding({ top: `${this.titleBarPadding}px` })
      .width('100%')
      // .backgroundColor('#ff007dfe')
      .backgroundColor(Color.Red)
    }
    // .height('100%')
  }

  // onPageShow(){
  //   console.log('onPageShow')
  //   this.open()
  // }

  private open() {
    let windowStage = StatusBarManager.get().getWindowStage();
    if (windowStage) {
      StatusBarManager.get().setImmersiveStatusBar(windowStage)
        .then(() => {
          this.titleBarPadding = StatusBarManager.get().getSystemBarOffset();
        });
    }
  }

  private close() {
    let windowStage = StatusBarManager.get().getWindowStage();
    if (windowStage) {
      StatusBarManager.get().hideImmersiveStatusBar(windowStage).then(() => {
        this.titleBarPadding = 0;
      })
    }
  }
}