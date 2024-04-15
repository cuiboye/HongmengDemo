@Entry
@Component
struct Temp {
  private bannerList = [
    'https://image.59cdn.com/static/upload/image/app/20240401/o_1711938042571.jpg',
    'https://image.59cdn.com/static/upload/image/app/20240321/o_1711014875389.jpg',
    'https://image.59cdn.com/static/upload/image/app/20231124/o_1700805809122.jpg'
  ];

  build() {
    Column() {
      Column() {
        Row() {
          Row() {
            Text('搜索图标')
            Text('掌阅珍藏干红——2018')
              .fontColor('#a3a2a2')
              .fontSize(15)
              .margin({ left: 10 })
          }
          .borderRadius(8)
          .height(30)
          .backgroundColor('#bdffffff')
          .layoutWeight(1)

          Text('客服图标')
          Text('消息图标')
        }
        .padding({ left: 18, right: 18 })
        .width('100%')
        //轮播图
        Swiper() {
          ForEach(this.bannerList, (bannerItem: string, index?: number) => {
            Image(bannerItem).width('100%')//给图片设置一个宽度，高度会自适应
          })
        }
        .autoPlay(true
        )
        .margin({top:15,left:13,right:13})
        // .padding({left:15,right:15})//设置宽度为100%后，左右的margin不生效了，只能设置padding
        // .width('100%') //不要设置Swiper的宽度为100%，否则左右的margin没有用
        .borderRadius(8) //设置Swiper的圆角

      }.linearGradient({
        repeating: true, // 渐变颜色是否重复
        // direction: GradientDirection.Top, // 渐变方向
        colors: [[0xf56e1d, 0], [0xf56e1d, 1]] //0和1可能代表的是顺序
      })
      //棋盘格
      // Grid() {
      //   ForEach(['g','i','h','g','f','e','d','c','b','a',], (service: string, index) => {
      //     GridItem() {
      //       Text(service)
      //     }
      //     .width('25%')
      //   }, service => service)
      // }
      // .rowsTemplate('1fr 1fr') // 只设置rowsTemplate属性，当内容超出Grid区域时，可水平滚动。
      // .rowsGap(15)
      Swiper(){
        Grid(){

        }
      }
    }
    .height('100%')
  }
}