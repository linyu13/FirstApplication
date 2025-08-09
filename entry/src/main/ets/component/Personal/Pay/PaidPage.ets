import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { PaidPage } from '../../../data/PageUrl';
import { SettingImageLeft } from '../../../data/SettingData';
import { PayTabData } from '../../../data/TabClass';
import { orderRe } from '../../../models/httpResult';
import { TabClass } from '../../../models/TabClass';
import { TopBarBuilder } from '../../Builders/TopBar';
import { GoodsReceived } from './GoodsReceived';
import { PurchasedItems } from './PurchasedItems';
import { UsedProducts } from './UsedProducts';

@HMRouter({
  pageUrl: PaidPage
})
@Component
export struct PayPage {
  token: string = ""
  @State orderList: orderRe[] = []
  @State currentIndex: number = -1;
  @State isLoad: boolean = false

  // tabsController: TabsController = new TabsController()

  aboutToAppear(): void {
    this.loadPayList()
  }

  @Builder
  TabBuilder(item: TabClass, index: number) {
    Text(item.text)
      .fontSize(14)
      .fontColor(this.currentIndex === index ? '#E85A88' : '#63AAAA')

  }

  build() {
    Column() {
      TopBarBuilder(SettingImageLeft.icon, "订单记录")

      Stack({ alignContent: Alignment.TopStart }) {
        Tabs({ barPosition: BarPosition.Start, index: this.currentIndex }) {
          TabContent() {
            PurchasedItems()
          }.tabBar(this.TabBuilder(PayTabData[0], 0))

          TabContent() {
            GoodsReceived()
          }.tabBar(this.TabBuilder(PayTabData[1], 1))

          TabContent() {
            UsedProducts()
          }.tabBar(this.TabBuilder(PayTabData[2], 2))

        }
        .barPosition(BarPosition.Start)
        .barWidth('100%')
        .barHeight(46)
        .width('100%')
        .height("100%")
        .backgroundColor('#F1F3F5')
        .onChange((index: number) => {
          this.currentIndex = index; // 监听索引index的变化，实现页签内容的切换。
        })

      }
      .height("100%")
      .width('100%')

    }

  }

  private loadPayList() {
    this.currentIndex = HMRouterMgr.getCurrentParam() as number
    console.info(`currentIndex: ${this.currentIndex}`)
    // this.tabsController.changeIndex(this.currentIndex)
  }
}