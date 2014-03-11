//
//  LineChartView.m
//  DrawDemo
//
//  Created by 潘朋 dream on 2014-01-01.
//  Copyright (c) 2014年 dreaminto.com.
//

#import "LineChartView.h"

@interface LineChartView()
{
    //坐标原点
    int _newCoordinateX;
    int _newCoordinateY;
    
    //坐标比率
    float _cordinateRate;
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
        hGap = 20;
        vGap = 20;
        _cordinateRate = 1.0;
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
    
    CGColorRef borderLineColorRef = UICOLORFROMRGB(0x333333).CGColor;
    CGColorRef lineColorRef = UICOLORFROMRGB(0xd3d3d3).CGColor;
    CGContextSetStrokeColorWithColor(context, lineColorRef);
    
    //纵坐标数值的标签显示宽度
    int vOrdinateLabelWidth = 30;
    //坐标数值的标签高与宽度
    int coordinateLabelHeight = 20;
    int coordinateLabelWidth = vOrdinateLabelWidth;
    
    UIColor *coordinateLabelFontColor = UICOLORFROMRGB(0x333333);
    UIFont *coordinateLabelFont = [UIFont systemFontOfSize:12];

    _newCoordinateX = vOrdinateLabelWidth;//x位置由纵坐标数值的标签宽度决定
    _newCoordinateY = coordinateLabelHeight/2;
    
    int x = self.frame.size.width;
    int y = _newCoordinateY;
    CGPoint beginPoint, endPoint;
    int vOrdinateLabelCenterX = _newCoordinateX/2;
    
    //画水平线
    for (int i = (int)vDesc.count -1; i > 0; i--)
    {
        beginPoint = CGPointMake(_newCoordinateX, y);
        endPoint = CGPointMake(x, y);
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, vOrdinateLabelWidth, coordinateLabelHeight)];
        [label setCenter:CGPointMake(vOrdinateLabelCenterX, beginPoint.y)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:coordinateLabelFontColor];
        [label setText:[vDesc objectAtIndex:i]];
        [label setFont:coordinateLabelFont];
        [self addSubview:label];
        
        CGContextMoveToPoint(context, beginPoint.x, beginPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        
        y += vGap;
    }
    CGContextStrokePath(context);
    
    //画水平底线
    beginPoint = CGPointMake(_newCoordinateX, y);
    endPoint = CGPointMake(x, y);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, vOrdinateLabelWidth, coordinateLabelHeight)];
    [label setCenter:CGPointMake(vOrdinateLabelCenterX, beginPoint.y)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:coordinateLabelFontColor];
    [label setText:[vDesc objectAtIndex:0]];
    [label setFont:coordinateLabelFont];
    [self addSubview:label];
    [self drawCoordinateBorderLineWith:context withBeginPoint:beginPoint withEndPoint:endPoint withColor:borderLineColorRef];
    y +=vGap;
    
    //画垂直线时的初始数据
    x = _newCoordinateX;
    y -= vGap;
    //画垂直左边线
    beginPoint = CGPointMake(x, y);
    endPoint = CGPointMake(x, _newCoordinateY);
    [self drawCoordinateBorderLineWith:context withBeginPoint:beginPoint withEndPoint:endPoint withColor:borderLineColorRef];
    x += hGap;
    
    //画垂直线
    
    int labelCenterXOffset = (int)(10 + floor(hGap/2));//可以在改进，自动适配显示文字的宽度
    for (int i=1; i<hDesc.count; i++) {
        beginPoint = CGPointMake(x, y);
        endPoint = CGPointMake(x, _newCoordinateY);
        if ( i==6 || i==14 || i==21 || i==29 ) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x-labelCenterXOffset, y, coordinateLabelWidth, coordinateLabelHeight)];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:coordinateLabelFontColor];
            [label setText:[NSString stringWithFormat:@"%@", [hDesc objectAtIndex:i] ]];
            [label setFont:coordinateLabelFont];
            [self addSubview:label];
        }
        
//        if (i==0) {
//            [self drawCoordinateBorderLineWith:context withBeginPoint:beginPoint withEndPoint:endPoint withColor:borderLineColorRef];
//        }
//        else {
            CGContextMoveToPoint(context, beginPoint.x, beginPoint.y);
            CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
