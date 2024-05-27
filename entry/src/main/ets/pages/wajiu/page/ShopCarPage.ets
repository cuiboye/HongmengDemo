
import { ProductItem } from '../adapter/ProductItem'
import { ShopCarModel } from './model/ShopcarModel'
/**
 * 购物车
 */
@Entry
@Component
export struct ShopCarPage {
  // @State @Watch('selectProductChange') productArray :ShopCarModel[] = []
  @State productArray :ShopCarModel[] = []

  @State totalPrice:number = 0
  //当前是否是全选
  @State selectedAll:boolean = false


  // selectProductChange(index: number): boolean {
  //   if (this.productArray[index] !== undefined) {
  //     return this.productArray[index].selected;
  //   }
  //   return false;
  // }
  aboutToAppear(){
    //添加两条商品模拟数据
    let shopCarModel1 = new ShopCarModel()
    shopCarModel1.selected  = false
    shopCarModel1.productName  = '商品1'
    shopCarModel1.productPrice = 100
    this.productArray.push(shopCarModel1)

    let shopCarModel2 = new ShopCarModel()
    shopCarModel2.selected  = false
    shopCarModel2.productName  = '商品2'
    shopCarModel2.productPrice = 200
    this.productArray.push(shopCarModel2)
  }

  build() {
    Column() {
      Scroll(){
        Column(){
          List(){
            ForEach(this.productArray,(item:ShopCarModel,index:number)=>{
              ListItem(){
                ProductItem({
                  item:this.productArray[index],
                  totalPrice:$totalPrice,
                  productArray:this.productArray,
                  selectedAll:$selectedAll
                })
              }
            })
          }
          Text('猜你喜欢')
          List(){
            ForEach([1,2,3,4,5,6],()=>{
              ListItem(){
                Column(){
                  Text('商品').height(150)
                Text('价钱').backgroundColor('#00a0e9')
                }
              }
            })
          }
        }
      }.layoutWeight(1)
      Row(){
        Row(){
          Image(this.selectedAll ? $r('app.media.selected_product') : $r('app.media.unselected_product'))
            .height(24)
            .width(24)
            .onClick(()=>{
              if(this.selectedAll){

              }
              this.productArray.forEach((item:ShopCarModel)=>{
                this.totalPrice += item.productPrice
                // this.productArray[0].selected = true
              })
            })
          Text('全选')
        }.layoutWeight(1)
        Text(`总计：${this.totalPrice}`)
        Text('结算').margin({left:13,right:13})
      }
    }
    .height('100%')
  }


}