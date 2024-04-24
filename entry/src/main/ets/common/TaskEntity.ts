export default class ShopInfo {
  states:number
  msg:string
  result:Data
}

export class Data{
  indexList:IndexListEntity
  banner_international:BannerInternationalEntity[]
  brandHall:BrandHallEntity[]
  famousProducts:FamousProductsEntity
}

export class DataBoardTabs{
  "code": string
  "name": string
}

export class IndexListEntity{
  focus_picture:FocusPictureEntity
  home_button:HomeButtonEntity
}

export class FocusPictureEntity{
  appNewIndexCategories:AppNewIndexCategoriesEntity[]
}

export class AppNewIndexCategoriesEntity{
  picture:string
}


export class HomeButtonEntity{
  appNewIndexCategories:HomeButtonAppNewIndexCategoriesEntity[]
}

export class HomeButtonAppNewIndexCategoriesEntity{
  indexName:string
  picture:string
}

export class BannerInternationalEntity{
  picture:string
}

export class BrandHallEntity{
  appPictrueAddress:string
}

export class FamousProductsEntity{
  famousProductList:FamousProductListEntity[]
}

export class FamousProductListEntity{
  cname:string
  picture:string
}
