import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';

@HMRouter({
  pageUrl: 'mainPage'
})
@Component
export struct mainPage {
  build() {
    Column() {
      Button('Push')
        .onClick(() => {
          HMRouterMgr.replace({ pageUrl: 'StartPage' })
        })
    }
  }
}