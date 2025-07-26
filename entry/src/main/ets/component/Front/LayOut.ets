import { HMRouter } from '@hadss/hmrouter';
import { tabData } from '../../data/TabClass';
import { TabClass } from '../../models/TabClass';
import { Home } from './Home';
import { Message } from './Message';
import { Mine } from './Mine';

@HMRouter({
  pageUrl: 'LayOutPage'
})
@Component
export struct LayOut {
  @State currentIndex: number = 0

  @Builder
  TabBuilder(item: TabClass, index: number) {
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
    Column() {
      Tabs() {
        ForEach(tabData, (item: TabClass, index: number) => {
          TabContent() {
            if (this.currentIndex === 0) {
              Home()
            } else if (this.currentIndex === 1) {
              Message()
            } else if (this.currentIndex === 2) {
              Mine()
            }
            // else {
            //   Mine()
            // }
          }.tabBar(this.TabBuilder(item, index))
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        })
      }
      .scrollable(false)
      .animationDuration(0)
      .onChange((index: number) => {
        this.currentIndex = index
      })
      .barPosition(BarPosition.End)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }
  }
}