import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { AccountSafeData, SettingHeight, SettingImageLeft, SettingImageRight } from '../../data/SettingData';
import { CodeRe, emailRequest, EmptyObject, HttpResult } from '../../models/httpResult';
import { TextExample } from '../../models/TextClass';
import { TopBarBuilder } from '../Builders/TopBar';
import { API_ENDPOINTS } from '../../data/variable';
import { promptAction } from '@kit.ArkUI';
import { HttpRequest } from '../../service/HttpRequest';
import { PreferencesManager } from '../../service/preference';

@HMRouter({
  pageUrl: "AccountSafe"
})
@Component
export struct AccountSafe {
  token: string = ""
  email: string = ""
  code: string = ""
  @State Height: number = SettingHeight
  @State AllHeight: number = this.Height * AccountSafeData.length
  @State param: string = ""
  @State isShowSheet: boolean = false

  aboutToDisappear(): void {
    const prefManager = PreferencesManager.getInstance()
    const TOKEN = prefManager.getData("TOKEN_KEY") + ""
    this.token = TOKEN

  }

  @Builder
  SheetBuilder() {
    List() {
      ListItem() {
        TextInput({ placeholder: "请输入QQ邮箱账号", text: this.email })
          .onChange((value: string) => {
            this.email = value
          })
          .type(InputType.Email)
          .width("90%")
          .margin({ left: 20, right: 20, bottom: 10 })// 设置左右边距
          .placeholderColor(0x7b7b87)
          .backgroundColor(0xe8e9ed)
      }

      ListItem() {
        Row() {
          TextInput({ placeholder: "请输入验证码", text: this.code })
            .onChange((value: string) => {
              this.code = value
            })
            .margin({ left: 20, right: 20, bottom: 10 })// 设置左右边距
            .placeholderColor(0x7b7b87)
            .backgroundColor(0xe8e9ed)
            .width("50%")
            .layoutWeight(1)

          Button("发送验证码")
            .onClick(() => {
              promptAction.showToast({
                message: "验证码已发送",
                duration: 2000
              })
              let request: emailRequest = {
                email: this.email
              }
              HttpRequest.post<HttpResult<CodeRe>>(API_ENDPOINTS.SEND_CODE, request)
              // console.log(res.then(()=>{
              //
              // }));
              // const response = JSON.parse(res as string) as HttpResult
            })
            .margin({ right: 20 })
            .width("30%")
            .backgroundColor(0x94F6FF)

        }
        .width("100%")
        .alignItems(VerticalAlign.Top)
      }

      ListItem() {
        Button("确认删除")
          .width("90%")
          .margin({ left: 20 })
          .onClick(() => {
            let obj: EmptyObject = {}
            HttpRequest.delete<HttpResult<null>>(API_ENDPOINTS.UserDelete, obj, this.token).then((result) => {
              if (result.status === 1000) {
                const prefManager = PreferencesManager.getInstance()
                prefManager.putData("TOKEN_KEY", "")
              }
            })
          })
      }
    }
    .margin({ top: 70 })
    .width("100%")
    .height("60%")
  }

  aboutToAppear(): void {
    this.param = HMRouterMgr.getCurrentParam() as string
  }

  build() {
    Column() {
      TopBarBuilder(SettingImageLeft.icon, this.param)

      List({ space: 6 }) {
        ListItem() {
          // ThemeSettingBuilder("", AccountSafeData, ThemeSettingOption_AccountSafeData)
          Column() {

            Flex({ direction: FlexDirection.Column }) {
              ForEach(AccountSafeData, (item: TextExample, index: number) => {
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
                .height(this.Height)
                .onClick(() => {
                  this.isShowSheet = !this.isShowSheet
                })
                .bindSheet($$this.isShowSheet, this.SheetBuilder(), {
                  detents: [300],
                  preferType: SheetType.BOTTOM,
                })


                if (index < AccountSafeData.length - 1) {
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
            .margin({ left: 20, right: 20, top: 20 })
            .height(this.AllHeight)
          }
        }
      }
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .width("100%")
      .height("100%")
      .backgroundColor(0xf7f7f7)
    }
  }
}