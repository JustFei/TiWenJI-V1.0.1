//
//  JAYLineChart.m
//  JAYChartDemo
//
//  Created by JayZY on 14-7-24.
//  Copyright (c) 2014年 MountainJ. All rights reserved.
//

#import "JAYLineChart.h"
#import "JAYColor.h"
#import "JAYChartLabel.h"

/*
 
 */
#define kMaxXLabels 10  //单屏显示最多数据条数
#define kMinXLabelS  4  //单屏显示最少数据条数
#define kDotWH 8 //画图点的宽高
#define kYLableNumbers (22.0) //纵轴显示数值单位个数
#define kBottomXLabelsH JAYLabelHeight*4 //横轴时间Lable高度
#define kStrokeLineWH  0.2 //横线竖线的宽或高
#define kStrokeLineAlpha 0.4 //描线的透明度

#define kStrokeDotDuration 0.2 //描点时间，如果不要，可设置0.0001

@interface JAYLineChart ()
{
    UIScrollView *_myScrollView;
    CGFloat  _xAxisLengh;
}

@end

@implementation JAYLineChart {
    NSHashTable *_chartLabelsForX;
}

-(void)setColors:(NSArray *)colors
{
    _colors = colors;
}

- (void)setMarkRange:(CGRange)markRange
{
    _markRange = markRange;
}

- (void)setGroupMarkRange:(JAYGroupRange)groupMarkRange
{
    _groupMarkRange = groupMarkRange;
}

- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}

- (void)setShowHorizonLine:(NSMutableArray *)ShowHorizonLine
{
    NSLog(@"ShowHorizonLine.count=%lu",(unsigned long)ShowHorizonLine.count);
    _ShowHorizonLine = ShowHorizonLine;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, JAYLabelHeight*2, frame.size.width, frame.size.height-JAYLabelHeight)];
        _myScrollView.contentSize = CGSizeMake(frame.size.width, 0);
        _myScrollView.contentOffset = CGPointMake(0, 0);
        [self addSubview:_myScrollView];
    }
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}

-(void)setYLabels:(NSArray *)yLabels
{
    NSLog(@"yLabels.count=%lu",(unsigned long)yLabels.count);
    NSInteger max = 0;
    NSInteger min = 1000000000;

    for (NSArray * ary in yLabels) {
        for (NSString *valueString in ary) {
            NSInteger value = [valueString integerValue];
            if (value > max) {
                max = value;
            }
            if (value < min) {
                min = value;
            }
        }
    }
    if (max < 5) {
        max = 5;
    }
    if (self.showRange) {
        _yValueMin = min;
    }else{
        _yValueMin = 0;
    }
    _yValueMax = (int)max;
    
    if (_chooseRange.max!=_chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }
   //Y轴设置5个标度
    float level = (_yValueMax-_yValueMin) /(kYLableNumbers);//22除以4
    
    CGFloat chartCavanHeight = _myScrollView.frame.size.height-kBottomXLabelsH;
    CGFloat levelHeight = chartCavanHeight /(kYLableNumbers);
    for (int i=0; i<kYLableNumbers; i++) {
        JAYChartLabel * label = [[JAYChartLabel alloc] initWithFrame:CGRectMake(0.0,2*JAYLabelHeight+i*levelHeight-JAYLabelHeight/2.0, JAYYLabelwidth, JAYLabelHeight)];
		label.text = [NSString stringWithFormat:@"%d",(int)(_yValueMax-i*level)];
        
		[self addSubview:label];
    }
    //描横线
    for (int i=0; i<kYLableNumbers; i++) {
        if ([_ShowHorizonLine[i] integerValue]>0) {
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(JAYYLabelwidth,2*JAYLabelHeight+i*levelHeight-1)];
            [path addLineToPoint:CGPointMake(self.frame.size.width,2*JAYLabelHeight+i*levelHeight-1)];
            [path closePath];
            shapeLayer.path = path.CGPath;
            shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:kStrokeLineAlpha] CGColor];
            shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
            shapeLayer.lineWidth = kStrokeLineWH;
            [self.layer addSublayer:shapeLayer];
        }
    }

