// import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
// import { PersonalHomePage, PersonInfoSetting } from '../../data/PageUrl';
// import { SettingImageLeft } from '../../data/SettingData';
// import { PersonTabData } from '../../data/TabClass';
// import { API_ENDPOINTS } from '../../data/variable';
// import { EmptyObject, HttpResult, UserInfoRe } from '../../models/httpResult';
// import { TabClass } from '../../models/TabClass';
// import { HttpRequest } from '../../service/HttpRequest';
// import { PreferencesManager } from '../../service/preference';
// import { dynamic } from './dynamic';
// import { evaluate } from './evaluate';
// import { MyProduct } from './MyProduct';
//
// @HMRouter({
//   pageUrl: PersonalHomePage
// })
// @Component
// export struct HomePage {
//   // Tab内容
//   @State currentIndex: number = 0;
//   @State animationDuration: number = 300;
//   @State indicatorLeftMargin: number = 0;
//   @State indicatorWidth: number = 0;
//   // UI内容
//   @State showUserPicture: boolean = false
//   @State offsetNumber: number = 0
//   token: string = ""
//   @State res: UserInfoRe = {
//     user_picture: '',
//     username: '',
//     email: '',
//     user_introduction: '',
//     background: '',
//     user_male: '',
//     user_birthday: '',
//     user_hobby: '',
//   }
//
//   @Builder
//   TabBuilder(item: TabClass, index: number) {
//     Column({ space: 5 }) {
//       // Image(item.icon)
//       //   .width(24)
//       //   .fillColor(this.currentIndex === index ? '#E85A88' : '#63AAAA')
//       Text(item.text)
//         .fontSize(14)
//         .fontColor(this.currentIndex === index ? '#E85A88' : '#63AAAA')
//     }
//   }
//
//   aboutToAppear(): void {
//     const prefManager = PreferencesManager.getInstance()
//     const TOKEN = prefManager.getData("TOKEN_KEY") + ""
//     const data: EmptyObject = {}
//     this.token = TOKEN
//
//     HttpRequest.get<HttpResult<UserInfoRe>>(API_ENDPOINTS.USERINFO, data, TOKEN).then((result) => {
//       if (result.status === 1000 && result.data) {
//         this.res = result.data
//         console.log("请求数据成功")
//       } else {
//         console.error("用户信息请求失败：" + result.msg)
//       }
//     })
//
//   }
//
//   build() {
//     Stack() {
//       Stack() {
//         Row() {
//           Image(SettingImageLeft.icon)
//             .height(15)// .width("10%")
//             .margin({ left: 10 })// .align(VerticalAlign.Center)
//             .padding({ left: 10, right: 10 })
//             .onClick(() => {
//               HMRouterMgr.pop()
//             })
//         }
//         .width("100%")
//         .justifyContent(FlexAlign.Start) // 横向对齐：从左开始
//
//         // .alignItems(HorizontalAlign.Start)
//
//         Column() {
//           Image(this.res.user_picture)
//             .borderRadius(15)
//             .width(30)
//             .height(30)
//             .margin({ left: 10, right: 6 })
//         }
//         .opacity(this.getOpacity())
//         .width("100%")
//         .justifyContent(FlexAlign.Center)
//       }
//       .backgroundColor(0xffffff)
//       .margin({ top: 10 })
//       .position({ x: 0, y: 0 })
//       .zIndex(999)
//       .alignContent(Alignment.TopStart)
//       .height(40)
//       .opacity(this.getOpacity())
//       .width("100%")
//
//
//       Scroll() {
//         Column() {
//           Stack() {
//             Column() {
//               Image(this.res.background)// .blur(5)
//                 .height("100%")
//                 .width("100%")
//                 .linearGradientBlur(60,
//                   { fractionStops: [[0, 0], [0.33, 0.5], [1, 1]], direction: GradientDirection.Bottom })
//                 .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
//             }
//             .height("100%")
//             .width("100%")
//             .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
//
//
//             Column() {
//               Row() {
//                 Image(SettingImageLeft.icon)
//                   .height(15)// .width("10%")
//                   .margin({ left: 10 })// .align(VerticalAlign.Center)
//                   .padding({ left: 10, right: 10 })
//                   .onClick(() => {
//                     HMRouterMgr.pop()
//                   })
//               }
//               .width("100%")
//               .justifyContent(FlexAlign.Start) // 横向对齐：从左开始
//
//               Row() {
//                 Image(this.res.user_picture)
//                   .width(80)
//                   .height(80)
//                   .borderRadius(40)
//                   .margin({ left: 20, right: 10 })
//
//                 Column() {
//                   Text(this.res.username)
//                     .fontSize(30)
//                     .fontWeight(FontWeight.Bold)
//                     .fontColor(0xffffff)
//                     .margin({ bottom: 8 })
//                 }
//                 .alignItems(HorizontalAlign.Start)
//                 .layoutWeight(1)
//
//                 Button("编辑")
//                   .width(85)
//                   .opacity(0.9)
//                   .backgroundColor(0xDEDEDE)
//                   .fontColor(0xffffff)
//                   .margin({ right: 10 })
//                   .onClick(() => {
//                     HMRouterMgr.push({
//                       pageUrl: PersonInfoSetting
//                     })
//                   })
//               }
//               .height("70%")
//               .justifyContent(FlexAlign.Start)
//
//               Column() {
//                 Text(this.res.user_introduction)
//                   .fontSize(20)
//                   .fontColor(0xf3f3f3)
//                   .margin({ left: 20 })
//               }
//               .width("100%")
//               .alignItems(HorizontalAlign.Start)
//             }
//             .height("100%")
//             .justifyContent(FlexAlign.Start)
//           }
//           .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
//           // .shadow()
//           .backdropBlur(10)
//           .height("30%")
//
//           List() {
//             ListItem() {
//               Stack({ alignContent: Alignment.TopStart }) {
//                 Tabs({ barPosition: BarPosition.Start }) {
//                   TabContent() {
//                     MyProduct()
//                     // Column().width('100%').height('100%').backgroundColor(item[1])
//                   }.tabBar(this.TabBuilder(PersonTabData[0], 0))
//
//                   TabContent() {
//                     evaluate()
//                   }.tabBar(this.TabBuilder(PersonTabData[1], 1))
//
//                   TabContent() {
//                     dynamic()
//                   }.tabBar(this.TabBuilder(PersonTabData[2], 2))
//                 }
//                 .barWidth("60%")
//                 .barHeight(40)
//                 .width("100%")
//                 .height("100%")
//                 .backgroundColor(0xffffff)
//                 .animationDuration(this.animationDuration)
//                 .onChange((index: number) => {
//                   this.currentIndex = index; // 监听索引index的变化，实现页签内容的切换。
//                 })
//               }
//             }
//             .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
//             .layoutWeight(1)
//           }
//           .scrollBar(BarState.Off)
//           .nestedScroll({
//             scrollForward: NestedScrollMode.PARENT_FIRST, // 可滚动组件往末尾端滚动时的嵌套滚动选项,父组件先滚动，父组件滚动到边缘以后自身滚动。
//             scrollBackward: NestedScrollMode.SELF_FIRST // 可滚动组件往起始端滚动时的嵌套滚动选项,自身先滚动，自身滚动到边缘以后父组件滚动。
//           })
//           .edgeEffect(EdgeEffect.None)
//
//           // .height("100%")
//           .scrollBar(BarState.Off)
//           .backgroundColor(0XFFFFFF)
//           .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
//         }
//
//       }
//       .onWillScroll((xOffset: number, yOffset: number, scrollState: ScrollState) => {
//         this.offsetNumber += yOffset
//         console.info("scroll 偏移量 " + xOffset + ' ' + yOffset);
//
//       })
//       .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
//       .scrollBar(BarState.Off)
//
//     }
//     // .align(Alignment.Start)
//     .alignContent(Alignment.TopStart)
//     .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
//
//
//     // .nestedScroll({
//     //   scrollForward: NestedScrollMode.PARENT_FIRST, // 可滚动组件往末尾端滚动时的嵌套滚动选项,父组件先滚动，父组件滚动到边缘以后自身滚动。
//     //   scrollBackward: NestedScrollMode.SELF_FIRST // 可滚动组件往起始端滚动时的嵌套滚动选项,自身先滚动，自身滚动到边缘以后父组件滚动。
//     // })
//
//     // .onWillScroll((xOffset: number, yOffset: number, scrollState: ScrollState) => {
//     //   this.offsetNumber += yOffset
//     //   console.info("scroll 偏移量 " + xOffset + ' ' + yOffset);
//     //
//     // })
//
//   }
//
//   // 计算透明度：滚动超过 0 开始显示，最多 1
//   getOpacity(): number {
//     let maxOffset = 50
//     return Math.min(this.offsetNumber / maxOffset, 1)
//   }
// }


