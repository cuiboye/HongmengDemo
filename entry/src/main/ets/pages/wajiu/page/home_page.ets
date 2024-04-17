import axios from '@ohos/axios'
import { MatchPattern } from '@ohos.UiTest';
import ShopInfo from '../../../common/TaskEntity';

/**
 * 挖酒首页
 */
// 在鸿蒙的Row布局中，如果你设置了子控件的宽度为100%，它确实会尝试占据其父容器的全部宽度。当存在多层嵌套的布局时，这个问题可能会变得更加复杂，因为每个父容器都可能尝试将其子控件扩展到其最大可用空间。
//
// 要解决这个问题，你可以尝试以下几种方法：
//
// 使用match_parent代替100%：
// 在某些情况下，使用match_parent而不是100%可能会有所不同。match_parent会使子控件的宽度与其父控件的宽度相匹配，而不是直接设置为100%的屏幕尺寸。
// 设置layout_weight：
// 如果你想要子控件在Row布局中平均分配空间，你可以使用layout_weight属性。例如，给所有子控件设置相同的layout_weight值可以使它们平均分配空间。
// 使用ConstraintLayout：
// 如果你的布局比较复杂，可能需要更复杂的布局逻辑，那么可以考虑使用ConstraintLayout。ConstraintLayout提供了更多的布局选项和约束，可以更好地控制子控件的位置和大小。
// 限制子控件的最大宽度：
// 你可以尝试给子控件设置一个max_width属性，以限制其最大宽度。这样，即使子控件被设置为100%，它的宽度也不会超过这个最大值。
// 检查嵌套层级：
// 如果问题是由嵌套层级过多引起的，那么尝试减少布局的嵌套层级。每个额外的嵌套层级都可能引入额外的布局问题。
// 查看父控件的大小：
// 确保父控件的大小是正确设置的。如果父控件的大小没有被正确约束，那么子控件可能会尝试填满整个屏幕。
// 更新鸿蒙系统版本和工具：
// 确保你正在使用的鸿蒙系统版本和开发工具是最新的。有时，这类问题可能是由系统或工具的bug引起的，而这些bug可能在新版本中已经得到修复。

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
          ForEach([1, 2, 3, 4, 5, 6, 7, 8], (item: number) => {
            GridItem() {
              Text(`${item}`)
            }
          })
        }
        .rowsTemplate('1fr 1fr') //设置Grid为2行
        .columnsTemplate('1fr 1fr 1fr 1fr') //设置Grid为4列
        .height(200)

        Grid() {
          ForEach([11, 13, 12, 14, 15, 16, 17, 18], (item: number) => {
            GridItem() {
              Text(`${item}`)
            }
          })
        }
        .rowsTemplate('1fr 1fr') //设置Grid为2行
        .columnsTemplate('1fr 1fr 1fr 1fr') //设置Grid为4列
        .height(200)
      }
      //隐藏指示器，Indicator这个api在4.0才能使用
      // .indicator(Indicator.dot()
      //   .itemWidth(15)
      //   .itemHeight(15)
      //   .selectedItemWidth(15)
      //   .selectedItemHeight(15)
      //   .color('#00000000')
      //   .selectedColor('#00000000'))
      Row() {
        Row() {
          Image($r('app.media.app_home_dingdan_blue')).width(20)
          Text('订单查询')
            .fontSize(16)
            .fontColor($r('app.color.343434'))
            .margin({left:8})
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        Divider().strokeWidth(1).color($r('app.color.dfdfdf')).vertical(true)
        Row() {
          Image($r('app.media.app_index_chongzhi_new')).width(20)
          Text('充值')
            .fontSize(16)
            .fontColor($r('app.color.343434'))
            .margin({left:8})
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      }
      .margin({ left: 13, right: 13 })
      .backgroundColor(Color.White)
      .borderRadius(8)
      .height(43)
      .justifyContent(FlexAlign.SpaceBetween)

      Row(){
        Image($r('app.media.app_home_xiaowakuaibao'))
          .margin({left:18})
          .height(15)
          .backgroundColor(Color.White)
        Divider()
          .margin({left:10,right:7})
          .vertical(true)
          .color($r('app.color.dfdfdf'))
          .strokeWidth(1)
          .height(12)

        Swiper(){
          Text('跑马灯效果')
            .fontSize(13)
            .fontColor($r('app.color.343434'))
            .margin({right:10})
            .layoutWeight(1)
          Text('跑马灯效果2')
            .fontSize(13)
            .fontColor($r('app.color.343434'))
            .margin({right:10})
            .layoutWeight(1)
        }
        .autoPlay(true)
        .layoutWeight(1)
        .vertical(true)
        .interval(4000)
        .height(25)
      }
      .margin({top:8,left:13,right:13})
      .height(43)
      .borderRadius(8)
      .backgroundColor(Color.White)


      Row(){

      }.width('100%')


    }
    .height('100%')
    .backgroundColor($r('app.color.eeeeee'))
  }
}