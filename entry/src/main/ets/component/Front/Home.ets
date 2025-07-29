import { TextInputCodeImage, TextInputSearchImage, TextTabs } from '../../data/HomeData'
import { API_ENDPOINTS } from '../../data/variable'
import { EmptyObject, HttpResultArray, ProductRe } from '../../models/httpResult'
import { HttpRequest } from '../../service/HttpRequest'
import { PreferencesManager } from '../../service/preference'
import { promptAction } from '@kit.ArkUI'
import { FooterState, WaterFlowDataSource } from '../../data/WaterFlowDataSource'

@Component
export struct Home {
  @State minSize: number = 80
  @State maxSize: number = 180
  @State fontSize: number = 24
  @State footerState: FooterState = FooterState.Loading
  scroller: Scroller = new Scroller()
  allProducts: WaterFlowDataSource = new WaterFlowDataSource()
  footProduct: WaterFlowDataSource = new WaterFlowDataSource()
  @State selectedTabIndex: number = 0
  token = ""

  aboutToAppear(): void {
    const PrefManger = PreferencesManager.getInstance()
    const TOKEN = PrefManger.getData("TOKEN_KEY")
    this.token = TOKEN + ""
    let obj: EmptyObject = {}
    HttpRequest.get<HttpResultArray<ProductRe>>(API_ENDPOINTS.GetProduct, obj, this.token).then((result) => {
      if (result.status === 1000) {
        result.data.forEach((item: ProductRe) => {
          this.allProducts.addSource(item)
          if (item.category === "食品") {
            this.footProduct.addSource(item)
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
  itemFoot() {
    Column() {
      if (this.footerState === FooterState.Loading) {
        Text("加载中")
          .fontSize(10)
          .width(50)
          .height(50)
          .align(Alignment.Center)
          .margin({ top: 5, bottom: 5 })
      } else {
        Text("到底了")
          .fontSize(10)
          .width(50)
          .height(50)
          .align(Alignment.Center)
          .margin({ top: 5, bottom: 5 })
      }
    }
    .align(Alignment.Center)
    .justifyContent(FlexAlign.Center)
  }

  // @State selectedTabIndex: number = 0
  @Builder
  itemHead(text: string) {
    Text(text)
      .fontSize(16)
      .padding(10)
  }

  build() {
    List({ space: 10 }) {
      ListItem() {
        Row() {
          // 搜索栏放大镜样例
          Image(TextInputSearchImage.icon)
            .width(22)
            .fillColor('#fff')
            .padding({ top: 5, bottom: 5, left: 5 })
          // 搜索框显示字样
          TextInput({ placeholder: '点击以搜索' })
            .placeholderColor('#817D83')
            .padding({ left: 5 })
            .backgroundColor('#cedbed')
            .fontColor('#999')// 除使用之外
            .layoutWeight(1)
          // 扫描二维码之类
          Image(TextInputCodeImage.icon)
            .width(20)
            .fillColor('#fff')
        }.width('100%')
        .border({ radius: 20 })
        .backgroundColor('#cedbed')
        .padding({ left: 8, right: 8 })
      }


      ListItem() {
        Row({ space: 5 }) {
          List() {
            ForEach(TextTabs, (tabs: string, index) => {
              ListItem() {
                Text(tabs)
                  .fontSize(16)
                  .padding(10)
                  .fontColor(index === this.selectedTabIndex ? Color.Red : Color.Black)
                  .onClick(() => this.selectedTabIndex = index)
              }
            })
          }
          .sticky(StickyStyle.Header) // 吸顶设置
          .height(30)
          .scrollBar(BarState.Off)
          .width("85%")
          .listDirection(Axis.Horizontal)
        }
      }

      ListItem() {
        Column() {
          if (this.selectedTabIndex === 0) {
            // Column() {
            //   Text('推荐内容').padding(20)
            // }
            Column() {
              // WaterFlow({ footer: this.itemFoot() }) {
              WaterFlow() {
                LazyForEach(this.allProducts, (item: ProductRe) => {
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
                      Text(item.product_name)
                        .maxLines(2)
                        .fontColor(0x1c1c1c)
                      Text(`￥${item.product_price}`)
                        .fontColor(0xfb4440)
                      Text(item.shop_name)
                        .fontColor(0x959595)

                    }
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
          if (this.selectedTabIndex === 1) {
            Column() {
              Text('食品').padding(20)
            }
          }
          if (this.selectedTabIndex === 2) {
            Column() {
              Text('手机').padding(20)
            }
          }
        }
      }
    }
    .height('100%')
    .width('100%')
    .padding({
      left: 10,
      right: 10,
      top: 5,
      bottom: 5
    })
    .scrollBar(BarState.Off)
  }
}