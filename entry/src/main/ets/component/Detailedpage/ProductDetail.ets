import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { ProductDetailPage } from '../../data/PageUrl';
import { API_ENDPOINTS } from '../../data/variable';
import {
  appraise,
  commentGet,
  commentRe,
  EmptyObject,
  FollowShop,
  HttpResult,
  ProductRe,
  userCollect,
  userUnCollect
} from '../../models/httpResult';
import { HttpRequest } from '../../service/HttpRequest';
import { PreferencesManager } from '../../service/preference';
import { promptAction } from '@kit.ArkUI';
import { TopBarBuilder } from '../Builders/TopBar';
import { SettingImageLeft, SettingImageRight } from '../../data/SettingData';

@HMRouter({
  pageUrl: ProductDetailPage
})
@Component
export struct ProductDetail {
  @State param: number = -1
  @State isFollow: boolean = false
  @State isCollect: boolean = false
  @State isShow: boolean = false
  @State isShowByRow: boolean = false
  @State isShowFollowSheet: boolean = false
  //
  token: string = ""
  @State commentReArray: commentRe[] = []
  @State commentInput: string = ""
  @State newComment: string = ""
  @State commentMap: Map<number, commentRe> = new Map
  @State ProductDetailInfo: ProductRe = {
    id: 0,
    shop_id: 0,
    product_name: "",
    category: "",
    product_price: 0,
    product_unit: "",
    product_picture: "",
    CreatedAt: "",
    shop_name: "",
    product_introduction: "",
    product_score: 0
  }

  aboutToAppear(): void {
    this.param = HMRouterMgr.getCurrentParam() as number;
    const PrefManger = PreferencesManager.getInstance()
    const TOKEN = PrefManger.getData("TOKEN_KEY")
    this.token = TOKEN + ""
    let obj: EmptyObject = {}

    // 商品信息获取
    HttpRequest.get<HttpResult<ProductRe>>(API_ENDPOINTS.GetProductDetail + `/${this.param}`, obj,
      this.token).then((result) => {
      console.log("返回的状态码是: " + result.status)
      const data = result.data!

      console.log(
        `商品详情 => ` +
          `ID: ${data.id} | ` +
          `商铺ID: ${data.shop_id} | ` +
          `商品名称: ${data.product_name} | ` +
          `分类: ${data.category} | ` +
          `价格: ${data.product_price} | ` +
          `单位: ${data.product_unit} | ` +
          `图片地址: ${data.product_picture} | ` +
          `创建时间: ${data.CreatedAt} | ` +
          `商铺名称: ${data.shop_name} | ` +
          `简介: ${data.product_introduction} | ` +
          `评分: ${data.product_score}`
      )
      if (result.status === 1000) {
        this.ProductDetailInfo = result.data!

        // 是否收藏
        HttpRequest.get<HttpResult<number[]>>(API_ENDPOINTS.GetCollectList, obj, this.token).then((resultCollect) => {
          console.log("收藏status: " + resultCollect.status)
          if (resultCollect.status === 1000) {
            resultCollect.data!.forEach((item: number) => {
              if (item === this.param) {
                this.isCollect = true
              }
            })
          }
        })
        // 是否关注
        HttpRequest.get<HttpResult<number[]>>(API_ENDPOINTS.GetFollowedShops, obj,
          this.token).then((resultFollow) => {
          if (resultFollow.status === 1000) {
            resultFollow.data!.forEach((item: number) => {
              if (item === result.data!.shop_id) {
                this.isFollow = !this.isFollow
              }
            })
          }
        })
        // 评论信息获取
        let data: commentGet = {
          id: this.ProductDetailInfo.id
        }
        HttpRequest.post<HttpResult<appraise>>(API_ENDPOINTS.GetCommentByID, data,
          this.token).then((result) => {
          if (result.status === 1000) {
            // promptAction.showToast({
            //   message: "关注成功",
            //   duration: 2000
            // })
            this.commentReArray = result.data?.appraise ?? []
            // this.commentReArray.forEach((item: commentRe, index: number) => {
            //   console.info("获取评论信息:",
            //     this.commentReArray[index].user_name + " 评论：" + this.commentReArray[index].user_content +
            //       " 评分：" +
            //     this.commentReArray[index].user_rating);
            // })

          } else {
            promptAction.showToast({
              message: "获取评论失败",
              duration: 2000
            })
          }
        })
      } else {
        promptAction.showToast({
          message: "商品获取失败",
          duration: 2000
        })
      }
    })
  }

