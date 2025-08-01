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
  // 其他接口地址，逐个写
}

// 传输占位用
export interface EmptyObject {}

// http请求返回结构
export interface HttpResult<T> {
  status: number
  msg: string
  data: T | null
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