import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import {
  AccountSafeData,
  SettingHeight,
  SettingImageLeft,
  ThemeSettingOption_AccountSafeData
} from '../../data/SettingData';
import { ThemeSettingBuilder } from '../Builders/ThemeSettings';
import { TopBarBuilder } from '../Builders/TopBar';

@HMRouter({
  pageUrl: "AccountSafe"
})
@Component
export struct AccountSafe {
  @State Height: number = SettingHeight
  @State AllHeight: number = this.Height * AccountSafeData.length
  @State param: string = ""

  aboutToAppear(): void {
    this.param = HMRouterMgr.getCurrentParam() as string
  }

  build() {
    Column() {
      TopBarBuilder(SettingImageLeft.icon, this.param)

      List({ space: 6 }) {
        ListItem() {
          ThemeSettingBuilder("", AccountSafeData, ThemeSettingOption_AccountSafeData)
          // Column() {
          //
          //   Flex({ direction: FlexDirection.Column }) {
          //     ForEach(AccountSafeData, (item: TextExample, index: number) => {
          //
          //       Row() {
          //         Text(item.text)
          //           .height(40)
          //           .width("100%")// .backgroundColor(0xffffff)
          //             // .border({ radius: { topLeft: 10, topRight: 10 } })
          //           .layoutWeight(1)
          //           .margin({ left: 10 })
          //         Image(SettingImageRight.icon)
          //           .height(20)
          //           .margin({ right: 10 })
          //       }
          //       .height(this.Height)
          //       .onClick(() => {
          //         HMRouterMgr.push({
          //           pageUrl: item.pageUrl,
          //           param: item.text
          //         })
          //       })
          //
          //
          //       if (index < AccountSafeData.length - 1) {
          //         Divider()// 添加分隔线
          //           .color('#E0E0E0')
          //           .height(1)
          //           .margin({ left: 10, right: 10 }) // 可控制缩进样式
          //       }
          //     })
          //   }
          //   .border({
          //     radius: {
          //       topLeft: 10,
          //       topRight: 10,
          //       bottomLeft: 10,
          //       bottomRight: 10
          //     }
          //   })
          //   .backgroundColor(0xffffff)
          //   .margin({ left: 20, right: 20, top: 20 })
          //   .height(this.AllHeight)
          // }
        }
      }
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .width("100%")
      .height("100%")
      .backgroundColor(0xf7f7f7)
    }
  }
}