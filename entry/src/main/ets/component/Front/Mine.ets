import { HMRouterMgr } from '@hadss/hmrouter'
import { MineSetting } from '../../data/MineData'
import { PersonalHomePage, SettingPage, StartNavigation } from '../../data/PageUrl'
import { API_ENDPOINTS } from '../../data/variable'
import { EmptyObject, HttpResult, UserInfoRe } from '../../models/httpResult'
import { HttpRequest } from '../../service/HttpRequest'
import { PreferencesManager } from '../../service/preference'

@Component
export struct Mine {
  @State offsetNumber: number = 0
  token = ""
  @State res: UserInfoRe = {
    user_picture: '',
    username: '',
    email: '',
    user_introduction: '',
    background: '',
    user_male: '',
    user_birthday: '',
    user_hobby: '',
  }

  aboutToAppear(): void {
    const prefManager = PreferencesManager.getInstance()
    const TOKEN = prefManager.getData("TOKEN_KEY") + ""
    const data: EmptyObject = {}
    this.token = TOKEN
    HttpRequest.get<HttpResult<UserInfoRe>>(API_ENDPOINTS.USERINFO, data, TOKEN).then((result) => {
      if (result.status === 1000 && result.data) {
        this.res = result.data
        console.log("请求数据成功，数据如下",
          this.res.username + this.res.user_picture + this.res.user_introduction + this.res.background)
      } else {
        console.error("用户信息请求失败：" + result.msg)
      }
    })
  }

  build() {
    List({ space: 20 }) {
      ListItem() {
        Row({ space: 5 }) {
          Row() {
            Image(this.res.user_picture)
              .borderRadius(15)
              .width(30)
              .height(30)
              .margin({ left: 10, right: 6 })

            Column() {
              Text(this.res.username)
                .fontSize(25)
                .fontWeight(FontWeight.Bold)
            }
          }
          .justifyContent(FlexAlign.Start)
          .width("90%")
          .layoutWeight(1)
          .onClick(() => {
            HMRouterMgr.push({
              pageUrl: PersonalHomePage
            })

          })

          Column() {
            Image(MineSetting.icon)
              .height(24) // .width("10%")

            Text("设置")
              .fontSize(12)
          }
          .margin({ right: 10 })
          .onClick(() => {
            HMRouterMgr.push({
              navigationId: StartNavigation,
              pageUrl: SettingPage
            })
          })

          // .width(20)
          // .height(20)
        }
        .height(45)
        // .margin({ left: 10, right: 10, top: 10 })
        .width("100%")
        // .border()
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .position({ x: 0, y: 0 })
        // .opacity(this.getOpacity())
        .zIndex(10)
        .backgroundColor(0xffffff)
      }

      ListItem() {

      }
    }
    // 边缘滑动
    .alignListItem(ListItemAlign.Start)
    .width("100%")
    .height("100%")

    // .margin({ right: 10, left: 10 })
  }

  // 计算透明度：滚动超过 0 开始显示，最多 1
  getOpacity(): number {
    let maxOffset = 100
    return Math.min(this.offsetNumber / maxOffset, 1)
  }
}