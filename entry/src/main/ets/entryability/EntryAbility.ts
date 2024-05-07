import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import PreferencesUtil from '../common/utils/PreferencesUtil';

export default class EntryAbility extends UIAbility {
  async onCreate(want, launchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    // 初始化Preferences
    await PreferencesUtil.loadPreference(this.context, 'MyPreferences')
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');


    windowStage.loadContent('pages/Splash', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
    let windowClass: window.Window = null;
    windowStage.getMainWindow((err, data) => {
      // 1.获取应用主窗口
      windowClass = data;

      // 2.设置底部navigation导航栏显示、状态栏不显示。注意：需要显示哪个数组中就写哪个就行
      //status：顶部状态栏；navigation：底部导航栏
      //下面的数组中要设置“navigation”，如果不设置在有虚拟按键的情况下会不显示底部的导航
      windowClass.setWindowSystemBarEnable(['status','navigation'], (err) => {

      });
      // 3.设置全屏
      windowClass.setWindowLayoutFullScreen(true).then(() => {

      })

      windowClass.setWindowSystemBarProperties({
        statusBarColor: '#00a0e9',
        navigationBarColor: '#00a0e9',
        // 以下两个属性从API Version 8开始支持A03d00/JSAPP
        statusBarContentColor: '#00a0e9',
        navigationBarContentColor: '#00a0e9'
      })

      // 4.获取底部导航栏高度，此时的高度单位是px
      let navigationHeight = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).bottomRect.height
      let topStatusHeight = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height
      AppStorage.SetOrCreate<number>('topStatusHeight', topStatusHeight)
      AppStorage.SetOrCreate<number>('navigationHeight', navigationHeight)
    })
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
