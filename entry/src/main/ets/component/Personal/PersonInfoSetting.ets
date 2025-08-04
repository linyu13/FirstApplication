import { HMRouter, HMRouterMgr } from '@hadss/hmrouter'
import { maleSelectArray } from '../../data/male'
import { PersonInfoSetting, UserIntroductionSetting, UserNameSetting } from '../../data/PageUrl'
import {
  AddressMangeData,
  PersonInfoData,
  SettingHeight,
  SettingImageLeft,
  SettingImageRight
} from '../../data/SettingData'
import { API_ENDPOINTS } from '../../data/variable'
import {
  changeBirthday,
  changeDeliveryAddress,
  changeHobby,
  changeMale,
  changeReturnAddress,
  EmptyObject,
  HttpResult,
  pageInfoParam,
  UserAddressRe,
  UserInfoRe
} from '../../models/httpResult'
import { HttpRequest } from '../../service/HttpRequest'
import { PreferencesManager } from '../../service/preference'
import { promptAction } from '@kit.ArkUI'
import { HobbyTextArray } from '../../data/HobbyData'
import { fruits } from '../../data/city'


@HMRouter({
  pageUrl: PersonInfoSetting
})
@Component
export struct PersonInfoSettingPage {
  @State Height: number = SettingHeight
  @State AllHeight: number = this.Height * 6
  token: string = ""
  @State UserInfo: UserInfoRe = {
    user_picture: '',
    username: '',
    email: '',
    user_introduction: '',
    background: '',
    user_male: '',
    user_birthday: '',
    user_hobby: '',
  }
  @State param: pageInfoParam = {}
  @State UserAddress: UserAddressRe = { delivery_address: "", return_address: "" }
  @State maleSelect: number = -1
  @State selectedDate: Date = new Date()
  @State isShowHobbySelect: boolean = false
  @State HobbySelect: number[] = []
  @State HobbyString: string = ""
  @State isSelect: number[] = []
  // @State returnAddressSelect: number[] = []
  // @State deliveryAddressSelect: number[] = []
  @State returnAddressSelect: number = -1
  @State deliveryAddressSelect: number = -1
  private onSuccess?: () => void
  private today: Date = new Date()

  aboutToAppear(): void {
    this.param = HMRouterMgr.getCurrentParam() as pageInfoParam
    this.onSuccess = this.param.onSuccess
    console.log("进入aboutToAppear")

    this.loadUserInfo()
  }

  // @Builder
  // pageRouterBuilder(text: string, reInfo: string, PageUrl: string) {
  //   Row() {
  //     Text(text)
  //       .height(40)// .width("100%")
  //       .layoutWeight(1)
  //       .margin({ left: 10 })
  //
  //     Text(this.UserInfo.username)
  //       .fontSize(16)
  //       .fontColor(Color.Grey)
  //       .margin({ right: 8 })
  //
  //     Image(SettingImageRight.icon)
  //       .height(20)
  //       .margin({ right: 10 })
  //   }
  //   .height(this.Height)
  //   .onClick(() => {
  //     console.log("传入的Info: " + reInfo)
  //     HMRouterMgr.push({
  //       pageUrl: PageUrl,
  //       param: text
  //     })
  //   })
  //
  // }

