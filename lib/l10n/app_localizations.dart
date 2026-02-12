import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';

/// 应用文案：默认英语，支持 zh 中文
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    return AppLocalizations(locale);
  }

  Map<String, String> get _t =>
      locale.languageCode == 'zh' ? _zh : _en;

  static const Map<String, String> _en = {
    'appName': 'PhotoSquish',
    'tabHome': 'Home',
    'tabWorks': 'Works',
    'tabProfile': 'Profile',
    'imageProcess': 'Image',
    'losslessCompress': 'Lossless',
    'losslessSubtitle': 'No size change',
    'scaleCompress': 'Scale',
    'scaleSubtitle': 'Aspect ratio',
    'resizeCompress': 'Resize',
    'resizeSubtitle': 'Custom size',
    'formatConvert': 'Format',
    'formatSubtitle': 'Convert format',
    'noImagesYet': 'No images yet',
    'tapToAddImages': 'Tap the button below to add images',
    'compressingProgress': 'Compressing %1/%2',
    'addImages': 'Add images',
    'compressConfig': 'Compress settings',
    'clear': 'Clear',
    'startCompress': 'Compress',
    'addImagesFailed': 'Failed to add images: %s',
    'compressDone': 'Done!',
    'compressFailed': 'Compress failed: %s',
    'confirmDelete': 'Delete image?',
    'confirmDeleteContent': 'Delete this image?',
    'cancel': 'Cancel',
    'delete': 'Delete',
    'confirmClear': 'Clear all?',
    'confirmClearContent': 'Clear all images?',
    'statistics': 'Statistics',
    'totalCount': 'Total',
    'successCount': 'Success',
    'failedCount': 'Failed',
    'totalOriginalSize': 'Original size',
    'totalCompressedSize': 'Compressed size',
    'totalRatio': 'Ratio',
    'close': 'Close',
    'compressConfigTitle': 'Compress settings',
    'reset': 'Reset',
    'quickPresets': 'Presets',
    'presetHigh': 'High quality',
    'presetHighSub': '90% quality, 80% scale',
    'presetBalance': 'Balance',
    'presetBalanceSub': '75% quality, 70% scale',
    'presetStrong': 'High compression',
    'presetStrongSub': '60% quality, 50% scale',
    'presetSmart': 'Smart',
    'presetSmartSub': 'Auto',
    'saveConfig': 'Save',
    'presetApplied': 'Preset applied',
    'configReset': 'Config reset',
    'configSaved': 'Saved',
    'discardChanges': 'Discard changes?',
    'discardChangesContent': 'You have unsaved changes. Discard?',
    'continueEdit': 'Keep editing',
    'discard': 'Discard',
    'compressMode': 'Mode',
    'compressQuality': 'Quality',
    'scaleRatio': 'Scale',
    'targetSize': 'Size',
    'fillMode': 'Fill',
    'outputFormat': 'Format',
    'qualityLevel': 'Level',
    'lowQuality': 'Low',
    'highQuality': 'High',
    'width': 'Width',
    'height': 'Height',
    'fitContain': 'Contain',
    'fitCover': 'Cover',
    'fitFill': 'Fill',
    'showPreview': 'Show preview',
    'showPreviewSub': 'Compare before/after when done',
    'losslessTitle': 'Lossless',
    'scaleTitle': 'Scale',
    'resizeTitle': 'Resize',
    'formatTitle': 'Format',
    'clearAll': 'Clear',
    'pickImages': 'Pick images',
    'pickImagesFailed': 'Pick failed: %s',
    'compressQualityLabel': 'Quality',
    'qualityLow': 'Low',
    'qualityMid': 'Mid',
    'qualityHigh': 'High',
    'qualitySuper': 'Super',
    'formatOriginal': 'Original',
    'processing': 'Processing...',
    'startCompressButton': 'Compress',
    'compressing': 'Compressing...',
    'inputTargetSize': 'Enter target size',
    'skippedNoSmaller': 'Not smaller, skipped',
    'compressFailedNoPreview': 'Failed, no preview',
    'confirmClearAll': 'Clear all?',
    'confirmClearAllContent': 'Clear all selected images?',
    'ok': 'OK',
    'convertFailed': 'Convert failed',
    'convertFailedNoPreview': 'Convert failed, no preview',
    'customPixels': 'Custom px',
    'originalSize': 'Original %s×%s',
    'targetWidth': 'Width',
    'targetHeight': 'Height',
    'rangeWidth': '1~%s',
    'rangeHeight': '1~%s',
    'pixels': 'px',
    'profileTitle': 'Profile',
    'photoCompress': 'PhotoSquish',
    'normalUser': 'Free user',
    'freeAllFeatures': 'All features free',
    'welcome': 'Welcome',
    'helpManual': 'Help',
    'contactUs': 'Contact',
    'userAgreement': 'User agreement',
    'privacyPolicy': 'Privacy',
    'accountLogout': 'Logout',
    'currentVersion': 'Version',
    'logoutConfirm': 'Log out?',
    'logoutConfirmContent': 'Are you sure?',
    'logoutSuccess': 'Done',
    'alreadyLatest': 'Already latest',
    'contactTitle': 'Contact us',
    'emailService': 'Email',
    'workHours': 'Hours',
    'copiedToClipboard': 'Copied %s',
    'imagePreview': 'Preview',
    'share': 'Share',
    'save': 'Save',
    'noImage': 'No image',
    'noPreviewImages': 'No images to preview',
    'shareFailed': 'Share failed: %s',
    'savedToGallery': 'Saved to gallery',
    'saveFailedCheckPermission': 'Save failed, check permission',
    'saveFailed': 'Save failed: %s',
    'shareSubject': 'Images compressed with PhotoSquish',
    'worksTitle': 'History',
    'noHistory': 'No history',
    'historyHint': 'Compressed images appear here',
    'deleted': 'Deleted',
    'confirmClearHistory': 'Clear history?',
    'confirmClearHistoryContent': 'Clear all history?',
    'language': 'Language',
    'languageEnglish': 'English',
    'languageChinese': '中文',
    'helpTitle': 'Help',
    'helpLossless': 'Lossless',
    'helpLosslessDesc': 'Reduce file size without changing dimensions.',
    'helpScale': 'Scale',
    'helpScaleDesc': 'Scale by ratio for good compression.',
    'helpResize': 'Resize',
    'helpResizeDesc': 'Set width/height or pixels.',
    'helpFormat': 'Format',
    'helpFormatDesc': 'Convert format; can compress too.',
    'splashTagline': 'Fast · Easy · Pro',
    'splashLoading': 'Loading...',
    'emailLabel': 'Email',
  };

  static const Map<String, String> _zh = {
    'appName': '照片压缩',
    'tabHome': '首页',
    'tabWorks': '作品',
    'tabProfile': '我的',
    'imageProcess': '图片处理',
    'losslessCompress': '无损压缩',
    'losslessSubtitle': '不影响尺寸大小',
    'scaleCompress': '等比缩放',
    'scaleSubtitle': '等比例模式',
    'resizeCompress': '指定尺寸',
    'resizeSubtitle': '指定大小',
    'formatConvert': '格式转换',
    'formatSubtitle': '一键转换格式',
    'noImagesYet': '还没有图片',
    'tapToAddImages': '点击右下角按钮添加图片',
    'compressingProgress': '正在压缩 %1/%2',
    'addImages': '添加图片',
    'compressConfig': '压缩配置',
    'clear': '清空',
    'startCompress': '开始压缩',
    'addImagesFailed': '添加图片失败: %s',
    'compressDone': '压缩完成！',
    'compressFailed': '压缩失败: %s',
    'confirmDelete': '确认删除',
    'confirmDeleteContent': '确定要删除这张图片吗？',
    'cancel': '取消',
    'delete': '删除',
    'confirmClear': '确认清空',
    'confirmClearContent': '确定要清空所有图片吗？',
    'statistics': '统计信息',
    'totalCount': '总图片数',
    'successCount': '成功压缩',
    'failedCount': '失败数量',
    'totalOriginalSize': '原始总大小',
    'totalCompressedSize': '压缩后大小',
    'totalRatio': '总压缩率',
    'close': '关闭',
    'compressConfigTitle': '压缩配置',
    'reset': '重置',
    'quickPresets': '快速预设',
    'presetHigh': '高质量',
    'presetHighSub': '质量90% + 等比80%',
    'presetBalance': '平衡',
    'presetBalanceSub': '质量75% + 等比70%',
    'presetStrong': '高压缩',
    'presetStrongSub': '质量60% + 等比50%',
    'presetSmart': '智能',
    'presetSmartSub': '自动优化',
    'saveConfig': '保存配置',
    'presetApplied': '已应用预设配置',
    'configReset': '已重置配置',
    'configSaved': '配置已保存',
    'discardChanges': '放弃更改？',
    'discardChangesContent': '您有未保存的配置更改，确定要放弃吗？',
    'continueEdit': '继续编辑',
    'discard': '放弃',
    'compressMode': '压缩模式',
    'compressQuality': '压缩质量',
    'scaleRatio': '缩放比例',
    'targetSize': '目标尺寸',
    'fillMode': '填充模式',
    'outputFormat': '输出格式',
    'qualityLevel': '质量等级',
    'lowQuality': '低质量',
    'highQuality': '高质量',
    'width': '宽度',
    'height': '高度',
    'fitContain': '包含（留白）',
    'fitCover': '覆盖（裁剪）',
    'fitFill': '拉伸填充',
    'showPreview': '显示对比预览',
    'showPreviewSub': '压缩完成后显示原图与压缩图对比',
    'losslessTitle': '无损压缩',
    'scaleTitle': '等比缩放',
    'resizeTitle': '指定尺寸',
    'formatTitle': '格式转换',
    'clearAll': '清除',
    'pickImages': '请选取图片',
    'pickImagesFailed': '选择图片失败: %s',
    'compressQualityLabel': '压缩质量',
    'qualityLow': '低',
    'qualityMid': '中',
    'qualityHigh': '高',
    'qualitySuper': '超高',
    'formatOriginal': '原格式',
    'processing': '处理中...',
    'startCompressButton': '开始压缩',
    'compressing': '压缩中...',
    'inputTargetSize': '请输入目标尺寸',
    'skippedNoSmaller': '压缩后体积未减小，已自动跳过',
    'compressFailedNoPreview': '压缩失败，没有可预览的图片',
    'confirmClearAll': '清除全部',
    'confirmClearAllContent': '确定要清除所有已选择的图片吗？',
    'ok': '确定',
    'convertFailed': '转换失败',
    'convertFailedNoPreview': '转换失败，没有可预览的图片',
    'customPixels': '自定义像素',
    'originalSize': '原图 %s×%s',
    'targetWidth': '指定宽度',
    'targetHeight': '指定高度',
    'rangeWidth': '1~%s',
    'rangeHeight': '1~%s',
    'pixels': '像素',
    'profileTitle': '我的',
    'photoCompress': '照片压缩',
    'normalUser': '普通用户',
    'freeAllFeatures': '免费使用所有功能',
    'welcome': '欢迎您',
    'helpManual': '帮助手册',
    'contactUs': '联系客服',
    'userAgreement': '用户协议',
    'privacyPolicy': '隐私政策',
    'accountLogout': '账户注销',
    'currentVersion': '当前版本',
    'logoutConfirm': '账户注销',
    'logoutConfirmContent': '确定要注销账户吗？',
    'logoutSuccess': '注销成功',
    'alreadyLatest': '已是最新版本了',
    'contactTitle': '联系我们',
    'emailService': '邮件客服',
    'workHours': '工作时间',
    'copiedToClipboard': '已复制%s到剪贴板',
    'imagePreview': '图片预览',
    'share': '分享',
    'save': '保存',
    'noImage': '没有图片',
    'noPreviewImages': '没有可预览的图片',
    'shareFailed': '分享失败: %s',
    'savedToGallery': '已保存到相册',
    'saveFailedCheckPermission': '保存失败，请检查相册权限',
    'saveFailed': '保存失败: %s',
    'shareSubject': '通过照片压缩压缩的图片',
    'worksTitle': '压缩记录',
    'noHistory': '暂无压缩记录',
    'historyHint': '压缩图片后会自动保存到这里',
    'deleted': '已删除',
    'confirmClearHistory': '清空记录',
    'confirmClearHistoryContent': '确定要清空所有压缩记录吗？',
    'language': '语言',
    'languageEnglish': 'English',
    'languageChinese': '中文',
    'helpTitle': '帮助手册',
    'helpLossless': '无损压缩',
    'helpLosslessDesc': '不改变图片尺寸,只压缩图片大小,对图片质量基本没有影响',
    'helpScale': '等比压缩',
    'helpScaleDesc': '等比例改变图片尺寸,影响图片质量,但是压缩效果较好',
    'helpResize': '指定尺寸',
    'helpResizeDesc': '可选择指定尺寸或指定像素压缩,灵活满足您的需求',
    'helpFormat': '格式转换',
    'helpFormatDesc': '转换成您需要的图片格式,转换后也可以继续压缩哦',
    'splashTagline': '高效 · 便捷 · 专业',
    'splashLoading': '正在启动...',
    'emailLabel': '邮箱',
  };

  String get appName => _t['appName']!;
  String get tabHome => _t['tabHome']!;
  String get tabWorks => _t['tabWorks']!;
  String get tabProfile => _t['tabProfile']!;
  String get imageProcess => _t['imageProcess']!;
  String get losslessCompress => _t['losslessCompress']!;
  String get losslessSubtitle => _t['losslessSubtitle']!;
  String get scaleCompress => _t['scaleCompress']!;
  String get scaleSubtitle => _t['scaleSubtitle']!;
  String get resizeCompress => _t['resizeCompress']!;
  String get resizeSubtitle => _t['resizeSubtitle']!;
  String get formatConvert => _t['formatConvert']!;
  String get formatSubtitle => _t['formatSubtitle']!;
  String get noImagesYet => _t['noImagesYet']!;
  String get tapToAddImages => _t['tapToAddImages']!;
  String get addImages => _t['addImages']!;
  String get compressConfig => _t['compressConfig']!;
  String get clear => _t['clear']!;
  String get startCompress => _t['startCompress']!;
  String get cancel => _t['cancel']!;
  String get delete => _t['delete']!;
  String get confirmDelete => _t['confirmDelete']!;
  String get confirmDeleteContent => _t['confirmDeleteContent']!;
  String get confirmClear => _t['confirmClear']!;
  String get confirmClearContent => _t['confirmClearContent']!;
  String get statistics => _t['statistics']!;
  String get totalCount => _t['totalCount']!;
  String get successCount => _t['successCount']!;
  String get failedCount => _t['failedCount']!;
  String get totalOriginalSize => _t['totalOriginalSize']!;
  String get totalCompressedSize => _t['totalCompressedSize']!;
  String get totalRatio => _t['totalRatio']!;
  String get close => _t['close']!;
  String get compressConfigTitle => _t['compressConfigTitle']!;
  String get reset => _t['reset']!;
  String get quickPresets => _t['quickPresets']!;
  String get presetHigh => _t['presetHigh']!;
  String get presetHighSub => _t['presetHighSub']!;
  String get presetBalance => _t['presetBalance']!;
  String get presetBalanceSub => _t['presetBalanceSub']!;
  String get presetStrong => _t['presetStrong']!;
  String get presetStrongSub => _t['presetStrongSub']!;
  String get presetSmart => _t['presetSmart']!;
  String get presetSmartSub => _t['presetSmartSub']!;
  String get saveConfig => _t['saveConfig']!;
  String get presetApplied => _t['presetApplied']!;
  String get configReset => _t['configReset']!;
  String get configSaved => _t['configSaved']!;
  String get compressDone => _t['compressDone']!;
  String get discardChanges => _t['discardChanges']!;
  String get discardChangesContent => _t['discardChangesContent']!;
  String get continueEdit => _t['continueEdit']!;
  String get discard => _t['discard']!;
  String get compressMode => _t['compressMode']!;
  String get compressQuality => _t['compressQuality']!;
  String get scaleRatio => _t['scaleRatio']!;
  String get targetSize => _t['targetSize']!;
  String get fillMode => _t['fillMode']!;
  String get outputFormat => _t['outputFormat']!;
  String get qualityLevel => _t['qualityLevel']!;
  String get lowQuality => _t['lowQuality']!;
  String get highQuality => _t['highQuality']!;
  String get width => _t['width']!;
  String get height => _t['height']!;
  String get fitContain => _t['fitContain']!;
  String get fitCover => _t['fitCover']!;
  String get fitFill => _t['fitFill']!;
  String get showPreview => _t['showPreview']!;
  String get showPreviewSub => _t['showPreviewSub']!;
  String get losslessTitle => _t['losslessTitle']!;
  String get scaleTitle => _t['scaleTitle']!;
  String get resizeTitle => _t['resizeTitle']!;
  String get formatTitle => _t['formatTitle']!;
  String get clearAll => _t['clearAll']!;
  String get pickImages => _t['pickImages']!;
  String get compressQualityLabel => _t['compressQualityLabel']!;
  String get qualityLow => _t['qualityLow']!;
  String get qualityMid => _t['qualityMid']!;
  String get qualityHigh => _t['qualityHigh']!;
  String get qualitySuper => _t['qualitySuper']!;
  String get formatOriginal => _t['formatOriginal']!;
  String get processing => _t['processing']!;
  String get startCompressButton => _t['startCompressButton']!;
  String get compressing => _t['compressing']!;
  String get inputTargetSize => _t['inputTargetSize']!;
  String get skippedNoSmaller => _t['skippedNoSmaller']!;
  String get compressFailedNoPreview => _t['compressFailedNoPreview']!;
  String get confirmClearAll => _t['confirmClearAll']!;
  String get confirmClearAllContent => _t['confirmClearAllContent']!;
  String get ok => _t['ok']!;
  String get convertFailedNoPreview => _t['convertFailedNoPreview']!;
  String get customPixels => _t['customPixels']!;
  String get targetWidth => _t['targetWidth']!;
  String get targetHeight => _t['targetHeight']!;
  String get pixels => _t['pixels']!;
  String get profileTitle => _t['profileTitle']!;
  String get photoCompress => _t['photoCompress']!;
  String get normalUser => _t['normalUser']!;
  String get freeAllFeatures => _t['freeAllFeatures']!;
  String get welcome => _t['welcome']!;
  String get helpManual => _t['helpManual']!;
  String get contactUs => _t['contactUs']!;
  String get userAgreement => _t['userAgreement']!;
  String get privacyPolicy => _t['privacyPolicy']!;
  String get accountLogout => _t['accountLogout']!;
  String get currentVersion => _t['currentVersion']!;
  String get logoutConfirm => _t['logoutConfirm']!;
  String get logoutConfirmContent => _t['logoutConfirmContent']!;
  String get logoutSuccess => _t['logoutSuccess']!;
  String get alreadyLatest => _t['alreadyLatest']!;
  String get contactTitle => _t['contactTitle']!;
  String get emailService => _t['emailService']!;
  String get workHours => _t['workHours']!;
  String get imagePreview => _t['imagePreview']!;
  String get share => _t['share']!;
  String get save => _t['save']!;
  String get noImage => _t['noImage']!;
  String get noPreviewImages => _t['noPreviewImages']!;
  String get savedToGallery => _t['savedToGallery']!;
  String get saveFailedCheckPermission => _t['saveFailedCheckPermission']!;
  String get worksTitle => _t['worksTitle']!;
  String get noHistory => _t['noHistory']!;
  String get historyHint => _t['historyHint']!;
  String get deleted => _t['deleted']!;
  String get confirmClearHistory => _t['confirmClearHistory']!;
  String get confirmClearHistoryContent => _t['confirmClearHistoryContent']!;
  String get language => _t['language']!;
  String get languageEnglish => _t['languageEnglish']!;
  String get languageChinese => _t['languageChinese']!;
  String get helpTitle => _t['helpTitle']!;
  String get helpLossless => _t['helpLossless']!;
  String get helpLosslessDesc => _t['helpLosslessDesc']!;
  String get helpScale => _t['helpScale']!;
  String get helpScaleDesc => _t['helpScaleDesc']!;
  String get helpResize => _t['helpResize']!;
  String get helpResizeDesc => _t['helpResizeDesc']!;
  String get helpFormat => _t['helpFormat']!;
  String get helpFormatDesc => _t['helpFormatDesc']!;
  String get splashTagline => _t['splashTagline']!;
  String get splashLoading => _t['splashLoading']!;
  String get emailLabel => _t['emailLabel']!;

  String compressingProgress(String a, String b) =>
      (_t['compressingProgress']!).replaceAll('%1', a).replaceAll('%2', b);
  String addImagesFailed(String s) => (_t['addImagesFailed']!).replaceAll('%s', s);
  String compressFailed(String s) => (_t['compressFailed']!).replaceAll('%s', s);
  String pickImagesFailed(String s) => (_t['pickImagesFailed']!).replaceAll('%s', s);
  String copiedToClipboard(String s) => (_t['copiedToClipboard']!).replaceAll('%s', s);
  String shareFailed(String s) => (_t['shareFailed']!).replaceAll('%s', s);
  String saveFailed(String s) => (_t['saveFailed']!).replaceAll('%s', s);
  String originalSize(String w, String h) =>
      (_t['originalSize']!).replaceFirst('%s', w).replaceFirst('%s', h);
  String rangeWidth(String s) => (_t['rangeWidth']!).replaceAll('%s', s);
  String rangeHeight(String s) => (_t['rangeHeight']!).replaceAll('%s', s);
  String get shareSubjectText => _t['shareSubject']!;
}