  @Builder
  SheetBuilder() {
    Column() {
      Scroll() {
        List({ space: 5 }) {
          if (Array.isArray(this.commentReArray) && this.commentReArray.length > 0 &&
          this.commentReArray[0].user_name) {
            ForEach(this.commentReArray, (item: commentRe) => {
              ListItem() {
                Row() {
                  Image(item.user_picture)
                    .borderRadius(20)
                    .width(40)
                    .height(40)
                    .margin({ left: 10, right: 10 })

                  Column() {
                    Text(item.user_name)
                      .fontSize(15)
                      .fontWeight(FontWeight.Bold)
                    // .width("70%")

                    Text(item.user_content)
                      .fontSize(14)
                    // .width("70%")
                  }
                  // .height("100%")
                  .alignItems(HorizontalAlign.Start)
                  .layoutWeight(1)
                  .justifyContent(FlexAlign.Start)

                  Column() {
                    Text("评分")

                    Divider()// 添加分隔线
                      // .vertical(true)
                      .color('#E0E0E0')
                      .width(1)
                      .margin({ top: 5, bottom: 5 }) // 可控制缩进样式

                    Text(`${item.user_rating}`)
                  }
                  // .height("100%")
                  .margin({ right: 10, left: 6 })
                  .alignItems(HorizontalAlign.End)
                  .justifyContent(FlexAlign.Start)
                }
                .alignItems(VerticalAlign.Top)
                .justifyContent(FlexAlign.Start)
                .width("100%")
              }

            })
          } else {
            ListItem() {
              Text("暂时没有评论")
            }
          }
        }
        .height("100%")
      }
      .layoutWeight(1)

      if (this.newComment !== "") {
        Row() {
          TextInput({ placeholder: '说说你的看法吧' })
            .onChange((value: string) => {
              this.newComment = value
            })
            .height(40)
            .placeholderColor('#817D83')
            .padding({ left: 5 })
            .backgroundColor('#cedbed')
            .fontColor('#999')// 除使用之外
            .layoutWeight(1)
            .margin({ right: 10, left: 10 })

          Button("发送")
            .height(40)
            .backgroundColor(0xa0badc)
            .onClick(() => {

            })
        }
        .margin({ bottom: 15 })
        .height("10%")

      } else {
        Row() {
          TextInput({ placeholder: '说说你的看法吧' })
            .onChange((value: string) => {
              this.newComment = value
            })
            .height(40)
            .placeholderColor('#817D83')
            .padding({ left: 5 })
            .backgroundColor('#cedbed')
            .fontColor('#999')// 除使用之外
            .layoutWeight(1)
            .margin({ right: 10, left: 10 })

          Image($r('app.media.icon_more'))
            .width(40)
            .height(40)
        }
        .margin({ bottom: 15 })
        .height("10%")
      }
    }
  }

  @Builder
  FollowSheetBuilder() {
    Column() {
      Text("确认取消关注吗")
        .fontSize(40)
        .height("50%")
        .width("100%")

      Row() {
        Button("确定")
          .width(100)
          .height(35)
          .fontSize(20)
          .backgroundColor(0xe4e5e7)
          .onClick(() => {
            let obj: userUnCollect = { shop_id: this.ProductDetailInfo.shop_id }
            HttpRequest.delete<HttpResult<null>>(API_ENDPOINTS.UnfollowShop, obj, this.token).then((result) => {
              if (result.status === 1000) {
                this.isFollow = !this.isFollow
              }
            })
          })
        Button("取消")
          .width(100)
          .height(35)
          .fontSize(20)
          .backgroundColor(0xff90d3)
          .onClick(() => {
            this.isShowFollowSheet = !this.isShowFollowSheet
          })
      }
    }
  }

