import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { LogInPage, PreferredPage, RegisterPage, StartNavigation } from '../../data/PageUrl';

@HMRouter({
  pageUrl: PreferredPage
})
@Component
export struct Preferred {
  build() {
    // Text("This is Preferred")
    Stack() {
      // Text("欢迎").fontSize(30).fontColor(Color.White)
      List({ space: 6 }) {
        ListItem() {
          Button("登录")
            .width("80%")
            .fontColor(0x246ffd)
            .backgroundColor(0xe9f0ff)
            .onClick(() => {
              HMRouterMgr.push({
                navigationId: StartNavigation,
                pageUrl: LogInPage
              })
            })
        }

        ListItem() {
          Button("注册")
            .width("80%")
            .fontColor(0x181818)
            .backgroundColor(0x9bedf2)
            .onClick(() => {
              HMRouterMgr.push({
                navigationId: StartNavigation,
                pageUrl: RegisterPage
              })
            })
        }
      }
      .width("100%")
      .height("100%")
      .listDirection(Axis.Vertical)
      .alignListItem(ListItemAlign.Center)
    }
    .alignContent(Alignment.Center)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .height("100%")
    .width("100%")
    .linearGradient({
      angle: 90,
      direction: GradientDirection.RightBottom,
      colors: [[0xffffff, 0.0], [0xd2f2ff, 1.0]]
    })
  }
}