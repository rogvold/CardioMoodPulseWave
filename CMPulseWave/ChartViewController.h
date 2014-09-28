//
//  ChartViewController.h
//  CMPulseWave
//
//  Created by nastia on 28.09.14.
//  Copyright (c) 2014 Анастасия. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface ChartViewController : UIViewController <CPTPlotDataSource>

@property (nonatomic, strong) IBOutlet CPTGraphHostingView *hostView;

@end

