import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { ForumDetailPage } from '../../data/PageUrl';
import { API_ENDPOINTS } from '../../data/variable';
import {
  comment,
  EmptyObject,
  HttpResult,
  HttpResultArray,
  postComment,
  PostList
} from '../../models/httpResult';
import { HttpRequest } from '../../service/HttpRequest';
import { base64ToPixel, pixelMap2File } from '../../service/imageManger';
import { PreferencesManager } from '../../service/preference';
import { promptAction } from '@kit.ArkUI';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { TopBarBuilder } from '../Builders/TopBar';
import { SettingImageLeft } from '../../data/SettingData';

const TAG = 'ForumDetail';

@HMRouter({
  pageUrl: ForumDetailPage
})
@Component
export struct ForumDetail {
  @State path: string = this.getUIContext().getHostContext()!.filesDir + '/image.jpg';
  @State param: number = -1
  @State commentReArray: postComment[] = []
  @State commentInput: string = ""
  @State newComment: string = ""
  @State commentCount: number = -1
  @State postList: PostList = {
    id: this.param,
    title: "",
    content: "",
    author_id: 0,
    author_picture: "",
    author_name: "",
    picture: ""
  }
  token: string = ""
  @State picture: PixelMap | null = null

  aboutToAppear(): void {
    this.param = HMRouterMgr.getCurrentParam() as number;
    const PrefManger = PreferencesManager.getInstance()
    const TOKEN = PrefManger.getData("TOKEN_KEY")
    this.token = TOKEN + ""

    const obj: EmptyObject = {}
    HttpRequest.get<HttpResult<PostList>>(API_ENDPOINTS.GetPostDetail + `/${this.param}`, obj,
      this.token).then(async (result) => {
      console.log(`论坛帖子详情页status: ${result.status}`)
      if (result.status === 1000) {
        this.postList = result.data
        if (result.data.picture) {
          await base64ToPixel(result.data.picture).then((pixelMap) => {
            this.picture = pixelMap
          })
        }
      }
    })

    HttpRequest.get<HttpResultArray<postComment>>(API_ENDPOINTS.GetPostComments + `/${this.param}`, obj,
      this.token).then((result) => {
      console.log(`论坛帖子评论获取status: ${result.status}`)
      if (result.status === 1000) {
        this.commentReArray = result.data
        this.commentCount = this.commentReArray.length
      }
    })
  }

  build() {
    Column() {
      TopBarBuilder(SettingImageLeft.icon)

      Row() {
        Image(this.postList.author_picture)
          .borderRadius(20)
          .width(40)
          .width(40)
          .margin({ left: 10, right: 5 })

        Text(this.postList.author_name)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 5 })
      }
      .width("100%")
      .padding(10)

      Column() {
        Column() {
          Text(this.postList.title)
            .fontWeight(FontWeight.Bold)
            .fontSize(30)
            .width("100%")
            .textAlign(TextAlign.Start)

          Text(this.postList.content)
            .fontSize(25)
            .width("100%")
            .textAlign(TextAlign.Start)
        }
        .width("100%")
        .padding(10)

        if (this.postList.picture) {
          Image(this.picture)
            .zIndex(10)
            .width(120)
            .height(120)
            .objectFit(ImageFit.Contain)
            .onClick(async () => {
              try {
                await pixelMap2File(this.picture, this.path);
                let context = this.getUIContext().getHostContext();
                let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
                let assetChangeRequest: photoAccessHelper.MediaAssetChangeRequest =
                  photoAccessHelper.MediaAssetChangeRequest.createImageAssetRequest(context, this.path);
                await phAccessHelper.applyChanges(assetChangeRequest);
                this.getUIContext().getPromptAction().showToast({
                  message: "保存成功",
                  duration: 2000
                });
              } catch (err) {
                hilog.error(0x0000, TAG, 'createAsset failed, error: ' + JSON.stringify(err));
              }

            })
          // .gesture(
          //   LongPressGesture({
          //     duration: 300
          //   })
          //     .onAction(async (event: GestureEvent | undefined) => {
          //       if (event) {
          //         await pixelMap2File(this.picture, this.path);
          //         let context = this.getUIContext().getHostContext();
          //         let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
          //         let assetChangeRequest: photoAccessHelper.MediaAssetChangeRequest =
          //           photoAccessHelper.MediaAssetChangeRequest.createImageAssetRequest(context, this.path);
          //         await phAccessHelper.applyChanges(assetChangeRequest);
          //         this.getUIContext().getPromptAction().showToast({
          //           message: "保存成功",
          //           duration: 2000
          //         });
          //       }
          //     })
          // )

        }
      }

      Column() {
        Text(`评论(${this.commentCount})`)
          .width("100%")
          .fontSize(20)
          .margin(5)

        List() {
          ForEach(this.commentReArray, (item: postComment) => {
            ListItem() {
              Column() {
                Row() {
                  Image(item.author_picture)
                    .borderRadius(15)
                    .height(30)
                    .width(30)
                    .margin({ left: 10, right: 5 })

                  Text(item.author_name)
                    .fontSize(20)
                    .margin({ left: 5 })
                }
                .width("100%")

                Text(item.content)
                  .fontSize(15)
                  .width("100%")
                  .padding(10)
                  .margin({ top: 5 })
              }

            }
          })
        }
        .width("100%")
        .height("100%")
      }
      .layoutWeight(1)
      .width("100%")
      .padding(10)

      if (this.newComment !== "") {
        Row() {
          TextInput({ placeholder: '说说你的看法吧' })
            .onChange((value: string) => {
              this.newComment = value
            })
            .height(40)
            .placeholderColor('#817D83')
            .padding({ left: 5 })
            .backgroundColor('#cedbed')
            .fontColor('#999')// 除使用之外
            .layoutWeight(1)
            .margin({ right: 10, left: 10 })

          Button("发送")
            .height(40)
            .backgroundColor(0xa0badc)
            .onClick(() => {
              let obj: comment = { post_id: this.param, content: this.newComment }
              HttpRequest.post<HttpResult<null>>(API_ENDPOINTS.CreatePostComment, obj, this.token).then((result) => {
                if (result.status === 1000) {
                  promptAction.showToast({
                    message: "发布成功",
                    duration: 2000
                  })
                }
              })
            })
        }
        .margin({ bottom: 15 })
        .height("10%")

      } else {
        Row() {
          TextInput({ placeholder: '说说你的看法吧' })
            .onChange((value: string) => {
              this.newComment = value
            })
            .height(40)
            .placeholderColor('#817D83')
            .padding({ left: 5 })
            .backgroundColor('#cedbed')
            .fontColor('#999')// 除使用之外
            .layoutWeight(1)
            .margin({ right: 10, left: 10 })

          Image($r('app.media.icon_more'))
            .width(40)
            .height(40)
        }
        .margin({ bottom: 15 })
        .height("10%")
      }
    }
    .width("100%")
    .height("100%")
  }
}