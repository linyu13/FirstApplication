import { HMRouter } from '@hadss/hmrouter';
import { Request } from '../../service/HttpRequest';
import { CodeRe, emailRequest, HttpResult, RegisterRequest } from '../../models/httpResult';
import { promptAction } from '@kit.ArkUI';
import { API_ENDPOINTS } from '../../data/variable';

@HMRouter({
  pageUrl: 'RegisterPage'
})
@Component
export struct Register {
  email: string = ""
  password: string = ""
  code: string = ""

  build() {
    Column() {
      Text("Register")

        .height("50%")
        .width("40%")
      // .layoutWeight(1)
      // .textAlign(TextAlign.Start)
      List() {
        // ListItem() {
        //   TextInput({placeholder: "请输入昵称", text: this.userName})
        //     .onChange((value: string) => {
        //       this.userName = value
        //     })
        //     .width("90%")
        //     .margin({ left: 20, right: 20, bottom: 10}) // 设置左右边距
        //     .placeholderColor(0x7b7b87)
        //     .backgroundColor(0xe8e9ed)
        // }

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
            .copyOption(CopyOptions.None)// .showPasswordIcon(true)
              // .passwordIcon()
            .showPassword(false)
            .type(InputType.Password)
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
                let res = Request.post<HttpResult<CodeRe>>(API_ENDPOINTS.SEND_CODE, request)
                try {
                  res.then((result) => {
                    console.log(result.data?.code)
                  })
                } catch (error) {
                  promptAction.showToast({
                    message: "验证码发送失败",
                    duration: 2000
                  })
                  console.error("请求失败: ", (error as Error).message)
                }
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
          Button("注册")
            .width("90%")
            .margin({ left: 20 })
            .onClick(() => {
              let request: RegisterRequest =
                {
                  email: this.email,
                  password: this.password,
                  type: "USER",
                  code: this.code
                }
              let res = Request.post<HttpResult<null>>(API_ENDPOINTS.REGISTER, request)
              try {
                res.then((result) => {
                  if (!result.data) {
                    promptAction.showToast({
                      message: "注册成功",
                      duration: 2000
                    })
                  }
                })
              } catch (error) {
                promptAction.showToast({
                  message: "验证码发送失败",
                  duration: 2000
                })
                console.error("请求失败: ", (error as Error).message)
              }
            })
        }
      }
      .width("100%")
      .height("60%")
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .height("100%")
    .width("100%")
    .linearGradient({
      angle: 90,
      direction: GradientDirection.RightBottom,
      colors: [[0xffffff, 0.0], [0xd2f2ff, 1.0]]
    })
    .alignItems((HorizontalAlign.Start))
    .justifyContent(FlexAlign.Start)

  }
}