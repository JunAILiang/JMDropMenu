//
//  JMDropMenu.m
//  JMDropMenu
//
//  Created by JM on 2017/12/20.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "JMDropMenu.h"

#define kWindow [UIApplication sharedApplication].keyWindow
#define kCellIdentifier @"cellIdentifier"
#define kDropMenuCellID @"DropMenuCellID"

@interface JMDropMenu()<UITableViewDelegate,UITableViewDataSource>
/** 蒙版 */
@property (nonatomic, strong) UIView *cover;
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** 存放标题和图片数组 */
@property (nonatomic, strong) NSMutableArray *titleImageArrM;
/** rowHeight */
@property (nonatomic, assign) CGFloat rowHeight;
/** rgb的可变数组 */
@property (nonatomic, strong) NSMutableArray *RGBStrValueArr;
/** 类型(qq或者微信) */
@property (nonatomic, assign) JMDropMenuType type;
@end

@implementation JMDropMenu

- (NSMutableArray *)titleImageArrM {
    if (!_titleImageArrM) {
        _titleImageArrM = [NSMutableArray array];
    }
    return _titleImageArrM;
}

- (NSMutableArray *)RGBStrValueArr {
    if (!_RGBStrValueArr) {
        _RGBStrValueArr = [NSMutableArray array];
    }
    return _RGBStrValueArr;
}

- (instancetype)initWithFrame:(CGRect)frame ArrowOffset:(CGFloat)arrowOffset TitleArr:(NSArray *)titleArr ImageArr:(NSArray *)imageArr Type:(JMDropMenuType)type LayoutType:(JMDropMenuLayoutType)layoutType RowHeight:(CGFloat)rowHeight Delegate:(id<JMDropMenuDelegate>)delegate {
    if (self = [super initWithFrame:frame]) {
        //初始化赋值
        self.frame = frame;
        _arrowOffset = arrowOffset;
        _type = type;
        _LayoutType = layoutType;
        _rowHeight = rowHeight;
        _delegate = delegate;
        //类型判断
        if (type == JMDropMenuTypeWeChat) {
            self.RGBStrValueArr = [NSMutableArray arrayWithObjects:@(54),@(54),@(54), nil];
            _titleColor = [UIColor whiteColor];
            _lineColor = [UIColor whiteColor];
        } else {
            self.RGBStrValueArr = [NSMutableArray arrayWithObjects:@(255),@(255),@(255), nil];
            _titleColor = [UIColor blackColor];
            _lineColor = [UIColor lightGrayColor];
        }
        //字典转模型
        for (int i = 0; i < titleArr.count; i++) {
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
            [tempDict setObject:titleArr[i] forKey:@"title"];
            if (i != imageArr.count) {
                [tempDict setObject:imageArr[i] forKey:@"image"];
            }
            [tempDict setObject:@(layoutType) forKey:@"layoutType"];
            [tempDict setObject:@(type) forKey:@"type"];
            JMDropMenuModel *model = [JMDropMenuModel dropMenuWithDictonary:tempDict];
            [self.titleImageArrM addObject:model];
        }
        
        
        [kWindow addSubview:self.cover];
        UITapGestureRecognizer *tapCover = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCoverClick)];
        [self.cover addGestureRecognizer:tapCover];
        
        self.backgroundColor = [UIColor clearColor];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        [self addSubview:self.tableView];
    }
    return self;
}

