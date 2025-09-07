import photoAccessHelper from '@ohos.file.photoAccessHelper'
import fs from '@ohos.file.fs'
import util from '@ohos.util'
import image from '@ohos.multimedia.image'
import { BusinessError } from '@kit.BasicServicesKit'
import { hilog } from '@kit.PerformanceAnalysisKit'

export async function initData(): Promise<string> {
  try {
    // 配置选择器
    let PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions()
    PhotoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE
    PhotoSelectOptions.maxSelectNumber = 1

    // 打开相册
    let photoPicker = new photoAccessHelper.PhotoViewPicker()
    let photoSelectResult: photoAccessHelper.PhotoSelectResult =
      await photoPicker.select(PhotoSelectOptions)

    let albumPath = photoSelectResult.photoUris[0]

    // 读取文件
    const file = fs.openSync(albumPath, fs.OpenMode.READ_ONLY)
    const size = fs.statSync(file.fd).size
    let buffer = new ArrayBuffer(size)
    fs.readSync(file.fd, buffer)
    fs.closeSync(file)

    // 转Base64
    let uint8 = new Uint8Array(buffer)
    let base64Helper = new util.Base64Helper()
    const base64String: string = base64Helper.encodeToStringSync(uint8, util.Type.BASIC)


    return base64String
  } catch (e) {
    console.error('获取相册图片失败：', JSON.stringify(e))
    return ''
  }
}

/**
 * Base64 转 PixelMap
 */
export async function base64ToPixel(base64: string): Promise<PixelMap | null> {
  try {
    let pureBase64 = base64
    if (base64.includes(',')) {
      pureBase64 = base64.split(',')[1] // 去掉 data:image/jpeg;base64 前缀
    }

    const base64Helper = new util.Base64Helper()
    const uint8Array = base64Helper.decodeSync(pureBase64)
    const imageSource = image.createImageSource(uint8Array.buffer)
    const pixelMap = await imageSource.createPixelMap({})
    return pixelMap
  } catch (err) {
    console.error('Base64 转 PixelMap 失败:', (err as BusinessError).message)
    return null
  }
}


/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

const TAG = 'UTILS';

/**
 * Copy the source image into sandbox.
 * @param src - source image path
 * @param path - sandbox path
 * @returns Promise<string>
 */
export async function copyImg2Sandbox(src: string, path: string): Promise<string> {
  let srcImage = fs.openSync(src, fs.OpenMode.READ_ONLY);
  let destImage = fs.openSync(path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.copyFileSync(srcImage.fd, destImage.fd);
  fs.closeSync(srcImage);
  fs.closeSync(destImage);
  return path;
}

/**
 * Save the pixel map into image file.
 * @param pixelMap - pixel map
 * @param path - file path
 * @returns Promise<void>
 */
export function pixelMap2File(pixelMap: image.PixelMap | null, path: string): Promise<void> {
  const imagePacker = image.createImagePacker();
  let file = fs.openSync(path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  let packOpts: image.PackingOption = { format: 'image/jpeg', quality: 98 };
  return imagePacker.packToFile(pixelMap, file.fd, packOpts).then(() => {
    hilog.info(0x0000, TAG, 'packToFile succeed!');
    fs.closeSync(file.fd);
  }).catch((error: BusinessError) => {
    hilog.error(0x0000, TAG, 'packToFile failed, error: ' + JSON.stringify(error));
  });
}