  build() {
    Column() {
      TopBarBuilder(SettingImageLeft.icon)

      Scroll() {
        Column() {
          Row() {
            Text(this.ProductDetailInfo.shop_name)
              .margin({ top: 6, left: 6 })
              .fontSize(20)
              .layoutWeight(1)

            if (!this.isFollow) {
              Button("+关注")
                .width(100)
                .height(35)
                .fontSize(20)
                .backgroundColor(0xff90d3)
                .onClick(() => {
                  let obj: FollowShop = { shop_id: this.ProductDetailInfo.shop_id }
                  HttpRequest.post<HttpResult<null>>(API_ENDPOINTS.FollowShop, obj, this.token).then((result) => {
                    if (result.status === 1000) {
                      this.isFollow = !this.isFollow
                      promptAction.showToast({
                        message: "关注成功",
                        duration: 2000
                      })
                    }
                  })
                })
            } else {
              Button("已关注")
                .width(100)
                .height(35)
                .fontSize(20)
                .backgroundColor(0xe4e5e7)
                .onClick(() => {
                  this.isShowFollowSheet = !this.isShowFollowSheet
                })
                .bindSheet($$this.isShowFollowSheet, this.FollowSheetBuilder(), {
                  detents: [150],
                  preferType: SheetType.BOTTOM
                })
            }
          }
          .margin({ bottom: 10 })
          .width("100%")

          Column() {
            Row() {
              Text("￥")
                .fontSize(15)
                .fontColor(Color.Red)

              Text(`${this.ProductDetailInfo.product_price}`)
                .fontSize(25)
                .fontColor(Color.Red)
            }
            .margin({ top: 8, left: 10, bottom: 20 })
            .width("100%")

            Text(this.ProductDetailInfo.product_introduction)
              .fontSize(15)
              .margin({ left: 10 })

            Row() {
              Column() {
                Text("分类")
                  .fontColor(0x999999)
                  .textAlign(TextAlign.Start)
                  .margin({ bottom: 5 })
                  .width("100%")

                Text(this.ProductDetailInfo.category)
                  .textAlign(TextAlign.Start)
                  .width("100%")
              }
              .width("30%")

              Divider()// 添加分隔线
                .vertical(true)
                .color('#E0E0E0')
                .width(1)
                .margin({ top: 5, bottom: 5 }) // 可控制缩进样式

              Column() {
                Text("评分")
                  .fontColor(0x999999)
                  .textAlign(TextAlign.Start)
                  .margin({ left: 5, bottom: 5 })
                  .width("100%")

                Text(`${this.ProductDetailInfo.product_score}`)
                  .textAlign(TextAlign.Start)
                  .width("100%")
              }
            }
            .margin({ top: 10, left: 15 })
            .height(70)
            .alignItems(VerticalAlign.Top)
            .width("100%")

            Divider()// 添加分隔线
              .vertical(true)
              .color('#E0E0E0')
              .height(1)
              .width("100%")
              .margin({ top: 10, bottom: 10 }) // 可控制缩进样式

            Image(this.ProductDetailInfo.product_picture)
              .margin({ top: 5 })
              .border({
                radius: {
                  topRight: 20,
                  topLeft: 20,
                  bottomLeft: 20,
                  bottomRight: 20
                }
              })
          }
          .backgroundColor(0xffffff)
          .border({ radius: { topLeft: 20, topRight: 20 } })
          .width("100%")

          Row() {
            Text(`留言(${this.commentReArray.length})`)
              .fontWeight(FontWeight.Bold)
              .fontSize(20)
              .layoutWeight(1)

            Image(SettingImageRight.icon)
              .height(10)
              .width(10)
          }
          .margin({ left: 15, right: 15, top: 15 })
          .onClick(() => {
            this.isShowByRow = !this.isShowByRow
          })
          .bindSheet($$this.isShowByRow, this.SheetBuilder(), {
            detents: [600],
            preferType: SheetType.BOTTOM,
            title: {
              title: "留言", subtitle: `${this.commentReArray?.length ?? 0}`
            },

          })

          Column() {
            ForEach(this.commentReArray.slice(0, 2), (item: commentRe) => {
              Row() {
                Image(item.user_picture)
                  .borderRadius(20)
                  .width(40)
                  .height(40)
                  .margin({ left: 10, right: 10 })

                Column() {
                  Text(item.user_name)
                    .fontSize(15)
                    .fontWeight(FontWeight.Bold)
                  // .width("70%")

                  Text(item.user_content)
                    .fontSize(14)
                  // .width("70%")
                }
                // .height("100%")
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)
                .justifyContent(FlexAlign.Start)

                Column() {
                  Text("评分")

                  Divider()// 添加分隔线
                    // .vertical(true)
                    .color('#E0E0E0')
                    .width(1)
                    .margin({ top: 5, bottom: 5 }) // 可控制缩进样式

                  Text(`${item.user_rating}`)
                }
                // .height("100%")
                .margin({ right: 10, left: 6 })
                .alignItems(HorizontalAlign.End)
                .justifyContent(FlexAlign.Start)
              }
              .margin({ top: 10 })
              .alignItems(VerticalAlign.Top)
              .justifyContent(FlexAlign.Start)
              .width("100%")
            })
          }
          .margin({ top: 10, bottom: 10 })
        }
        .width("100%")
      }
      .layoutWeight(1)

      Row() {
        Row() {
          Image($r('app.media.icon_comment'))
            .width(20)
            .height(20)
            .margin({ right: 20, left: 20 })
            .onClick(() => {
              this.isShow = !this.isShow
            })
            .bindSheet($$this.isShow, this.SheetBuilder(), {
              detents: [600],
              preferType: SheetType.BOTTOM,
              title: {
                title: "留言", subtitle: `${this.commentReArray?.length ?? 0}`
              }
            })

          if (!this.isCollect) {
            Image($r('app.media.icon_unCollect'))
              .width(20)
              .margin({ right: 20, left: 20 })
              .onClick(() => {
                let obj: userCollect = { product_id: this.ProductDetailInfo.id }
                HttpRequest.post<HttpResult<null>>(API_ENDPOINTS.CollectProduct, obj, this.token).then((result) => {
                  if (result.status === 1000) {
                    this.isCollect = !this.isCollect
                  }
                })
              })
          } else {
            Image($r('app.media.icon_collect'))
              .width(20)
              .margin({ right: 20, left: 20 })
              .onClick(() => {
                let obj: userCollect = { product_id: this.ProductDetailInfo.id }
                HttpRequest.delete<HttpResult<null>>(API_ENDPOINTS.UnCollectProduct, obj, this.token).then((result) => {
                  if (result.status === 1000) {
                    this.isCollect = !this.isCollect
                  }
                })

              })
          }

        }
        .layoutWeight(1)
        .margin({ left: 15, right: 15 })
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Button("立即购买")
            .fontColor(Color.Black)
            .backgroundColor(0xf7f7f7)
            .width(100)
            .height(35)
            .fontSize(15)
            .margin({ right: 10 })

          Button("聊一聊")
            .fontColor(Color.Black)
            .backgroundColor(0xffe60f)
            .width(100)
            .height(35)
            .fontSize(15)
        }
        .margin({ right: 15 })
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .align(Alignment.Start)
      .width("100%")
      .height(50)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.START])

      // Image(this.ProductDetailInfo.product_picture)
    }
    .backgroundColor(0xffffff)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.START])
  }
}