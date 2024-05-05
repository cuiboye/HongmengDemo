import axios from '@ohos/axios'
import { MatchPattern } from '@ohos.UiTest';
import ShopInfo, {
  AnnouncementAppNewIndexCategoriesEntity,
  AppNewIndexCategoriesEntity,
  BannerInternationalEntity,
  BrandHallEntity,
  FamousProductListEntity,
  HomeButtonAppNewIndexCategoriesEntity,
  KindSetEntity,
  ProductInfoListEntity
} from '../../TaskEntity';
import { WaterfallFlowPage } from '../../waterfall_flow_page';
import observer from '@ohos.telephony.observer';

import common from '@ohos.app.ability.common';
import util from '@ohos.util';
import hilog from '@ohos.hilog';
import { indexInfo } from '../../../../common/constants/Constants';
import BreakpointSystem from '../../../../common/MediaData';
import HomeBanner from './home_banner';
import HomeButton from './home_button';
import HomeOrder from './home_order';
import HomeNews from './home_news';
import NationalPavilion from './national_pavilion';
import BrandPavilion from './brand_pavilion';
import HomeExcellentProducts from './home_excellent_products';
import HomeKindList from './home_kind_list';
import { CommonHeader } from '../../../../common/common_header';
import HomeSearch from './home_search';

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
  //最好给Provider设置一个别名，不然变量名被修改可能会有问题
  //轮播图数据
  @Provide('bannerList') bannerList: AppNewIndexCategoriesEntity[] = []
  //棋盘格数据
  @Provide('homeButtonList') homeButtonList: HomeButtonAppNewIndexCategoriesEntity[] = []
  //国家馆
  @Provide('bannerInternationalList') bannerInternationalList: BannerInternationalEntity[] = []
  //品牌馆
  @Provide('brandHallList') brandHallList: BrandHallEntity[] = []
  //名庄优品
  @Provide('famousProductList') famousProductList: FamousProductListEntity[] = []
  //新闻
  @Provide('newsList') newsList: AnnouncementAppNewIndexCategoriesEntity[] = []
  @Provide('kindSetList') kindSetList: KindSetEntity[] = []

  @StorageProp('topStatusHeight') topStatusHeight: number = 0

  aboutToAppear() {
    //1)
    //===start用于预览测试，使用的时本地数据===
    this.bannerList = indexInfo.result.indexList.focus_picture.appNewIndexCategories
    this.homeButtonList = indexInfo.result.indexList.home_button.appNewIndexCategories
    this.bannerInternationalList = indexInfo.result.banner_international
    this.brandHallList = indexInfo.result.brandHall
    this.famousProductList = indexInfo.result.famousProducts.famousProductList
    this.newsList = indexInfo.result.indexList.announcement.appNewIndexCategories
    this.kindSetList = indexInfo.result.kindSet
    //===end用于预览测试，使用的时本地数据===


    //2)接口请求数据
    // this.getShopListByAxiosAsync().then(indexInfo => {
    //   if(indexInfo.states == 200){
    //     this.bannerList = indexInfo.result.indexList.focus_picture.appNewIndexCategories
    //     this.homeButtonList = indexInfo.result.indexList.home_button.appNewIndexCategories
    //     this.bannerInternationalList = indexInfo.result.banner_international
    //     this.brandHallList = indexInfo.result.brandHall
    //     this.famousProductList = indexInfo.result.famousProducts.famousProductList
    //     this.newsList = indexInfo.result.indexList.announcement.appNewIndexCategories
    //     this.kindSetList = indexInfo.result.kindSet
    //   }
    // })


    //3)获取rawfile中的json数据，然后转为实体类
    // let context = getContext(this) as common.UIAbilityContext;
    //  //这里有个坑，resourceManager在预览模式不支持
    // const rm = context.resourceManager;
    //  rm.getRawFileContent("index.json").then(value => {
    //   let rawFile = value;
    //   let textdecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true })
    //   let retStr = textdecoder.decodeWithStream(rawFile, { stream: false });
    //   // console.log('host_config打印: ' + JSON.stringify(retStr));
    //    //打印日志使用hilog，使用console日志有的打印不出来
    //
    //    //JSON.stringify：将字符串转为json
    //    // JSON.parse 将json转为对象
    //   hilog.info(100,'host_config打印1: ' , JSON.stringify(retStr));
    //    let dataBean = JSON.parse(retStr) as ShopInfo
    //    hilog.info(100,'host_config打印3: ' , dataBean.states.toString());
    // })
  }

  // async getShopListByAxiosAsync(): Promise<ShopInfo> {
  //   // 1.发送请求
  //   let resp = await axios.get(
  //     // `${this.baseURL}/shops`,
  //     'https://mock.apifox.com/m1/3626399-3255008-default/cby/index',
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
    Column(){
      CommonHeader({showTitleBar:false})
      HomeSearch()
      Scroll() {

        Column() {
          HomeBanner()
          HomeButton()
          HomeOrder()
          HomeNews()
          NationalPavilion()
          BrandPavilion()
          HomeExcellentProducts()
          HomeKindList()
        }
        //
        //   //比较使用 ===
        //
        //   //todo
        //   //注意：如果Grid的最外层是Scroll的话，会导致Grid无法滑动，可以将Grid替换为List 通过list的lanes属性可
        //   // 以达到grid的效果。 在外层使用scroll包裹导致的滑动冲突替换为list后也没有了
        //
        //   //
        //   // //瀑布流
        //   // //注意：Scroll嵌套WaterFlow滚动时无法联动，api10已经解决
        //   // //参考链接：https://developer.huawei.com/consumer/cn/forum/topic/0204137264128132694
        //   // WaterfallFlowPage()
        // }
        // .backgroundColor($r('app.color.eeeeee'))
        // .justifyContent(FlexAlign.Start)
      }
      .scrollBar(BarState.Off) //隐藏滚动条
      .edgeEffect(EdgeEffect.Spring) //滚动到边缘回弹
      .layoutWeight(1)
    }.backgroundColor($r('app.color.eeeeee'))
  }
  //鸿蒙上架应用市场指南：
  //https://developer.huawei.com/consumer/cn/doc/app/agc-help-harmonyos-releaseapp-0000001126380068

  //使用hdc命令的时候需要使用下面目录中的hdc，否则执行hdc命令会有问题
  // windows
  // C:\Users\cuiboye\AppData\Local\Huawei\Sdk\hmscore\3.1.0\toolchains

  // Mac,注意：格式不能变，否则hdc命令会不生效
  // export PATH=/Users/tom/Library/Huawei/Sdk/hmscore/3.1.0/toolchains:$PATH

  //如果ohpm没有了，可以在Build,Execution,Deployment中的Ohpm选项中下载
}

//报错：Failed to find the incremental input file: /Users/tom/.ohos/config/auto_debug_HongmengDemo_com.example.myapplication_890086000102043708.cer.
//解决：
// 1）删除build-profile.json5文件内，signingConfigs对应部份的内容后解决了，删除后形如： "signingConfigs": []
// 2）点击File ——》Project Structure——》Project ——》Signing Configs 选择 Automatically generate signature 自动签名就可以了