#pragma mark -这里设置正常范围需要突出的背景色
    //单组数据
    if (_yValues.count ==1&&[super respondsToSelector:@selector(setMarkRange:)]) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, (1-(_markRange.max-_yValueMin)/(_yValueMax-_yValueMin))*chartCavanHeight,_xAxisLengh, (_markRange.max-_markRange.min)/(_yValueMax-_yValueMin)*chartCavanHeight)];
        view.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
        [_myScrollView addSubview:view];
    }
    if (_yValues.count==2&&[super respondsToSelector:@selector(setGroupMarkRange:)]) {
        //2组数据
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, (1-(_groupMarkRange.range1.max-_yValueMin)/(_yValueMax-_yValueMin))*chartCavanHeight,_xAxisLengh, (_groupMarkRange.range1.max-_groupMarkRange.range1.min)/(_yValueMax-_yValueMin)*chartCavanHeight)];
            
            view.backgroundColor = [_colors[0] colorWithAlphaComponent:0.4];
            [_myScrollView addSubview:view];
            //
            UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, (1-(_groupMarkRange.range2.max-_yValueMin)/(_yValueMax-_yValueMin))*chartCavanHeight,_xAxisLengh, (_groupMarkRange.range2.max-_groupMarkRange.range2.min)/(_yValueMax-_yValueMin)*chartCavanHeight)];
            view2.backgroundColor = [_colors[1] colorWithAlphaComponent:0.4];
            [_myScrollView addSubview:view2];
        //颜色指示图
        [self configTopColorIndicator];
    }
}

- (void)configTopColorIndicator
{
    JAYChartLabel * leftlabel = [[JAYChartLabel alloc] initWithFrame:CGRectMake(kScreenWidth/2.0-2*_xLabelWidth, JAYLabelHeight, _xLabelWidth/2, 1)];
    leftlabel.backgroundColor = [_colors firstObject];
    [self addSubview:leftlabel];
    JAYChartLabel * leftTextlabel = [[JAYChartLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftlabel.frame), CGRectGetMinY(leftlabel.frame)-JAYLabelHeight/2.0, _xLabelWidth, JAYLabelHeight)];
    leftTextlabel.text = @"收缩压";
    leftTextlabel.textAlignment = NSTextAlignmentLeft;
    leftTextlabel.textColor = leftlabel.backgroundColor;
    [self addSubview:leftTextlabel];
    //
    JAYChartLabel * rightLabel = [[JAYChartLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftTextlabel.frame), CGRectGetMinY(leftlabel.frame), _xLabelWidth/2, 1)];
    rightLabel.backgroundColor = [_colors lastObject];
    [self addSubview:rightLabel];
    JAYChartLabel * rightTextLabel = [[JAYChartLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rightLabel.frame), CGRectGetMinY(leftTextlabel.frame), _xLabelWidth, JAYLabelHeight)];
    rightTextLabel.text = @"舒张压";
    rightTextLabel.textAlignment = NSTextAlignmentLeft;
    rightTextLabel.textColor = rightLabel.backgroundColor;
    [self addSubview:rightTextLabel];
}

-(void)setXLabels:(NSArray *)xLabels
{
    if( !_chartLabelsForX ){
        _chartLabelsForX = [NSHashTable weakObjectsHashTable];
    }
    _xLabels = xLabels;
   // NSLog(@"_xLabels=%@",_xLabels);
    CGFloat num = 0;
    if (xLabels.count>=kMaxXLabels) {
        num=kMaxXLabels;
    }else if (xLabels.count<=kMinXLabelS){
        num=kMinXLabelS;
    }else{
        num = xLabels.count;
    }
    _xLabelWidth = (self.frame.size.width - JAYYLabelwidth)/num;
    _xAxisLengh = _xLabelWidth *(xLabels.count+1)+chartMargin;
    //横坐标
    for (int i=0; i<xLabels.count; i++) {
        NSString *labelText = xLabels[i];
        JAYChartLabel * label = [[JAYChartLabel alloc] initWithFrame:CGRectMake(i * _xLabelWidth+JAYYLabelwidth, _myScrollView.frame.size.height-kBottomXLabelsH-JAYLabelHeight/2.0, _xLabelWidth, kBottomXLabelsH)];
        label.numberOfLines = 2;
        label.font = [UIFont systemFontOfSize:9];
        label.text = labelText;
        label.textAlignment = NSTextAlignmentCenter;
        [_myScrollView addSubview:label];
        [_chartLabelsForX addObject:label];
    }
    float max = (([xLabels count])*_xLabelWidth + chartMargin)+_xLabelWidth;
    if (_myScrollView.frame.size.width < max-kMaxXLabels) {
        _myScrollView.contentSize = CGSizeMake(max, _myScrollView.frame.size.height);
    }
    //竖线
    for (int i=1; i<xLabels.count+1; i++) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(i*_xLabelWidth+kDotWH,0)];
        [path addLineToPoint:CGPointMake(i*_xLabelWidth+kDotWH,_myScrollView.frame.size.height-kBottomXLabelsH)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:kStrokeLineAlpha] CGColor];
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = kStrokeLineWH;
        [_myScrollView.layer addSublayer:shapeLayer];
    }
}

