import ArrayList from '@ohos.util.ArrayList'

//枚举
enum SexValue{
  MAIL = '男',
  FEMAIL = '女'
}

//3）使用别名来明明函数类型
//语法 (a: string) => void 的意思是“一个带有一个参数、名为 a、类型为 string、没有返回值的
//函数”。就像函数声明一样，如果未指定参数类型，则隐式为 any。
type Success = (str:string)=>void
type Success2 = (str:string)=>number
//请注意，参数名称是必需的。函数类型 (string) => void 的意思是“一个带有名为 string、类
//型为 any 的参数的函数”！


@Entry
@Component
struct Index {
  @State message: string = 'Hello World'

  personSize:number = 12
  isPass :boolean = true

  success:Success
  success2:Success2
  //定义数组
  //第一种
  arr1 :number[]=[1,2,3,4,5]
  //第二种
  arr2:Array<string> = ['a','b','c']

  //元组，类似于解构，数量是固定的，比如第一个类型是string，那么后面的第一个值hello只能是string类型
  f1:[string,number] =  ['hello',5]

  //Null:值为null
  result = null

  //undefined:没有定义该变量
  result2 = undefined

  //联合类型，该类型即可以赋值为string，也可以赋值为number类型的
  result3:string | number = 'hello'

  //数组
  play(){
    //获取数组中的元素
    this.arr1[0]
    //添加元素到数组
    this.arr1.push(6)
    //删除数组中的元素
    this.arr1.pop()
    this.success('s')
    this.success2('s')

    //添加和删除数组中指定位置的元素
    this.arr2.splice(2,0,'word')//在数组中的第二个位置添加一个元素'word'，第二个参数0表示添加
    this.arr2.splice(2,1)//删除下标为2的元素，第二个参数1表示删除
  }

  //for循环
  play2(){
    let arr3:Array<string> = ['a','b','c']
    for(const i in arr3){
      console.log(arr3[i])
    }

    for(let j=0;j<arr3.length;j++){
      console.log(arr3[j])
    }


    this.play4(10)
    this.play5(10,'s',[10])
  }

  //函数
  //1）可选参数:使用?修饰变量
  play4(size:number,result?:string){}

  //2）剩余参数
  play5(size:number,...numbs:Array<number>){}
  play6(size:number,...numbs:number[]){}


  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%').backgroundColor(Color.Red)
  }
}