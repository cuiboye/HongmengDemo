import axios from '@ohos/axios'
import { MatchPattern } from '@ohos.UiTest';
import ShopInfo, { AppNewIndexCategoriesEntity, BannerInternationalEntity, BrandHallEntity, FamousProductListEntity, HomeButtonAppNewIndexCategoriesEntity } from '../../../common/TaskEntity';
import { WaterfallFlowPage } from '../waterfall_flow_page';
import observer from '@ohos.telephony.observer';

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
  // private bannerList = [
  //   'https://image.59cdn.com/static/upload/image/app/20240401/o_1711938042571.jpg',
  //   'https://image.59cdn.com/static/upload/image/app/20240321/o_1711014875389.jpg',
  //   'https://image.59cdn.com/static/upload/image/app/20231124/o_1700805809122.jpg'
  // ];
  //轮播图数据
  @State bannerList:AppNewIndexCategoriesEntity[] = []
  //棋盘格数据
  @State homeButtonList:HomeButtonAppNewIndexCategoriesEntity[] = []
  //国家馆
  @State bannerInternationalList:BannerInternationalEntity[] = []
  //品牌馆
  @State brandHallList:BrandHallEntity[] = []
  //名庄优品
  @State famousProductList:FamousProductListEntity[] = []


  private swiperController: SwiperController = new SwiperController()
  private listController:Scroller = new Scroller()

  @State selectedTabIndex:number = 0

  aboutToAppear() {
    this.getShopListByAxiosAsync().then(indexInfo => {
      if(indexInfo.states == 200){
        this.bannerList = indexInfo.result.indexList.focus_picture.appNewIndexCategories
        this.homeButtonList = indexInfo.result.indexList.home_button.appNewIndexCategories
        this.bannerInternationalList = indexInfo.result.banner_international
        this.brandHallList = indexInfo.result.brandHall
        this.famousProductList = indexInfo.result.famousProducts.famousProductList
      }
    })
  }

  async getShopListByAxiosAsync(): Promise<ShopInfo> {
    // 1.发送请求
    let resp = await axios.get(
      // `${this.baseURL}/shops`,
      'https://mock.apifox.com/m1/3626399-3255008-default/cby/index',
      // {
      //   params: { pageNo: this.pageNo, pageSize: 3 }
      // }
    )
    // 2.处理响应
    if (resp.status === 200) {
      // 查询成功
      console.log('testTag', '查询商铺成功！', JSON.stringify(resp.data))
      return resp.data;
    }
    // 查询失败
    console.log('testTag', '查询商铺信息失败！error:', JSON.stringify(resp))
  }

  build() {
    Scroll() {
      Column() {
        // Button('请求接口数据').onClick(() => {
        //   this.getShopListByAxiosAsync()
        // }).margin({ top: 90 })
        //
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
            ForEach(this.bannerList, (bannerItem: AppNewIndexCategoriesEntity, index?: number) => {
              Image(bannerItem.picture).width('100%') //给图片设置一个宽度，高度会自适应
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

        // 棋盘格
        Tabs(){
          TabContent(){
            Grid() {
              ForEach(this.homeButtonList.slice(0,8), (item: HomeButtonAppNewIndexCategoriesEntity) => {
                GridItem() {
                  Column(){
                    //Grid中加载图片遇到的一个坑，某个图片的路径多个一个/，导致图片加载不出来
                    //这个图片在浏览器中是可以加载出来的，鸿蒙中的Image加载不出来
                    //加载不出来的图片
                    //https://image.59cdn.com//static/upload/image/app/20230112/o_1673513393408.png
                    //正常的图片
                    //https://image.59cdn.com/static/upload/image/app/20230112/o_1673513393408.png
                    Image(item.picture)
                      .width(53)
                      .height(53)
                    Text(item.indexName)
                      .fontColor('#989898')
                      .fontSize(14)
                      .margin({top:8})
                  }
                }
              }, (item: HomeButtonAppNewIndexCategoriesEntity) => '' + item.indexName)
            }
            .rowsTemplate('1fr 1fr') //设置Grid为2行
            .columnsTemplate('1fr 1fr 1fr 1fr') //设置Grid为4列
            .height(200)
          }
          TabContent(){
            Grid() {
              ForEach(this.homeButtonList.slice(8,this.homeButtonList.length), (item: HomeButtonAppNewIndexCategoriesEntity) => {
                GridItem() {
                  Column(){
                    //Grid中加载图片遇到的一个坑，某个图片的路径多个一个/，导致图片加载不出来
                    //这个图片在浏览器中是可以加载出来的，鸿蒙中的Image加载不出来
                    //加载不出来的图片
                    //https://image.59cdn.com//static/upload/image/app/20230112/o_1673513393408.png
                    //正常的图片
                    //https://image.59cdn.com/static/upload/image/app/20230112/o_1673513393408.png
                    Image(item.picture)
                      .width(53)
                      .height(53)
                    Text(item.indexName)
                      .fontColor('#989898')
                      .fontSize(14)
                      .margin({top:8})
                  }
                }
              }, (item: HomeButtonAppNewIndexCategoriesEntity) => '' + item.indexName)
            }
            .rowsTemplate('1fr 1fr') //设置Grid为2行
            .columnsTemplate('1fr 1fr 1fr 1fr') //设置Grid为4列
            .height(200)
          }
        }
        .height(200)
        .barHeight(0)


        //Swiper嵌套Grid时，切换页面会导致数据重新加载，页面会先空白然后数据再出来，暂时没有解决办法，也适用Tabs+Grid代替
        // Swiper() {
        //   Grid() {
        //     ForEach(this.homeButtonList.slice(0,8), (item: HomeButtonAppNewIndexCategoriesEntity) => {
        //       GridItem() {
        //         Column(){
        //           Image(item.picture)
        //             .width(53)
        //             .height(53)
        //           Text(item.indexName)
        //             .fontColor('#989898')
        //             .fontSize(14)
        //             .margin({top:8})
        //         }
        //       }
        //     })
        //   }
        //   .rowsTemplate('1fr 1fr') //设置Grid为2行
        //   .columnsTemplate('1fr 1fr 1fr 1fr') //设置Grid为4列
        //   .height(200)
        //
        //   Grid() {
        //     ForEach(this.homeButtonList.slice(8,this.homeButtonList.length), (item: HomeButtonAppNewIndexCategoriesEntity) => {
        //       GridItem() {
        //         Column(){
        //           Image(item.picture)
        //             .width(53)
        //             .height(53)
        //           Text(item.indexName)
        //             .fontColor('#989898')
        //             .fontSize(14)
        //             .margin({top:8})
        //         }
        //       }
        //     })
        //   }
        //   .rowsTemplate('1fr 1fr') //设置Grid为2行
        //   .columnsTemplate('1fr 1fr 1fr 1fr') //设置Grid为4列
        //   .height(180)
        // }
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
              .margin({ left: 8 })
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)

          Divider().strokeWidth(1).color($r('app.color.dfdfdf')).vertical(true)
          Row() {
            Image($r('app.media.app_index_chongzhi_new')).width(20)
            Text('充值')
              .fontSize(16)
              .fontColor($r('app.color.343434'))
              .margin({ left: 8 })
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
        }
        .margin({ left: 13, right: 13 })
        .backgroundColor(Color.White)
        .borderRadius(8)
        .height(43)
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Image($r('app.media.app_home_xiaowakuaibao'))
            .margin({ left: 18 })
            .height(15)
            .backgroundColor(Color.White)
          Divider()
            .margin({ left: 10, right: 7 })
            .vertical(true)
            .color($r('app.color.dfdfdf'))
            .strokeWidth(1)
            .height(12)

          Swiper() {
            Text('跑马灯效果')
              .fontSize(13)
              .fontColor($r('app.color.343434'))
              .margin({ right: 10 })
              .layoutWeight(1)
            Text('跑马灯效果2')
              .fontSize(13)
              .fontColor($r('app.color.343434'))
              .margin({ right: 10 })
              .layoutWeight(1)
          }
          .autoPlay(true)
          .layoutWeight(1)
          .vertical(true)
          .interval(4000)
          .height(25)
        }
        .margin({ top: 8, left: 13, right: 13 })
        .height(43)
        .borderRadius(8)
        .backgroundColor(Color.White)

        Row() {
          Image('https://image.59cdn.com/app/release/index/HotNewProduct/TopSellerList.png')
            .layoutWeight(1)
          Column() {
            Image('https://image.59cdn.com/static/upload/image/app/20230313/o_1678679039491.png')
              .objectFit(ImageFit.Auto)
            Image('https://image.59cdn.com/app/release/index/HotNewProduct/HotNewProduct.png')
              .margin({ top: 8 })
              .objectFit(ImageFit.Fill)
          }
          .justifyContent(FlexAlign.SpaceEvenly)
          .margin({ left: 8 })
          .layoutWeight(1)
        }
        .margin({ left: 13, right: 13, top: 8 })


        Column() {
          Stack() {
            Image($r('app.media.app_home_guojiaguan_title_background')).height(30)
            Text('- 国家馆 -')
              .fontColor('#ffffff')
              .fontWeight('bold')
          }
          .width('100%')
          //不要在外层设置borderRadius，因为外层的宽度是100%，没有背景色，是看不出来的
          .borderRadius({topLeft:8,topRight:8})
          .linearGradient({
            repeating: true,
            direction: GradientDirection.Bottom,
            colors: [[0xffe4d2, 0], [0xffffff, 1]]
          })

          List({space:15}){//设置List的item之间的间隔
            ForEach(this.bannerInternationalList,(item:BannerInternationalEntity)=>{
              ListItem(){
                Image(item.picture)
                  .height(60)
                  .backgroundColor(Color.Blue)
                  .objectFit(ImageFit.Fill)
                  .clip(new Circle({ width: 60, height: 60 }))//设置图片为圆角
              }
            })
          }
          .padding({top:15,left:13,right:13,bottom:15})
          .width('100%')
          .backgroundColor(Color.White)
          .borderRadius({bottomLeft:8,bottomRight:8})
          .listDirection(Axis.Horizontal)
        }
        .margin({top:8})
        .width('100%')
        .padding({left:13,right:13})//设置外层的宽度为屏幕的宽度
        //   // 设置组件自身的宽度，缺省时使用元素自身内容需要的宽度。若子组件的宽大于父组件的宽，则会画出父组件的范围。
        //
        Column() {
          Stack() {
            Image($r('app.media.app_home_guojiaguan_title_background')).height(30)
            Text('- 品牌馆 -')
              .fontColor('#ffffff')
              .fontWeight('bold')
          }
          .width('100%')
          //不要在外层设置borderRadius，因为外层的宽度是100%，没有背景色，是看不出来的
          .borderRadius({topLeft:8,topRight:8})
          .linearGradient({
            repeating: true,
            direction: GradientDirection.Bottom,
            colors: [[0xffe4d2, 0], [0xffffff, 1]]
          })

          List({space:15}){//设置List的item之间的间隔
            ForEach(this.brandHallList,(item:BrandHallEntity)=>{
              ListItem(){
                Image(item.appPictrueAddress)
                  .height(60)
                  .border({color:'#eeeeee',width:1}).borderRadius(1000)
                  .clip(new Circle({ width: 60, height: 60 }))//设置图片为圆角
              }
            })
          }
          .padding({top:15,left:13,right:13,bottom:15})
          .width('100%')
          .backgroundColor(Color.White)
          .borderRadius({bottomLeft:8,bottomRight:8})
          .listDirection(Axis.Horizontal)
        }
        .margin({top:8})
        .width('100%')
        .padding({left:13,right:13})

        Column() {
          Row({space:10}){
            Image($r('app.media.app_home_guojiaguan_title_background')).width(90).height(90)
            Column(){
              Text('dsfd').fontSize('14').width('100%')
              Blank()
              Row(){
                Text('我是按钮前文')
                Blank()
                Button('立即查看',{type:ButtonType.Capsule}).width(80).height(35).onClick(()=>{
                  // Logger.debug('当前索引值：'+ index.toString() + '，当前item：' + title)
                })
              }
              .width('100%')
              .backgroundColor(Color.Orange)
            }
            .layoutWeight(1) // 占满主轴方向剩余空间
            .height(80)
            .justifyContent(FlexAlign.SpaceBetween)
            .backgroundColor(Color.Pink)
          }
          .width('100%')
          .padding(10)
          Divider().color('#F2F2F2').strokeWidth(1).margin({left:10,right:10})
        }.width('100%')

        Column(){
          Row(){
            Text('名庄优品')
              .layoutWeight(1)
              .fontColor('#e8eb1100')
              .fontWeight(FontWeight.Bold)//设置字体为粗体
              .fontStyle(FontStyle.Italic)//设置字体为斜体
              .fontSize(17)
              .margin({left:17})
            Row(){
              Text('更多')
                .fontColor('#7b7b7b')
                .fontSize(14)
              Image($r('app.media.home_main_right_arrow'))
                .height(12)
                .margin({left:7})
            }
            .margin({right:17})
          }
          .linearGradient({
            repeating: true,
            direction: GradientDirection.Bottom,
            colors: [[0xffe4d2, 0], [0xffffff, 1]]
          })
          .borderRadius({
            topLeft:8,
            topRight:8
          })
          .padding({top:20})


          List({space:12}){
            ForEach(this.famousProductList,(item:FamousProductListEntity)=>{
            // ForEach([1,2,3,4],(item:number)=>{
              ListItem(){
                Column(){
                  //这里加一个Row的作用是要在图片外层加一个边框，但是图片如果宽度太窄的话边框只会包裹图片不能充满左右
                  Row(){
                    Image('https://image.59cdn.com/static/upload/image/product/20240312/o_17102246991345.png')
                      .height(179)
                      .backgroundColor(Color.White)
                      .alignSelf(ItemAlign.Center)
                  }
                  .padding({top:10,bottom:10})//设置图片上下的内边距
                  .width('100%')//设置图片的外层宽度为100%
                  .border({color:'#c5c5c5',width:1})
                  .justifyContent(FlexAlign.Center)
                  Text(item.cname)
                    .fontColor('#343434')
                    .fontSize(14)
                    .margin({top:6})
                    .maxLines(1)//最大一行
                    .backgroundColor(Color.Green)
                    .align(Alignment.BottomEnd)
                    .textOverflow({overflow:TextOverflow.Ellipsis})//末尾省略

                  Text('我是Text') {
                    Span('¥')
                      .fontColor('#ec6e20')
                      .fontSize(14)
                    Span('16')
                      .fontColor('#ec6e20')
                      .fontSize(16)
                    Span('.')
                      .fontColor('#ec6e20')
                      .fontSize(14)
                    Span('00')
                      .fontColor('#ec6e20')
                      .fontSize(14)
                    Span('/瓶')
                      .fontColor('#ec6e20')
                      .fontSize(14)
                  }
                  .margin({top:5})
                  .maxLines(1)//最大一行
                  .textOverflow({overflow:TextOverflow.Ellipsis})//末尾省略
                }
                .width('100%')//设置每个item宽度充满
                .alignItems(HorizontalAlign.Start)
                .backgroundColor(Color.White)
              }
              .margin({right:8})
            })
          }
          .width('100%')
          .borderRadius({
            bottomLeft:8,
            bottomRight:8
          })
          .padding({left:11,right:11,top:20})
          .lanes(2)
          .backgroundColor(Color.White)
        }
        .margin({left:13,right:13})
        //
        // Tabs(){
        //   TabContent(){
        //     this.tabPageItemView('aaa')
        //   }
        //   TabContent(){
        //     this.tabPageItemView('bbb')
        //   }
        // }
        //
        // //5个tab和pageview
        // Column(){
        //   List({scroller:this.listController}){
        //     ForEach(['起泡甜白','流行通货','缤纷起泡','新颖小瓶','精装佳酿'],(item:string,index:number)=>{
        //       ListItem(){
        //         this.tabItem(item,index)
        //       }
        //     })
        //   }
        //   .padding({top:18,left:9,right:9})
        //   .borderRadius({
        //     topLeft:8,
        //     topRight:8
        //   })
        //   .linearGradient({
        //     repeating: true,
        //     direction: GradientDirection.Bottom,
        //     colors: [[0xffe4d2, 0], [0xffffff, 1]]//顶部渐变色
        //   })
        //   .width('100%')
        //   .listDirection(Axis.Horizontal)
        //
        //   Swiper(this.swiperController) {
        //     this.tabPageItemView('aaa')
        //     this.tabPageItemView('aaa')
        //     this.tabPageItemView('aaa')
        //     this.tabPageItemView('aaa')
        //     Text('流行通货')
        //   }
        //   .onChange( (index: number) => {
        //     this.selectedTabIndex = index;
        //     this.listController.scrollToIndex(index)
        //     console.log(`onChange ${index}`)
        //   })
        //   .index(this.selectedTabIndex)
        //   .padding({top:15})
        //   .loop(false)
        //   .padding({ left: 10, right: 2 }) //距离右边距离为2，因为item之间设置的距离为8
        //   .backgroundColor(Color.White)
        //
        //   Row() {
        //     Text('更多')
        //       .fontSize(14)
        //       .fontColor('#7b7b7b')
        //     Image($r('app.media.home_main_right_arrow'))
        //       .height(12)
        //       .margin({left:5})
        //   }
        //   .width('100%')
        //   .justifyContent(FlexAlign.Center)
        //   .backgroundColor(Color.White)
        //   .padding({top:15,bottom:13})
        //   .borderRadius({
        //     bottomLeft: 8,
        //     bottomRight: 8
        //   })
        // }
        // .width('100%')
        // .margin({top:8})
        // .padding({left:13,right:13})
        //
        // //瀑布流
        // //注意：Scroll嵌套WaterFlow滚动时无法联动，api10已经解决
        // //参考链接：https://developer.huawei.com/consumer/cn/forum/topic/0204137264128132694
        // WaterfallFlowPage()
      }
      .backgroundColor($r('app.color.eeeeee'))
    }
    .scrollBar(BarState.Off) //隐藏滚动条
    .edgeEffect(EdgeEffect.Spring) //滚动到边缘回弹
    .height('100%')
  }

  //使用hdc命令的时候需要使用下面目录中的hdc，否则执行hdc命令会有问题
  //C:\Users\cuiboye\AppData\Local\Huawei\Sdk\hmscore\3.1.0\toolchains

  @Builder tabItem(item:string,index:number){
    Text(item)
      .fontSize(this.selectedTabIndex == index?20:12)
      .fontColor(this.selectedTabIndex == index? $r('app.color.f56e1d') : $r('app.color.999999'))//未选中是474747这个颜色
      .margin({right:13})
      .onClick(()=>{
        this.selectedTabIndex = index;
        console.log(`selectedTabIndex ${index}`)
        // this.swiperController.
      })
  }

  //5个tab的页面item
  @Builder tabPageItemView(name: string) {
    List() {
      ForEach([1, 2, 3, 4,5,6], (item: number) => {
        ListItem() {
          Column() {
            Image('https://image.59cdn.com/static/upload/image/product/20170915/o_1505468820337.jpg')
              .height(125)
              .border({width:1,color:'#eeeeee'})
            Text(name).textAlign(TextAlign.Center)
              .fontColor(Color.Black)
              .margin({top:6})
              .fontColor('#343434')
              .fontSize(14)
          }
          .margin({right:8})//设置水平item之间的间隔后，最右侧需要减去5像素
        }
      })
    }
    .divider({strokeWidth:10,color:Color.White})//设置item上下之间的距离
    .lanes(3)
  }
}