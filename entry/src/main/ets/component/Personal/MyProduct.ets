import { API_ENDPOINTS, JwtPayload } from '../../data/variable'
import { WaterFlowDataSource } from '../../data/WaterFlowDataSource'
import {
  creatProduct,
  creatShop,
  EmptyObject,
  HttpResult,
  HttpResultArray,
  IsShopOwnerRe,
  ProductRe
} from '../../models/httpResult'
import { HttpRequest } from '../../service/HttpRequest'
import { PreferencesManager } from '../../service/preference'
import { promptAction } from '@kit.ArkUI'
import { ProductDetailPage } from '../../data/PageUrl'
import { HMRouterMgr } from '@hadss/hmrouter'
import { categoryTextArray } from '../../data/category'
import { base } from '../../service/token'

@Component
export struct MyProduct {
  token: string = ""
  @State isSelect: number = -1
  @State allProducts: WaterFlowDataSource = new WaterFlowDataSource()
  @State isShowSheet: boolean = false
  @State isShowShopSheet: boolean = false
  @State shopName: string = ""
  @State shopIntroduction: string = ""
  @State shopLocation: string = ""
  @State shopPhone: string = ""
  @State getProductCount: number = -1
  //
  @State productName: string = ""
  @State productPrice: string = ""
  @State productIntroduction: string = ""
  @State ProductCategorySelect: string = ""
  @State isCategorySelect: boolean = false
  @State isShowCategory: boolean = false

  aboutToAppear(): void {
    this.loadMyProduct()
  }

