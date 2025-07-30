// import { StartImageData } from "../data/StartImageData";
//
// @Builder
// export function StartBuilder() {
//   Start();
// }
//
// @Component
// struct Start {
//   pageStack: NavPathStack = new NavPathStack();
//   @State StartImageIndex: number = 0
//   @State SlideOffset: number = 0
//   totalDx: number = 0
//   screenWidth: number = 720 // 默认宽度
//   build() {
//     NavDestination() {
//       // Text("This is Start")
//       Stack(){
//         Image(StartImageData[this.StartImageIndex].link)
//           .width("100%")
//           .height("100%")
//           .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
//       }
//         .gesture(
//           PanGesture({direction: PanDirection.Horizontal})
//             .onActionUpdate((event: GestureEvent) => {
//               this.totalDx += event.offsetX
//             })
//             .onActionEnd(() => {
//               if (this.totalDx < -this.screenWidth / 2) {
//                 if (this.StartImageIndex < StartImageData.length - 1) {
//                   this.StartImageIndex += 1
//                 } else {
//                   this.pageStack.replacePathByName("Preferred", null, false)
//                 }
//               } else if (this.totalDx > this.screenWidth / 2) {
//                 if (this.StartImageIndex > 0) {
//                   this.StartImageIndex -= 1
//                 }
//               }
//               this.totalDx = 0
//             })
//         )
//
//     }.onReady((context: NavDestinationContext) => {
//       this.pageStack = context.pathStack;
//     })
//
//   }
// }
import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { LayOutPage, PreferredPage, StartNavigation, StartPage } from '../../data/PageUrl';
import { StartImageData } from '../../data/StartImageData';
import { JwtPayload } from '../../data/variable';
import { PreferencesManager } from '../../service/preference';
import { base } from '../../service/token';

// import { ImageItem } from '../models/Image';

@HMRouter({
  pageUrl: StartPage
})
@Component
export struct Start {
  // @State StartImageIndex: number = 0
  // @State SlideOffset: number = 0
  // totalDx: number = 0
  // screenWidth: number = 720 // 默认宽度

  // Tabs() {
  //   TabContent() {
  //     Text("This is Start")
  //   }
  //   ForEach(StartImageData, (item: ImageItem) => {
  //     TabContent() {
  //       Image(item.link)
  //         .height("100%")
  //         .width("100%")
  //         .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  //     }
  //   })
  // }
  // .onChange((index: number) => {
  //   this.StartImageIndex = index
  //   if (index > StartImageData.length - 1) {
  //     HMRouterMgr.push({
  //       pageUrl: 'Preferred'
  //     })
  //   }
  // })
  @State StartImageIndex: number = 0
  @State SlideOffset: number = 0
  token: string = ""
  totalDx: number = 0
  screenWidth: number = 720 // 默认宽度
  // }
  // private prefManager = new PreferencesManager
  prefManager = PreferencesManager.getInstance()

  build() {
    // Text("This is Start")
    Stack() {
      Image(StartImageData[this.StartImageIndex].icon)
        .width("100%")
        .height("100%")
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }
    .gesture(
      PanGesture({ direction: PanDirection.Horizontal })
        .onActionUpdate((event: GestureEvent) => {
          this.totalDx += event.offsetX
        })
        .onActionEnd(async () => {
          if (this.totalDx < -this.screenWidth / 2) {
            if (this.StartImageIndex < StartImageData.length - 1) {
              this.StartImageIndex += 1
            } else {
              // const value = ""
              const value = this.prefManager.getData("TOKEN_KEY")
              // let value = PreferencesManager.getValue("TOKEN_KEY", "")
              try {
                const res: JwtPayload = base((value + ""))
                AppStorage.set("UserID", res.user_id)
                if (res.exp > Math.floor(Date.now() / 1000)) {

                  HMRouterMgr.replace({
                    pageUrl: LayOutPage
                  })
                } else {
                  HMRouterMgr.replace({
                    navigationId: StartNavigation,
                    pageUrl: PreferredPage
                  })
                }
              } catch (err) {
                console.log(err)
                HMRouterMgr.push({
                  navigationId: StartNavigation,
                  pageUrl: PreferredPage
                })
              }
            }
          } else if (this.totalDx > this.screenWidth / 2) {
            if (this.StartImageIndex > 0) {
              this.StartImageIndex -= 1
            }
          }
          this.totalDx = 0
        })
    )

  }
}
