//
//  ScanCodeMaskView.m
//  HealthManager
//
//  Created by user on 14-2-20.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "ScanCodeMaskView.h"

@implementation ScanCodeMaskView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self setClearsContextBeforeDrawing: YES];
    [self setAlpha:0.3];
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    int leftX = 30;
    int rightX = DEVICE_WIDTH - leftX;
    int topY = 64+20;
    int bottomY = DEVICE_HEIGHT-20-4-44-20- topY;
    int hornLength = 20;
    
    //画底部透明层
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [self colorWithRGB:0x303030 withAlpha:1.0].CGColor);
    CGContextFillRect(context, CGRectMake(0, DEVICE_HEIGHT-44-44-20-44, DEVICE_WIDTH, 44));
    CGContextFillRect(context, CGRectMake(0, 0, DEVICE_WIDTH, 64));
    CGContextRestoreGState(context);
    
    //画出提示文字
    CGContextSaveGState(context);
    CGContextSetTextDrawingMode(context, kCGTextFillStroke);
    CGContextSetLineWidth(context, 0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    NSString *tipsText = @"请将条形码置于扫描框的红线内，避免反光或阴影提示：【中国药品电子监管码】一般位于药盒的背面和侧面";
    [tipsText drawInRect:CGRectMake(20, 4, DEVICE_WIDTH-40, 80) withFont:[UIFont systemFontOfSize:14] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
    CGContextRestoreGState(context);
    
    CGColorRef hornColorRef = [UIColor greenColor].CGColor;
    //画左上角
    [self drawLine:context WithStartPoint:CGPointMake(leftX, topY) withEndPoint:CGPointMake(leftX + hornLength, topY) withColor:hornColorRef];
    [self drawLine:context WithStartPoint:CGPointMake(leftX, topY) withEndPoint:CGPointMake(leftX, topY+hornLength) withColor:hornColorRef];
    //画右上角
    [self drawLine:context WithStartPoint:CGPointMake(rightX, topY) withEndPoint:CGPointMake(rightX, topY + hornLength) withColor:hornColorRef];
    [self drawLine:context WithStartPoint:CGPointMake(rightX, topY) withEndPoint:CGPointMake(rightX-hornLength, topY) withColor:hornColorRef];
    //画右下角
    [self drawLine:context WithStartPoint:CGPointMake(rightX, bottomY) withEndPoint:CGPointMake(rightX-hornLength, bottomY) withColor:hornColorRef];
    [self drawLine:context WithStartPoint:CGPointMake(rightX, bottomY) withEndPoint:CGPointMake(rightX, bottomY - hornLength) withColor:hornColorRef];
    //画左下角
    [self drawLine:context WithStartPoint:CGPointMake(leftX, bottomY) withEndPoint:CGPointMake(leftX + hornLength, bottomY) withColor:hornColorRef];
    [self drawLine:context WithStartPoint:CGPointMake(leftX, bottomY) withEndPoint:CGPointMake(leftX, bottomY - hornLength) withColor:hornColorRef];
    //画红色中线
    float middleLineY = topY + (bottomY-topY)/2;
    [self drawLine:context WithStartPoint:CGPointMake(leftX, middleLineY) withEndPoint:CGPointMake(rightX, middleLineY) withColor:[UIColor redColor].CGColor];
}

- (void)drawLine:(CGContextRef)context WithStartPoint:(CGPoint)startPoint withEndPoint:(CGPoint)endPoint withColor:(CGColorRef)colorRef {
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, colorRef);
    CGContextSetLineWidth(context, 2.0f);
    CGContextMoveToPoint(context, startPoint.x , startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (UIColor *)colorWithRGB:(int)rgbValue withAlpha:(float)alphaValue {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue];
}
@end