  @Builder
  WaterBuilder(Source: WaterFlowDataSource) {
    Column() {
      // WaterFlow({ footer: this.itemFoot() }) {
      WaterFlow() {
        LazyForEach(Source, (item: ProductRe) => {
          FlowItem() {
            Column() {
              Image(item.product_picture)
                .width("100%")
                .border({
                  radius: {
                    topLeft: 10,
                    topRight: 10
                  }
                })
              Column() {
                Text(item.product_name)
                  .maxLines(2)
                  .width("100%")
                  .fontColor(0x1c1c1c)
                  .textAlign(TextAlign.Start)
                Text(`￥${item.product_price}`)
                  .fontColor(0xfb4440)
                  .width("100%")
                  .textAlign(TextAlign.Start)
                Text(item.shop_name)
                  .fontColor(0x959595)
                  .width("100%")
                  .textAlign(TextAlign.Start)
              }.width("100%")

            }
            .onClick(() => {
              HMRouterMgr.push({
                pageUrl: ProductDetailPage,
                param: item.id
              })
            })
            .margin({ top: 5, bottom: 5 })
            .backgroundColor(0xffffff)
            // .backgroundColor(Color.Black)
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
        })
      }
      .columnsTemplate("1fr 1fr")
      .columnsGap(20)
      .rowsGap(10)
      .backgroundColor(0xf7f6f4)
      .width("100%")
      .height("85%")
      // .onReachEnd(() => {
      //
      // })
      .onScrollIndex((first: number, last: number) => {
        if (last + 20 >= this.allProducts.totalCount()) {
          setTimeout(() => {
            this.allProducts.notifyDataAdd(30)
          }, 1000)
        }
      })
    }
  }

  @Builder
  ShowBuilder(showWhich: boolean) {
    Column() {
      if (showWhich === true) {
        Column() {
          Row() {
            Text("商铺名称")
            TextInput({ text: this.shopName })
              .borderRadius(0)
              .padding(3)
              .borderColor({
                top: Color.Transparent,
                left: Color.Transparent,
                right: Color.Transparent,
                bottom: Color.Black
              })
              .width("80%")
              .margin({ left: 20, right: 20, bottom: 10 })// 设置左右边距
              .placeholderColor(0x7b7b87)
              .backgroundColor(0xe8e9ed)
              .onChange((value: string) => {
                this.shopName = value
              })
              .backgroundColor(Color.Transparent)
              .borderWidth(1)

          }
          .width("90%")

          Row() {
            Text("商铺位置")
            TextInput({ text: this.shopLocation })
              .borderRadius(0)
              .padding(3)
              .borderColor({
                top: Color.Transparent,
                left: Color.Transparent,
                right: Color.Transparent,
                bottom: Color.Black
              })
              .width("80%")
              .margin({ left: 20, right: 20, bottom: 10 })// 设置左右边距
              .placeholderColor(0x7b7b87)
              .backgroundColor(0xe8e9ed)
              .onChange((value: string) => {
                this.shopLocation = value
              })
              .backgroundColor(Color.Transparent)
              .borderWidth(1)

          }
          .width("90%")

          Row() {
            Text("商铺介绍")
            TextInput({ text: this.shopIntroduction })
              .borderRadius(0)
              .padding(3)
              .borderColor({
                top: Color.Transparent,
                left: Color.Transparent,
                right: Color.Transparent,
                bottom: Color.Black
              })
              .width("80%")
              .margin({ left: 20, right: 20, bottom: 10 })// 设置左右边距
              .placeholderColor(0x7b7b87)
              .backgroundColor(0xe8e9ed)
              .onChange((value: string) => {
                this.shopIntroduction = value
              })
              .backgroundColor(Color.Transparent)
              .borderWidth(1)

          }
          .width("90%")

          // 缺图片上传

          Row() {
            Text("商铺联系电话")
            TextInput({ text: this.shopPhone })
              .borderRadius(0)
              .padding(3)
              .borderColor({
                top: Color.Transparent,
                left: Color.Transparent,
                right: Color.Transparent,
                bottom: Color.Black
              })
              .width("80%")
              .margin({ left: 20, right: 20, bottom: 10 })// 设置左右边距
              .placeholderColor(0x7b7b87)
              .backgroundColor(0xe8e9ed)
              .onChange((value: string) => {
                this.shopPhone = value
              })
              .type(InputType.PhoneNumber)
              .backgroundColor(Color.Transparent)
              .borderWidth(1)

          }
          .width("90%")

          Button("注册商铺")
            .onClick(() => {

              let obj: creatShop = {
                name: this.shopName,
                location: this.shopLocation,
                introduction: this.shopIntroduction,
                phone: this.shopPhone
              }

              HttpRequest.post<HttpResult<null>>(API_ENDPOINTS.RegisterShop, obj, this.token).then((result) => {
                if (result.status === 1000) {
                  promptAction.showToast({
                    message: "注册成功",
                    duration: 2000
                  })
                  this.isShowSheet = !this.isShowSheet
                  this.loadMyProduct()
                } else {
                  promptAction.showToast({
                    message: "注册失败",
                    duration: 2000
                  })
                  console.log(`注册为商铺 返回的status ${result.status} 返回的message ${result.msg}`)
                }
              })
            })
        }
      } else {
        Column() {
          Row() {
            Text("商品名称")
            TextInput({ text: this.productName })
              .onChange((value: string) => {
                this.productName = value
              })
              .borderRadius(0)
              .padding(3)
              .borderColor({
                top: Color.Transparent,
                left: Color.Transparent,
                right: Color.Transparent,
                bottom: Color.Black
              })
              .width("80%")
              .margin({ left: 20, right: 20, bottom: 10 })// 设置左右边距
              .placeholderColor(0x7b7b87)
              .backgroundColor(0xe8e9ed)
              .backgroundColor(Color.Transparent)
              .borderWidth(1)

          }
          .width("90%")

          Row() {
            Text("商品简介")
            TextInput({ text: this.productIntroduction })
              .onChange((value: string) => {
                this.productIntroduction = value
              })
              .borderRadius(0)
              .padding(3)
              .borderColor({
                top: Color.Transparent,
                left: Color.Transparent,
                right: Color.Transparent,
                bottom: Color.Black
              })
              .width("80%")
              .margin({ left: 20, right: 20, bottom: 10 })// 设置左右边距
              .placeholderColor(0x7b7b87)
              .backgroundColor(0xe8e9ed)
              .backgroundColor(Color.Transparent)
              .borderWidth(1)

          }
          .width("90%")

          Row() {
            Text("商品价格")
            TextInput({ text: this.productPrice })
              .type(InputType.Number)
              .onChange((value) => {
                this.productPrice = value
              })
              .borderRadius(0)
              .padding(3)
              .borderColor({
                top: Color.Transparent,
                left: Color.Transparent,
                right: Color.Transparent,
                bottom: Color.Black
              })
              .width("80%")
              .margin({ left: 20, right: 20, bottom: 10 })// 设置左右边距
              .placeholderColor(0x7b7b87)
              .backgroundColor(0xe8e9ed)
              .backgroundColor(Color.Transparent)
              .borderWidth(1)

          }
          .width("90%")

          Row() {
            Text("商品分类")
              .textAlign(TextAlign.Start)
          }
          .width("90%")
          .onClick(() => {
            this.isShowCategory = !this.isShowCategory
          })
          .bindSheet($$this.isShowCategory, this.showCategoryBuilder(), {
            detents: [400],
            preferType: SheetType.BOTTOM,
            title: {
              title: "选择商品分类"
            }
          })

          Button("上传商品")
            .onClick(() => {
              let obj: creatProduct = {
                product_name: this.productName,
                product_price: Number(this.productPrice),
                product_introduction: this.productIntroduction,
                category: categoryTextArray[this.isSelect]
              }
              HttpRequest.post<HttpResult<null>>(API_ENDPOINTS.CreateProduct, obj, this.token).then((result) => {
                if (result.status === 1000) {
                  promptAction.showToast({
                    message: "上传商品成功",
                    duration: 2000
                  })
                  this.loadMyProduct()
                  this.isShowSheet = !this.isShowSheet
                } else {
                  console.log(`上传商品时 返回的status ${result.status} 返回的message ${result.msg}`)
                }
              })
            })
        }
      }
    }
  }

  @Builder
  showCategoryBuilder() {
    Column() {
      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
        ForEach(categoryTextArray, (item: string, index: number) => {
          Text(item)
            .width(70)
            .backgroundColor(this.isSelect === index ? 0xff7ca6 : 0xf8f8f8)
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
              if (this.isSelect === index) {
                this.isSelect = -1
              } else {
                this.isSelect = index
              }
            })
        })
      }
    }
  }

  build() {
    Stack() {
      if (this.getProductCount) {
        Column() {
          this.WaterBuilder(this.allProducts)
        }
      } else {
        Column() {
          Text("暂时还没有发布的商品")
        }
      }

      Column() {
        Button("+")
          .width(60)
          .height(60)
          .backgroundColor("#e85a88")
          .fontColor(Color.White)
          .onClick(() => {
            let obj: EmptyObject = {}
            HttpRequest.post<HttpResult<IsShopOwnerRe>>(API_ENDPOINTS.IsShopOwner, obj, this.token).then((result) => {
              console.log(`检测是否是商铺 返回的status ${result.status} 返回的message ${result.msg} 返回的数据 ${result.data?.is_shop_owner}`)
              if (result.status === 1000 && result.data?.is_shop_owner === true) {
                // this.isShowSheet = !this.isShowSheet
                this.isShowSheet = !this.isShowSheet
                this.isShowShopSheet = false
              } else if (result.status === 1000 && result.data?.is_shop_owner === false) {
                this.isShowSheet = !this.isShowSheet
                this.isShowShopSheet = true
              } else if (result.status !== 1000) {
                promptAction.showToast({
                  message: "是否为商铺获取失败",
                  duration: 2000
                })
              }
            })
          })
          .bindSheet($$this.isShowSheet, this.ShowBuilder(this.isShowShopSheet), {
            detents: [600],
            preferType: SheetType.BOTTOM,
            title: {
              title: this.isShowShopSheet ? "注册为商铺" : "上传商品"
            }
          })
      }
    }
    .width("100%")
    .height("100%")
  }

  private loadMyProduct() {
    const prefManger = PreferencesManager.getInstance()
    const TOKEN = prefManger.getData("TOKEN_KEY") + ""
    this.token = TOKEN

    let obj: EmptyObject = {}
    const userToken: JwtPayload = base(this.token)
    HttpRequest.get<HttpResultArray<ProductRe>>(API_ENDPOINTS.GetProductsByShopID + userToken.user_id, obj,
      this.token).then((result) => {
      if (result.status === 1000) {
        console.log(`本次获取到了 ${result.data.length} 个该用户的商品数据`)
        result.data.forEach((item: ProductRe) => {
          this.allProducts.addSource(item)
        })
        this.getProductCount = this.allProducts.totalCount()
        console.log(`本次瀑布流类存入数据 ${this.allProducts.totalCount()} 个该用户的商品数据`)
      } else {
        promptAction.showToast({
          message: "我的商品获取失败",
          duration: 2000
        })

      }
    })
  }
}