
/**
 * 状态管理 @State
 */
class Person{
  name:string
  age:number
  gl:Person

  constructor(name:string,age:number,gl?:Person) {
    this.name = name
    this.age = age
    this.gl = gl
  }
}
@Entry
@Component
struct StatePage {
  @State person:Person = new Person('Jack',21,new Person('Rose',20))

  build() {
    Column() {
      Row(){
        Text(this.person.name)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Text(`${this.person.age}`).onClick(()=>{
          this.person.age++
        }).fontSize(50)
      }
      //@State不能触发对象嵌套对象中的属性
     Row(){
       Text(`${this.person.gl.name}`)
         .fontSize(50)
         .fontWeight(FontWeight.Bold)
       Text(`${this.person.gl.age}`).onClick(()=>{
         this.person.gl.age++
       }).fontSize(50)
     }
    }
    .height('100%')
    //@State也不能触发数组中对象属性的修改，只能触发数组的更新
  }
}