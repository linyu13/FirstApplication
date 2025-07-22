import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { Request } from '../service/HttpRequest';
import { JSON } from '@kit.ArkTS';
import { promptAction } from '@kit.ArkUI';
import { API_ENDPOINTS } from '../data/variable';
import { loginData } from '../models/httpResult';
import { PreferencesManager } from '../service/preference';

@HMRouter({
  pageUrl: 'LogInPage'
})
@Component
export struct LogIn {
  email: string = ""
  password: string = ""
  code: string = ""
  // private prefManager = new PreferencesManager

  prefManager = PreferencesManager.getInstance()

  build() {
    Column() {
      Text("LogIn")
        .width("50%")
        .height("59%")

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
          TextInput({ placeholder: "请输入密码", text: this.password })
            .onChange((value: string) => {
              this.password = value
            })
            .copyOption(CopyOptions.None)
            .showPassword(false)
            .type(InputType.Password)
            .width("90%")
            .margin({ left: 20, right: 20, bottom: 10 })// 设置左右边距
            .placeholderColor(0x7b7b87)
            .backgroundColor(0xe8e9ed)
        }

        ListItem() {
          Button("登录")
            .width("90%")
            .margin({ left: 20 })
            .onClick(() => {
              let res = Request.post<loginData>(API_ENDPOINTS.LOGIN, JSON.stringify({
                email: this.email,
                password: this.password,
              }))
              try {
                res.then(async (result) => {
                  if (result.user_id) {
                    this.prefManager.putData("TOKEN_KEY", result.token)
                    HMRouterMgr.replace({
                      pageUrl: "LayOutPage"
                    })
                    // token = result.token
                  }

                })
              } catch (error) {
                promptAction.showToast({
                  message: "登陆失败",
                  duration: 2000
                })
                console.error("请求失败: ", (error as Error).message)
              }
            })
        }

        ListItem() {
          Text("还没有账号？去注册")
            .onClick(() => {
              HMRouterMgr.push({
                pageUrl: 'Register'
              })
            })
        }
      }
    }
  }
}