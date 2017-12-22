# JMDropMenu
仿QQ、微信下拉菜单封装, 一行代码实现QQ和微信的下拉菜单
* 支持自定义样式
* 支持CocoaPods

![](https://github.com/JunAILiang/JMDropMenu/raw/master/JMDropMenu/JMDropMenu.gif)  

# 如何使用
* 通过CocoaPods导入 `pod 'JMDropMenu', '~> 0.1.1'`
* 手动导入 直接下载工程把 `JMDropMenu` 文件夹导入到自己工程中

## 初始化数据
```
self.titleArr = @[@"创建群聊",@"加好友/群",@"扫一扫",@"付款",@"拍摄"];
self.imageArr = @[@"img1",@"img2",@"img3",@"img4",@"img5"];
```

## 一行代码调用
```
[JMDropMenu showDropMenuFrame:CGRectMake(8, 64, 120, 208) ArrowOffset:16.f TitleArr:self.titleArr ImageArr:self.imageArr Type:JMDropMenuTypeWeChat LayoutType:JMDropMenuLayoutTypeNormal RowHeight:40.f Delegate:self];
```

## 遵守代理
```
- (void)didSelectRowAtIndex:(NSInteger)index Title:(NSString *)title Image:(NSString *)image {
    NSLog(@"index----%zd,  title---%@, image---%@", index, title, image);
}
```
## 你也可以高度自定义
```
/** 文字颜色 */
@property (nonatomic, strong) UIColor *titleColor;
/** 线条颜色 */
@property (nonatomic, strong) UIColor *lineColor;
/** 箭头x偏移值 */
@property (nonatomic, assign) CGFloat arrowOffset;
/** 布局类型 (图片再左, 文字在右) */
@property (nonatomic, assign) JMDropMenuLayoutType LayoutType;
/** 箭头的颜色(UIColor类型) */
@property (nonatomic, strong) UIColor *arrowColor;
/** 箭头的颜色(16进制类型, 传16进制值即可, 例 #ffffff) */
@property (nonatomic, copy) NSString *arrowColor16;
```

#### 联系我:
   * qq: 1245424073
[我的博客](https://ljmvip.cn)
