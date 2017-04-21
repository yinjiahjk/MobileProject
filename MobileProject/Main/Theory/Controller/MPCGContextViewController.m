//
//  MPCGContextViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/4/21.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPCGContextViewController.h"

@interface MPCGContextViewController ()<CALayerDelegate>
@property(nonatomic,strong)MPContextView *myMPContextView;
@end

static const CGFloat PHOTO_HEIGHT=100;

@implementation MPCGContextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    //加载视图
    [self.view addSubview:self.myMPContextView];
    [self.myMPContextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.top.mas_equalTo(100);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];
    
    //
    [self myCALayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark 重写BaseViewController设置内容

//设置导航栏背景色
-(UIColor*)set_colorBackground
{
    return [UIColor whiteColor];
}

//是否隐藏导航栏底部的黑线 默认也为NO
-(BOOL)hideNavigationBottomLine
{
    return NO;
}

////设置标题
-(NSMutableAttributedString*)setTitle
{
    return [self changeTitle:@"CGContext知识点运用"];
}

//设置左边按键
-(UIButton*)set_leftButton
{
    UIButton *left_button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    [left_button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [left_button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateHighlighted];
    return left_button;
}

//设置左边事件
-(void)left_button_event:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(18) range:NSMakeRange(0, title.length)];
    return title;
}

//视图里面的绘制效果
-(MPContextView *)myMPContextView
{
    if (!_myMPContextView) {
        _myMPContextView=[MPContextView new];
        _myMPContextView.backgroundColor=[UIColor blueColor];
    }
    return _myMPContextView;
}

//绘一个图片加边框效果
-(void)myCALayer
{
    CGPoint position= CGPointMake(160, 300);
    CGRect bounds=CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);
    CGFloat cornerRadius=PHOTO_HEIGHT/2;
    CGFloat borderWidth=2;
    
    //阴影图层
    CALayer *layerShadow=[[CALayer alloc]init];
    layerShadow.bounds=bounds;
    layerShadow.position=position;
    layerShadow.cornerRadius=cornerRadius;
    layerShadow.shadowColor=[UIColor grayColor].CGColor;
    layerShadow.shadowOffset=CGSizeMake(2, 1);
    layerShadow.shadowOpacity=1;
    layerShadow.borderColor=[UIColor whiteColor].CGColor;
    layerShadow.borderWidth=borderWidth;
    [self.view.layer addSublayer:layerShadow];
    
    //容器图层
    CALayer *layer=[[CALayer alloc]init];
    layer.bounds=bounds;
    layer.position=position;
    layer.backgroundColor=[UIColor redColor].CGColor;
    layer.cornerRadius=cornerRadius;
    layer.masksToBounds=YES;
    layer.borderColor=[UIColor whiteColor].CGColor;
    layer.borderWidth=borderWidth;
    
    //设置图层代理
    layer.delegate=self;
    
    //添加图层到根图层
    [self.view.layer addSublayer:layer];
    
    //调用图层setNeedDisplay,否则代理方法不会被调用
    [layer setNeedsDisplay];
}

#pragma mark CALayerDelegate 绘制图形、图像到图层，注意参数中的ctx是图层的图形上下文，其中绘图位置也是相对图层而言的
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    //    NSLog(@"%@",layer);//这个图层正是上面定义的图层
    CGContextSaveGState(ctx);
    
    //图形上下文形变，解决图片倒立的问题
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -PHOTO_HEIGHT);
    
    UIImage *image=[UIImage imageNamed:@"photo_header"];
    
    //解决图片模糊问题
    layer.contentsScale = [UIScreen mainScreen].scale;
    //注意这个位置是相对于图层而言的不是屏幕
    CGContextDrawImage(ctx, CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT), image.CGImage);
    
    //    CGContextFillRect(ctx, CGRectMake(0, 0, 100, 100));
    //    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    CGContextRestoreGState(ctx);
}

@end
