import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { PersonInfoData, SettingHeight, SettingImageLeft, } from '../../data/SettingData';
import { API_ENDPOINTS } from '../../data/variable';
import { EmptyObject, HttpResult, UserInfoRe } from '../../models/httpResult';
import { TextExample } from '../../models/TextClass';
import { HttpRequest } from '../../service/HttpRequest';
import { PreferencesManager } from '../../service/preference';
import { TopBarBuilder } from '../Builders/TopBar';

@HMRouter({
  pageUrl: "PersonInfo"
})
@Component
export struct PersonInfo {
  @State param: string = ""
  @State Height: number = SettingHeight
  @State AllHeight: number = this.Height * PersonInfoData.length
  token = ""
  res: UserInfoRe = {
    user_picture: '',
    username: '',
    email: '',
    user_introduction: '',
    background: '',
    user_male: '',
    user_birthday: '',
    user_hobby: '',
  }
  @State resMap: Map<string, string> = new Map

  aboutToAppear(): void {
    this.param = HMRouterMgr.getCurrentParam() as string;
    const prefManager = PreferencesManager.getInstance()
    const TOKEN = prefManager.getData("TOKEN_KEY") + ""
    const data: EmptyObject = {}
    this.token = TOKEN
    // const renderList = PersonInfoData.map((item) => ({
    //   const label: item.text,
    //
    // }))
    HttpRequest.get<HttpResult<UserInfoRe>>(API_ENDPOINTS.USERINFO, data, TOKEN).then((result) => {
      if (result.status === 1000 && result.data) {
        this.res = result.data
        Object.entries(this.res).forEach((entry: [string, string]) => {
          this.resMap.set(entry[0], entry[1])
        })

        // this.resMap.forEach((value, key) => {
        //   console.log("Map数据" + key, ':', value)
        // })

        console.log("请求数据成功")
      } else {
        console.error("用户信息请求失败：" + result.msg)
      }
    })
  }

  build() {
    Column() {
      TopBarBuilder(SettingImageLeft.icon, this.param)


      List({ space: 6 }) {
        ListItem() {

          // ThemeSettingBuilder(this.Data)
          Column() {

            Flex({ direction: FlexDirection.Column }) {
              ForEach(PersonInfoData, (item: TextExample, index: number) => {

                Row() {
                  Text(item.text)
                    .height(40)
                    .width("100%")// .backgroundColor(0xffffff)
                      // .border({ radius: { topLeft: 10, topRight: 10 } })
                    .layoutWeight(1)
                    .margin({ left: 10 })
                  // Image(SettingImageRight.icon)
                  //   .height(20)
                  //   .margin({ right: 10 })
                  if (item.type === "user_picture") {
                    Image(this.resMap.get(item.type) ?? '')
                      .margin({ right: 8 })
                      .height(30)
                      .borderRadius(15)
                  } else {
                    Text(this.resMap.get(item.type) ?? '')
                      .fontSize(16)
                      .fontColor(Color.Grey)
                      .margin({ right: 8 })
                  }
                }
                .height(this.Height)
                .onClick(() => {
                  HMRouterMgr.push({
                    pageUrl: item.pageUrl,
                    param: item.text
                  })
                })

                if (index < PersonInfoData.length - 1) {
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