import { ApiEndpoints } from '../models/httpResult';


export const API_ENDPOINTS: ApiEndpoints = {
  SEND_CODE: '/api/v1/auth/code',
  REGISTER: '/api/v1/auth/register',
  LOGIN: "/api/v1/auth/login"
}

export interface JwtPayload {
  user_id: number
  username: string
  iss: string
  exp: number
}
