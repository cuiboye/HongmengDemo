
import router from '@ohos.router'
/**
 * 第二个页面
 */
@Entry
@Component
struct SecondRouter {
  @State message: string = 'Hello World'

  aboutToAppear(){
    const params = router.getParams();
    const id:number = params['id'];
    const name:string = params['name'];
    console.log(`接受到的参数： id=${id},name=${name}`)
  }

  build() {
    Row() {
      Column() {
        Button('跳转到下一个页面并携带参数').onClick(() => {
          router.back({
            url:'pages/routerdemo/first_router',
            params:{'backParams':'secondRouter'}
          })
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}