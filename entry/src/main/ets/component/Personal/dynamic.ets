import { HMRouterMgr } from '@hadss/hmrouter'
import { ForumDetailPage } from '../../data/PageUrl'
import { API_ENDPOINTS, JwtPayload } from '../../data/variable'
import { EmptyObject, HttpResultArray, PostList } from '../../models/httpResult'
import { HttpRequest } from '../../service/HttpRequest'
import { base64ToPixel } from '../../service/imageManger'
import { PreferencesManager } from '../../service/preference'
import { base } from '../../service/token'

@Component
export struct dynamic {
  token: string = ""
  @State hasPost: boolean = false
  @State postList: PostList[] = []
  @State picture: (PixelMap | null)[] = []

  aboutToAppear(): void {
    const PrefManger = PreferencesManager.getInstance()
    const TOKEN = PrefManger.getData("TOKEN_KEY")
    this.token = TOKEN + ""

    const data: EmptyObject = {}
    const userToken: JwtPayload = base(this.token)

    HttpRequest.get<HttpResultArray<PostList>>(API_ENDPOINTS.GetPostList, data, this.token).then((result) => {
      if (result.status === 1000) {
        if (result.data !== null) {
          result.data.forEach(async (item: PostList) => {
            if (item.author_id === userToken.user_id) {
              this.hasPost = true
              this.postList.push(item)
              if (item.picture) {
                await base64ToPixel(item.picture).then((pixelMap) => {
                  this.picture.push(pixelMap)
                })
              } else {
                this.picture.push(null)
              }
            }
          })
        }
      }
    })

  }

  build() {
    Column() {
      if (this.hasPost) {
        List() {
          ForEach(this.postList, (item: PostList, index: number) => {
            ListItem() {
              Column() {
                Row() {
                  Image(item.author_picture)
                    .borderRadius(15)
                    .width(30)
                    .height(30)
                    .margin({ left: 10, right: 5 })

                  Text(item.author_name)
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)
                    .margin({ left: 5 })
                }
                .width("100%")
                .padding(10)

                Column() {
                  Column() {
                    Text(item.title)
                      .fontWeight(FontWeight.Bold)
                      .fontSize(25)
                      .width("100%")
                      .textAlign(TextAlign.Start)
                    Text(item.content)
                      .fontSize(20)
                      .width("100%")
                      .textAlign(TextAlign.Start)
                      .maxLines(2)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                  .width("100%")
                  .padding(10)

                  if (this.picture[index] !== null) {
                    Image(this.picture[index])
                      .width(120)
                      .height(120)
                      .objectFit(ImageFit.Cover)
                  }
                }
              }
              .padding(5)
            }
            .onClick(() => {
              HMRouterMgr.push({
                pageUrl: ForumDetailPage,
                param: item.id
              })
            })
            .backgroundColor(Color.White)
            .border({
              radius: {
                topLeft: 10,
                topRight: 10,
                bottomLeft: 10,
                bottomRight: 10
              }
            })
            .margin({ top: 10, bottom: 10 })
          })

        }
        .height("100%")
        .width("100%")
      } else {
        Text("暂无论坛内容")
      }
    }
    .height("100%")

  }
}