+ (instancetype)showDropMenuFrame:(CGRect)frame ArrowOffset:(CGFloat)arrowOffset TitleArr:(NSArray *)titleArr ImageArr:(NSArray *)imageArr Type:(JMDropMenuType)type LayoutType:(JMDropMenuLayoutType)layoutType RowHeight:(CGFloat)rowHeight Delegate:(id<JMDropMenuDelegate>)delegate{
    return [[self alloc] initWithFrame:frame ArrowOffset:arrowOffset TitleArr:titleArr ImageArr:imageArr Type:type LayoutType:layoutType RowHeight:rowHeight Delegate:delegate];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 8, self.frame.size.width, self.frame.size.height - 8) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 6.f;
        if (_type == JMDropMenuTypeWeChat) {
            _tableView.backgroundColor = [UIColor colorWithRed:54 / 255.0 green:54 / 255.0 blue:54 / 255.0 alpha:1];
        } else {
            _tableView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1];
        }
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleImageArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMDropMenuCell *cell = [JMDropMenuCell dropMenuCellWithTableView:tableView];
    cell.model = self.titleImageArrM[indexPath.row];
    float r = [self.RGBStrValueArr[0] floatValue] / 255.0;
    float g = [self.RGBStrValueArr[1] floatValue] / 255.0;
    float b = [self.RGBStrValueArr[2] floatValue] / 255.0;
    cell.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
    cell.titleL.textColor = _titleColor;
    cell.line1.backgroundColor = _lineColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JMDropMenuModel *model = self.titleImageArrM[indexPath.row];
    if ([_delegate respondsToSelector:@selector(didSelectRowAtIndex:Title:Image:)]) {
        [_delegate didSelectRowAtIndex:indexPath.row Title:model.title Image:model.image];
    }
    [self removeDropMenu];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _rowHeight;
}

- (UIView *)cover {
    if (!_cover) {
        _cover = [[UIView alloc] initWithFrame:kWindow.bounds];
        _cover.backgroundColor = [UIColor blackColor];
        _cover.alpha = 0.1;
    }
    return _cover;
}

#pragma mark - 蒙版点击
- (void)tapCoverClick {
    [self removeDropMenu];
}

#pragma mark - 隐藏蒙版
- (void)removeDropMenu {
    [self.tableView removeFromSuperview];
    [self.cover removeFromSuperview];
    [self removeFromSuperview];
}

// 覆盖drawRect方法，你可以在此自定义绘画和动画
- (void)drawRect:(CGRect)rect
{
    //An opaque type that represents a Quartz 2D drawing environment.
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    /*画三角形*/
    CGPoint sPoints[3];//坐标点
    sPoints[0] = CGPointMake(_arrowOffset, 0);//坐标1
    sPoints[1] = CGPointMake(_arrowOffset - 8, 8);//坐标2
    sPoints[2] = CGPointMake(_arrowOffset + 8, 8);//坐标3
    CGContextAddLines(context, sPoints, 3);//添加线
    //填充色
    float r = [self.RGBStrValueArr[0] floatValue] / 255.0;
    float g = [self.RGBStrValueArr[1] floatValue] / 255.0;
    float b = [self.RGBStrValueArr[2] floatValue] / 255.0;
    UIColor *aColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
    CGContextSetFillColorWithColor(context, aColor.CGColor);
    //画线笔颜色
    CGContextSetRGBStrokeColor(context,r, g, b,1.0);//画笔线的颜色
    CGContextClosePath(context);//封起来
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
}

