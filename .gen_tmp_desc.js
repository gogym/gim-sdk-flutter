// 一次性脚本：为 RtcGroup 描述符追加 roomId(6)/mode(7) 字段并重编码 base64
// 运行后可删除。用法: node .gen_tmp_desc.js
const fs = require('fs');

const target = 'D:/GitHub/gim-sdk-flutter/lib/protocol/ImProto.pbjson.dart';
const src = fs.readFileSync(target, 'utf8');

// 提取现有 base64 片段（按行拼接）
const re = /final \$typed_data\.Uint8List rtcGroupDescriptor = \$convert\.base64Decode\(\r?\n([\s\S]*?)\);/;
const m = src.match(re);
if (!m) throw new Error('rtcGroupDescriptor not found');

// 从 dart 源码行中拼出 base64 字符串（去掉引号与行尾逗号）
const b64 = m[1]
  .split(/\r?\n/)
  .map((l) => l.trim().replace(/,+$/, ''))
  .map((l) => l.startsWith("'") || l.startsWith('"') ? l.slice(1, -1) : l)
  .join('');

const buf = Buffer.from(b64, 'base64');

// 构造单个 FieldDescriptorProto 字节序列
// tag: 1=name(string) 3=number(int32) 4=label(enum) 5=type(enum) 10=jsonName(string)
function field(name, number, type) {
  const parts = [];
  const nb = Buffer.from(name, 'utf8');
  parts.push(Buffer.from([0x0a, nb.length]), nb); // 1: name
  // number 用 varint，1~15 单字节
  parts.push(Buffer.from([0x18, number])); // 3: number
  parts.push(Buffer.from([0x20, 0x01])); // 4: LABEL_OPTIONAL
  parts.push(Buffer.from([0x28, type])); // 5: type (9=string, 5=int32)
  parts.push(Buffer.from([0x52, nb.length]), nb); // 10: jsonName
  const body = Buffer.concat(parts);
  return Buffer.concat([Buffer.from([0x12, body.length]), body]); // 2: field
}

const roomIdField = field('roomId', 6, 9); // string
const modeField = field('mode', 7, 5); // int32

const appended = Buffer.concat([buf, roomIdField, modeField]);
const outB64 = appended.toString('base64');

// 按每行 ~74 字符切分，与 protobuf dart 生成器风格一致
const lines = [];
for (let i = 0; i < outB64.length; i += 74) {
  lines.push(outB64.slice(i, i + 74));
}
const dartLines = lines.map((l) => "    '" + l + "'").join('\n');

const newBlock =
  'final $typed_data.Uint8List rtcGroupDescriptor = $convert.base64Decode(\n' +
  dartLines +
  ');';

const updated = src.replace(re, newBlock);
fs.writeFileSync(target, updated, 'utf8');
console.log('done. old len=' + buf.length + ' new len=' + appended.length);
