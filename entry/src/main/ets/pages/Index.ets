import ArrayList from '@ohos.util.ArrayList'
import router from '@ohos.router'
import data from '@ohos.telephony.data'

//枚举
enum SexValue {
  MAIL = '男',
  FEMAIL = '女'
}

//3）使用别名来明明函数类型
//语法 (a: string) => void 的意思是“一个带有一个参数、名为 a、类型为 string、没有返回值的
//函数”。就像函数声明一样，如果未指定参数类型，则隐式为 any。
type Success = (str: string) => void //如果你需要接受任意函数但不打算调用它，则类型 () => void 通常更安全。

type Success2 = (str: string) => number
//请注意，参数名称是必需的。函数类型 (string) => void 的意思是“一个带有名为 string、类
//型为 any 的参数的函数”！


@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  myClickHandler(): void {
    console.log('HarmonyOS Hello!')
  }

  build() {
    Column() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }

      Button('click2').onClick(this.myClickHandler.bind(this))
      Button('跳转第二个页面').onClick(()=>{
        router.pushUrl(
          {
            url:'pages/secondpage',
            params:{name:'张三'}//传递的参数
          },
          router.RouterMode.Standard,//跳转模式 Single/Stantard
          err=>{
            if(err){
              console.log('路由失败')
              console.log(err.code+'')
              console.log(err.message)
              console.log(err.name)
            }
          },
        )
      })
    }
    .height('100%').backgroundColor(Color.Red)
  }
}
