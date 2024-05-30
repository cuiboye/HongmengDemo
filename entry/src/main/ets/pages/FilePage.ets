/**
 * 文件操作
 */
import common from '@ohos.app.ability.common'
import { CommonHeader } from '../common/common_header'
@Entry
@Component
struct FilePage {
  private context = getContext(this) as common.UIAbilityContext

  build() {
    Column() {
      CommonHeader({title:'文件相关'})
      Button('获取文件路径')
        .onClick(()=>{
          let cacheDir = this.context.cacheDir;
          console.log(`cacheDir的路径为：${cacheDir}`)

          let tempDir = this.context.tempDir;
          console.log(`tempDIr的路径为：${tempDir}`)

          let fileDir = this.context.filesDir;
          console.log(`fileDir的路径为：${fileDir}`)

          let databaseDir = this.context.databaseDir;
          console.log(`databaseDir的路径为${databaseDir}`)

          let bundleCodeDir = this.context.bundleCodeDir;
          console.log(`bundleCodeDir的路径为${bundleCodeDir}`)

          let distributeFilesDir = this.context.distributedFilesDir;
          console.log(`distributeFileDir的路径为${distributeFilesDir}`)

          let preferencesDir = this.context.preferencesDir;
          console.log(`preferenceDir的路径为${preferencesDir}`)

          //输出结果：
          // cacheDir的路径为：        /data/storage/el2/base/haps/entry/cache
          // tempDIr的路径为：         /data/storage/el2/base/haps/entry/temp
          // fileDir的路径为：         /data/storage/el2/base/haps/entry/files
          // preferenceDir的路径为     /data/storage/el2/base/haps/entry/preferences

          // databaseDir的路径为       /data/storage/el2/database/entry
          // bundleCodeDir的路径为     /data/storage/el1/bundle
          // distributeFileDir的路径为 /data/storage/el2/distributedfiles
        })

      Button('获取其它应用或Module的context')
        .onClick(()=>{
          let context = getContext().createModuleContext('sharelibrary')
          let cacheDir = context.cacheDir;
          console.log(`sharelibrary中的cacheDir路径为：${cacheDir}`)
          //输出结果：/data/storage/el2/base/cache
        })
    }
    .height('100%')
  }
}