//        }
        
        x += hGap;
    }
    CGContextStrokePath(context);

    //转换纵坐标为实际高度值
    _newCoordinateY = y;
    
    CGContextStrokePath(context);
    
    _cordinateRate = ([[self.vDesc objectAtIndex:1] floatValue] - [[self.vDesc objectAtIndex:0] floatValue]) / vGap;
    [self drawBloodCharWith:context];
}
- (void)drawBloodCharWith:(CGContextRef)context {
    NSMutableArray *highPressure, *lowPressure, *pulse;
    highPressure = [NSMutableArray new];
    lowPressure = [NSMutableArray new];
    pulse = [NSMutableArray new];
    NSUInteger bloodArrayCount = [bloodArray count];
    if ( bloodArrayCount>0 ) {
        for (NSDictionary *item in bloodArray) {
            [highPressure addObject:[item objectForKey:@"highPressure"]];
            [lowPressure addObject:[item objectForKey:@"lowPressure"]];
            [pulse addObject:[item objectForKey:@"pulse"]];
        }
    }
    
    CGColorRef colorRef;
    colorRef = [self getHighPressureColor];
    [self drawBloodLineCharWith:context withArray:highPressure withFillColor:colorRef];
    
    colorRef = [self getLowPressureColor];
    [self drawBloodLineCharWith:context withArray:lowPressure withFillColor:colorRef];
    
    colorRef = [self getPulsePressureColor];
    [self drawBloodLineCharWith:context withArray:pulse withFillColor:colorRef];
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

- (void)drawBloodLineCharWith:(CGContextRef)context withArray:(NSArray *)bloodItem withFillColor:(CGColorRef)colorRef {
    if (bloodItem.count == 0) {
        return;
    }
    NSUInteger bloodItemCount = [bloodItem count];
	CGPoint p1 = CGPointMake(0, [[bloodItem objectAtIndex:0] floatValue]);
    CGPoint goPoint;
	int i = 1;
    p1.x += _newCoordinateX;
    p1.y = (_newCoordinateY-p1.y)*_cordinateRate;
	CGContextMoveToPoint(context, p1.x, p1.y);
    
    NSMutableArray *drawPoint = [NSMutableArray new];
    [drawPoint addObject:[NSValue valueWithCGPoint:p1]];
    
	for (; i<bloodItemCount; i++)
	{
		p1 = CGPointMake(i, [[bloodItem objectAtIndex:i] floatValue]);
        goPoint = CGPointMake(_newCoordinateX + p1.x*hGap, _newCoordinateY-p1.y);
        [drawPoint addObject:[NSValue valueWithCGPoint:goPoint]];
		CGContextAddLineToPoint(context, goPoint.x, goPoint.y);
    }
    CGContextSetStrokeColorWithColor(context, colorRef);
    CGContextStrokePath(context);
    
    //画端点圆
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, colorRef);
    for (id item in drawPoint)
	{
        goPoint = [item CGPointValue];
        CGContextAddArc(context, goPoint.x, goPoint.y, 2, 0, 2*M_PI, 0);
        CGContextFillPath(context);
    }
    CGContextRestoreGState(context);
}

/**
 * @Deprecated from 2014-1-13
 */
- (void)drawBloodLineCharWith:(CGContextRef)context withPoint:(NSArray *)bloodItem withFillColor:(CGColorRef)colorRef {
    
    NSUInteger bloodItemCount = [bloodItem count];
	CGPoint p1 = [[bloodItem objectAtIndex:0] CGPointValue];
    CGPoint goPoint;
	int i = 1;
    p1.x += _newCoordinateX;
    p1.y = _newCoordinateY-p1.y;
	CGContextMoveToPoint(context, p1.x, p1.y);
    
	for (; i<bloodItemCount; i++)
	{
		p1 = [[bloodItem objectAtIndex:i] CGPointValue];
        goPoint = CGPointMake(_newCoordinateX+(p1.x-1)*hGap, _newCoordinateY-p1.y);
		CGContextAddLineToPoint(context, goPoint.x, goPoint.y);
    }
    CGContextSetStrokeColorWithColor(context, colorRef);
    CGContextSetFillColorWithColor(context, colorRef);
    
    CGContextStrokePath(context);
    
    for (i=0; i<bloodItemCount; i++)
	{
		p1 = [[bloodItem objectAtIndex:i] CGPointValue];
        goPoint = CGPointMake(_newCoordinateX+(p1.x-1)*hGap, _newCoordinateY-p1.y);
		CGContextAddLineToPoint(context, goPoint.x, goPoint.y);
        //画端点圆
        CGContextAddArc(context, goPoint.x, goPoint.y, 2, 0, 2*M_PI, 0);
        CGContextFillPath(context);
    }
}

- (CGColorRef)getHighPressureColor {
    CGColorRef colorRef = UICOLORFROMRGB(0xf39800).CGColor;// [UIColor colorWithRed:243.0f/255.0f green:152.0f/255.0f blue:0.0f alpha:1.0f].CGColor;
    return colorRef;
}

- (CGColorRef)getLowPressureColor {
    CGColorRef colorRef = UICOLORFROMRGB(0x8fc31f).CGColor;//[UIColor colorWithRed:143.0f/255.0f green:195.0f/255.0f blue:31.0f/255.0f alpha:1.0f].CGColor;
    return colorRef;
}

- (CGColorRef)getPulsePressureColor {
    CGColorRef colorRef = UICOLORFROMRGB(0x39b3d2).CGColor;//[UIColor colorWithRed:57.0f/255.0f green:179.0f/255.0f blue:210.0f/255.0f alpha:1.0f].CGColor;
    return colorRef;
}

@end
