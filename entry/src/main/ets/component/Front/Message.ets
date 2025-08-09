@Component
export struct Message {
  @State isChat: boolean = false

  build() {
    Column() {
      Text("暂无消息")
    }
  }
}