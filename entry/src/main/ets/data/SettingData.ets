import { ImageItem } from '../models/Image';
import { TextExample } from '../models/TextClass';
import { ThemeSettingOption } from '../models/ThemeSettingOption';

export const SettingImageRight: ImageItem = { icon: $r('app.media.icon_right') }

export const SettingHeight = 50

export const SettingImageLeft: ImageItem = { icon: $r('app.media.icon_left') }

export const SettingPersonSet: TextExample[] = [
  { text: "个人资料", pageUrl: "PersonInfo" }, { text: "地址管理", pageUrl: "AddressMange" },
  { text: "账号与安全", pageUrl: "AccountSafe" }
]

export const PersonInfoData: TextExample[] = [
  { text: "昵称", type: "username" },
  { text: "简介", type: "user_introduction" },
  { text: "头像", type: "user_picture" },
  { text: "邮箱", type: "email" },
  { text: "性别", type: "user_male" }, { text: "生日", type: "user_birthday" },
  { text: "兴趣", type: "user_hobby" }
]

export const AddressMangeData: TextExample[] = [
  { text: "收货地址", pageUrl: "DeliveryAddress" }, { text: "退货地址", pageUrl: "ReturnAddress" }
]

export const ThemeSettingOptionData: ThemeSettingOption = {
  isTitle: true,
  isRightIcon: true,
}

export const ThemeSettingOption_AccountSafeData: ThemeSettingOption = {
  isTitle: false,
  isRightIcon: true
}

export const AccountSafeData: TextExample[] = [
  { text: "注销账号" }
]

export interface Tmp {
  ThemeName: string
  option: ThemeSettingOption
}

export const LogOutData: TextExample[] = [
  { text: "退出登录" }
]

export const ThemeSettingOption_LogOutData: ThemeSettingOption = {
  isRightIcon: false,
  isTitle: false
}