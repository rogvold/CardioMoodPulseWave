//
//  ChartViewController.m
//  CMPulseWave
//
//  Created by nastia on 28.09.14.
//  Copyright (c) 2014 Анастасия. All rights reserved.
//

#import "ChartViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ChartViewController()

@property (nonatomic) CPTGraph *graph;
@property (nonatomic) NSMutableArray *yPoints;
@property (nonatomic) NSMutableArray *xPoints;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *graphWidth;
@property (nonatomic) NSMutableArray *bufferWithPoints;
@property (nonatomic) CMBluetoothLogic *bluetooth;

@property (nonatomic) int x;

@property (nonatomic) CPTMutableLineStyle *styleForLine;

@end

@implementation ChartViewController


-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initPlot];
    
    self.bluetooth = [[CMBluetoothLogic alloc]init];
    self.bluetooth.delegate = self;
    
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(draw) userInfo:nil repeats:YES];

//        [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(newYPoints) userInfo:nil repeats:YES];
    
}

-(int)x{
    if(!_x){
        _x = 800;
    }
    return _x;
}

-(void) updateDataWithPoints:(NSArray *)points{
    for (int i = 0; i < [points count]; i++) {
        
        [self.xPoints addObject:@([self.xPoints.lastObject floatValue]+1)];
        [self.yPoints addObject:points[i]];
    
        if ([self.xPoints.lastObject integerValue] > self.x) {
            [self changePlotRange];
        }
        [self.graph reloadData];

    }
//    [self.graph reloadData];

    
}

-(NSMutableArray *)newYPoints{
    
    NSMutableArray *tra = [[NSMutableArray alloc]initWithCapacity:20];
    
    for (int i = 0; i<20; i++) {
        int a = arc4random_uniform(10);
        [tra addObject:@(a)];
//        [self.xPoints addObject:@(x+i)];
//        [self.yPoints addObject:@(a)];
    }
    [self updateDataWithPoints:tra];
    
    return tra;
}

#pragma mark - Plot methods
-(void)initPlot {
//    [self configureHost];
    [self configureGraph];
    [self configurePlot];
    [self.graph reloadData];
}

- (void)configureHost {
//    self.hostView.alpha = 0.5;
    
//    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:self.viewWithConstraints.bounds];
//    [self.viewWithConstraints addSubview:self.hostView];
}

-(CPTGraph *) graph{
    if(!_graph){
        _graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
        
    }
    return _graph;
}

-(void)configureGraph {
    // 1 - Create the graph
//    [self.graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    CPTColor *s = [CPTColor colorWithComponentRed:117.0f/255.0f green:79.0f/255.0f blue:129.0f/255.0f alpha:1];
    CPTColor *e = [CPTColor colorWithComponentRed:56.0f/255.0f green:93.0f/255.0f blue:98.0f/255.0f alpha:1];
    
    CPTGradient *gradient = [CPTGradient gradientWithBeginningColor:s endingColor:e];
    gradient.angle = 270.0f;
    self.graph.fill = [[CPTFill alloc]initWithGradient:gradient];
    
    self.hostView.hostedGraph = self.graph;
    
    // 2 - Set graph title
    // 3 - Create and set text style
    
    // 4 - Set padding for plot area
    self.graph.paddingBottom = 0;
    self.graph.paddingLeft = 0;
    self.graph.paddingRight =0;
    self.graph.paddingTop = 0;
    self.graph.axisSet = nil;
    
    // 5 - Enable user interactions for plot space
    [self.graph.defaultPlotSpace setAllowsUserInteraction:NO];
    
//    self.selectedTheme = [CPTTheme themeNamed:kCPTSlateTheme];
//    [self.graph applyTheme:self.selectedTheme];

}

