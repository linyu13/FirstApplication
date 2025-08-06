import { API_ENDPOINTS } from '../../data/variable'
import { appraiseByUserID, EmptyObject, getCommentByIDRe, HttpResult } from '../../models/httpResult'
import { HttpRequest } from '../../service/HttpRequest'
import { PreferencesManager } from '../../service/preference'

@Component
export struct evaluate {
  token: string = ""
  @State commentArray: getCommentByIDRe[] = []
  @State ArrayLength: number = -1

  aboutToAppear(): void {
    this.loadComment()
  }

  build() {
    if (this.ArrayLength === 0) {
      Text("暂无评价")
    } else {
      Column() {
        List({ space: 5 }) {
          if (Array.isArray(this.commentArray) && this.commentArray.length > 0 &&
          this.commentArray[0].user_name) {
            ForEach(this.commentArray, (item: getCommentByIDRe) => {
              ListItem() {
                Row() {
                  Image(item.user_picture)
                    .borderRadius(20)
                    .width(40)
                    .height(40)
                    .margin({ left: 10, right: 10 })

                  Column() {
                    Text(item.user_name)
                      .fontSize(15)
                      .fontWeight(FontWeight.Bold)
                    // .width("70%")

                    Text(item.user_content)
                      .fontSize(14)
                    // .width("70%")
                  }
                  // .height("100%")
                  .alignItems(HorizontalAlign.Start)
                  .layoutWeight(1)
                  .justifyContent(FlexAlign.Start)

                  Column() {
                    Text("评分")

                    Divider()// 添加分隔线
                      // .vertical(true)
                      .color('#E0E0E0')
                      .width(1)
                      .margin({ top: 5, bottom: 5 }) // 可控制缩进样式

                    Text(`${item.user_rating}`)
                  }
                  // .height("100%")
                  .margin({ right: 10, left: 6 })
                  .alignItems(HorizontalAlign.End)
                  .justifyContent(FlexAlign.Start)
                }
                .alignItems(VerticalAlign.Top)
                .justifyContent(FlexAlign.Start)
                .width("100%")
              }

            })
          } else {
            ListItem() {
              Text("暂时没有评论")
            }
          }
        }
        .nestedScroll({ scrollForward: NestedScrollMode.SELF_ONLY, scrollBackward: NestedScrollMode.SELF_ONLY })
        .height("100%")

      }

    }
  }

  private loadComment() {
    const prefManger = PreferencesManager.getInstance()
    const TOKEN = prefManger.getData("TOKEN_KEY") + ""
    this.token = TOKEN

    let obj: EmptyObject = {}
    HttpRequest.get<HttpResult<appraiseByUserID>>(API_ENDPOINTS.GetCommentByUserID, obj,
      this.token).then((result) => {
      if (result.status === 1000) {

        this.commentArray = result.data?.appraise ?? []
        console.log(`根据用户id获取评论成功 status: ${result.status} msg: ${result.msg}`)
        console.log("测试数据是否正常：" + result.data?.appraise[0].user_name)
        this.ArrayLength = this.commentArray.length
      } else {
        console.log(`根据用户id获取评论失败 status: ${result.status} msg: ${result.msg}`)
      }
    })
  }
}