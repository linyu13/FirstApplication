export interface ApiEndpoints {
  SEND_CODE: string
  REGISTER: string
  LOGIN: string
  // 其他接口地址，逐个写
}

export class HttpResult<T> {
  status: number = 0 // 返回状态
  msg: string = "" // 文字叙述
  data: T | null = null // 返回数据
}

export interface codeData {
  code: string
}

export interface emailRequest {
  email: string
}

export interface loginData {
  user_id: string
  token: string
}