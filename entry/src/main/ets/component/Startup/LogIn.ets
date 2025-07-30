import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { HttpRequest } from '../../service/HttpRequest';
import { AttributeUpdater, promptAction } from '@kit.ArkUI';
import { API_ENDPOINTS } from '../../data/variable';
import { HttpResult, LoginReData, LoginRequest } from '../../models/httpResult';
import { PreferencesManager } from '../../service/preference';
import { LayOutPage, LogInPage, RegisterPage, StartNavigation } from '../../data/PageUrl';

@HMRouter({
  pageUrl: LogInPage
})
@Component
export struct LogIn {
  modifier: MyNavModifier = new MyNavModifier();
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
              let request: LoginRequest = {
                email: this.email,
                password: this.password,
              }
              let res = HttpRequest.post<HttpResult<LoginReData>>(API_ENDPOINTS.LOGIN, request)
              try {
                res.then(async (result) => {
                  if (result.data?.user_id) {
                    this.prefManager.putData("TOKEN_KEY", result.data.token)
                    // const res: JwtPayload = base(result.data.token)
                    // AppStorage.set("UserID", res.user_id)
                    if (result.status === 1000) {
                      console.log("登陆成功")
                      // HMNavigation({
                      //   navigationId: "MainNavigation",
                      //   homePageUrl: "LayOutPage",
                      //   options: {
                      //     standardAnimator: HMDefaultGlobalAnimator.STANDARD_ANIMATOR,
                      //     dialogAnimator: HMDefaultGlobalAnimator.DIALOG_ANIMATOR,
                      //     modifier: this.modifier
                      //   }
                      // })
                      HMRouterMgr.replace({
                        pageUrl: LayOutPage
                      })
                    } else {
                      console.log("登陆失败")
                    }

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
                navigationId: StartNavigation,
                pageUrl: RegisterPage
              })
            })
        }
      }
      .width("100%")
      .height("80%")
    }
  }
}

class MyNavModifier extends AttributeUpdater<NavigationAttribute> {
  initializeModifier(instance: NavigationAttribute): void {
    instance.mode(NavigationMode.Stack);
    // instance.hideNavBar(true) //这句会导致底部导航不展示
    instance.navBarWidth('100%')
    instance.hideTitleBar(true)
    instance.hideToolBar(true)
  }
}
