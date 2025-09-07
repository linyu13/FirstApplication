import { TextInputCodeImage, TextInputSearchImage, TextTabs } from '../../data/HomeData'
import { API_ENDPOINTS } from '../../data/variable'
import { EmptyObject, HttpResult, HttpResultArray, ProductRe, userCollect } from '../../models/httpResult'
import { HttpRequest } from '../../service/HttpRequest'
import { PreferencesManager } from '../../service/preference'
import { promptAction } from '@kit.ArkUI'
import { FooterState, WaterFlowDataSource } from '../../data/WaterFlowDataSource'
import { HMRouterMgr } from '@hadss/hmrouter'
import { ProductDetailPage, SearchHistoryPage } from '../../data/PageUrl'

@Component
export struct Home {
  // 瀑布流参数
  @State minSize: number = 80
  @State maxSize: number = 180
  @State fontSize: number = 24
  @State footerState: FooterState = FooterState.Loading
  @State selectedTabIndex: number = 0
  // 下拉刷新参数
  @State refreshing: boolean = false
  @State refreshOffset: number = 0
  @State refreshState: RefreshStatus = RefreshStatus.Inactive
  @State isLoading: boolean = false
  // token参数及商品信息
  token = ""
  scroller: Scroller = new Scroller()
  @State allProducts: WaterFlowDataSource = new WaterFlowDataSource()
  @State footProduct: WaterFlowDataSource = new WaterFlowDataSource()
  @State cellPhone: WaterFlowDataSource = new WaterFlowDataSource()
  @State ComputerOffice: WaterFlowDataSource = new WaterFlowDataSource()
  @State clothing: WaterFlowDataSource = new WaterFlowDataSource()
  @State Digital: WaterFlowDataSource = new WaterFlowDataSource()
  @State Fresh: WaterFlowDataSource = new WaterFlowDataSource()
  @State HomeAppliances: WaterFlowDataSource = new WaterFlowDataSource()
  @State other: WaterFlowDataSource = new WaterFlowDataSource()

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
          } else if (item.category === "手机") {
            this.cellPhone.addSource(item)
          } else if (item.category === "电脑办公") {
            this.ComputerOffice.addSource(item)
          } else if (item.category === "服装") {
            this.clothing.addSource(item)
          } else if (item.category === "数码") {
            this.Digital.addSource(item)
          } else if (item.category === "生鲜") {
            this.Fresh.addSource(item)
          } else if (item.category === "家电") {
            this.HomeAppliances.addSource(item)
          } else if (item.category === "其他") {
            this.other.addSource(item)
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

  aboutToDisappear(): void {
    console.log("销毁")
  }

  // @Builder
  // itemFoot() {
  //   Column() {
  //     if (this.footerState === FooterState.Loading) {
  //       Text("加载中")
  //         .fontSize(10)
  //         .width(50)
  //         .height(50)
  //         .align(Alignment.Center)
  //         .margin({ top: 5, bottom: 5 })
  //     } else {
  //       Text("到底了")
  //         .fontSize(10)
  //         .width(50)
  //         .height(50)
  //         .align(Alignment.Center)
  //         .margin({ top: 5, bottom: 5 })
  //     }
  //   }
  //   .align(Alignment.Center)
  //   .justifyContent(FlexAlign.Center)
  // }

  // @State selectedTabIndex: number = 0
  // @Builder
  // itemHead(text: string) {
  //   Text(text)
  //     .fontSize(16)
  //     .padding(10)
  // }

  @Builder
  RefreshBuilder() {
    Stack() {
      if (this.refreshState != RefreshStatus.Inactive && this.refreshState != RefreshStatus.Done) {
        Progress({ value: this.refreshOffset, total: 64, type: ProgressType.Ring })
          .width(32)
          .height(32)
          .style({ status: this.refreshing ? ProgressStatus.LOADING : ProgressStatus.PROGRESSING })
          .margin(10)
      }
    }
    .clip(true)
    .height("100%")
    .width("100%")
    .alignContent(Alignment.Bottom)
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
              let obj: userCollect = { product_id: item.id }
              HttpRequest.post<HttpResult<null>>(API_ENDPOINTS.UserHistory, obj, this.token).then((result) => {
                if (result.status === 1000) {
                  HMRouterMgr.push({
                    pageUrl: ProductDetailPage,
                    param: item.id
                  })
                } else {
                  promptAction.showToast({
                    message: "页面跳转失败",
                    duration: 2000
                  })
                }
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
      .height("100%")
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
            .onClick(() => {
              HMRouterMgr.push({
                pageUrl: SearchHistoryPage
              })
            })
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
        Stack() {
          Refresh({ refreshing: $$this.refreshing, builder: this.RefreshBuilder() }) {
            Column() {
              if (this.selectedTabIndex === 0) {
                this.WaterBuilder(this.allProducts)
              }
              if (this.selectedTabIndex === 1) {
                this.WaterBuilder(this.footProduct)
              }
              if (this.selectedTabIndex === 2) {
                this.WaterBuilder(this.cellPhone)
              }
              if (this.selectedTabIndex === 3) {
                this.WaterBuilder(this.ComputerOffice)
              }
              if (this.selectedTabIndex === 4) {
                this.WaterBuilder(this.clothing)
              }
              if (this.selectedTabIndex === 5) {
                this.WaterBuilder(this.Digital)
              }
              if (this.selectedTabIndex === 6) {
                this.WaterBuilder(this.Fresh)
              }
              if (this.selectedTabIndex === 7) {
                this.WaterBuilder(this.HomeAppliances)
              }
              if (this.selectedTabIndex === 8) {
                this.WaterBuilder(this.other)
              }
            }
            .width("100%")
            .height("100%")
          }
          .width("100%")
          .height("100%")
          .onOffsetChange((offset: number) => {
            this.refreshOffset = offset
          })
          .onStateChange((state: RefreshStatus) => {
            this.refreshState = state
          })
          .onRefreshing(() => {
            this.allProducts.deleteAll()
            this.footProduct.deleteAll()
            this.cellPhone.deleteAll()
            this.ComputerOffice.deleteAll()
            this.clothing.deleteAll()
            this.Digital.deleteAll()
            this.Fresh.deleteAll()
            this.HomeAppliances.deleteAll()
            this.other.deleteAll()

            let obj: EmptyObject = {}
            HttpRequest.get<HttpResultArray<ProductRe>>(API_ENDPOINTS.GetProduct, obj, this.token).then((result) => {
              if (result.status === 1000) {
                result.data.forEach((item: ProductRe) => {
                  this.allProducts.addSource(item)
                  if (item.category === "食品") {
                    this.footProduct.addSource(item)
                  } else if (item.category === "手机") {
                    this.cellPhone.addSource(item)
                  } else if (item.category === "电脑办公") {
                    this.ComputerOffice.addSource(item)
                  } else if (item.category === "服装") {
                    this.clothing.addSource(item)
                  } else if (item.category === "数码") {
                    this.Digital.addSource(item)
                  } else if (item.category === "生鲜") {
                    this.Fresh.addSource(item)
                  } else if (item.category === "家电") {
                    this.HomeAppliances.addSource(item)
                  } else if (item.category === "其他") {
                    this.other.addSource(item)
                  }
                })
              } else {
                promptAction.showToast({
                  message: "商品获取失败",
                  duration: 2000
                })
              }
            })

            setTimeout(() => {
              this.refreshing = false
            }, 2000)
          })

          // Button("+")
          //   .
        }
      }
    }
    .scrollBar(BarState.Off)
    // 边缘滑动
    .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
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