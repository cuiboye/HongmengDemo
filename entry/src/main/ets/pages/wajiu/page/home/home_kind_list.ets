
import { KindSetEntity, ProductInfoListEntity } from '../../TaskEntity'
/**
 * 5个tab
 */
@Component
export default struct HomeKindList{
  //swiper的控制器
  private swiperController: SwiperController = new SwiperController()
  //list的控制器
  private listController:Scroller = new Scroller()

  @Consume('kindSetList') kindSetList:KindSetEntity[]
  @State selectedTabIndex:number = 0

  build(){
    if(this.kindSetList && this.kindSetList.length>0){
      Column(){
        List({scroller:this.listController}){
          ForEach(this.kindSetList,(item:KindSetEntity,index:number)=>{
            ListItem(){
              this.tabItem(item?.kindName??'',index)
            }
          })
        }
        .alignListItem(ListItemAlign.Center)
        .padding({top:18,left:9,right:9})
        .borderRadius({
          topLeft:8,
          topRight:8
        })
        .linearGradient({
          repeating: true,
          direction: GradientDirection.Bottom,
          colors: [[0xffe4d2, 0], [0xffffff, 1]]//顶部渐变色
        })
        .width('100%')
        .listDirection(Axis.Horizontal)

        Swiper(this.swiperController) {
          ForEach(this.kindSetList,(item:KindSetEntity)=>{
            this.tabPageItemView(item.productInfoList??[])
          })
        }
        .onChange( (index: number) => {
          this.selectedTabIndex = index;
          this.listController.scrollToIndex(index)
          console.log(`onChange ${index}`)
        })
        // .index(this.selectedTabIndex)
        .index(2)
        .padding({top:15})
        .loop(false)
        .padding({ left: 10, right: 2 }) //距离右边距离为2，因为item之间设置的距离为8
        .backgroundColor(Color.White)

        Row() {
          Text('更多')
            .fontSize(14)
            .fontColor('#7b7b7b')
          Image($r('app.media.home_main_right_arrow'))
            .height(12)
            .margin({left:5})
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor(Color.White)
        .padding({top:15,bottom:13})
        .borderRadius({
          bottomLeft: 8,
          bottomRight: 8
        })
      }
      .width('100%')
      .margin({top:8})
      .padding({left:13,right:13})
    }
  }

  @Builder tabItem(item:string,index:number){
    Text(item)
      .fontSize(this.selectedTabIndex == index?20:16)
      .fontColor(this.selectedTabIndex == index? $r('app.color.f56e1d') : $r('app.color.999999'))//未选中是474747这个颜色
      .margin({right:13})
      .onClick(()=>{
        this.selectedTabIndex = index;
        console.log(`selectedTabIndex ${index}`)
      })
  }

  @Builder tabPageItemView(list: ProductInfoListEntity[]) {
    if(list && list.length>0){
      List() {
        ForEach(list, (item: ProductInfoListEntity) => {
          ListItem() {
            Column() {
              // .load(url + "?imageView2/2/w/" + viewWidht + "/h/" + viewHight + "/format/webp")
              //这个图片加载过慢，是因为图片太大，有1，2M
              Image(item.picture)
                .height(125)
                .border({width:1,color:'#eeeeee'})

              //插件imageknife和sdk9不兼容，暂时先不用
              // ImageKnifeComponent({imageKnifeOption:{loadSrc:item.picture,
              //   placeholderSrc:$r('app.media.default_image')
              // }})
              Text(item.cname).textAlign(TextAlign.Center)
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
}