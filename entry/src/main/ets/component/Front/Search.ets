import { HMRouter } from '@hadss/hmrouter';
import { SearchHistoryPage } from '../../data/PageUrl';
import { historyWordList, HistoryWordModel } from '../../models/HistoryWordModel';
import { Constants as Constants } from '../../common/Constants';

@HMRouter({
  pageUrl: SearchHistoryPage
})
@Component
export struct SearchPage {
  @StorageProp('topRectHeight') topRectHeight: number = Constants.INITIAL_VALUE
  @StorageProp('bottomRectHeight') bottomRectHeight: number = Constants.INITIAL_VALUE
  @State toastBottom: number = Constants.INITIAL_VALUE
  @State currentSearchContent: string = ''
  @State historyWords: Array<HistoryWordModel> = historyWordList
  @State showLinkWord: boolean = false
  @State currentIndex: number = Constants.INITIAL_VALUE
  @State hotSearchTabIndex: number = Constants.INITIAL_VALUE
  @State isDeleteState: boolean = false
  private currentHistoryHeight: number = Constants.INITIAL_VALUE
  private controller = new TextInputController()

  simulatorThinkWord() {
    Constants.SEARCH_DATA.forEach((value: string, index: number) => {
      let startStr: string = ''
      let midStr: string = ''
      let endStr: string = ''
      let hIndex: number = Constants.MINUS_ONE

      let position = value.indexOf(this.currentSearchContent)
      if (position !== Constants.MINUS_ONE) {
        if (position === Constants.ZERO_INDEX) {
          startStr = value.toString().slice(Constants.ZERO_INDEX, this.currentSearchContent.length)
        } else {
          startStr = value.slice(Constants.ZERO_INDEX, position)
        }
        if (startStr.length < value.length) {
          position = value.slice(startStr.length).indexOf(this.currentSearchContent)
          if (position === Constants.MINUS_ONE) {
            midStr = value.slice(startStr.length)
          } else {
            midStr = value.slice(startStr.length, this.currentSearchContent.length)
          }
          if (startStr.length + midStr.length < value.length) {
            endStr = value.slice(startStr.length + midStr.length)
          }
        }
        if (startStr === this.currentSearchContent) {
          hIndex = Constants.ZERO_INDEX
        } else if (midStr === this.currentSearchContent) {
          hIndex = Constants.ONE_INDEX
        } else if (endStr === this.currentSearchContent) {
          hIndex = Constants.TWO_INDEX
        }
      }
    })
  }

  dealHistoryData(wordModel: HistoryWordModel, isDelete: boolean) {
    if (wordModel.word.length !== Constants.ZERO_LENGTH) {
      this.historyWords.forEach((item, index) => {
        if (item.word === wordModel.word) {
          this.historyWords.splice(index, Constants.NUM_ONE)
        }
      });
      if (!isDelete) {
        this.historyWords.unshift(new HistoryWordModel(wordModel.word))
      }
    }
  }

