export interface ApiEndpoints {
  SEND_CODE: string
  REGISTER: string
  LOGIN: string
  USERINFO: string
  UserLogout: string
  UserAddressGet: string
  UserAddressPost: string
  UserDelete: string
  GetProduct: string
  GetProductDetail: string
  FollowShop: string
  GetCommentByID: string
  GetFollowedShops: string
  GetCollectList: string
  UnfollowShop: string
  CollectProduct: string
  UnCollectProduct: string
  UpdateUserInfo: string
  SaveUserAddress: string
  GetProductsByShopID: string
  IsShopOwner: string
  RegisterShop: string
  CreateProduct: string
  GetCommentByUserID: string
  UserHistory: string
  GetUserHistory: string
  GetShopInfo: string
  CreateOrder: string
  GetOrderList: string
  UpdateOrder: string
  GetPostList: string
  // 其他接口地址，逐个写
}

// 传输占位用
export interface EmptyObject {}

// http请求返回结构
export interface HttpResult<T> {
  status: number
  msg: string
  data: T
}

export interface HttpResultArray<T> {
  status: number
  msg: string
  data: T[]
}

// 请求验证码
export interface emailRequest {
  email: string
}

// 返回验证码
export interface CodeRe {
  code: string
}

// 登录请求
export interface LoginRequest {
  email: string
  password: string

}

// 登陆返回
export interface LoginReData {
  user_id: string
  token: string
}

// 注册请求
export interface RegisterRequest {
  email: string
  password: string
  type: string
  code: string
}

// 用户信息返回
export interface UserInfoRe {
  user_picture: string
  username: string
  email: string
  user_introduction: string
  background: string
  user_male: string
  user_birthday: string
  user_hobby: string
}

// 地址返回
export interface UserAddressRe {
  delivery_address: string
  return_address: string
}

// 商品返回
export interface ProductRe {
  id: number // 商品id
  shop_id: number // 商铺id
  shop_name: string // 商铺名称
  product_name: string // 商品名称
  category: string //商品分类
  product_price: number // 商品价格
  product_unit: string // 商品价格单位
  product_picture: string // 商品图片
  CreatedAt: string // 商品创建时间
  product_introduction: string // 商品简介
  product_score: number // 商品评分
}

export interface FollowShop {
  shop_id: number
}

export interface commentGet {
  id: number // 商品id
}

export interface appraise {
  appraise: commentRe[]
}

export interface commentRe {
  user_name: string
  user_picture: string
  user_content: string
  user_rating: number
}

export interface userUnCollect {
  shop_id: number
}

export interface userCollect {
  product_id: number
}

export interface userInfoUpdate {
  username: string
  user_picture: string
  background: string
  user_introduction: string
  user_birthday: string
  user_hobby: string
  user_male: string
}

export interface pageInfoParam {
  text?: string
  info?: string
  onSuccess?: () => void
}

export interface changeName {
  username: string
}

export interface changeIntro {
  user_introduction: string
}

export interface changeBirthday {
  user_birthday: string
}

export interface changeHobby {
  user_hobby: string
}

export interface changeMale {
  user_male: string
}

export interface changeReturnAddress {
  return_address: string
}

export interface changeDeliveryAddress {
  delivery_address: string
}

export interface IsShopOwnerRe {
  is_shop_owner: boolean
}

export interface creatProduct {
  product_name: string
  product_price: number
  product_introduction: string
  category: string
}

export interface creatShop {
  name: string
  location: string
  introduction: string
  phone: string
}

export interface creatOrder {
  product_id: number
  product_count: number
  is_buy: boolean
}

export interface orderRe {
  product_id: number
  is_buy: boolean
  user_id: number
  delivery_address: string
  shop_id: number
  product_count: number
  shop_name: string
  product_name: string
  category: string
  product_price: number
  product_picture: string
  product_introduction: string
  product_score: number
  updated_at: string
}

export interface getCommentByIDRe {
  user_name: string
  user_picture: string
  user_content: string
  user_rating: number
  product_id: number
}

export interface appraiseByUserID {
  appraise: getCommentByIDRe[]
}

export interface UserHistory {
  user_id: number
  product_id: number
  shop_id: number
  shop_name: string
  product_name: string
  category: string
  product_price: number
  product_picture: string
  product_introduction: string
  product_score: number
}

export interface shopInfo {
  user_id: number
  name: string
  hot: boolean
  location: string
  picture: string
  introduction: string
  score: number
  phone: string
}

export interface postToForum {
  title: string
  content: string
  picture: string
}

export interface PostList {
  title: string
  content: string
  author_id: number
  author_picture: string
  author_name: string
  picture: string
}