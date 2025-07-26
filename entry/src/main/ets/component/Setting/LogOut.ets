import { HMRouter } from '@hadss/hmrouter';
import { LogOutData, SettingHeight, SettingImageRight } from '../../data/SettingData';
import { TextExample } from '../../models/TextClass';

@Component
export struct LogOut {
  @State isShow: boolean = false

  @Builder
  SheetBuilder() {
    Column() {
      Text("您是否要退出登录")
        .height(40)
    }
    .width("100%")
  }

  build() {
    Column() {
      // ThemeSettingBuilder("", LogOutData, ThemeSettingOption_LogOutData)


    }
  }
}