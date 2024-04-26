
import router from '@ohos.router'
/**
 * 第一个页面
 */
@Entry
@Component
struct FirstRouter {
  @State message: string = 'Hello World'

  build() {
    Row() {
      Button('跳转到下一个页面并携带参数').onClick(() => {
        router.pushUrl(
          {
            url: 'pages/routerdemo/second_router',
            params: {
              id: 123,
              name: '张三'
            }
          })
      })
    }
    .height('100%')
  }

  onPageShow(){
    const params = router.getParams();
    if(params){
      const backParams:string = params['backParams']
      console.log(`接受不返回的参数为：${backParams}`)
    }
  }
}