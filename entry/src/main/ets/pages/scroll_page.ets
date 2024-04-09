
/**
 * 滚动列表
 */
@Entry
@Component
struct ScrollPage {
  //初始化Scroller，Scroller目前只支持绑定到Scroll和List 。
  private scroller:Scroller = new Scroller()

  build() {
    Row() {
      Scroll(this.scroller){
        Column(){
          Button('Hello1').height(300)
          Button('Hello2').height(300)
          Button('Hello3').height(300)
          Button('Hello4').height(300)
          Button('Hello5').height(300)
        }
      }
    }
    .height('100%')
  }
}