  @Builder
  HobbySelectBuilder() {
    Column() {
      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
        ForEach(HobbyTextArray, (item: string, index: number) => {
          Text(item)
            .width(70)
            .backgroundColor(this.isSelect.includes(index) ? 0xff7ca6 : 0xf8f8f8)
            .fontSize(20)
            .maxLines(1)
            .margin(5)
            .padding({
              left: 15,
              right: 15,
              top: 15,
              bottom: 15
            })
            .border({
              radius: {
                topLeft: 15,
                topRight: 15,
                bottomLeft: 15,
                bottomRight: 15
              }
            })
            .onClick(() => {
              if (this.isSelect.length > 2) {
                promptAction.showToast({
                  message: "最多选择三个",
                  duration: 2000
                })
              } else {
                if (this.isSelect.includes(index)) {
                  let TextIndex = this.isSelect.indexOf(index)
                  this.isSelect.splice(TextIndex, 1)
                } else {
                  this.isSelect.push(index)
                }
              }
            })
        })
      }

      Button("保存")
        .width("90")
        .onClick(() => {
          this.HobbyString = this.isSelect
            .map(index => HobbyTextArray[index])
            .join('/')
          let obj: changeHobby = {
            user_hobby: this.HobbyString
          }
          HttpRequest.put<HttpResult<null>>(API_ENDPOINTS.UpdateUserInfo, obj, this.token).then((resultChange) => {
            if (resultChange.status === 1000) {
              promptAction.showToast({
                message: "修改成功",
                duration: 2000
              })
              this.loadUserInfo()
            } else {
              promptAction.showToast({
                message: "修改失败",
                duration: 2000
              })
            }
          })
        })

    }
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
              if (this.onSuccess) {
                this.onSuccess()
              }
              HMRouterMgr.pop()
            })
        }
        .width("100%")
        .justifyContent(FlexAlign.Start) // 横向对齐：从左开始

        Text("编辑资料")
          .height(50)
          .fontWeight(FontWeight.Bold)
          .align(Alignment.Center)

      }
      .width("100%")
      .height(40)


      Column() {
        Flex({ direction: FlexDirection.Column }) {
          // this.pageRouterBuilder(PersonInfoData[0].text, this.res.username, PersonInfoData[0].pageUrl!)

          Row() {
            Text(PersonInfoData[0].text)
              .height(40)
              .width("100%")
              .layoutWeight(1)
              .margin({ left: 10 })

            Text(this.UserInfo.username)
              .fontSize(16)
              .fontColor(Color.Grey)
              .margin({ right: 8 })

            Image(SettingImageRight.icon)
              .height(20)
              .margin({ right: 10 })
          }
          .height(this.Height)
          .onClick(() => {
            let paramInfo: pageInfoParam = {
              text: PersonInfoData[0].text,
              info: this.UserInfo.username,
              onSuccess: () => {
                this.loadUserInfo()
              }
            }
            HMRouterMgr.push({
              pageUrl: UserNameSetting,
              param: paramInfo
            })
          })

          Divider()// 添加分隔线
            .color('#E0E0E0')
            .height(1)
            .margin({ left: 10, right: 10 }) // 可控制缩进样式

          Row() {
            Text(PersonInfoData[2].text)
              .height(40)
              .width("100%")
              .layoutWeight(1)
              .margin({ left: 10 })

            Image(this.UserInfo.user_picture)
              .margin({ right: 8 })
              .height(30)
              .borderRadius(15)

            Image(SettingImageRight.icon)
              .height(20)
              .margin({ right: 10 })
          }
          .height(this.Height)
          .onClick(() => {
          })

          Divider()// 添加分隔线
            .color('#E0E0E0')
            .height(1)
            .margin({ left: 10, right: 10 }) // 可控制缩进样式

          // 简介
          // this.pageRouterBuilder(PersonInfoData[1].text, this.res.user_introduction, PersonInfoData[1].pageUrl!)

          Row() {
            Text(PersonInfoData[1].text)
              .height(40)
              .width("100%")
              .layoutWeight(1)
              .margin({ left: 10 })

            Text(this.UserInfo.user_introduction)
              .fontSize(16)
              .fontColor(Color.Grey)
              .margin({ right: 8 })

            Image(SettingImageRight.icon)
              .height(20)
              .margin({ right: 10 })
          }
          .height(this.Height)
          .onClick(() => {
            let obj: pageInfoParam = {
              text: PersonInfoData[1].text,
              info: this.UserInfo.user_introduction,
              onSuccess: () => {
                this.loadUserInfo()
              }
            }
            console.log("个人信息界面user_introduction", this.UserInfo.user_introduction)
            HMRouterMgr.push({
              pageUrl: UserIntroductionSetting,
              param: obj
            })
          })

          Divider()// 添加分隔线
            .color('#E0E0E0')
            .height(1)
            .margin({ left: 10, right: 10 }) // 可控制缩进样式

          // 性别
          Row() {
            Text(PersonInfoData[4].text)
              .height(40)
              .width("100%")
              .layoutWeight(1)
              .margin({ left: 10 })

            Text(this.UserInfo.user_male)
              .fontSize(16)
              .fontColor(Color.Grey)
              .margin({ right: 8 })

            Image(SettingImageRight.icon)
              .height(20)
              .margin({ right: 10 })

          }
          .height(this.Height)
          .onClick(() => {
            this.getUIContext().showTextPickerDialog({
              canLoop: false,
              range: maleSelectArray,
              selected: this.maleSelect,
              onAccept: (value: TextPickerResult) => {
                this.maleSelect = value.index as number

                let obj: changeMale = {
                  user_male: maleSelectArray[this.maleSelect].text as string
                }

                HttpRequest.put<HttpResult<null>>(API_ENDPOINTS.UpdateUserInfo, obj,
                  this.token).then((resultChange) => {
                  if (resultChange.status === 1000) {
                    this.loadUserInfo()
                    promptAction.showToast({
                      message: "修改成功",
                      duration: 2000
                    })
                  }
                })
              }
            })
          })

          Divider()// 添加分隔线
            .color('#E0E0E0')
            .height(1)
            .margin({ left: 10, right: 10 }) // 可控制缩进样式

          // 生日
          Row() {
            Text(PersonInfoData[5].text)
              .height(40)
              .width("100%")
              .layoutWeight(1)
              .margin({ left: 10 })

            Text(this.UserInfo.user_birthday)
              .fontSize(16)
              .fontColor(Color.Grey)
              .margin({ right: 8 })

            Image(SettingImageRight.icon)
              .height(20)
              .margin({ right: 10 })

          }
          .height(this.Height)
          .onClick(() => {
            console.info("CalendarDialog.show")
            CalendarPickerDialog.show({
              selected: this.today,
              acceptButtonStyle: {
                fontColor: '#2787d9',
                fontSize: '16fp',
                backgroundColor: '#f7f7f7',
                borderRadius: 10
              },
              cancelButtonStyle: {
                fontColor: Color.Red,
                fontSize: '16fp',
                backgroundColor: '#f7f7f7',
                borderRadius: 10
              },
              onAccept: (date: Date) => {
                // 当弹出框再次弹出时显示选中的是上一次确定的日期
                // this.selectedDate = date;

                let selectedDate = new Date(date.getFullYear(), date.getMonth(), date.getDate())
                if (selectedDate.getTime() > this.today.getTime()) {
                  // 这里你可以弹出提示框或 toast
                  promptAction.showToast({
                    message: "必须是今天及以前的日期",
                    duration: 2000
                  })
                  // console.warn("不能选择大于今天的日期")
                  return
                }
                this.selectedDate = selectedDate

                let obj: changeBirthday = {
                  user_birthday: selectedDate.toLocaleDateString()
                }
                HttpRequest.put<HttpResult<null>>(API_ENDPOINTS.UpdateUserInfo, obj,
                  this.token).then((resultChange) => {
                  if (resultChange.status === 1000) {
                    promptAction.showToast({
                      message: "修改成功",
                      duration: 2000
                    })
                  }
                  this.loadUserInfo()
                })
              }
            })
          })

          Divider()// 添加分隔线
            .color('#E0E0E0')
            .height(1)
            .margin({ left: 10, right: 10 }) // 可控制缩进样式

          // 兴趣
          Row() {
            Text(PersonInfoData[6].text)
              .height(40)
              .width("100%")
              .layoutWeight(1)
              .margin({ left: 10 })

            Text(this.UserInfo.user_hobby)
              .fontSize(16)
              .fontColor(Color.Grey)
              .margin({ right: 8 })

            Image(SettingImageRight.icon)
              .height(20)
              .margin({ right: 10 })

          }
          .height(this.Height)
          .onClick(() => {
            this.isShowHobbySelect = !this.isShowHobbySelect
          })
          .bindSheet($$this.isShowHobbySelect, this.HobbySelectBuilder(), {
            detents: [300],
            preferType: SheetType.BOTTOM,
            title: {
              title: "请选择你的兴趣爱好"
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
        .margin({
          left: 20,
          right: 20,
          top: 20,
          bottom: 20
        })
        .height(this.AllHeight)


        Flex({ direction: FlexDirection.Column }) {
          Row() {
            Text("收货地址")
              .height(40)
              .width("100%")// .backgroundColor(0xffffff)
                // .border({ radius: { topLeft: 10, topRight: 10 } })
              .layoutWeight(1)
              .margin({ left: 10 })
            // Image(SettingImageRight.icon)
            //   .height(20)
            //   .margin({ right: 10 })
            Text(this.UserAddress.delivery_address)
              .fontSize(16)
              .fontColor(Color.Grey)
              .margin({ right: 8 })

          }
          .height(this.Height)
          .onClick(() => {
            this.getUIContext().showTextPickerDialog({
              canLoop: false,
              range: fruits,
              selected: this.deliveryAddressSelect,
              onAccept: (value: TextPickerResult) => {
                this.deliveryAddressSelect = value.index as number
                const selectedValues = value.value as string[] // 多列选中的值
                const fullAddress = selectedValues.join("/") // 拼成一个字符串，如 "北京/朝阳区"

                let obj: changeDeliveryAddress = {
                  delivery_address: fullAddress
                }

                HttpRequest.put<HttpResult<null>>(API_ENDPOINTS.SaveUserAddress, obj,
                  this.token).then((resultChange) => {
                  console.log(`修改地址时状态码为${resultChange.status}`)

                  if (resultChange.status === 1000) {
                    this.loadUserInfo()
                    console.log(``)
                    promptAction.showToast({
                      message: "修改成功",
                      duration: 2000
                    })
                  } else {
                    promptAction.showToast({
                      message: "修改失败",
                      duration: 2000
                    })
                  }
                })

              }
            })
          })


          Divider()// 添加分隔线
            .color('#E0E0E0')
            .height(1)
            .margin({ left: 10, right: 10 }) // 可控制缩进样式

          Row() {
            Text("退货地址")
              .height(40)
              .width("100%")
              .layoutWeight(1)
              .margin({ left: 10 })

            Text(this.UserAddress.return_address)
              .fontSize(16)
              .fontColor(Color.Grey)
              .margin({ right: 8 })

          }
          .height(this.Height)
          .onClick(() => {
            this.getUIContext().showTextPickerDialog({
              canLoop: false,
              range: fruits,
              selected: this.returnAddressSelect,
              onAccept: (value: TextPickerResult) => {
                this.returnAddressSelect = value.index as number

                const selectedValues = value.value as string[] // 多列选中的值
                const fullAddress = selectedValues.join("/") // 拼成一个字符串，如 "北京/朝阳区"

                let obj: changeReturnAddress = {
                  return_address: fullAddress
                }

                HttpRequest.put<HttpResult<null>>(API_ENDPOINTS.SaveUserAddress, obj,
                  this.token).then((resultChange) => {
                  console.log(`修改地址时状态码为${resultChange.status}`)
                  if (resultChange.status === 1000) {
                    this.loadUserInfo()
                    promptAction.showToast({
                      message: "修改成功",
                      duration: 2000
                    })
                  }
                })
              }
            })
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
        .height(AddressMangeData.length * this.Height)
      }
    }
    .width("100%")
    .height("100%")
    .backgroundColor(0xf7f7f7)

  }

  private loadUserInfo() {
    const PrefManger = PreferencesManager.getInstance()
    const TOKEN = PrefManger.getData("TOKEN_KEY")
    this.token = TOKEN + ""
    const obj: EmptyObject = {}

    HttpRequest.get<HttpResult<UserInfoRe>>(API_ENDPOINTS.USERINFO, obj, this.token).then((result) => {
      if (result.status === 1000 && result.data) {
        this.UserInfo = result.data
        console.log("个人信息编辑页面请求数据成功，数据如下",
          this.UserInfo.username + this.UserInfo.user_picture + this.UserInfo.user_introduction +
          this.UserInfo.background)

        HttpRequest.get<HttpResult<UserAddressRe>>(API_ENDPOINTS.UserAddressGet, obj,
          this.token).then((resultAddress) => {
          if (resultAddress.status === 1000) {
            this.UserAddress = resultAddress.data!
            console.log("个人信息地址请求成功，数据如下",
              this.UserAddress.return_address + this.UserAddress.delivery_address)

          }
        })
      } else {
        console.error("用户信息请求失败：" + result.msg)
      }
    })

  }
}