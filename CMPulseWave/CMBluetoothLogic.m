//
//  CMBluetoothViewController.m
//  CMPulseWave
//
//  Created by nastia on 30.09.14.
//  Copyright (c) 2014 Анастасия. All rights reserved.
//

#import "CMBluetoothLogic.h"
#import "ChartViewController.h"

#define SERVICE_UUID [CBUUID UUIDWithString:@"0000aa30-0000-1000-8000-00805f9b34fb"]
#define CHARACTERISTIC_UUID [CBUUID UUIDWithString:@"0000aa31-0000-1000-8000-00805f9b34fb"]

@interface CMBluetoothLogic () 


@end

@implementation CMBluetoothLogic

-(instancetype)init{
    self = [super init];
    [self centralManager];
    [self heartRatePeripherals];
    return self;
}
-(CBCentralManager *) centralManager{
    if(!_centralManager){
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return _centralManager;
}

-(NSMutableArray *)heartRatePeripherals{
    if (!_heartRatePeripherals) {
        _heartRatePeripherals = [NSMutableArray new];
    }
    return _heartRatePeripherals;
}

#pragma mark - CBCentralManagerDelegate

-(void)centralManagerDidUpdateState: (CBCentralManager *)central{
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    }
    else{
        [self.heartRatePeripherals removeAllObjects];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{

//    if (![self.heartRatePeripherals containsObject:peripheral]) {
        [self.heartRatePeripherals addObject:peripheral];
        [self.centralManager connectPeripheral:peripheral options:nil];
//    }
//    if([peripheral.name isEqual:@"H7 102022"]){
        [self.centralManager stopScan];
//    }
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"didConnectPeriphera");
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
}



#pragma mark - CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
    NSLog(@"didDiscoverServices");
    if(!error){
        for (CBService *service in peripheral.services) {
            if ([service.UUID isEqual:SERVICE_UUID]) {
                [peripheral discoverCharacteristics:@[CHARACTERISTIC_UUID] forService:service];
                return;
            }
        }
    }
    [self.centralManager cancelPeripheralConnection:peripheral];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
    NSLog(@"didDiscoverCharacteristicsForService");
    if (!error) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:CHARACTERISTIC_UUID]) {
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                
                return;
            }
        }
    }
    
    [self.centralManager cancelPeripheralConnection:peripheral];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    NSLog(@"didUpdateValueForCharacteristic");
        
    uint8_t* val = (uint8_t *)[characteristic.value bytes];
    
    [self.delegate updatePointsBuffer:val];
//    [self.delegate drawPoints];
    
    for (int i = 0; i < [characteristic.value length] - 1; i++) {
        NSLog(@"%d", val[i]);
    }

}

@end
