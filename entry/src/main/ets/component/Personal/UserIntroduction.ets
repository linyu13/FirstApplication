import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { UserIntroductionSetting } from '../../data/PageUrl';
import { SettingImageLeft } from '../../data/SettingData';
import { changeIntro, HttpResult, pageInfoParam } from '../../models/httpResult';
import { PreferencesManager } from '../../service/preference';
import { promptAction } from '@kit.ArkUI';
import { HttpRequest } from '../../service/HttpRequest';
import { API_ENDPOINTS } from '../../data/variable';


@HMRouter({
  pageUrl: UserIntroductionSetting
})
@Component
export struct UserIntroduction {
  token: string = ""
  @State param: pageInfoParam = {
    text: "",
    info: "",
  }
  @State inputIntro: string = ""
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
            .zIndex(10)
            .height(15)// .width("10%")
            .margin({ left: 10 })// .align(VerticalAlign.Center)
            .padding({ left: 10, right: 10 })
            .onClick(() => {
              HMRouterMgr.pop()
            })
        }
        .zIndex(11)
        .width("30%")
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
              if (this.inputIntro === "") {
                promptAction.showToast({
                  message: "个人简介不能为空",
                  duration: 2000
                })
              } else if (this.inputIntro === this.param.info) {
                promptAction.showToast({
                  message: "个人简介不能与原先相同",
                  duration: 2000
                })
              } else {
                this.inputIntro = this.inputIntro.replace(/\s+/g, "")
                let obj: changeIntro = {
                  user_introduction: this.inputIntro
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
      .alignContent(Alignment.Start)
      .width("100%")
      .height(40)

      TextInput({ text: this.param.info })// .height("40%")
        .borderRadius(0)
        .padding(3)
        .borderColor({ top: Color.Transparent, left: Color.Transparent, right: Color.Transparent })
        .onChange((value) => {
          this.inputIntro = value
        })
        .margin({ top: 20 })
        .width("90%")
        .borderWidth(1)// .borderColor(0xAFEEEE)
        .backgroundColor(Color.Transparent)
      // .border({style: {bottom: 1})
    }
  }
}