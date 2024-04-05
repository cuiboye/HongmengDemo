import { CommonHeader } from '../common/common_header';
import { StatusBarManager } from '../common/StatusBarManager';

@Entry
@Component
struct Index {
  @State showImmersiveStatusBar: boolean = false;
  @State titleBarPadding: number = 0;

  build() {
    Column() {
      CommonHeader({titleBarPadding:this.titleBarPadding})
    }
  }

  onPageShow(){
    this.open()
    console.log('onPageShow')
  }

  private open() {
    let windowStage = StatusBarManager.get().getWindowStage();
    if (windowStage) {
      StatusBarManager.get().setImmersiveStatusBar(windowStage)
        .then(() => {
          this.titleBarPadding = StatusBarManager.get().getSystemBarOffset();
          console.log(`titleBarPadding ${this.titleBarPadding}`)
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
