import { HMRouterMgr } from '@hadss/hmrouter'
import { MineSetting } from '../../data/MineData'
import { PersonalHomePage, SettingPage, StartNavigation } from '../../data/PageUrl'
import { API_ENDPOINTS } from '../../data/variable'
import {
  EmptyObject,
  FollowShop,
  HttpResult,
  HttpResultArray,
  pageInfoParam,
  userCollect,
  UserHistory,
  UserInfoRe
} from '../../models/httpResult'
import { HttpRequest } from '../../service/HttpRequest'
import { PreferencesManager } from '../../service/preference'
import { promptAction } from '@kit.ArkUI'

@Component
export struct Mine {
  @State offsetNumber: number = 0
  token = ""
  @State collectNumber: number = 0
  @State followNumber: number = 0
  @State historyNumber: number = 0
  // @State ReUserHistory: UserHistory[] = []
  @State ReUserHistoryCount: number = 0
  @State ReUSerFollowList: FollowShop[] = []
  @State ReUserCollectList: userCollect[] = []
  @State ReUserFollowCount: number = 0
  @State ReUserCollectCount: number = 0
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
    this.UserInfo()
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
            let obj: pageInfoParam = {
              onSuccess: () => {
                this.UserInfo()
              }
            }

            HMRouterMgr.push({
              pageUrl: PersonalHomePage,
              param: obj
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
        Row() {
          Column() {
            Text("商品收藏")
              .margin({
                bottom: 5
              })
            Text(`${this.collectNumber}`)
          }
          .onClick(() => {

          })
          .margin({
            top: 8,
            bottom: 8,
            right: 8,
            left: 8
          })

          Column() {
            Text("店铺关注")
              .margin({
                bottom: 5
              })
            Text(`${this.followNumber}`)
          }
          .margin({
            top: 8,
            bottom: 8,
            right: 8,
            left: 8
          })

          Column() {
            Text("浏览历史")
              .margin({
                bottom: 5
              })
            Text(`${this.historyNumber}`)
          }
          .margin({
            top: 8,
            bottom: 8,
            right: 8,
            left: 8
          })

        }
        .width("90%")
        .justifyContent(FlexAlign.SpaceBetween)
        .height(70)
        .backgroundColor(Color.White)
        .margin({
          top: 8,
          bottom: 8,
          left: 10,
          right: 10
        })
        .border({
          radius: {
            topLeft: 10,
            topRight: 10,
            bottomLeft: 10,
            bottomRight: 10
          }
        })

      }
      .width("100%")

      ListItem() {
        Row() {
          Column() {
            Text("我购买的")
              .margin({
                bottom: 5
              })

            Image($r('app.media.icon_pay'))
              .width(30)
              .height(30)

          }
          .margin({
            top: 8,
            bottom: 8,
            right: 8,
            left: 8
          })

          Column() {
            Text("我收到的")
              .margin({
                bottom: 5
              })
            Image($r('app.media.icon_arrive'))
              .width(30)
              .height(30)

          }
          .margin({
            top: 8,
            bottom: 8,
            right: 8,
            left: 8
          })


          Column() {
            Text("我使用的")
              .margin({
                bottom: 5
              })

            Image($r('app.media.icon_use'))
              .width(30)
              .height(30)
          }
          .margin({
            top: 8,
            bottom: 8,
            right: 8,
            left: 8
          })

        }
        .width("90%")
        .justifyContent(FlexAlign.SpaceBetween)
        .height(90)
        .backgroundColor(Color.White)
        .margin({
          top: 8,
          bottom: 8,
          left: 10,
          right: 10
        })
        .border({
          radius: {
            topLeft: 10,
            topRight: 10,
            bottomLeft: 10,
            bottomRight: 10
          }
        })

      }
      .width("100%")

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

  private UserInfo() {
    const prefManager = PreferencesManager.getInstance()
    const TOKEN = prefManager.getData("TOKEN_KEY") + ""
    const data: EmptyObject = {}
    this.token = TOKEN
    HttpRequest.get<HttpResult<UserInfoRe>>(API_ENDPOINTS.USERINFO, data, TOKEN).then((result) => {
      if (result.status === 1000 && result.data) {
        this.res = result.data
        let obj: EmptyObject = {}
        // 获取收藏列表
        HttpRequest.get<HttpResultArray<userCollect>>(API_ENDPOINTS.GetCollectList, obj,
          this.token).then((resultUserCollect) => {
          if (resultUserCollect.status === 1000) {
            this.ReUserCollectList = resultUserCollect.data
            this.ReUserCollectCount = this.ReUserCollectList.length
          } else {
            promptAction.showToast({
              message: "收藏列表获取失败",
              duration: 2000
            })
          }
        })
        // 获取关注记录
        HttpRequest.get<HttpResultArray<FollowShop>>(API_ENDPOINTS.GetFollowedShops, obj,
          this.token).then((resultFollowList) => {
          if (resultFollowList.status === 1000) {
            this.ReUSerFollowList = resultFollowList.data
            this.ReUserFollowCount = this.ReUSerFollowList.length
          } else {
            promptAction.showToast({
              message: "关注列表获取失败",
              duration: 2000
            })
          }
        })
        // 获取历史记录
        HttpRequest.get<HttpResultArray<UserHistory>>(API_ENDPOINTS.GetUserHistory, obj,
          this.token).then((resultHistory) => {
          if (resultHistory.status === 1000) {
            this.ReUserHistoryCount = resultHistory.data.length
          } else {
            promptAction.showToast({
              message: "历史记录获取失败",
              duration: 2000
            })
          }
        })
      } else {
        console.error("用户信息请求失败：" + result.msg)
      }
    })
  }
}