#pragma mark -  描点
-(void)strokeChart
{
    for (int i=0; i<_yValues.count; i++) {
        NSArray *childAry = _yValues[i];
       // NSLog(@"-------%@",childAry);
        if (childAry.count==0) {
            return;
        }
        NSInteger max_i =0;
        NSInteger min_i =0;
        //获取最大最小位置
        CGFloat max = [childAry[0] floatValue];
        CGFloat min = [childAry[0] floatValue];
        for (int j=0; j<childAry.count; j++){
            CGFloat num = [childAry[j] floatValue];
            if (max<=num){
                max = num;
                max_i = j;
            }
            if (min>=num){
                min = num;
                min_i = j;
            }
        }
        //划线
        CAShapeLayer *_chartLine = [CAShapeLayer layer];
        _chartLine.lineCap = kCALineCapRound;
        _chartLine.lineJoin = kCALineJoinBevel;
        _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth   = 2.0;
        _chartLine.strokeEnd   = 0.0;
        [_myScrollView.layer addSublayer:_chartLine];
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        CGFloat firstValue = [[childAry objectAtIndex:0] floatValue];
        CGFloat xPosition = (JAYYLabelwidth + _xLabelWidth/2.0);
        CGFloat chartCavanHeight = _myScrollView.frame.size.height - kBottomXLabelsH;
        
        float grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
        //第一个点
        BOOL isShowMaxAndMinPoint = YES;
        if (self.ShowMaxMinArray) {
            if ([self.ShowMaxMinArray[i] intValue]>0) {
                isShowMaxAndMinPoint = (max_i==0 || min_i==0)?NO:YES;
            }else{
                isShowMaxAndMinPoint = YES;
            }
        }
        [self addPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight)
                 index:i
                isShow:self.showTextValue
                 value:firstValue];

        [progressline moveToPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight)];
        [progressline setLineWidth:2.0];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        NSInteger index = 0;
        for (NSString * valueString in childAry)
        {
            float grade =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
            if (index != 0) {
                CGPoint point = CGPointMake(xPosition+index*_xLabelWidth, chartCavanHeight - grade * chartCavanHeight);
                [progressline addLineToPoint:point];
                
                BOOL isShowMaxAndMinPoint = YES;
                
                if (self.ShowMaxMinArray) {
                    if ([self.ShowMaxMinArray[i] intValue]>0) {
                        isShowMaxAndMinPoint = (max_i==index || min_i==index)?NO:YES;
                    }else{
                        isShowMaxAndMinPoint = YES;
                    }
                }
                [progressline moveToPoint:point];
                [self addPoint:point
                         index:i
                        isShow:self.showTextValue
                         value:[valueString floatValue]];
            }
            index += 1;
        }
        _chartLine.path = progressline.CGPath;
        if ([[_colors objectAtIndex:i] CGColor]) {
            _chartLine.strokeColor = [[_colors objectAtIndex:i] CGColor];
        }else{
            _chartLine.strokeColor = [JAYGreen CGColor];
        }
        //添加数据图线绘画效果
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = childAry.count*kStrokeDotDuration;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.autoreverses = NO;
       // [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        _chartLine.strokeEnd = 1.0;
    }
}

- (void)addPoint:(CGPoint)point index:(NSInteger)index isShow:(BOOL)isHollow value:(CGFloat)value
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDotWH, kDotWH)];
    view.center = point;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 4;
    view.layer.borderWidth = 2;
    view.layer.borderColor = [[_colors objectAtIndex:index] CGColor]?[[_colors objectAtIndex:index] CGColor]:JAYGreen.CGColor;
    view.backgroundColor = [UIColor whiteColor];
    [_myScrollView addSubview:view];
    // 数值的显示
    if (isHollow) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x-JAYTagLabelwidth/2.0, point.y-JAYLabelHeight*1.5, JAYTagLabelwidth, JAYLabelHeight)];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor =  [_colors objectAtIndex:index]?[_colors objectAtIndex:index] :JAYGreen;
        label.text = [NSString stringWithFormat:@"%0.2f",(double)value];
        [_myScrollView addSubview:label];
        //异常点的标识
        //        if (value < _markRange.min ||value > _markRange.max) {
        //            view.backgroundColor = [UIColor redColor];
        //            view.layer.borderColor = [UIColor redColor].CGColor;
        //            label.textColor = [UIColor redColor];
        //
        //        }
    }
    
    
}

- (NSArray *)chartLabelsForX
{
    return [_chartLabelsForX allObjects];
}

@end
