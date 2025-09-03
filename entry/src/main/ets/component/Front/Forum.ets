import { API_ENDPOINTS } from '../../data/variable'
import { EmptyObject, HttpResultArray, PostList } from '../../models/httpResult'
import { HttpRequest } from '../../service/HttpRequest'
import { PreferencesManager } from '../../service/preference'

@Component
export struct Forum {
  @State hasPost: boolean = false
  token: string = ""
  @State postList: PostList[] = []

  aboutToAppear(): void {
    const PrefManger = PreferencesManager.getInstance()
    const TOKEN = PrefManger.getData("TOKEN_KEY")
    this.token = TOKEN + ""

    const data: EmptyObject = {}
    HttpRequest.get<HttpResultArray<PostList>>(API_ENDPOINTS.GetPostList, data, this.token).then((result) => {
      if (result.status === 1000) {
        if (result.data !== null) {
          this.hasPost = true
          result.data.forEach((item: PostList) => {
            this.postList.push(item)
          })
        }
      }
    })
  }

  build() {
    Column() {
      Text("暂无论坛内容")
    }
  }
}