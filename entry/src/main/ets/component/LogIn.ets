@Builder
export function LogInBuilder() {
  LogIn()
}

@Component
struct LogIn {
  pageStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Text("This is LogIn")

      Column() {

      }
    }.onReady((context: NavDestinationContext) => {
      this.pageStack = context.pathStack;
    })
  }
}