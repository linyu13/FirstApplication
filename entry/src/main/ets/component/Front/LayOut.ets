import { HMRouter } from '@hadss/hmrouter';
import { LayOutPage } from '../../data/PageUrl';
import { tabData } from '../../data/TabClass';
import { ImageItem } from '../../models/Image';
import { Home } from './Home';
import { Message } from './Message';
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
          Message()
        }.tabBar(this.TabBuilder(tabData[1], 1))

        TabContent() {
          Mine()
        }.tabBar(this.TabBuilder(tabData[2], 2))
      }
      .barPosition(BarPosition.End)
      .barWidth('100%')
      .barHeight(46)
      .width('100%')
      .height("100%")
      .backgroundColor('#F1F3F5')
      .animationDuration(this.animationDuration)
      .onChange((index: number) => {
        this.currentIndex = index; // 监听索引index的变化，实现页签内容的切换。
      })

      // .onAnimationStart((index: number, targetIndex: number, event: TabsAnimationEvent) => {
      //   // 切换动画开始时触发该回调。下划线跟着页面一起滑动，同时宽度渐变。
      //   this.currentIndex = targetIndex;
      //   this.startAnimateTo(this.animationDuration, this.textInfos[targetIndex][0], this.textInfos[targetIndex][1]);
      // })
      // .onAnimationEnd((index: number, event: TabsAnimationEvent) => {
      //   // 切换动画结束时触发该回调。下划线动画停止。
      //   let currentIndicatorInfo = this.getCurrentIndicatorInfo(index, event);
      //   this.startAnimateTo(0, currentIndicatorInfo.left, currentIndicatorInfo.width);
      // })
      // .onGestureSwipe((index: number, event: TabsAnimationEvent) => {
      //   // 在页面跟手滑动过程中，逐帧触发该回调。
      //   let currentIndicatorInfo = this.getCurrentIndicatorInfo(index, event);
      //   this.currentIndex = currentIndicatorInfo.index;
      //   this.setIndicatorAttr(currentIndicatorInfo.left, currentIndicatorInfo.width);
      // })

      // Column()// .position({ bottom: 0 })
      //   .height(2)
      //   .width(this.indicatorWidth)
      //   .margin({ start: LengthMetrics.vp(this.indicatorLeftMargin) })
      //   .backgroundColor('#007DFF')
    }
    .height("100%")
    .width('100%')
  }

  // private getCurrentIndicatorInfo(index: number, event: TabsAnimationEvent): Record<string, number> {
  //   let nextIndex = index;
  //   if (index > 0 && (CommonUtil.getIsRTL() ? event.currentOffset < 0 : event.currentOffset > 0)) {
  //     nextIndex--;
  //   } else if (index < this.textInfos.length - 1 &&
  //     (CommonUtil.getIsRTL() ? event.currentOffset > 0 : event.currentOffset < 0)) {
  //     nextIndex++;
  //   }
  //   let indexInfo = this.textInfos[index];
  //   let nextIndexInfo = this.textInfos[nextIndex];
  //   let swipeRatio = Math.abs(event.currentOffset / this.tabsWidth);
  //   let currentIndex = swipeRatio > 0.5 ? nextIndex : index; // 页面滑动超过一半，tabBar切换到下一页。
  //   let currentLeft = indexInfo[0] + (nextIndexInfo[0] - indexInfo[0]) * swipeRatio;
  //   let currentWidth = indexInfo[1] + (nextIndexInfo[1] - indexInfo[1]) * swipeRatio;
  //   return { 'index': currentIndex, 'left': currentLeft, 'width': currentWidth };
  // }

  // private startAnimateTo(duration: number, leftMargin: number, width: number) {
  //   this.isStartAnimateTo = true;
  //   this.getUIContext()?.animateTo({
  //     duration: duration, // 动画时长
  //     curve: Curve.Linear, // 动画曲线
  //     iterations: 1, // 播放次数
  //     playMode: PlayMode.Normal, // 动画模式
  //     onFinish: () => {
  //       this.isStartAnimateTo = false;
  //       console.info('play end');
  //     }
  //   }, () => {
  //     this.setIndicatorAttr(leftMargin, width);
  //   });
  // }
  //
  // private setIndicatorAttr(leftMargin: number, width: number) {
  //   this.indicatorWidth = width;
  //   if (CommonUtil.getIsRTL()) {
  //     this.indicatorLeftMargin = this.tabsWidth - leftMargin - width;
  //   } else {
  //     this.indicatorLeftMargin = leftMargin;
  //   }
  // }
}