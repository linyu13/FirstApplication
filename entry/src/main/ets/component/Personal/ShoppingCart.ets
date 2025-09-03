import { HMRouter } from '@hadss/hmrouter';
import { ShoppingCartPage } from '../../data/PageUrl';
import { API_ENDPOINTS } from '../../data/variable';
import { creatOrder, EmptyObject, HttpResult, HttpResultArray, orderRe } from '../../models/httpResult';
import { HttpRequest } from '../../service/HttpRequest';
import { PreferencesManager } from '../../service/preference';
import { promptAction } from '@kit.ArkUI';
import { TopBarBuilder } from '../Builders/TopBar';
import { SettingImageLeft } from '../../data/SettingData';

@HMRouter({
  pageUrl: ShoppingCartPage
})
@Component
export struct ShoppingCart {
  token: string = ""
  @State orderList: orderRe[] = []
  productBuyList: orderRe[] = []
  @State productIsSelect: boolean[] = []
  @State productBuyCount: number[] = []
  @State allPrice: number = 0

  aboutToAppear(): void {
    this.loadShoppingCart()
  }

  build() {

    Column() {
      TopBarBuilder(SettingImageLeft.icon, "购物车")

      List({ space: 6 }) {
        ForEach(this.orderList, (item: orderRe, index: number) => {
          ListItem() {
            Row() {
              Checkbox()
                .select(this.productIsSelect[index] ?? false)
                .selectedColor(0xed6f21)
                .shape(CheckBoxShape.CIRCLE)
                .onChange((value: boolean) => {
                  let oldValue = this.productIsSelect[index]
                  if (oldValue === true && value === false) {
                    this.allPrice -= this.productBuyCount[index] * item.product_price
                  } else {
                    this.allPrice += this.productBuyCount[index] * item.product_price
                  }
                  this.productIsSelect[index] = value;
                  this.productIsSelect = [...this.productIsSelect];
                })


              Image(item.product_picture)
                .width(60)
                .height(60)
                .margin({ left: 10, right: 10 })

              Column() {
                Text(item.product_name)
                  .fontSize(20)
                  .width("100%")
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })

                Text(`￥${item.product_price}`)
                  .width("100%")
                  .fontSize(20)
                  .margin({ left: 10, right: 10 })

              }
              .layoutWeight(1)

              Row() {
                Text("-")
                  .fontSize(25)
                  .backgroundColor("#ececec")
                  .width(35)
                  .height(35)
                  .textAlign(TextAlign.Center)
                  .onClick(() => {
                    if (this.productBuyCount[index] > 1) {
                      this.productBuyCount[index]--

                      if (this.productIsSelect[index]) {
                        this.allPrice -= item.product_price
                      }

                      // this.productBuyCount[index] = item.product_count
                    }
                  })
                  .gesture(
                    LongPressGesture({
                      repeat: true,
                      duration: 300
                    })
                      .onAction((event: GestureEvent | undefined) => {
                        if (event) {
                          if (event.repeat) {
                            if (this.productBuyCount[index] > 1) {
                              this.productBuyCount[index]--

                              if (this.productIsSelect[index]) {
                                this.allPrice -= item.product_price
                              }

                              // this.productBuyCount[index] = item.product_count
                            }
                          }
                        }
                      })
                  )

                Text(`${this.productBuyCount[index]}`)
                  .fontSize(25)
                  .backgroundColor(Color.White)
                  .width(35)
                  .height(35)
                  .textAlign(TextAlign.Center)

                Text("+")
                  .fontSize(25)
                  .backgroundColor("#ececec")
                  .width(35)
                  .height(35)
                  .textAlign(TextAlign.Center)
                  .onClick(() => {
                    if (this.productBuyCount[index] < 99) {
                      this.productBuyCount[index]++
                      if (this.productIsSelect[index]) {
                        this.allPrice += item.product_price
                      }

                      // this.productBuyCount[index] = item.product_count
                    } else {
                      promptAction.showToast({
                        message: "单次购买最多为99",
                        duration: 2000
                      })
                    }
                  })
                  .gesture(
                    LongPressGesture({
                      repeat: true,
                      duration: 300
                    })
                      .onAction((event: GestureEvent | undefined) => {
                        if (event) {
                          if (event.repeat) {
                            if (this.productBuyCount[index] < 99) {
                              this.productBuyCount[index]++

                              if (this.productIsSelect[index]) {
                                this.allPrice += item.product_price
                              }
                              // this.productBuyCount[index] = item.product_count
                            } else {
                              promptAction.showToast({
                                message: "单次购买最多为99",
                                duration: 2000
                              })
                            }
                          }
                        }
                      })
                  )
              }
              .border({
                radius: {
                  topRight: 5,
                  topLeft: 5,
                  bottomRight: 5,
                  bottomLeft: 5
                }
              })
              .margin({ right: 8 })

            }
          }
          .height("15%")
          .width("90%")
          .backgroundColor(Color.White)
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
      .alignListItem(ListItemAlign.Center)
      .margin({ top: 10 })
      .width("100%")
      .height("87%")

      Row() {
        Row() {
          Text("总价")
            .fontSize(15)
            .margin({ left: 10, right: 20 })

          Text(`￥${this.allPrice}`)
            .fontSize(20)
        }
        .layoutWeight(1)

        Row() {
          Text("保存")
            .border({
              radius: {
                topLeft: 10,
                topRight: 10,
                bottomLeft: 10,
                bottomRight: 10
              }
            })
            .textAlign(TextAlign.Center)
            .width(100)
            .height(50)
            .backgroundColor(0xf7f7f7)
            .onClick(() => {
              this.orderList.forEach((item: orderRe, index: number) => {
                if (item.product_count !== this.productBuyCount[index]) {
                  let obj: creatOrder =
                    { product_count: this.productBuyCount[index], product_id: item.product_id, is_buy: false }
                  console.info(`product_id ${item.product_id} product_count ${this.productBuyCount[index]} is_buy ${false} preCount ${item.product_count}`)
                  HttpRequest.put<HttpResult<null>>(API_ENDPOINTS.UpdateOrder, obj, this.token).then((result) => {
                    if (result.status === 1000) {
                      item.product_count = this.productBuyCount[index]
                      // this.loadShoppingCart()
                      promptAction.showToast({
                        message: "保存成功",
                        duration: 2000
                      })
                    } else {
                      promptAction.showToast({
                        message: "保存失败",
                        duration: 2000
                      })

                    }
                  })
                }
              })
            })


          Text("立即购买")
            .border({
              radius: {
                topLeft: 10,
                topRight: 10,
                bottomLeft: 10,
                bottomRight: 10
              }
            })
            .textAlign(TextAlign.Center)
            .width(100)
            .height(50)
            .backgroundColor(0xd0604d)
            .onClick(() => {
              this.orderList.forEach((item: orderRe, index: number) => {
                if (this.productIsSelect[index]) {
                  item.is_buy = true
                  let obj: creatOrder = {
                    product_id: item.product_id,
                    product_count: this.productBuyCount[index],
                    is_buy: true
                  }

                  HttpRequest.put<HttpResult<null>>(API_ENDPOINTS.UpdateOrder, obj, this.token).then((result) => {
                    if (result.status === 1000) {
                      promptAction.showToast({
                        message: "购买成功",
                        duration: 2000
                      })

                    } else {
                      promptAction.showToast({
                        message: "购买失败",
                        duration: 2000
                      })
                    }
                  })
                } else {
                  promptAction.showToast({
                    message: "尚未勾选商品",
                    duration: 2000
                  })
                }
              })
              this.orderList.forEach((item: orderRe) => {
                console.log(`filter方法前的orderList product_id ${item.product_id} product_count ${item.product_count} is_buy ${item.is_buy}`)
              })


              const deleteIndexes: number[] = []
              this.orderList.forEach((item, index) => {
                if (item.is_buy) {
                  deleteIndexes.push(index)
                }
              })

              deleteIndexes.reverse().forEach(i => {
                this.productIsSelect.splice(i, 1)
                this.allPrice -= this.productBuyCount[i] * this.orderList[i].product_price
                this.productBuyCount.splice(i, 1)
              })

              this.orderList = this.orderList.filter(item => item.is_buy !== true)

              this.orderList.forEach((item: orderRe) => {
                console.log(`filter方法后的orderList product_id ${item.product_id} product_count ${item.product_count} is_buy ${item.is_buy}`)
              })
            })

        }
      }
      .backgroundColor(Color.White)
    }
    .height("100%")
    .backgroundColor(0xf7f7f7)

  }

  private loadShoppingCart() {
    const prefManger = PreferencesManager.getInstance()
    const TOKEN = prefManger.getData("TOKEN_KEY")
    this.token = TOKEN + ""

    let obj: EmptyObject = {}
    HttpRequest.get<HttpResultArray<orderRe>>(API_ENDPOINTS.GetOrderList, obj, this.token).then((result) => {
      if (result.status === 1000) {
        result.data.forEach((item: orderRe) => {
          if (item.is_buy === false) {
            this.orderList.push(item)
            this.productBuyCount.push(item.product_count)
            // this.productBuyList.push(item)
            // this.allPrice += item.product_price * item.product_count
          }
        })
      } else {
        promptAction.showToast({
          message: "购物车信息获取失败",
          duration: 2000
        })
      }
    })
  }
}