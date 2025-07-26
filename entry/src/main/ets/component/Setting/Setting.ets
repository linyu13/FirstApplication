import { HMRouter } from '@hadss/hmrouter';
import {
  LogOutData,
  SettingHeight,
  SettingImageLeft,
  SettingImageRight,
  SettingPersonSet,
  ThemeSettingOptionData
} from '../../data/SettingData';
// import { API_ENDPOINTS } from '../../data/variable';
// import { EmptyObject, HttpResult } from '../../models/httpResult';
import { EmptyObject } from '../../models/httpResult';

import { TextExample } from '../../models/TextClass';
// import { Request } from '../../service/HttpRequest';
import { PreferencesManager } from '../../service/preference';
import { ThemeSettingBuilder } from '../Builders/ThemeSettings';
import { TopBarBuilder } from '../Builders/TopBar';


@HMRouter({
  pageUrl: 'Setting'
})
@Component
export struct Setting {
  @State isShow: boolean = false
  text: string = "设置"
  data: EmptyObject = {}
  prefManager = PreferencesManager.getInstance()
  token: string = this.prefManager.getData("TOKEN_KEY") + ""

  aboutToAppear(): void {
  }

  @Builder
  SheetBuilder() {
    Column() {
      Text("您是否要退出登录")
        .height(40)

      Row() {
        Column() {
          Button("取消")
            .onClick(() => {
              this.isShow = !this.isShow
            })
            .width("50%")
        }
        .width("50%")

        Column() {
          Button("确认")
            .onClick(() => {
              console.log("登出成功")
              this.prefManager.putData("TOKEN_KEY", "")
              // Request.post<HttpResult<null>>(API_ENDPOINTS.UserLogout, this.data, this.token).then((result) => {
              //   if (result.status === 1000) {
              //     console.log("登出成功")
              //   }
              // })
              this.isShow = !this.isShow
            })
            .width("50%")
        }
        .align(Alignment.Center)
        .justifyContent(FlexAlign.Center)
        .width("50%")

      }
      .width("100%")
    }
    .justifyContent(FlexAlign.Start)
    .width("100%")
    .height("100%")
  }

  build() {
    Column() {
      TopBarBuilder(SettingImageLeft.icon, this.text)

      List({ space: 6 }) {
        ListItem() {
          ThemeSettingBuilder("个人", SettingPersonSet, ThemeSettingOptionData)
        }

        ListItem() {
          Flex({ direction: FlexDirection.Column }) {
            ForEach(LogOutData, (item: TextExample, index: number) => {
              Row() {
                Text(item.text)
                  .height(40)
                  .width("100%")// .backgroundColor(0xffffff)
                    // .border({ radius: { topLeft: 10, topRight: 10 } })
                  .layoutWeight(1)
                  .margin({ left: 10 })

                Image(SettingImageRight.icon)
                  .height(20)
                  .margin({ right: 10 })
              }
              .height(SettingHeight)
              .onClick(() => {
                this.isShow = !this.isShow
              })
              .bindSheet($$this.isShow, this.SheetBuilder(), { detents: [300], preferType: SheetType.BOTTOM })

              if (index < LogOutData.length - 1) {
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
          .height(SettingHeight * LogOutData.length)
        }

      }
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .width("100%")
      .height("100%")
      .backgroundColor(0xf7f7f7)
    }
  }
}