import { TextInputCodeImage, TextInputSearchImage, TextTabs } from '../data/HomeData'

@Component
export struct Home {
  @State selectedTabIndex: number = 0

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
          // .sticky(StickyStyle.Header) // 吸顶设置
          .height("10%")
          .scrollBar(BarState.Off)
          .width("85%")
          .listDirection(Axis.Horizontal)
        }
      }

      ListItem() {
        Column() {
          if (this.selectedTabIndex === 0) {
            Column() {
              Text('推荐内容').padding(20)
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