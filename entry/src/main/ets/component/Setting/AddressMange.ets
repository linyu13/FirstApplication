import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { AddressMangeData, SettingHeight, SettingImageLeft } from '../../data/SettingData';
import { API_ENDPOINTS } from '../../data/variable';
import { EmptyObject, HttpResult, UserAddressRe } from '../../models/httpResult';
import { TextExample } from '../../models/TextClass';
import { PreferencesManager } from '../../service/preference';
import { TopBarBuilder } from '../Builders/TopBar';
import { HttpRequest } from '../../service/HttpRequest';


@HMRouter({
  pageUrl: "AddressMange"
})
@Component
export struct AddressMange {
  @State param: string = ""
  @State Height: number = SettingHeight
  @State AllHeight: number = this.Height * AddressMangeData.length
  token = ""
  @State UserAddress: UserAddressRe = { delivery_address: "", return_address: "" }
  @State Address: string[] = []

  aboutToAppear(): void {
    this.param = HMRouterMgr.getCurrentParam() as string;
    const prefManager = PreferencesManager.getInstance()
    const TOKEN = prefManager.getData("TOKEN_KEY") + ""
    this.token = TOKEN
    let obj: EmptyObject = {}
    // 获取地址信息
    HttpRequest.get<HttpResult<UserAddressRe>>(API_ENDPOINTS.UserAddressGet, obj, this.token).then((result) => {
      if (result.status === 1000) {
        console.log("返回数据成功")
        this.Address.push(result.data!.delivery_address)
        this.Address.push(result.data!.return_address)
        // if (result.data?.return_address !== null) {
        //   this.UserAddress.return_address = result.data!.return_address
        // }
      }
    })
  }

  build() {
    Column() {
      TopBarBuilder(SettingImageLeft.icon, this.param)

      List({ space: 6 }) {
        ListItem() {
          Column() {
            Flex({ direction: FlexDirection.Column }) {
              ForEach(AddressMangeData, (item: TextExample, index: number) => {
                Row() {
                  Text(item.text)
                    .height(40)
                    .width("100%")// .backgroundColor(0xffffff)
                      // .border({ radius: { topLeft: 10, topRight: 10 } })
                    .layoutWeight(1)
                    .margin({ left: 10 })
                  // Image(SettingImageRight.icon)
                  //   .height(20)
                  //   .margin({ right: 10 })
                  Text(this.Address[index])
                    .fontSize(16)
                    .fontColor(Color.Grey)
                    .margin({ right: 8 })

                }
                .height(this.Height)

                // .onClick(() => {
                //   HMRouterMgr.push({
                //     pageUrl: item.pageUrl,
                //     param: item.text
                //   })
                // })


                if (index < AddressMangeData.length - 1) {
                  Divider()// 添加分隔线
                    .color('#E0E0E0')
                    .height(1)
                    .margin({ left: 10, right: 10 }) // 可控制缩进样式
                }
              })
            }
            .border({
              radius: {
                topLeft: 10,
                topRight: 10,
                bottomLeft: 10,
                bottomRight: 10
              }
            })
            .backgroundColor(0xffffff)
            .margin({ left: 20, right: 20, top: 20 })
            .height(this.AllHeight)
          }
        }
      }
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .width("100%")
      .height("100%")
      .backgroundColor(0xf7f7f7)
    }
  }
}