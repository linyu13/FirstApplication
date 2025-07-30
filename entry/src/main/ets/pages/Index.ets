import { HMDefaultGlobalAnimator, HMNavigation } from '@hadss/hmrouter';
import { AttributeUpdater } from '@kit.ArkUI';
import { StartNavigation, StartPage } from '../data/PageUrl';

@Entry
@Component
struct Index {
  modifier: MyNavModifier = new MyNavModifier();

  // onPageShow(): void {
  //   prefMangerFunction()
  // }

  // pageStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!

  build() {

    Column() {
      // Text("This is Index")
      HMNavigation({
        navigationId: StartNavigation, homePageUrl: StartPage,
        options: {
          standardAnimator: HMDefaultGlobalAnimator.STANDARD_ANIMATOR,
          dialogAnimator: HMDefaultGlobalAnimator.DIALOG_ANIMATOR,
          modifier: this.modifier
        }
      })


    }
  }
}

// function prefMangerFunction() {
//   const prefManger = PreferencesManager.getInstance()
//
//   prefManger.init(getContext(), "LayOut")
//
// }

class MyNavModifier extends AttributeUpdater<NavigationAttribute> {
  initializeModifier(instance: NavigationAttribute): void {
    instance.mode(NavigationMode.Stack);
    // instance.hideNavBar(true) //这句会导致底部导航不展示
    instance.navBarWidth('100%')
    instance.hideTitleBar(true)
    instance.hideToolBar(true)
  }
}