import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { PersonalHomePage, PersonInfoSetting } from '../../data/PageUrl';
import { SettingImageLeft } from '../../data/SettingData';
import { PersonTabData } from '../../data/TabClass';
import { API_ENDPOINTS } from '../../data/variable';
import { EmptyObject, HttpResult, UserInfoRe } from '../../models/httpResult';
import { TabClass } from '../../models/TabClass';
import { HttpRequest } from '../../service/HttpRequest';
import { PreferencesManager } from '../../service/preference';
import { dynamic } from './dynamic';
import { evaluate } from './evaluate';
import { MyProduct } from './MyProduct';

@HMRouter({
  pageUrl: PersonalHomePage
})
@Component
export struct HomePage {
  @State currentIndex: number = 0;
  @State animationDuration: number = 300;
  @State indicatorLeftMargin: number = 0;
  @State indicatorWidth: number = 0;
  @State showUserPicture: boolean = false;
  @State offsetNumber: number = 0;
  token: string = "";
  @State res: UserInfoRe = {
    user_picture: '',
    username: '',
    email: '',
    user_introduction: '',
    background: '',
    user_male: '',
    user_birthday: '',
    user_hobby: '',
  }

  aboutToAppear(): void {
    const prefManager = PreferencesManager.getInstance();
    const TOKEN = prefManager.getData("TOKEN_KEY") + "";
    this.token = TOKEN;

    const data: EmptyObject = {};
    HttpRequest.get<HttpResult<UserInfoRe>>(API_ENDPOINTS.USERINFO, data, TOKEN).then((result) => {
      if (result.status === 1000 && result.data) {
        this.res = result.data;
        console.log("用户信息加载成功");
      } else {
        console.error("用户信息请求失败：" + result.msg);
      }
    });
  }