-(void)configurePlot {
    // 1 - Get graph and plot space
    CPTGraph *graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    
    // 2 - Create the plot
    CPTScatterPlot *plot = [[CPTScatterPlot alloc] init];
    plot.dataSource = self;
    [graph addPlot:plot toPlotSpace:plotSpace];
    
    [plotSpace scaleToFitPlots:[NSArray arrayWithObject:plot]];

    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0) length:CPTDecimalFromDouble(255)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0) length:CPTDecimalFromDouble(self.x)];
    
    
    // 4 - Create styles and symbols
    
    CPTColor *color = [CPTColor blackColor];
    
    CPTMutableLineStyle *style = [CPTMutableLineStyle lineStyle];
    style.lineColor = color;
    style.lineWidth = 1.0f;
    
    [plot setDataLineStyle: style];
//    plot.dataLineStyle = nil;
    

    CPTPlotSymbol *symbol = [CPTPlotSymbol ellipsePlotSymbol];
    symbol.fill = [CPTFill fillWithColor:color];
    symbol.size = CGSizeMake(1.0f, 1.0f);
    symbol.lineStyle = nil;
    plot.plotSymbol = symbol;
    

    
//


}

-(void)changePlotRange
{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    
    CPTPlotRange *tempXRange = plotSpace.xRange;

        float newXLoc = CPTDecimalFloatValue(tempXRange.location) + 1;
//    float newXLoc = CPTDecimalFloatValue(tempXRange.location) + 20;
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(newXLoc) length:CPTDecimalFromFloat(self.x)];
    

}

-(void) configureAxis{
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)[self.graph axisSet];
    
    CPTXYAxis *xAxis = [axisSet xAxis];
    CPTXYAxis *yAxis = [axisSet yAxis];
    
    [xAxis setMinorTickLineStyle:nil];
    [xAxis setAxisLineStyle:nil];
    
}

#pragma mark - Points
-(NSMutableArray *) xPoints{
    if (!_xPoints) {
        _xPoints =  [[NSMutableArray alloc] initWithObjects:nil];
    }
    return _xPoints;
}

-(NSMutableArray *) yPoints{
    if (!_yPoints) {
        _yPoints =  [[NSMutableArray alloc] initWithObjects:@(0), nil];
    }
    return _yPoints;
}

-(NSMutableArray *)bufferWithPoints{
    if(!_bufferWithPoints){
        _bufferWithPoints = [[NSMutableArray alloc] initWithObjects:nil];
    }
    return _bufferWithPoints;
}

#pragma mark - CPTPlotDataSource protocol methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [self.xPoints count];
}

-(NSNumber *) numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx{
    
//    [self.graph.defaultPlotSpace scaleToFitPlots:@[plot]];
    
    NSInteger counter = [self.xPoints count];
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            if (idx < counter){
                return self.xPoints[idx];
            }
            break;
            
        case CPTScatterPlotFieldY:
            if (idx < counter){
                return self.yPoints[idx];
            }
            break;
    }

    return [NSDecimalNumber zero];
}

#pragma mark - CMResponseToDataChange protocol functions

//-(void)updatePointsBuffer:(uint8_t *)points{
//    
//    //draws 20 dots at once
//    for (int i = 0 ; i < 20; i++) {
//        [self.yPoints addObject:@(points[i])];
//        [self.xPoints addObject:@([self.xPoints.lastObject integerValue] +1)];
//    }
//    if ([self.xPoints.lastObject integerValue] >=self.x){
//        [self changePlotRange];
//    }
//    [self.graph reloadData];
//}

-(void)updatePointsBuffer:(uint8_t *)points{

    //draws one dot at once
    for (int i = 0 ; i < 20; i++) {
        [self.bufferWithPoints addObject:@(points[i])];
    }
}

-(void)draw{
    if (self.bufferWithPoints.count !=0) {
        
        long y = [self.bufferWithPoints.firstObject integerValue];
        [self.bufferWithPoints removeObjectAtIndex:0];
        
        [self.yPoints addObject:@(y)];
        [self.xPoints addObject:@([self.xPoints.lastObject integerValue] +1)];
        
        if ([self.xPoints.lastObject integerValue] >=self.x){
            [self changePlotRange];
//            [self updateWidth];
            
        }
        [self.graph reloadData];
    }
}

@end