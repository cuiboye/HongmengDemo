import axios from '@ohos/axios'
import ShopInfo from '../../../common/TaskEntity';

/**
 * 挖酒首页
 */

@Component
  @Entry
export struct HomePage {
  private bannerList = [
    'https://image.59cdn.com/static/upload/image/app/20240401/o_1711938042571.jpg',
    'https://image.59cdn.com/static/upload/image/app/20240321/o_1711014875389.jpg',
    'https://image.59cdn.com/static/upload/image/app/20231124/o_1700805809122.jpg'
  ];

  // aboutToAppear() {
  //   this.getShopListByAxiosAsync().then(shops => {
  //     shops.code
  //     shops.msg
  //     shops.data
  //     shops.data.dataBoardTabs
  //   })
  // }

  // async getShopListByAxiosAsync(): Promise<ShopInfo> {
  //   // 1.发送请求
  //   let resp = await axios.get(
  //     // `${this.baseURL}/shops`,
  //     'https://mock.apifox.com/m1/3626399-3255008-default/getXXXData',
  //     // {
  //     //   params: { pageNo: this.pageNo, pageSize: 3 }
  //     // }
  //   )
  //   // 2.处理响应
  //   if (resp.status === 200) {
  //     // 查询成功
  //     console.log('testTag', '查询商铺成功！', JSON.stringify(resp.data))
  //     return resp.data;
  //   }
  //   // 查询失败
  //   console.log('testTag', '查询商铺信息失败！error:', JSON.stringify(resp))
  // }

  build() {
    Column() {
      // Button('请求接口数据').onClick(() => {
      //   this.getShopListByAxiosAsync()
      // }).margin({ top: 90 })
      Column() {
        Row() {
          Row() {
            Image($r('app.media.app_home_tabbar_seach'))
              .width('15')
              .margin({ left: 10 })
            Text('掌阅珍藏干红——2018')
              .fontColor('#a3a2a2')
              .fontSize(15)
              .margin({ left: 10 })
          }
          .borderRadius(8)
          .height(30)
          .backgroundColor('#bdffffff')
          .layoutWeight(1)

          Image($r('app.media.home_customer_service')).width(20).margin({ left: 10 })
          Image($r('app.media.app_index_message_new')).width(20).margin({ left: 10 })
        }
        .padding({ left: 18, right: 18 })
        .width('100%')
        //轮播图
        Swiper() {
          ForEach(this.bannerList, (bannerItem: string, index?: number) => {
            Image(bannerItem).width('100%') //给图片设置一个宽度，高度会自适应
          })
        }
        .autoPlay(true
        )
        .margin({ top: 15, left: 13, right: 13 })
        // .padding({left:15,right:15})//设置宽度为100%后，左右的margin不生效了，只能设置padding
        // .width('100%') //不要设置Swiper的宽度为100%，否则左右的margin没有用
        .borderRadius(8) //设置Swiper的圆角

      }.linearGradient({
        repeating: true, // 渐变颜色是否重复
        // direction: GradientDirection.Top, // 渐变方向
        colors: [[0xef7134, 0], [0xf4f4f4, 1]] //0和1可能代表的是顺序
      })
      //棋盘格

      Swiper() {
        Grid() {
          ForEach([1, 2, 3, 4, 5, 6, 7, 8], (item:number) => {
            GridItem() {
              Text(`${item}`)
            }
          })
        }
        .rowsTemplate('1fr 1fr') //设置Grid为2行
        .columnsTemplate('1fr 1fr 1fr 1fr') //设置Grid为4列
        .height(200)
        Grid() {
          ForEach([11, 13, 12, 14, 15, 16, 17, 18], (item:number) => {
            GridItem() {
              Text(`${item}`)
            }
          })
        }
        .rowsTemplate('1fr 1fr') //设置Grid为2行
        .columnsTemplate('1fr 1fr 1fr 1fr') //设置Grid为4列
        .height(200)
      }
     Row(){
       Text('sdfdsf').layoutWeight(1).textAlign(TextAlign.Center)
       Divider({color:Color.Black,st})
       Text('sdfdsf').layoutWeight(1).textAlign(TextAlign.Center)
     }.margin({left:13,right:13}).backgroundColor(Color.White)
     .borderRadius({topLeft:8,bottomLeft:8})
      .justifyContent(FlexAlign.SpaceBetween)
      //隐藏指示器，Indicator这个api在4.0才能使用
      // .indicator(Indicator.dot()
      //   .itemWidth(15)
      //   .itemHeight(15)
      //   .selectedItemWidth(15)
      //   .selectedItemHeight(15)
      //   .color('#00000000')
      //   .selectedColor('#00000000'))
    }
    .height('100%')
    .backgroundColor($r('app.color.eeeeee'))
  }
}