//将UIColor转换为RGB值
- (NSMutableArray *)changeUIColorToRGB:(UIColor *)color
{
    NSMutableArray *RGBStrValueArr = [[NSMutableArray alloc] init];
    NSString *RGBStr = nil;
    //获得RGB值描述
    NSString *RGBValue = [NSString stringWithFormat:@"%@",color];
    //将RGB值描述分隔成字符串
    NSArray *RGBArr = [RGBValue componentsSeparatedByString:@" "];
    //获取红色值
    int r = [[RGBArr objectAtIndex:1] intValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%d",r];
    [RGBStrValueArr addObject:RGBStr];
    //获取绿色值
    int g = [[RGBArr objectAtIndex:2] intValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%d",g];
    [RGBStrValueArr addObject:RGBStr];
    //获取蓝色值
    int b = [[RGBArr objectAtIndex:3] intValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%d",b];
    [RGBStrValueArr addObject:RGBStr];
    //返回保存RGB值的数组
    return RGBStrValueArr;
}

//16进制颜色(html颜色值)字符串转为UIColor
- (NSMutableArray *)hexStringToColor:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
//    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
//    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [NSMutableArray arrayWithObjects:@(r),@(g),@(b), nil];
}

#pragma mark - 箭头x偏移值
- (void)setArrowOffset:(CGFloat)arrowOffset {
    _arrowOffset = arrowOffset;
    [self setNeedsDisplay];
}
#pragma mark - 类型
- (void)setLayoutType:(JMDropMenuLayoutType)LayoutType {
    _LayoutType = LayoutType;
    for (JMDropMenuModel *model in self.titleImageArrM) {
        model.layoutType = LayoutType;
    }
    [self.tableView reloadData];
}

#pragma mark - 箭头颜色
- (void)setArrowColor:(UIColor *)arrowColor {
    _arrowColor = arrowColor;
    self.RGBStrValueArr = [self changeUIColorToRGB:arrowColor];
    [self setNeedsDisplay];
}

- (void)setArrowColor16:(NSString *)arrowColor16 {
    _arrowColor16 = arrowColor16;
    self.RGBStrValueArr = [self hexStringToColor:arrowColor16];
    [self setNeedsDisplay];
}

#pragma mark - 文字颜色
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self.tableView reloadData];
}

#pragma mark - 线条颜色
- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    [self.tableView reloadData];
}

@end


@interface JMDropMenuCell()
/** 屏幕中心点 */
@property (nonatomic, assign) CGFloat screenCenter;
@end

@implementation JMDropMenuCell

+ (instancetype)dropMenuCellWithTableView:(UITableView *)tableView {
    JMDropMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:kDropMenuCellID];
    if (!cell) {
        cell = [[JMDropMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDropMenuCellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imageIV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageIV];
        
        self.titleL = [[UILabel alloc] init];
        self.titleL.textColor = [UIColor blackColor];
        self.titleL.font = [UIFont systemFontOfSize:15.f];
        [self.contentView addSubview:self.titleL];
        
        self.line1 = [[UIImageView alloc] init];
        self.line1.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.line1];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.screenCenter = self.contentView.frame.size.height * 0.5;
    
    self.imageIV.frame = CGRectMake(10, self.screenCenter - 8, 16, 16);
    if (self.model.layoutType == JMDropMenuLayoutTypeTitle) {
        self.titleL.frame = CGRectMake(10, self.screenCenter - 10, self.frame.size.width, 20);
    } else {
        self.titleL.frame = CGRectMake(CGRectGetMaxX(self.imageIV.frame) + 10, self.screenCenter - 10, self.contentView.frame.size.width - 50, 20);
    }
    self.line1.frame = CGRectMake(0, self.contentView.frame.size.height - 0.5, self.contentView.frame.size.width, 0.5);
}

- (void)setModel:(JMDropMenuModel *)model {
    _model = model;
    if (model.layoutType == JMDropMenuLayoutTypeTitle) {
        self.titleL.frame = CGRectMake(10, self.screenCenter - 10, self.frame.size.width, 20);
    } else {
        self.imageIV.image = [UIImage imageNamed:model.image];
    }
    if (model.type == JMDropMenuTypeQQ) {
        self.titleL.textColor = [UIColor blackColor];
        self.line1.backgroundColor = [UIColor lightGrayColor];
    } else {
        self.titleL.textColor = [UIColor whiteColor];
        self.line1.backgroundColor = [UIColor whiteColor];
    }
    self.titleL.text = model.title;
}

@end


@interface JMDropMenuModel()
@end
@implementation JMDropMenuModel

- (instancetype)initWithDictonary:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)dropMenuWithDictonary:(NSDictionary *)dict {
    return [[self alloc] initWithDictonary:dict];
}

@end



