import { HMRouterMgr } from '@hadss/hmrouter'

@Builder
export function TopBarBuilder(icon: ResourceStr, text?: string) {
  Stack() {
    Row() {
      Image(icon)
        .height(15)// .width("10%")
        .margin({ left: 10 })// .align(VerticalAlign.Center)
        .padding({ left: 10, right: 10 })
        .onClick(() => {
          HMRouterMgr.pop()
        })
    }
    .width("100%")
    .justifyContent(FlexAlign.Start) // 横向对齐：从左开始

    if (text !== null) {
      Text(text)
        .height(50)
        .fontWeight(FontWeight.Bold)
        .align(Alignment.Center)
    }
  }
  .width("100%")
  .height(40)
}