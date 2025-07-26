export interface ApiEndpoints {
  SEND_CODE: string
  REGISTER: string
  LOGIN: string
  USERINFO: string
  UserLogout: string
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
