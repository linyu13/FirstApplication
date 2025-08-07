import { ApiEndpoints } from '../models/httpResult';


export const API_ENDPOINTS: ApiEndpoints = {
  SEND_CODE: '/api/v1/auth/code',
  REGISTER: '/api/v1/auth/register',
  LOGIN: "/api/v1/auth/login",
  USERINFO: "/api/v1/users",
  UserLogout: "/api/v1/auth/logout",
  UserAddressGet: "/api/v1/user/getAddress",
  UserAddressPost: "/api/v1/user/saveAddress",
  UserDelete: "/api/v1/users",
  GetProduct: "/api/v1/product/list",
  GetProductDetail: "/api/v1/product/detail",
  FollowShop: "/api/v1/user/follow",
  GetCommentByID: "/api/v1/product/appraise/get",
  GetFollowedShops: "/api/v1/user/follow/list",
  GetCollectList: "/api/v1/user/collect/list",
  UnfollowShop: "/api/v1/user/unFollow",
  CollectProduct: "/api/v1/user/collect",
  UnCollectProduct: "/api/v1/user/unCollect",
  UpdateUserInfo: "/api/v1/users",
  SaveUserAddress: "/api/v1/user/saveAddress",
  GetProductsByShopID: "/api/v1/shop/productId",
  IsShopOwner: "/api/v1/shop/isOwner",
  RegisterShop: "/api/v1/shop/register",
  CreateProduct: "/api/v1/product/create",
  GetCommentByUserID: "/api/v1/GetComment/ByUserID",
  UserHistory: "/api/v1/user/history",
  GetUserHistory: "/api/v1/user/getHistory",
  GetShopInfo: "/api/v1/shop/info",
  CreateOrder: "/api/v1/order/creat",
  GetOrderList: "/api/v1/order/list",
  UpdateOrder: "/api/v1/order/update"
}

export interface JwtPayload {
  user_id: number
  username: string
  iss: string
  exp: number
}