  @Builder
  TabBuilder(item: TabClass, index: number) {
    Column({ space: 5 }) {
      Text(item.text)
        .fontSize(14)
        .fontColor(this.currentIndex === index ? '#E85A88' : '#63AAAA')
    }
  }

  // getOpacity(): number {
  //   let maxOffset = 60;
  //   return Math.min(Math.max(this.offsetNumber / maxOffset, 0), 1);
  // }

  build() {
    Column() {
      // 顶部固定栏
      Stack() {
        Row() {
          Image(SettingImageLeft.icon)
            .height(15)
            .margin({ left: 10 })
            .padding({ left: 10, right: 10 })
            .onClick(() => {
              console.log("点击了返回按钮")
              HMRouterMgr.pop();
            })
        }
        .zIndex(3)
        .width("100%")
        .justifyContent(FlexAlign.Start)

        Column() {
          Image(this.res.user_picture)
            .borderRadius(15)
            .width(30)
            .height(30)
            .margin({ left: 10, right: 6 })
        }
        // .opacity(this.getOpacity())
        .width("100%")
        .justifyContent(FlexAlign.Center)
      }
      .position({ x: 0, y: 0 })
      .zIndex(2)
      .backgroundColor(0xffffff)
      .height(40)
      .width("100%")
      .visibility(this.offsetNumber > 50 ? Visibility.Visible : Visibility.Hidden)


      // .opacity(this.getOpacity())

      // 主体滚动内容
      Scroll() {
        Column() {
          // 背景与用户信息区
          Stack() {
            Column() {
              Image(this.res.background)
                .height("100%")
                .width("100%")
                .linearGradientBlur(60,
                  { fractionStops: [[0, 0], [0.33, 0.5], [1, 1]], direction: GradientDirection.Bottom })
            }
            .height("100%")
            .width("100%")

            Column() {
              Row() {
                Image(SettingImageLeft.icon)
                  .height(15)
                  .margin({ left: 10, top: 10 })
                  .padding({ left: 10, right: 10 })
                  .onClick(() => {
                    HMRouterMgr.pop();
                  })
              }
              .width("100%")
              .justifyContent(FlexAlign.Start)

              Row() {
                Image(this.res.user_picture)
                  .width(80)
                  .height(80)
                  .borderRadius(40)
                  .margin({ left: 20, right: 10 })

                Column() {
                  Text(this.res.username)
                    .fontSize(30)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(0xffffff)
                    .margin({ bottom: 8 })
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)

                Button("编辑")
                  .width(85)
                  .opacity(0.9)
                  .backgroundColor(0xDEDEDE)
                  .fontColor(0xffffff)
                  .margin({ right: 10 })
                  .onClick(() => {
                    HMRouterMgr.push({ pageUrl: PersonInfoSetting })
                  })
              }
              .height("70%")
              .justifyContent(FlexAlign.Start)

              Column() {
                Text(this.res.user_introduction)
                  .fontSize(20)
                  .fontColor(0xf3f3f3)
                  .margin({ left: 20 })
              }
              .width("100%")
              .alignItems(HorizontalAlign.Start)
            }
            .height("100%")
          }
          .backdropBlur(10)
          .height("30%")

          // Tab 内容
          List() {
            ListItem() {
              Stack({ alignContent: Alignment.TopStart }) {
                Tabs({ barPosition: BarPosition.Start }) {
                  TabContent() {
                    MyProduct()
                  }.tabBar(this.TabBuilder(PersonTabData[0], 0))

                  TabContent() {
                    evaluate()
                  }.tabBar(this.TabBuilder(PersonTabData[1], 1))

                  TabContent() {
                    dynamic()
                  }.tabBar(this.TabBuilder(PersonTabData[2], 2))
                }
                .position({ top: 40 })
                .barWidth("60%")
                .barHeight(40)
                .width("100%")
                .height("100%")
                .backgroundColor(0xffffff)
                .animationDuration(this.animationDuration)
                .onChange((index: number) => {
                  this.currentIndex = index;
                })
              }
            }
            .layoutWeight(1)
          }
          .nestedScroll({
            scrollForward: NestedScrollMode.PARENT_FIRST,
            scrollBackward: NestedScrollMode.SELF_FIRST
          })
          .edgeEffect(EdgeEffect.None)
          .scrollBar(BarState.Off)
          .backgroundColor(0xFFFFFF)
        }
      }
      // .nestedScroll({
      //   scrollForward: NestedScrollMode.PARENT_FIRST, // 可滚动组件往末尾端滚动时的嵌套滚动选项,父组件先滚动，父组件滚动到边缘以后自身滚动。
      //   scrollBackward: NestedScrollMode.SELF_FIRST // 可滚动组件往起始端滚动时的嵌套滚动选项,自身先滚动，自身滚动到边缘以后父组件滚动。
      // })

      .onWillScroll((xOffset: number, yOffset: number, scrollState: ScrollState) => {
        this.offsetNumber += yOffset
        console.info("scroll 偏移量 " + xOffset + ' ' + yOffset);

      })

      .scrollBar(BarState.Off)
    }
    .zIndex(1)
    // .alignContent(Alignment.TopStart)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
