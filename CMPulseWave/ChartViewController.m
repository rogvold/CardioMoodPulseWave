//
//  ChartViewController.m
//  CMPulseWave
//
//  Created by nastia on 28.09.14.
//  Copyright (c) 2014 Анастасия. All rights reserved.
//

#import "ChartViewController.h"

@interface ChartViewController()


@end

@implementation ChartViewController

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initPlot];
}
-(void)initPlot {
//    [self configureHost];
    [self configureGraph];
    [self configurePlot];
}

-(void)configureHost {
//    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:self.viewWithConstraints.bounds];
//    [self.viewWithConstraints addSubview:self.hostView];
}

-(void)configureGraph {
    // 1 - Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    self.hostView.hostedGraph = graph;
    
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
    plot.dataLineStyle = nil;
    CPTPlotSymbol *symbol = [CPTPlotSymbol ellipsePlotSymbol];
    symbol.fill = [CPTFill fillWithColor:color];
    symbol.size = CGSizeMake(6.0f, 6.0f);
    plot.plotSymbol = symbol;
}

#pragma mark - Points
-(NSArray *) xPoints{
    return @[@1, @2, @3, @5, @6, @5, @7, @8, @9];
}

-(NSArray *) yPoints{
    return @[@2, @4, @3, @9, @6, @3, @7, @5, @7];
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