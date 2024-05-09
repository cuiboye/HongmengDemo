/**
 * multiton启动模式,多实例模式
 */
import Want from '@ohos.app.ability.Want'
@Entry
@Component
struct MultitonAbilityPage {
  @State message: string = 'Hello World'

  aboutToAppear(){
    //这里接收的是在MultitonabilityEntryAbility中接收的want
    let want:Want =  globalThis.entryAbilityWant
    console.info("entryAbilityWant",want.parameters.instanceKey)
  }

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


//
// https://blog.csdn.net/m0_68349563/article/details/136605430
// https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V2/application-model-description-0000001493584092-V2