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

@end

@implementation ChartViewController

-(void) _updateData{
    [self.yPoints addObject:@([self.yPoints.lastObject floatValue]+0.25)];
    [self.xPoints addObject:@([self.yPoints.lastObject floatValue]+0.25)];
    [self.graph reloadData];
    
}

+(id) sharedInstance{
    ChartViewController *vc = nil;
    
    @synchronized(self){
        if (vc == nil){
            vc = [[self alloc] init];
        }
    }
    
    return vc;
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initPlot];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(_updateData) userInfo:nil repeats:YES];
    
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
//    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    [self.graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    self.hostView.hostedGraph = self.graph;
    
    // 2 - Set graph title
    //
    
    // 3 - Create and set text style
    //
    
    // 4 - Set padding for plot area
    
    // 5 - Enable user interactions for plot space
    //

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
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
    plotSpace.xRange = xRange;
//
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
    plotSpace.yRange = yRange;
    
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
        _xPoints =  [[NSMutableArray alloc] initWithObjects:@(0.5), nil];
    }
    return _xPoints;
}

-(NSMutableArray *) yPoints{
    if (!_yPoints) {
        _yPoints =  [[NSMutableArray alloc] initWithObjects:@(0.5), nil];
    }
    return _yPoints;
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    
    return [self.xPoints count];
}

-(NSNumber *) numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx{
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