  build() {
    Column() {
      //一. 输入框
      Row() {
        Stack() {
          TextInput({
            placeholder: $r('app.string.search_placeholder'),
            controller: this.controller,
            text: this.currentSearchContent
          })
            .height($r('app.integer.height_forty'))
            .width(Constants.FULL_PERCENT)
            .fontSize($r('app.integer.font_size_16'))
            .placeholderColor(Color.Grey)
            .placeholderFont({ size: $r('app.integer.font_size_16'), weight: Constants.FONT_WEIGHT })
            .borderStyle(BorderStyle.Solid)
            .backgroundColor($r('app.color.search_background_color'))
            .padding({
              left: $r('app.integer.search_content_padding_left'),
              right: $r('app.integer.search_content_padding_right')
            })
            .onChange((currentContent) => {
              this.currentSearchContent = currentContent
              if (this.currentSearchContent.length !== Constants.ZERO_LENGTH) {
                this.showLinkWord = true
                this.simulatorThinkWord()
              } else {
                this.showLinkWord = false
              }
            })
          Row() {
            Image($r('app.media.ic_search'))
              .width($r('app.integer.width_sixteen'))
              .height($r('app.integer.width_sixteen'))
            Button($r('app.string.search'))
              .width($r('app.integer.search_button_width'))
              .height($r('app.integer.search_button_height'))
              .fontColor($r('app.color.font_red'))
              .fontSize($r('app.integer.font_size_16'))
              .backgroundColor($r('app.color.search_background_color'))
              .onClick(() => {
                if (this.currentSearchContent.length !== Constants.ZERO_LENGTH) {
                  this.showLinkWord = false
                  this.dealHistoryData(new HistoryWordModel(this.currentSearchContent), false)
                  this.currentSearchContent = ''
                }
              })
          }.width(Constants.FULL_PERCENT)
          .hitTestBehavior(HitTestMode.None)
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ left: $r('app.integer.padding_ten'), right: $r('app.integer.padding_two') })
        }.alignContent(Alignment.Start)
        .width(Constants.FULL_PERCENT)
      }.justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: $r('app.integer.padding_sixteen'),
        right: $r('app.integer.padding_sixteen'),
        bottom: $r('app.integer.padding_sixteen'),
        top: $r('app.integer.padding_sixteen'),
      })
      .width(Constants.FULL_PERCENT)

      Column() {
        Scroll() {
          Stack() {
            Column() {
              if (this.historyWords.length !== Constants.ZERO_LENGTH) {
                Row() {
                  Text($r('app.string.search_history'))
                    .fontSize($r('app.integer.font_size_14'))
                    .fontWeight(FontWeight.Bold)
                  if (this.isDeleteState === false) {
                    Image($r('app.media.ic_delete'))
                      .width($r('app.integer.width_twenty'))
                      .height($r('app.integer.height_twenty'))
                      .onClick(() => {
                        this.isDeleteState = true;
                      })
                  } else {
                    Text($r('app.string.finish'))
                      .width($r('app.integer.width_forty'))
                      .height($r('app.integer.height_twenty'))
                      .onClick(() => {
                        this.isDeleteState = false;
                      })
                  }
                }.width(Constants.FULL_PERCENT)
                .padding({
                  top: $r('app.integer.padding_ten'),
                  left: $r('app.integer.padding_sixteen'),
                  right: $r('app.integer.padding_ten')
                })
                .justifyContent(FlexAlign.SpaceBetween)

                Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
                  ForEach(this.historyWords, (item: HistoryWordModel, index) => {
                    Text(this.isDeleteState === false ? item.word : item.word + ' ×')
                      .fontSize($r('app.integer.font_size_14'))
                      .margin($r('app.integer.history_content_margin'))
                      .fontColor($r('app.color.history_font_color'))
                      .maxLines(Constants.MAX_LINES)
                      .backgroundColor($r('app.color.background_color'))
                      .padding({
                        left: this.isDeleteState === false ? $r('app.integer.padding_fifteen') :
                        $r('app.integer.padding_nine'),
                        right: this.isDeleteState === false ? $r('app.integer.padding_fifteen') :
                        $r('app.integer.padding_nine'),
                        top: $r('app.integer.padding_nine'),
                        bottom: $r('app.integer.padding_nine')
                      })
                      .borderRadius($r('app.integer.history_content_radius'))
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .onClick(() => {
                        if (this.isDeleteState) {
                          this.dealHistoryData(item, true);
                        } else {
                          this.currentSearchContent = item.word;
                        }
                      })
                  })
                }.width(Constants.FULL_PERCENT)
                .padding({ top: $r('app.integer.padding_twelve'), left: $r('app.integer.padding_ten') })
                .onAreaChange((oldValue: Area, newValue: Area) => {
                  let newHeight = newValue.height as number
                  if (this.currentHistoryHeight === Constants.ZERO_LENGTH) {
                    this.currentHistoryHeight = newHeight
                  }
                })
              }
            }
          }
        }.scrollBar(BarState.On)
      }
      .width(Constants.FULL_PERCENT)
      .height(Constants.FULL_PERCENT)
      .borderRadius($r('app.integer.background_radius'))
      .padding({ top: $r('app.integer.padding_fifteen') })
      .backgroundColor(Color.White)

    }.width(Constants.FULL_PERCENT)
    .height(Constants.FULL_PERCENT)
    .backgroundColor($r('app.color.background_color'))
    .padding({ top: px2vp(this.topRectHeight), bottom: px2vp(this.bottomRectHeight) })

  }
}