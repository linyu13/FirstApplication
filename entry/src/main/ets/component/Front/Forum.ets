import { HMRouterMgr } from '@hadss/hmrouter'
import { ForumDetailPage } from '../../data/PageUrl'
import { API_ENDPOINTS } from '../../data/variable'
import { createPost, EmptyObject, HttpResult, HttpResultArray, PostList } from '../../models/httpResult'
import { HttpRequest } from '../../service/HttpRequest'
import { base64ToPixel, initData } from '../../service/imageManger'
import { PreferencesManager } from '../../service/preference'
import { promptAction } from '@kit.ArkUI'

@Component
export struct Forum {
  @State hasPost: boolean = false
  token: string = ""
  @State postList: PostList[] = []
  @State picture: (PixelMap | null)[] = []
  @State visible: boolean = false
  @State title: string = ""
  @State content: string = ""
  @State base: string = ""
  @State image: PixelMap | null = null

  aboutToAppear(): void {
    this.loadForum()
  }

  @Builder
  SheetBuilder() {
    Column() {
      TextInput({ placeholder: "请输入标题" })
        .borderRadius(0)
        .padding(3)
        .borderColor({
          top: Color.Transparent,
          left: Color.Transparent,
          right: Color.Transparent,
          bottom: Color.Transparent
        })
        .onChange((value) => {
          this.title = value
        })
        .margin({ top: 20 })
        .width("100%")
        .borderWidth(1)// .borderColor(0xAFEEEE)
        .backgroundColor(Color.Transparent)
        .margin({ bottom: 10 })

      Divider()// 添加分隔线
        .color('#E0E0E0')
        .height(1)
        .margin({ left: 10, right: 10 }) // 可控制缩进样式

      // TextInput({ placeholder: "请输入正文内容" })
      //   .onChange((val: string) => {
      //     this.content = val
      //   })
      //   .borderRadius(0)
      //   .padding(3)
      //   .borderColor({ top: Color.Transparent, left: Color.Transparent, right: Color.Transparent })
      //   .width("100%")// 宽度一定要固定或百分比
      //   .borderWidth(1)// .borderColor(0xAFEEEE)
      //   .backgroundColor(Color.Transparent)
      //   .padding({
      //     left: 10,
      //     right: 10,
      //     top: 5,
      //     bottom: 5
      //   })
      TextArea({ placeholder: "请输入正文内容" })
        .width('100%')
        .onChange((val: string) => {
          this.content = val
        })
        .backgroundColor(Color.Transparent)
        .borderRadius(0)
        .padding(3)
        .borderColor({
          top: Color.Transparent,
          left: Color.Transparent,
          right: Color.Transparent,
          bottom: Color.Transparent
        })
        .height(100)
        .borderWidth(1)
        .margin(1)
        .minFontSize(4)
        .maxFontSize(40)
        .heightAdaptivePolicy(TextHeightAdaptivePolicy.MAX_LINES_FIRST)

      if (this.image === null) {
        // 占位图（点击后选择图片）
        Column() {
          Text("+")
            .fontSize(40)
            .fontColor("#999999")
        }
        .width(120)
        .height(120)
        .backgroundColor("#F5F5F5")
        .border({ width: 1, color: "#DDDDDD", radius: 10 })
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .onClick(async () => {
          this.base = await initData()

          this.image = await base64ToPixel(this.base)
        })
      } else {
        // 显示选择的图片
        Image(this.image)
          .width(120)
          .height(120)
          .objectFit(ImageFit.Cover)
          .borderRadius(10)
          .onClick(() => {
            // 也可以点击重新选择
            this.image = null
          })
      }

      Divider()// 添加分隔线
        .color('#E0E0E0')
        .height(1)
        .margin({ left: 10, right: 10 }) // 可控制缩进样式

      Button("发布帖子")
        .width("100%")
        .height(50)
        .backgroundColor("#E85A88")// 按钮底色
        .fontColor(Color.White)// 字体颜色
        .fontSize(18)
        .borderRadius(25)// 圆角
        .shadow({
          // 阴影提升按钮层次感
          radius: 5,
          color: "rgba(0,0,0,0.2)",
          offsetX: 0,
          offsetY: 2
        })
        .margin({ top: 20 })
        .onClick(() => {
          const obj: createPost = {
            title: this.title,
            content: this.content,
            picture: this.base
          }
          HttpRequest.post<HttpResult<null>>(API_ENDPOINTS.CreatePost, obj, this.token).then((result) => {
            if (result.status === 1000) {
              promptAction.showToast({
                message: "发布成功",
                duration: 2000
              })
              this.visible = !this.visible
              this.base = ""
              this.image = null
              this.loadForum()
              this.postList = []
              this.picture = []
            }
          })
        })

    }
    .width("100%")
    .height("100%")
    .padding(10)

  }

  build() {
    Stack() {
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

      Button("+")
        .width(60)
        .height(60)
        .borderRadius(30)// 圆形按钮
        .backgroundColor('#E85A88')
        .fontSize(40)
        .fontColor(Color.White)
        .position({ bottom: 30, right: 30 })// 距离右下角 30vp
        .onClick(() => {
          this.visible = !this.visible
        })
        .bindSheet($$this.visible, this.SheetBuilder(), {
          detents: [900],
          preferType: SheetType.BOTTOM,
          title: {
            title: "创建帖子"
          }
        })
    }
    .width("100%")
    .height("100%")

  }

  private loadForum() {
    const PrefManger = PreferencesManager.getInstance()
    const TOKEN = PrefManger.getData("TOKEN_KEY")
    this.token = TOKEN + ""

    const data: EmptyObject = {}
    HttpRequest.get<HttpResultArray<PostList>>(API_ENDPOINTS.GetPostList, data, this.token).then((result) => {
      if (result.status === 1000) {
        if (result.data !== null) {
          this.hasPost = true
          result.data.forEach(async (item: PostList) => {
            this.postList.push(item)
            if (item.picture) {
              await base64ToPixel(item.picture).then((pixelMap) => {
                this.picture.push(pixelMap)
              })
            } else {
              this.picture.push(null)
            }
          })
        }
      }
    })

  }
}