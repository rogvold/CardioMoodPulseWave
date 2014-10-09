//
//  CMBluetoothViewController.h
//  CMPulseWave
//
//  Created by nastia on 30.09.14.
//  Copyright (c) 2014 Анастасия. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>


@protocol CMResponseToDataChange <NSObject>

-(void)updatePointsBuffer:(uint8_t *)points;
//-(void)drawPoints;

@end

@interface CMBluetoothLogic : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) NSString *connected;
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) NSMutableArray *heartRatePeripherals;
@property (nonatomic) id<CMResponseToDataChange> delegate;

@end
