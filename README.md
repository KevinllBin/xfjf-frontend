# Flutter 拍照搜题前端

## 功能

- 拍照搜题
- 相册选图搜题
- 选图后裁剪题目区域再上传
- 展示 OCR 文本和匹配题目结果
- 本地保存最近 20 条搜索记录
- 使用 `ChangeNotifier + Provider` 做状态管理

## 接口对接

- 后端上传接口：`POST /upload`
- 请求方式：`multipart/form-data`，字段名 `file`
- 读取返回字段：`ocr_text`、`count`、`results`

## 启动步骤

1. 安装 Flutter SDK，并确保 `flutter` 命令在环境变量中。
2. 在项目目录执行：

```bash
flutter pub get
flutter run --dart-define-from-file=env/dev.json
```

## 环境配置

项目通过 `BACKEND_BASE_URL` 配置后端地址，默认值在代码中作为兜底。

推荐使用环境文件并通过 `--dart-define-from-file` 注入：

```bash
flutter run --dart-define-from-file=env/dev.json
flutter build apk --release --dart-define-from-file=env/prod.json
```

`env/dev.json` 示例：

```json
{
	"BACKEND_BASE_URL": "https://api.example.com"
}
```


## 平台权限

请确保你的 Android 与 iOS 工程已添加相机和相册权限：

- Android：相机、读取媒体图片权限
- iOS：`NSCameraUsageDescription`、`NSPhotoLibraryUsageDescription`

如果你是从空目录初始化，建议先执行 `flutter create .` 生成平台目录后再补充权限配置。
