import router from '@ohos.router'
@Entry
@Component
struct AnimateMainPage {
  @State message: string = 'Hello World'

  build() {
    Column() {
      Button('显示动画')
        .onClick(()=>{
          router.pushUrl({
            url:'pages/animate/display_animate_page'
          })
        })
      Button('属性动画')
        .onClick(()=>{
          router.pushUrl({
            url:'pages/animate/attribute_animate_page'
          })
        })
      Button('共享元素转场动画')
        .onClick(()=>{
          router.pushUrl({
            url:'pages/animate/shared_animate_page'
          })
      })
    }
    .height('100%')
  }
}