@Entry
@Component
struct ScrollPage {
  @State message: string = 'Hello World'
  private arr: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  build() {
    Column() {
      Text('状态栏').height(50)
      List({space:10,scroller}){//space：设置每个item之间的间隔
        ForEach(this.arr, (item) => {
          ListItem(){
            Column(){
              Text(item.toString())
                .width('90%')
                .height(150)
                .backgroundColor(Color.Gray)
                .borderRadius(15)
                .fontSize(16)
                .textAlign(TextAlign.Center)
                .margin({ top: 10 })
              Text('底部')
            }
          }
        }, item => item)
      }.layoutWeight(1)//如果除了List之外顶部还有其它的组件，需要设置下List的layoutWeight属性
    }
    .height('100%')
  }
}