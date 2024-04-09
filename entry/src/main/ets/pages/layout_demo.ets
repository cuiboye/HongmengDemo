
/**
 * 布局学习
 */
@Entry
@Component
struct LayoutDemo {
  @State message: string = 'Hello World'

  build() {
    //1）space:每个元素之间的间距
    //2）width和height:宽高
    //3）backgroundColor：背景色
    //4）容器的根结点需要设置为100%，否则不会显示
    //5）Row和Column的交叉轴如果是充满布局，那么元素在交叉轴上面对齐方式为居中对齐
    //如果是Column可以通过设置alignItems属性为HorizontalAlign.Start来改变交叉轴上元素的位置。
    //6）alignItems：可以通过alignItems属性设置子元素在交叉轴（排列方向的垂直方向）上的对齐方式
    //7）alignSelf属性用于控制单个子元素在容器交叉轴上的对齐方式，其优先级高于alignItems属性，如果设置了alignSelf属性，则在单个子元素上会覆盖alignItems属性。
    //8）justifyContent：设置主轴上的对齐方式
    //9）layoutWeight：使子元素占满剩余空间
    Column() {
      // Column({space:20}) {
      //   Text(this.message)
      //     .fontSize(12)
      //     .fontWeight(FontWeight.Bold)
      //     .fontColor(Color.Black)
      // }.width('100%').backgroundColor(Color.Red)
      Column(){
        Text(this.message)
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
        Text(this.message)
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black).alignSelf(ItemAlign.Center)//通过alignSelf设置子元素水平居中
      }
      .backgroundColor(Color.Gray)
      .width('100%')
      .height(80)
      .alignItems(HorizontalAlign.Start)//alignItems：设置交叉轴方向上元素对齐方式左对齐
      .justifyContent(FlexAlign.End)//justifyContent：设置主轴上的对齐方式

      Row(){
        Text('测试layoutWeight').layoutWeight(1)//layoutWeight:占满可用的剩余空间
        Text('hello').backgroundColor(Color.Red).fontSize(8)
      }.width('100%').backgroundColor(Color.Gray).margin({top:10}).padding({left:10})
    }.height('100%').width('100%').margin({top:50})
  }
}