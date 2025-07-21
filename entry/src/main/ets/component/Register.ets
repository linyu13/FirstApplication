import { HMRouter } from "@hadss/hmrouter";


@HMRouter({
  pageUrl: 'RegisterPage'
})
@Component
export struct Register {
  @State email: string = ""
  @State password: string = ""
  @State userName: string = ""
  @State code: string = ""

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
            TextInput({placeholder: "请输入QQ邮箱账号", text: this.email})
              .onChange((value: string) => {
                this.email = value
              })
              .type(InputType.Email)
              .width("90%")
              .margin({ left: 20, right: 20, bottom: 10}) // 设置左右边距
              .placeholderColor(0x7b7b87)
              .backgroundColor(0xe8e9ed)
          }
          ListItem() {
            TextInput({placeholder: "请输入密码", text: this.password})
              .onChange((value: string) => {
                this.password = value
              })
              .copyOption(CopyOptions.None)
              // .showPasswordIcon(true)
              // .passwordIcon()
              .showPassword(false)
              .type(InputType.Password)
              .width("90%")
              .margin({ left: 20, right: 20, bottom: 10}) // 设置左右边距
              .placeholderColor(0x7b7b87)
              .backgroundColor(0xe8e9ed)
          }
          ListItem() {
            Row() {
              TextInput({placeholder: "请输入验证码", text: this.code})
                .onChange((value: string) => {
                  this.code = value
                })
                .margin({ left: 20, right: 20, bottom: 10}) // 设置左右边距
                .placeholderColor(0x7b7b87)
                .backgroundColor(0xe8e9ed)
                .width("50%")
                .layoutWeight(1)

              Button("发送验证码")
                .onClick(() => {

                })
                .margin( {right: 20} )
                .width("30%")
                .backgroundColor(0x94F6FF)

            }
            .width("100%")
            .alignItems(VerticalAlign.Top)
          }
          ListItem() {
            Button("注册")
              .width("90%")
              .margin( {left: 20} )
              .onClick(() => {

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