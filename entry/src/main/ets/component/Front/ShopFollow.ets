import { HMRouter } from '@hadss/hmrouter';
import { ShopFollowPage } from '../../data/PageUrl';
import { SettingImageLeft } from '../../data/SettingData';
import { API_ENDPOINTS } from '../../data/variable';
import { EmptyObject, HttpResult, shopInfo } from '../../models/httpResult';
import { HttpRequest } from '../../service/HttpRequest';
import { PreferencesManager } from '../../service/preference';
import { TopBarBuilder } from '../Builders/TopBar';

@HMRouter({
  pageUrl: ShopFollowPage
})
@Component
export struct ShopFollow {
  token: string = ""
  @State userFollowList: number[] = []
  @State userFollowDetail: shopInfo[] = []
  @State userFollowListCount: number = 0

  aboutToAppear(): void {
    this.loadShopFollow()
  }

  build() {
    Column() {
      TopBarBuilder(SettingImageLeft.icon, "店铺关注")
      if (this.userFollowListCount) {
        List() {
          ForEach(this.userFollowDetail, (item: shopInfo) => {
            ListItem() {
              Row() {
                Image(item.picture)
                  .width(60)
                  .height(60)
                  .margin({ left: 10, bottom: 5, top: 5 })

                Column() {
                  Text(item.name)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  Text(`￥${item.score}`)
                    .fontColor(Color.Red)

                  Text(item.location)
                }
                .width("70%")
                .alignItems(HorizontalAlign.Start)
                .margin({ left: 10 })
              }
              .justifyContent(FlexAlign.Start)
            }
            .align(Alignment.Start)
            .backgroundColor(0xffffff)
            .width("90%")
            .margin({ top: 5, bottom: 5 })
            .border({
              radius: {
                topLeft: 10,
                topRight: 10,
                bottomLeft: 10,
                bottomRight: 10
              }
            })

          })
        }
        .backgroundColor("#ececec")
        .alignListItem(ListItemAlign.Center)
        .width("100%")
        .height("100%")
      } else {
        Column() {
          Text("暂无关注")
        }
        .backgroundColor("#ececec")
        .width("100%")
        .height("100%")
      }
    }
    .width("100%")
    .height("100%")

  }

  private loadShopFollow() {
    const prefManger = PreferencesManager.getInstance()
    const TOKEN = prefManger.getData("TOKEN_KEY")
    this.token = TOKEN + ""

    let obj: EmptyObject = {}
    HttpRequest.get<HttpResult<number[]>>(API_ENDPOINTS.GetFollowedShops, obj, this.token).then((result) => {
      if (result.status === 1000) {
        this.userFollowList = result.data!
        this.userFollowListCount = this.userFollowList.length

        this.userFollowList.forEach((item: number) => {
          HttpRequest.get<HttpResult<shopInfo>>(API_ENDPOINTS.GetShopInfo + `/${item}`, obj,
            this.token).then((resultFollowShop) => {
            if (resultFollowShop.status === 1000) {
              this.userFollowDetail.push(resultFollowShop.data!)
            } else {
              console.error("关注商铺信息请求失败：" + result.msg)
            }
          })
        })
      }
    })
  }
}