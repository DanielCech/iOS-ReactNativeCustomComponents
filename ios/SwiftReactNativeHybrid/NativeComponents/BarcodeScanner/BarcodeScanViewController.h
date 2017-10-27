//
//  BarcodeScanViewController.h
//  Scanner App
//
//  Created by iRare Media on 12/4/13.
//  Copyright (c) 2013 iRare Media. All rights reserved.
//

@import UIKit;
#import "RMScannerView.h"
#import <React/RCTBridgeModule.h>

@interface BarcodeScanViewController : UIViewController <RMScannerViewDelegate, UIBarPositioningDelegate>

@property (strong, nonatomic) IBOutlet RMScannerView *scannerView;
@property (weak, nonatomic) IBOutlet UILabel *statusText;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sessionToggleButton;

@property (strong, nonatomic) RCTResponseSenderBlock barcodeScannerCallback;

- (void)startNewScannerSession;

@end
