import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { ProductCollectPage, ProductDetailPage } from '../../data/PageUrl';
import { SettingImageLeft } from '../../data/SettingData';
import { API_ENDPOINTS } from '../../data/variable';
import { EmptyObject, HttpResult, ProductRe } from '../../models/httpResult';
import { HttpRequest } from '../../service/HttpRequest';
import { PreferencesManager } from '../../service/preference';
import { TopBarBuilder } from '../Builders/TopBar';

@HMRouter({
  pageUrl: ProductCollectPage
})
@Component
export struct ProductCollect {
  token: string = ""
  @State userCollectList: number[] = []
  @State userCollectDetail: ProductRe[] = []
  @State userCollectListCount: number = 0

  aboutToAppear(): void {
    this.loadUserCollect()
  }

  build() {
    Column() {
      TopBarBuilder(SettingImageLeft.icon, "商品收藏")
      if (this.userCollectListCount) {
        List({ space: 6 }) {
          ForEach(this.userCollectDetail, (item: ProductRe) => {
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
                  param: item.id
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
        .height("100%")
        .backgroundColor("#ececec")
        .alignListItem(ListItemAlign.Center)
        .width("100%")
      } else {
        Text("暂无收藏")
      }
    }
  }

  private loadUserCollect() {
    const prefManger = PreferencesManager.getInstance()
    const TOKEN = prefManger.getData("TOKEN_KEY")
    this.token = TOKEN + ""

    let obj: EmptyObject = {}
    HttpRequest.get<HttpResult<number[]>>(API_ENDPOINTS.GetCollectList, obj, this.token).then((result) => {
      if (result.status === 1000) {
        this.userCollectList = result.data!
        this.userCollectListCount = this.userCollectList.length
        console.info(`收藏商品页面请求数据${result.data?.length}`)
        this.userCollectList.forEach((item: number) => {
          let obj: EmptyObject = {}
          HttpRequest.get<HttpResult<ProductRe>>(API_ENDPOINTS.GetProductDetail + `/${item}`, obj,
            this.token).then((resultGetProduct) => {
            console.info(`收藏商品页面请求商品信息的status ${resultGetProduct.status}`)
            if (resultGetProduct.status === 1000) {
              this.userCollectDetail.push(resultGetProduct.data!)
              console.info(`商品名称: ${resultGetProduct.data?.shop_name}`)
            } else {
              console.error("收藏商品信息请求失败：" + result.msg)
            }
          })
        })
      } else {
        console.error("用户收藏信息请求失败：" + result.msg)
      }
    })
  }
}