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
import { StartImageData } from '../data/StartImageData';
// import { ImageItem } from '../models/Image';

@HMRouter({
  pageUrl: 'StartPage'
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
    // }

  @State StartImageIndex: number = 0
  @State SlideOffset: number = 0
  totalDx: number = 0
  screenWidth: number = 720 // 默认宽度
  build() {
    // Text("This is Start")
    Stack(){
      Image(StartImageData[this.StartImageIndex].link)
        .width("100%")
        .height("100%")
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }
    .gesture(
      PanGesture({direction: PanDirection.Horizontal})
        .onActionUpdate((event: GestureEvent) => {
          this.totalDx += event.offsetX
        })
        .onActionEnd(() => {
          if (this.totalDx < -this.screenWidth / 2) {
            if (this.StartImageIndex < StartImageData.length - 1) {
              this.StartImageIndex += 1
            } else {
              HMRouterMgr.push({
                pageUrl: 'Preferred'
              })
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