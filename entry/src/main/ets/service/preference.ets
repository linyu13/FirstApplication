// import preferences from '@ohos.data.preferences';
// import { BusinessError } from '@kit.BasicServicesKit';
//
// // import dataPreferences from '@ohos.data.preferences'
//
// export class PreferencesManager {
//   private static instance: PreferencesManager
//   dataPreferences: preferences.Preferences | null = null;
//
//   private constructor() {
//   } // 私有构造函数，外部无法 new
//
//   static getInstance(): PreferencesManager {
//     if (!PreferencesManager.instance) {
//       PreferencesManager.instance = new PreferencesManager()
//     }
//     return PreferencesManager.instance
//   }
//
//
//   init(context: Context, name: string) {
//     preferences.getPreferences(context, name, (err: BusinessError, val: preferences.Preferences) => {
//       if (err) {
//         console.error("Failed to get preferences. code =" + err.code + ", message =" + err.message);
//         return;
//       }
//       this.dataPreferences = val;
//       console.info("Succeeded in getting preferences.");
//     })
//   }
//
//   // 存储数据
//   async putData(key: string, value: string) {
//
//     try {
//       // 检查key是否已存在
//       const hasKey = this.dataPreferences?.has(key)
//       if (hasKey) {
//         console.log(`键${key}已存在，将更新其值`)
//       }
//
//       // 存储数据到内存
//       this.dataPreferences?.put(key, value, (err: BusinessError) => {
//         if (err) {
//           console.error("存储数据失败: " + err.message)
//           return
//         }
//       })
//       // 持久化到文件
//       this.dataPreferences?.flush((err: BusinessError) => {
//         if (err) {
//           console.error("Failed to flush. code =" + err.code + ", message =" + err.message);
//           return;
//         }
//         console.info("Succeeded in flushing.");
//         // const data = this.getData(key)
//       })
//       console.log(`存储数据成功: ${key} = ${value}`)
//     } catch (error) {
//       console.error(`存储数据失败: ${key}`, error)
//     }
//   }
//
//   // 读取数据
//   async getData(key: string) {
//     if (!this.dataPreferences) {
//       return ""
//     }
//
//     this.dataPreferences?.get(key, "", (err: BusinessError, value: preferences.ValueType) => {
//       if (err) {
//         console.error("读取数据失败: " + err.message)
//         return;
//       }
//       console.info("数据读取成功: " + value)
//       return value
//     })
//
//     return ""
//
//   }
//
//   // 删除数据
//   async deleteData(key: string) {
//     if (!this.dataPreferences) {
//       return
//     }
//
//     try {
//       await this.dataPreferences?.delete(key)
//       await this.dataPreferences?.flush()
//       console.log(`删除数据成功: ${key}`)
//     } catch (error) {
//       console.error(`删除数据失败: ${key}`, error)
//     }
//   }
//
//   // 清空所有数据
//   async clearAllData() {
//     if (!this.dataPreferences) {
//       return
//     }
//
//     try {
//       await this.dataPreferences?.clear()
//       await this.dataPreferences?.flush()
//       console.log('清空所有数据成功')
//     } catch (error) {
//       console.error('清空所有数据失败', error)
//     }
//   }
// }


import { preferences } from '@kit.ArkData';


export class PreferencesManager {
  private static instance: PreferencesManager
  dataPreferences: preferences.Preferences | null = null;

  // static dataPreferences: preferences.Preferences;

  private constructor() {
  } // 私有构造函数，外部无法 new

  static getInstance(): PreferencesManager {
    if (!PreferencesManager.instance) {
      PreferencesManager.instance = new PreferencesManager()
    }
    return PreferencesManager.instance
  }

  init(context: Context, name: preferences.Options) {
    this.dataPreferences = preferences.getPreferencesSync(context, name)
  }

  getData(key: string) {
    return this.dataPreferences?.getSync(key, "")
  }

  putData(key: string, value: string) {
    this.dataPreferences?.putSync(key, value)
    this.dataPreferences?.flushSync()
  }
}

// import preferences from '@ohos.data.preferences';
// import { Context } from '@ohos.abilityAccessCtrl';
// import { BusinessError } from '@kit.BasicServicesKit';
//
// export class PreferencesManager{
//   static pre?: preferences.Preferences;
//
//   public static getPreferences(context: Context){
//     PreferencesManager.pre = preferences.getPreferencesSync(context,{name: 'AppPreferences'})
//   }
//
//   public static getValue(key: string,de: preferences.ValueType){
//     return PreferencesManager.pre?.getSync(key,de)
//   }
//
//   public static putValue(key:string ,value: preferences.ValueType){
//     PreferencesManager.pre?.putSync(key,value)
//   }
//
//   public static deleteValue(key:string){
//     PreferencesManager.pre?.deleteSync(key)
//   }
//
//   public static saveValue(){
//     PreferencesManager.pre?.flush((err: BusinessError) => {
//       if(err){
//         return
//       }
//     })
//   }
// }