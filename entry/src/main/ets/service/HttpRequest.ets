// import { http } from "@kit.NetworkKit";
// import { JSON } from "@kit.ArkTS";
// import { BusinessError } from "@kit.BasicServicesKit";
// import { emailData, HttpResult } from "../models/httpResult";
//
// export class Logger {
//   @HMService({serviceName: "Logger"})
//   info(tag: string, info: string) {
//     console.log(`INFO ${tag} : ${info}`)
//   }
// }
//
// let httpRequest = http.createHttp();
// export class CustomServer {
//   @HMService({serviceName: "UserServicePost"})
//   async UserServicePost<T>(service: string, data: string) : Promise<string> {
//     try {
//       const res =
//         await httpRequest.request(`http://192.168.1.127:8080${service}`, {
//           method: http.RequestMethod.POST,
//           header: {
//             'Content-Type': 'application/json'
//           },
//           extraData: data,
//           connectTimeout: 5000,
//           readTimeout: 5000
//         })
//       if (res.responseCode === 401) {
//         return Promise.reject(new Error('token超时！'))
//       } else if (res.responseCode === 404) {
//         return Promise.reject(new Error('请求地址不正确！'))
//       } else {
//         const result = JSON.parse(res.result as string) as HttpResult<T>
//         if (res.responseCode === 200) {
//           return result
//         }
//       }
//     } catch (error) {
//       return Promise.reject(error)
//     }
//     finally {
//       httpRequest.destroy()
//     }
//     return Promise.reject()
//
//     // try {
//     //   const res =
//     //     await httpRequest.request(`http://192.168.1.127:8080${service}`, {
//     //       method: http.RequestMethod.POST,
//     //       header: {
//     //         'Content-Type': 'application/json'
//     //       },
//     //       extraData: data,
//     //       connectTimeout: 5000,
//     //       readTimeout: 5000
//     //     })
//     //   if (res.responseCode === 401) {
//     //     return Promise.reject(new Error('token超时！'))
//     //   } else if (res.responseCode === 404) {
//     //     return Promise.reject(new Error('请求地址不正确！'))
//     //   } else {
//     //     const result = JSON.parse(res.result as string) as HttpResult<T>
//     //     if (res.responseCode === 200) {
//     //       return result.data as T
//     //     }
//     //   }
//     // } catch (error) {
//     //   return Promise.reject(error)
//     // }
//     // finally {
//     //   httpRequest.destroy()
//     // }
//     // return Promise.reject()
//     //   .then((response) => {
//     //   if(response.responseCode === 200) {
//     //     const resJson = JSON.parse(response.result as string)
//     //     if (resJson)
//     //   }
//     // })
//   }
// }
//
//


import { http } from '@kit.NetworkKit'
// import { TOKEN_KEY } from '../constants'
// import { BASE_URL } from '../constants/url_var'
import { promptAction, router } from '@kit.ArkUI'
import { HttpResult } from '../models/httpResult'

// import { ResponsesData } from './request2'
//传输参数token
export const TOKEN_KEY: string = 'token'

//请求网络的基底址
export const BASE_URL: string = 'http://192.168.1.127:8080'

// 最外层数据封装类的


//Next版本不支持在箭头函数上写纯泛型,
// function requestHttp(url: url地址, method: 请求方法类型,默认为get, data?: 参数类型) : 返回类型是: Promise里面的T类型的数据
async function requestHttp<T>(url: string = '', method: http.RequestMethod, data?: object, token?: string): Promise<T> {
  //创建一个网络请求
  const httpRequest = http.createHttp()
  //拼接地址
  let urlStr = BASE_URL + url
  //get方法需要自己拼接
  // if (method === http.RequestMethod.GET) {
  //   //如果data里面有值并且里面有对象的时候
  //   if (data && Object.keys(data).length) {
  //     urlStr += "?" + Object.keys(data).map(key => {
  //       if (data[key]) {
  //         return `${key}=${data[key]}` // a=1 =>
  //       }
  //       return ""
  //     }).join('&') //['a=1','b=2','c=3']
  //   }
  // }
  //设置请求对象
  let config: http.HttpRequestOptions = {
    method,
    header: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    },
    extraData: data,
    connectTimeout: 5000,
    readTimeout: 5000
    //method同名方法赋值，参数名和属性名相同时只需要写一个method等价于method:method
    // method,
    //超时时间
    // readTimeout: 10000,
    //get的extraData参数在上面处理过了 在这儿不需要再传一遍
    // extraData: method === http.RequestMethod.GET ? '' : data || {} as EmptyInterface,
    //响应参数的类型,指定为对象后有BUG，当结果有问题时，项目会直接瘫痪
    // expectDataType: http.HttpDataType.OBJECT,
    //请求头
    // header: {
    //   'Content-Type': 'application/json',
    //   // "Authorization": AppStorage.get(TOKEN_KEY) as string || ''
    // }
  }
  //发请求
  try {
    const res = await httpRequest.request(urlStr, config)
    console.log('请求url地址', urlStr)
    //res.responseCode响应状态码，这里的401还会认为是请求成功
    if (res.responseCode === 401) {
      //401 token超时
      //删除持久化数据token
      AppStorage.set<string>(TOKEN_KEY, '')
      promptAction.showToast({ message: 'token超时！' })
      //回登录
      router.replaceUrl({
        url: 'pages/Login/LoginPage'
      })
      //返回错误 终止
      return Promise.reject(new Error('token超时！'))
    } else if (res.responseCode === 404) {
      promptAction.showToast({ message: '请求地址不正确！' })
      return Promise.reject(new Error('请求地址不正确！'))
    } else {
      //指定为字符串，然后再转成一个对象，类型是不明确的要使用泛型,返回第一层+泛型,泛型的定义是一个类和之前的有所差距
      const result = JSON.parse(res.result as string) as HttpResult<T>
      //再判断返回的状态码进行处理，不是200都是失败
      if (res.responseCode === 200) {
        // return result.data as T
        return result as T
      } else {
        promptAction.showToast({ message: '服务器异常！' })
        return Promise.reject(new Error(result.msg))
      }
    }
  } catch (error) {
    promptAction.showToast({ message: error })
    return Promise.reject(error)
  }
  //执行最后销毁请求
  finally {
    //销毁请求请求结束
    httpRequest.destroy()
  }
}

//封装一个静态类的方法出来使用
export class Request {
  static get<T>(url: string, data?: object, token?: string): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.GET, data, token)
  }

  static post<T>(url: string, data?: object, token?: string): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.POST, data, token)
  }

  static put<T>(url: string, data?: object, token?: string): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.PUT, data, token)
  }

  static delete<T>(url: string, data?: object, token?: string): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.DELETE, data, token)
  }
}
