
import { ShopCarModel } from './model/ShopcarModel'
/**
 * 购物车
 */
@Entry
@Component
export struct ShopCarPage {
  @State productArray :ShopCarModel[] = []

  @State totalPrice:number = 0
  //当前是否是全选
  @State selectedAll:boolean = false

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
                Row(){
                  Checkbox({
                    name:`checkout${index}`,
                    group:'checkboxgroup'
                  })
                    .height(24)
                    .width(24)
                    .onClick(()=>{
                      this.productArray[index].selected = !this.productArray[index].selected
                      console.log(`${JSON.stringify(this.productArray)}`)

                      if(this.productArray[index].selected){
                        this.totalPrice +=this.productArray[index].productPrice
                      }else {
                        this.totalPrice-=this.productArray[index].productPrice
                      }
                      this.selectedAll = this.productArray.every((item:ShopCarModel)=>item.selected)
                    })
                  Text(`${this.productArray[index].productName}`).layoutWeight(1)
                  Text(`${this.productArray[index].productPrice}`)
                }
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
          Checkbox({
            name:`checkoutAll`,
            group:'checkboxgroupAll'
          })
            .height(24)
            .width(24)
            .select(this.selectedAll)
            .onClick(()=>{
              this.selectedAll = !this.selectedAll
              if(this.selectedAll){
                // this.productArray.map((item:ShopCarModel)=>{
                //   this.totalPrice+=item.productPrice
                //   item.selected = true
                // })
                this.productArray.forEach((item:ShopCarModel)=>{
                  this.totalPrice += item.productPrice
                })
              }
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