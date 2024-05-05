@Component
export default struct ClassifyItem{
  classifyName:string
  onClickItem = ()=>{}
  @Prop isSelected:boolean
  build(){
  // f56e1d 343434
    if(this.classifyName){
      Text(`${this.classifyName}`)
        .fontColor(this.isSelected?$r('app.color.f56e1d'):$r('app.color.343434'))
        .fontSize(14)
        .onClick(this.onClickItem)
    }
  }
}