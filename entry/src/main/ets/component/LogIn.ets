import { HMRouter } from "@hadss/hmrouter";

@Builder
export function LogInBuilder() {
  LogIn()
}

@HMRouter({
  pageUrl: 'LogInPage'
})
@Component
export struct LogIn {

  build() {

      Column() {

      }
  }
}