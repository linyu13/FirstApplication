import { HMRouter } from '@hadss/hmrouter';
import { LayOutPage } from '../../data/PageUrl';
import { tabData } from '../../data/TabClass';
import { ImageItem } from '../../models/Image';
import { Forum } from './Forum';
import { Home } from './Home';
import { Mine } from './Mine';

@HMRouter({
  pageUrl: LayOutPage
})
@Component
export struct LayOut {
  @State currentIndex: number = 0;
  @State animationDuration: number = 300;
  @State indicatorLeftMargin: number = 0;
  @State indicatorWidth: number = 0;

  @Builder
  TabBuilder(item: ImageItem, index: number) {
    Column({ space: 5 }) {
      Image(item.icon)
        .width(24)
        .fillColor(this.currentIndex === index ? '#E85A88' : '#63AAAA')
      Text(item.text)
        .fontSize(14)
        .fontColor(this.currentIndex === index ? '#E85A88' : '#63AAAA')
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Tabs({ barPosition: BarPosition.Start }) {
        TabContent() {
          Home()
          // Column().width('100%').height('100%').backgroundColor(item[1])
        }.tabBar(this.TabBuilder(tabData[0], 0))

        TabContent() {
          Forum()
        }.tabBar(this.TabBuilder(tabData[1], 1))

        TabContent() {
          Mine()
        }.tabBar(this.TabBuilder(tabData[2], 2))
      }
      .barPosition(BarPosition.End)
      .barWidth('100%')
      .barHeight(50)
      .width('100%')
      .height("100%")
      .backgroundColor('#F1F3F5')
      .animationDuration(this.animationDuration)
      .onChange((index: number) => {
        this.currentIndex = index; // 监听索引index的变化，实现页签内容的切换。
      })
    }
    .height("100%")
    .width('100%')
  }
}