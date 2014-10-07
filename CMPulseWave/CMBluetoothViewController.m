//
//  CMBluetoothViewController.m
//  CMPulseWave
//
//  Created by nastia on 30.09.14.
//  Copyright (c) 2014 Анастасия. All rights reserved.
//

#import "CMBluetoothViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

#define HEART_RATE_SERVICE_UUID [CBUUID UUIDWithString:@"180D"]
#define DEVICE_SERVICE_UUID_AA00 [CBUUID UUIDWithString:@"AA00"]
#define DEVICE_SERVICE_UUID_AA10 [CBUUID UUIDWithString:@"AA10"]
#define DEVICE_SERVICE_UUID_AA20 [CBUUID UUIDWithString:@"AA20"]
#define DEVICE_SERVICE_UUID_FFE0 [CBUUID UUIDWithString:@"FFE0"]
#define SERVICE_UUID [CBUUID UUIDWithString:@"0000aa30-0000-1000-8000-00805f9b34fb"]
#define CHARACTERISTIC_UUID [CBUUID UUIDWithString:@"0000aa31-0000-1000-8000-00805f9b34fb"]
#define HEART_RATE_CHAR_UUID [CBUUID UUIDWithString:@"2A37"]

@interface CMBluetoothViewController () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) NSMutableArray *heartRatePeripherals;

@end

@implementation CMBluetoothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", HEART_RATE_SERVICE_UUID);
    
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _heartRatePeripherals = [NSMutableArray new];

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
    
    for (int i = 0; i < [characteristic.value length] - 1; i++) {
        NSLog(@"%d", val[i]);
    }

}

@end
