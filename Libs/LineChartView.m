//
//  LineChartView.m
//  DrawDemo
//
//  Created by 潘朋 dream on 2014-01-01.
//  Copyright (c) 2014年 dreaminto.com.
//

#import "LineChartView.h"

#define PI 3.1415926535979323846

@interface LineChartView()
{
}

@end

@implementation LineChartView

@synthesize bloodArray;
@synthesize hGap,vGap;
@synthesize hDesc,vDesc;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        hGap = 9;
        vGap = 20;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self setClearsContextBeforeDrawing: YES];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat backLineWidth = 1.0f;
    CGContextSetLineWidth(context, backLineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGColorRef borderLineColorRef = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f].CGColor;
    CGColorRef lineColorRef = [UIColor colorWithRed:98.0f/255.0f green:98.0f/255.0f blue:98.0f/255.0f alpha:1.0f].CGColor;
    CGContextSetStrokeColorWithColor(context, lineColorRef);
    
    //纵坐标数值的标签显示宽度
    int vOrdinateLabelWidth = 30;
    //坐标数值的标签高与宽度
    int coordinateLabelHeight = 20;
    int coordinateLabelWidth = vOrdinateLabelWidth;
    //横轴坐标值的标签与坐标横轴的间隙
    int gapBetweenLabelAndHordinate = 5;
    
    UIColor *coordinateLabelFontColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];

    //坐标原点
    int newCoordinateX = vOrdinateLabelWidth;//x位置由纵坐标数值的标签宽度决定
    int newCoordinateY = self.frame.size.height - ( gapBetweenLabelAndHordinate*2 + coordinateLabelHeight );//为横轴坐标值的标签高度及上下间隙留出空间
    
    int x = self.frame.size.width;
    int y = newCoordinateY;
    CGPoint beginPoint, endPoint;
    int vOrdinateLabelCenterX = newCoordinateX/2;
    
    //画水平线
    for (int i=0; i<vDesc.count; i++) {
        beginPoint = CGPointMake(newCoordinateX, y);
        endPoint = CGPointMake(x, y);
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, vOrdinateLabelWidth, coordinateLabelHeight)];
        [label setCenter:CGPointMake(vOrdinateLabelCenterX, beginPoint.y)];
        [label setTextAlignment:UITextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:coordinateLabelFontColor];
        [label setText:[vDesc objectAtIndex:i]];
        [self addSubview:label];
        if (i==0) {
            [self drawCoordinateBorderLineWith:context withBeginPoint:beginPoint withEndPoint:endPoint withColor:borderLineColorRef];
        }
        else {
            CGContextMoveToPoint(context, beginPoint.x, beginPoint.y);
            CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        }
        
        y -= vGap;
    }
    CGContextStrokePath(context);
    
    
    //画垂直线
    x = newCoordinateX;
    y += vGap;
    int hOrdinateLabelCenterY = newCoordinateY+5;
    int labelCenterXOffset = (int)(10 + floor(hGap/2));//可以在改进，自动适配显示文字的宽度
    for (int i=0; i<hDesc.count; i++) {
        beginPoint = CGPointMake(x, y);
        endPoint = CGPointMake(x, newCoordinateY);
        if ( i==6 || i==14 || i==21 || i==29 ) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x-labelCenterXOffset, hOrdinateLabelCenterY, coordinateLabelWidth, coordinateLabelHeight)];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:coordinateLabelFontColor];
            [label setText:[NSString stringWithFormat:@"%@", [hDesc objectAtIndex:i] ]];
            [self addSubview:label];
        }
        
        if (i==0) {
            [self drawCoordinateBorderLineWith:context withBeginPoint:beginPoint withEndPoint:endPoint withColor:borderLineColorRef];
        }
        else {
            CGContextMoveToPoint(context, beginPoint.x, beginPoint.y);
            CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        }
        
        x += hGap;
    }

    CGContextStrokePath(context);
    
    for (int i=0; i<[bloodArray count]; i++) {
        CGColorRef colorRef;
        switch (i) {
            case 0:
                //高血压
                colorRef = [UIColor colorWithRed:243.0f/255.0f green:152.0f/255.0f blue:0.0f alpha:1.0f].CGColor;
                break;
            case 1:
                //低血压
                colorRef = [UIColor colorWithRed:143.0f/255.0f green:195.0f/255.0f blue:31.0f/255.0f alpha:1.0f].CGColor;
                break;
            case 2:
                //脉搏
                colorRef = [UIColor colorWithRed:57.0f/255.0f green:179.0f/255.0f blue:210.0f/255.0f alpha:1.0f].CGColor;
                break;
            default:
                colorRef = [UIColor colorWithRed:243.0f/255.0f green:152.0f/255.0f blue:0.0f alpha:1.0f].CGColor;
                break;
        }
        [self drawBloodLineCharWith:context withPoint:[bloodArray objectAtIndex:i] withCoordinateX:newCoordinateX withCoordinateY:newCoordinateY withFillColor:colorRef];
    }
}

- (void)drawCoordinateBorderLineWith:(CGContextRef)context withBeginPoint:(CGPoint)beginPoint withEndPoint:(CGPoint)endPoint withColor:(CGColorRef)borderLineColorRef {
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, borderLineColorRef);
    CGContextSetLineWidth(context, 2.0f);
    CGContextMoveToPoint(context, beginPoint.x, beginPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)drawBloodLineCharWith:(CGContextRef)context withPoint:(NSArray *)bloodItem withCoordinateX:(int)newCoordinateX withCoordinateY:(int)newCoordinateY withFillColor:(CGColorRef)colorRef {
    
    int bloodItemCount = [bloodItem count];
	CGPoint p1 = [[bloodItem objectAtIndex:0] CGPointValue];
    CGPoint goPoint;
	int i = 1;
    p1.x += newCoordinateX;
    p1.y = newCoordinateY-p1.y;
	CGContextMoveToPoint(context, p1.x, p1.y);
    
	for (; i<bloodItemCount; i++)
	{
		p1 = [[bloodItem objectAtIndex:i] CGPointValue];
        goPoint = CGPointMake(newCoordinateX+(p1.x-1)*hGap, newCoordinateY-p1.y);
		CGContextAddLineToPoint(context, goPoint.x, goPoint.y);
    }
    CGContextSetStrokeColorWithColor(context, colorRef);
    CGContextSetFillColorWithColor(context, colorRef);
    
    CGContextStrokePath(context);
    
    for (i=0; i<bloodItemCount; i++)
	{
		p1 = [[bloodItem objectAtIndex:i] CGPointValue];
        goPoint = CGPointMake(newCoordinateX+(p1.x-1)*hGap, newCoordinateY-p1.y);
		CGContextAddLineToPoint(context, goPoint.x, goPoint.y);
        //画端点圆
        CGContextAddArc(context, goPoint.x, goPoint.y, 2, 0, 2*PI, 0);
        CGContextFillPath(context);
    }
}
@end
