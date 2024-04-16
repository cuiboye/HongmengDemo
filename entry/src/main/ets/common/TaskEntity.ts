export default class ShopInfo {
  // id: number
  // name: string
  // images: string[]
  // area: string
  // address: string
  // avgPrice: number
  // comments: number
  // score: number
  // openHours: string

  code:number
  msg:string
  data:Data
}

class Data{
  dataBoardTabs:DataBoardTabs[]
}

class DataBoardTabs{
  "code": string
  "name": string
}