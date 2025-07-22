import { util } from '@kit.ArkTS';
import { JwtPayload } from '../data/variable';

export function base(token: string): JwtPayload {

  let payloadPart = token.split('.')[1];

  // Base64Url 转标准 Base64
  let base64Payload = payloadPart.replace(/-/g, '+')
    .replace(/_/g, '/')
    .padEnd(payloadPart.length + (4 - payloadPart.length % 4) % 4, '=');

  // 创建解码器
  let base64Helper = new util.Base64Helper();
  let decoded = base64Helper.decodeSync(base64Payload, util.Type.BASIC_URL_SAFE); // MIME 可能不兼容

  // 字节转字符串
  let decoder = new util.TextDecoder('utf-8');
  let jsonStr = decoder.decodeToString(decoded);

  // 解析 JSON
  return JSON.parse(jsonStr) as JwtPayload; // <-- 若格式不正确，这里会报错
}
