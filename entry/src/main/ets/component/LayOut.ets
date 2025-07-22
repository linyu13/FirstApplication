import { HMRouter } from '@hadss/hmrouter';

@HMRouter({
  pageUrl: 'LayOutPage'
})
@Component
export struct LayOut {
  build() {
    Column() {
      Text("This is LayOut")

    }
  }
}