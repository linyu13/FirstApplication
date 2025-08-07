import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { ProductDetailPage, ViewHistoryPage } from '../../data/PageUrl';
import { SettingImageLeft } from '../../data/SettingData';
import { API_ENDPOINTS } from '../../data/variable';
import { EmptyObject, HttpResultArray, UserHistory } from '../../models/httpResult';
import { HttpRequest } from '../../service/HttpRequest';
import { PreferencesManager } from '../../service/preference';
import { TopBarBuilder } from '../Builders/TopBar';

@HMRouter({
  pageUrl: ViewHistoryPage
})
@Component
export struct ViewHistory {
  token: string = ""
  @State HistoryList: UserHistory[] = []
  @State HistoryListCount: number = 0

  aboutToAppear(): void {
    this.loadHistory()
  }

  build() {
    Column() {
      TopBarBuilder(SettingImageLeft.icon, "浏览历史")

      if (this.HistoryListCount) {
        List({ space: 6 }) {
          ForEach(this.HistoryList, (item: UserHistory) => {
            ListItem() {
              Row() {
                Image(item.product_picture)
                  .width(60)
                  .height(60)
                  .margin({ left: 10, bottom: 5, top: 5 })

                Column() {
                  Text(item.product_name)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  Text(`￥${item.product_price}`)
                    .fontColor(Color.Red)

                  Text(item.shop_name)
                }
                .width("70%")
                .alignItems(HorizontalAlign.Start)
                .margin({ left: 10 })
              }
              .justifyContent(FlexAlign.Start)
              .onClick(() => {
                HMRouterMgr.push({
                  pageUrl: ProductDetailPage,
                  param: item.product_id
                })
              })
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
        .width("100%")
        .height("100%")
        .backgroundColor("#ececec")
        .alignListItem(ListItemAlign.Center)

      } else {
        Text("暂无历史记录")

      }

    }
  }

  private loadHistory() {
    const prefManger = PreferencesManager.getInstance()
    const TOKEN = prefManger.getData("TOKEN_KEY")
    this.token = TOKEN + ""

    let obj: EmptyObject = {}
    HttpRequest.get<HttpResultArray<UserHistory>>(API_ENDPOINTS.GetUserHistory, obj, this.token).then((result) => {
      if (result.status === 1000) {
        this.HistoryList = result.data
        this.HistoryListCount = this.HistoryList.length
        this.HistoryList.forEach((item: UserHistory) => {
          console.info(`UserHistory: user_id=${item.user_id}, product_id=${item.product_id}, shop_id=${item.shop_id}, shop_name=${item.shop_name}, product_name=${item.product_name}, category=${item.category}, product_price=${item.product_price}, product_picture=${item.product_picture}, product_introduction=${item.product_introduction}, product_score=${item.product_score}`)
        })
      } else {
        console.error("用户收藏信息请求失败：" + result.msg)
      }
    })
  }
}