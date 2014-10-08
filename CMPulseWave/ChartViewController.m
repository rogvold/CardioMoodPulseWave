//
//  ChartViewController.m
//  CMPulseWave
//
//  Created by nastia on 28.09.14.
//  Copyright (c) 2014 Анастасия. All rights reserved.
//

#import "ChartViewController.h"

@interface ChartViewController()

@property (nonatomic) CPTGraph *graph;
@property (nonatomic) NSMutableArray *yDataForGraph;
@property (nonatomic) NSMutableArray *yPoints;
@property (nonatomic) NSMutableArray *xPoints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *graphWidth;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ChartViewController

-(void) updateData{
    if ([self.xPoints.lastObject floatValue] <= 50) {
    
    [self.yPoints addObject:@([self.yPoints.lastObject floatValue]+0.5)];
    [self.xPoints addObject:@([self.xPoints.lastObject floatValue]+3)];
//    self.graphWidth.constant += self.view.bounds.size.width/4;
    [self.graph reloadData];
        
    } else {
        
        [self.yPoints addObject:@([self.yPoints.lastObject floatValue]-0.5)];
        [self.xPoints addObject:@([self.xPoints.lastObject floatValue]+3)];
        
        [self changePlotRange];
        [self.graph reloadData];

        
        
    }
    
//    [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//        self.scrollView.contentOffset = CGPointMake(self.graphWidth.constant, 0);
//    } completion:nil];

    
}

-(void)changePlotRange
{
    // Setup plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    
    CPTPlotRange *tempXRange = plotSpace.xRange;
    CPTPlotRange *tempYRange = plotSpace.yRange;

    float newLoc = CPTDecimalFloatValue(tempXRange.location) + 3;
    float newYLoc = CPTDecimalFloatValue(tempYRange.location) + 0.5;

    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(newLoc) length:CPTDecimalFromFloat(50)];
    
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(newYLoc) length:CPTDecimalFromFloat(10)];
}


- (void)updateWidth{
    self.graphWidth.constant += self.view.bounds.size.width/4;
//    [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.scrollView.contentOffset = CGPointMake(self.graphWidth.constant, 0);
//    } completion:nil];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initPlot];

    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateData) userInfo:nil repeats:YES];
    
}
-(void)initPlot {
//    [self configureHost];
    [self configureGraph];
    [self configurePlot];
    [self.graph reloadData];
}

- (void)configureHost {
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
    [self.graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    self.hostView.hostedGraph = self.graph;
    
    // 2 - Set graph title
    // 3 - Create and set text style
    // 4 - Set padding for plot area
    // 5 - Enable user interactions for plot space

}

-(void)configurePlot {
    // 1 - Get graph and plot space
    CPTGraph *graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;

    // 2 - Create the plot
    CPTScatterPlot *plot = [[CPTScatterPlot alloc] init];
    plot.dataSource = self;
    CPTColor *color = [CPTColor blueColor];
    [graph addPlot:plot toPlotSpace:plotSpace];
    
    // 3 - Set up plot space
    [plotSpace scaleToFitPlots:[NSArray arrayWithObject:plot]];
//
    
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0) length:CPTDecimalFromDouble(10)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0) length:CPTDecimalFromDouble(50)];
//    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
//    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
//    plotSpace.xRange = xRange;
//
    
//    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
//    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
//    plotSpace.yRange = yRange;
//    plotSpace.globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length: CPTDecimalFromInt(256.0)];
    
    
    // 4 - Create styles and symbols
//    plot.dataLineStyle = nil;
    CPTPlotSymbol *symbol = [CPTPlotSymbol ellipsePlotSymbol];
    symbol.fill = [CPTFill fillWithColor:color];
    symbol.size = CGSizeMake(6.0f, 6.0f);
    plot.plotSymbol = symbol;
}

#pragma mark - Points
-(NSMutableArray *) xPoints{
    if (!_xPoints) {
        _xPoints =  [[NSMutableArray alloc] initWithObjects:@(0), nil];
    }
    return _xPoints;
}

-(NSMutableArray *) yPoints{
    if (!_yPoints) {
        _yPoints =  [[NSMutableArray alloc] initWithObjects:@(0), nil];
    }
    return _yPoints;
}

#pragma mark - CPTPlotDataSource methods
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

@end