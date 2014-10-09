//
//  ChartViewController.h
//  CMPulseWave
//
//  Created by nastia on 28.09.14.
//  Copyright (c) 2014 Анастасия. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "CMBluetoothLogic.h"


@interface ChartViewController : UIViewController <CPTPlotDataSource, CMResponseToDataChange>

@property (nonatomic, weak) IBOutlet CPTGraphHostingView *hostView;

@end

