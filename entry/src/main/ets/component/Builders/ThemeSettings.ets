import { HMRouterMgr } from '@hadss/hmrouter';
import { SettingHeight, SettingImageRight, Tmp } from '../../data/SettingData';
import { TextExample } from '../../models/TextClass';
import { ThemeSettingOption } from '../../models/ThemeSettingOption';


@Builder
export function ThemeSettingBuilder
(ThemeName: string, ThemeData: TextExample[], option: ThemeSettingOption, resMap?: Tmp) {

  Column() {
    if (option.isTitle) {
      Row() {
        Text(ThemeName)
          .fontSize(15)
          .fontColor(0x999999)
          .margin({ left: 30, top: 10 })
          .textAlign(TextAlign.Start)
        // .layoutWeight(1)
      }
      .width("100%")

    }

    Flex({ direction: FlexDirection.Column }) {
      ForEach(ThemeData, (item: TextExample, index: number) => {
        Row() {
          Text(item.text)
            .height(40)
            .width("100%")// .backgroundColor(0xffffff)
              // .border({ radius: { topLeft: 10, topRight: 10 } })
            .layoutWeight(1)
            .margin({ left: 10 })

          if (option.isRightIcon) {
            Image(SettingImageRight.icon)
              .height(20)
              .margin({ right: 10 })
          }


        }
        .height(50)
        .onClick(() => {
          HMRouterMgr.push({
            pageUrl: item.pageUrl,
            param: item.text
          })
        })

        if (index < ThemeData.length - 1) {
          Divider()// 添加分隔线
            .color('#E0E0E0')
            .height(1)
            .margin({ left: 10, right: 10 }) // 可控制缩进样式
        }
      })
    }
    .border({
      radius: {
        topLeft: 10,
        topRight: 10,
        bottomLeft: 10,
        bottomRight: 10
      }
    })
    .backgroundColor(0xffffff)
    .margin({ left: 20, right: 20, top: 10 })
    .height(SettingHeight * ThemeData.length)
  }

  // Button().onClick(() => {
  //   info(resMap?.param)
  // })

}


// function info(resMap?: Map<string, string>) {
//   resMap!.forEach((value, key) => {
//     console.log("Map数据" + key, ':', value)
//   })
//
// }