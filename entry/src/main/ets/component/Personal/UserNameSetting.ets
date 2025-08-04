import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { UserNameSetting } from '../../data/PageUrl';
import { SettingImageLeft } from '../../data/SettingData';
import { API_ENDPOINTS } from '../../data/variable';
import { changeName, HttpResult, pageInfoParam } from '../../models/httpResult';
import { HttpRequest } from '../../service/HttpRequest';
import { PreferencesManager } from '../../service/preference';
import { promptAction } from '@kit.ArkUI';

@HMRouter({
  pageUrl: UserNameSetting
})
@Component
export struct UserNameSettingPage {
  token: string = ""
  @State param: pageInfoParam = {
    text: "",
    info: "",
  }
  @State inputName: string = ""
  private onSuccess?: () => void

  aboutToAppear(): void {
    this.param = HMRouterMgr.getCurrentParam() as pageInfoParam
    this.onSuccess = this.param.onSuccess
    const prefManager = PreferencesManager.getInstance()
    const TOKEN = prefManager.getData("TOKEN_KEY") + ""
    this.token = TOKEN
  }

  build() {
    Column() {
      Stack() {
        Row() {
          Image(SettingImageLeft.icon)
            .height(15)// .width("10%")
            .margin({ left: 10 })// .align(VerticalAlign.Center)
            .padding({ left: 10, right: 10 })
            .onClick(() => {
              HMRouterMgr.pop()
            })
        }
        .zIndex(11)
        .width("30%")
        .width("100%")
        .justifyContent(FlexAlign.Start) // 横向对齐：从左开始

        Text(`编辑${this.param.text}`)
          .width("100%")
          .height(50)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)

        Row() {
          Image($r('app.media.icon_finish'))
            .height(15)// .width("10%")
            .margin({ left: 10 })// .align(VerticalAlign.Center)
            .padding({ left: 10, right: 10 })
            .onClick(() => {
              if (this.inputName === "") {
                promptAction.showToast({
                  message: "昵称不能为空",
                  duration: 2000
                })
              } else if (this.inputName === this.param.info) {
                promptAction.showToast({
                  message: "昵称不能与原先相同",
                  duration: 2000
                })
              } else {
                this.inputName = this.inputName.replace(/\s+/g, "")
                let obj: changeName = {
                  username: this.inputName
                }
                HttpRequest.put<HttpResult<null>>(API_ENDPOINTS.UpdateUserInfo, obj,
                  this.token).then((resultChange) => {
                  if (resultChange.status === 1000) {
                    promptAction.showToast({
                      message: "修改成功",
                      duration: 2000
                    })
                    if (this.onSuccess) {
                      this.onSuccess()
                    }
                    HMRouterMgr.pop()
                  }
                })
              }
            })
            .zIndex(10)
        }
        .width("100%")
        .margin({ right: 10 })
        .justifyContent(FlexAlign.End) // 横向对齐：从左开始

      }
      .width("100%")
      .height(40)


      TextInput({ text: this.param.info })
        .borderRadius(0)
        .padding(3)
        .borderColor({ top: Color.Transparent, left: Color.Transparent, right: Color.Transparent })
        .onChange((value) => {
          this.inputName = value
        })
        .margin({ top: 20 })
        .width("90%")
        .borderWidth(1)// .borderColor(0xAFEEEE)
        .backgroundColor(Color.Transparent)
      // .border({style: {bottom: 1})


    }
  }
}