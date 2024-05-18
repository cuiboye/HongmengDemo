/**
 * 获取组件的位置
 */
export class PositionUtils {
  //获取组件所占矩形区域坐标
  static getComponentRect(key): ComponentRect {
    let rect: ComponentRect = new ComponentRect();
    //通过getInspectorByKey这个api
    let strJson = getInspectorByKey(key)
    let obj = JSON.parse(strJson)
    console.log("[getInspectorByKey] current component obj is: " + JSON.stringify(obj))
    let rectInfo = JSON.parse('[' + obj.$rect + ']')
    console.log("[getInspectorByKey] rectInfo is: " + rectInfo)
    rect.left = JSON.parse('[' + rectInfo[0] + ']')[0]
    rect.top = JSON.parse('[' + rectInfo[0] + ']')[1]
    rect.right = JSON.parse('[' + rectInfo[1] + ']')[0]
    rect.bottom = JSON.parse('[' + rectInfo[1] + ']')[1]
    return rect;
  }


  static log(content: string) {
    console.log("长度验证:", content.length)
    const maxSize = 1000
    if (content.length <= maxSize) {
      //直接打印
      console.log(content)
    } else {
      while (content.length > maxSize) {
        let logContent = content.substring(0, maxSize)
        //内容超长，分段打印
        console.log(logContent)
        content = content.replace(logContent, "")
      }
      console.log(content)
    }
  }
}


export class ComponentRect {
  left: number = 0;
  top: number = 0;
  right: number = 0;
  bottom: number = 0;
}