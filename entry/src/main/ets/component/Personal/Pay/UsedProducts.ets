import { API_ENDPOINTS } from '../../../data/variable'
import { EmptyObject, HttpResultArray, orderRe } from '../../../models/httpResult'
import { HttpRequest } from '../../../service/HttpRequest'
import { PreferencesManager } from '../../../service/preference'

@Component
export struct UsedProducts {
  token: string = ""
  @State UsedProductsList: orderRe[] = []
  @State UsedProductsListCount: number = 0

  aboutToAppear(): void {
    this.loadUsedProducts()
  }

  build() {
    Column() {
      if (this.UsedProductsListCount) {
        List() {
          ForEach(this.UsedProductsList, (item: orderRe) => {
            ListItem() {
              Row() {
                Image(item.product_picture)
                  .width(80)
                  .height(80)

                Column() {
                  Text(item.product_name)
                    .fontSize(15)
                    .width(200)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .textAlign(TextAlign.Start)

                  Text(item.shop_name)
                    .fontSize(15)
                    .width(200)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .textAlign(TextAlign.Start)

                  Text(`${item.product_price} × ${item.product_count}`)
                    .fontSize(15)
                    .textAlign(TextAlign.Start)
                    .width(200)

                }
                .margin({ left: 10 })
              }
            }
            .height(100)
            .backgroundColor(Color.White)
            .margin({
              left: 10,
              top: 5,
              bottom: 5,
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
            .width("90%")
          })
        }
        .backgroundColor(0xf1f3f5)
        .alignListItem(ListItemAlign.Center)
        .width("100%")
        .height("100%")
      } else {
        Text("暂无使用中的物品")
      }
    }
    .width("100%")
    .height("100%")
  }

  private loadUsedProducts() {
    const prefManger = PreferencesManager.getInstance()
    const TOKEN = prefManger.getData("TOKEN_KEY")
    this.token = TOKEN + ""

    let obj: EmptyObject = {}
    HttpRequest.get<HttpResultArray<orderRe>>(API_ENDPOINTS.GetOrderList, obj, this.token).then((result) => {
      if (result.status === 1000) {
        result.data.forEach((item: orderRe) => {
          if (item.is_buy) {
            const UpdateTime = item.updated_at
            const isoTime = UpdateTime.replace(" ", "T") + "Z"

            const orderUpdateTime = new Date(isoTime)
            const nowTime = new Date()

            const diffMilliseconds = nowTime.getTime() - orderUpdateTime.getTime()
            let diffSeconds = Math.floor(diffMilliseconds / 1000)
            let diffMinutes = Math.floor(diffSeconds / 60)
            let diffHours = Math.floor(diffMinutes / 60)
            console.info(`UsedProductsList ${diffHours}`)


            if (diffHours > 4) {
              this.UsedProductsList.push(item)
              this.UsedProductsListCount++
              console.info(`UsedProductsListCount: ${this.UsedProductsListCount}`)
            }

          }
        })
      }
    })
  }
}