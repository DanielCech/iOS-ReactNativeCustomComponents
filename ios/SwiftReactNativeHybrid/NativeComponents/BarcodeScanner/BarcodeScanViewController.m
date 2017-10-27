//
//  BarcodeScanViewController.m
//  Scanner App
//
//  Created by iRare Media on 12/4/13.
//  Copyright (c) 2013 iRare Media. All rights reserved.
//

#import "BarcodeScanViewController.h"
#import "SwiftReactNativeHybrid-Swift.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@interface BarcodeScanViewController ()

@property (nonatomic, strong) UIView* fakeNavbar;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIButton* closeButton;
@property (nonatomic, strong) FocusOverlayView* focusOverlay;

@end

@implementation BarcodeScanViewController
@synthesize scannerView, statusText;

- (void)viewDidLoad {
  
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Set verbose logging to YES so we can see exactly what's going on
    self.scannerView.delegate = self;
    
    [scannerView setVerboseLogging:YES];
    
    // Set animations to YES for some nice effects
    [scannerView setAnimateScanner:NO];
    
    // Set code outline to YES for a box around the scanned code
    [scannerView setDisplayCodeOutline:YES];
    
    // Start the capture session when the view loads - this will also start a scan session
    [scannerView checkAndStartCaptureSession];
    
    [self initFakeNavbar];
    [self initFocusOverlay];
    
    // Set the title of the toggle button
    self.sessionToggleButton.title = @"Stop";
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startNewScannerSession {
    if ([scannerView isScanSessionInProgress]) {
        [scannerView stopScanSession];
        self.sessionToggleButton.title = @"Start";
    } else {
        [scannerView startScanSession];
        self.sessionToggleButton.title = @"Stop";
    }
}

- (void)didScanCode:(NSString *)scannedCode onCodeType:(NSString *)codeType {
    
    NSLog(@"Code: %@, CodeType: %@", scannedCode, codeType);
    if (![codeType isEqualToString:@"org.iso.PDF417"]) {
        return;
    }
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

    if (self.barcodeScannerCallback != nil) {
        self.barcodeScannerCallback(@[[NSNull null], scannedCode]);
    }
    
    self.barcodeScannerCallback = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)errorGeneratingCaptureSession:(NSError *)error {
    [scannerView stopCaptureSession];

    NSLog(@"Unsupported Device");
    self.barcodeScannerCallback(@[@{@"error": @"unsupported device"}, [NSNull null]]);
    self.barcodeScannerCallback = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)errorAcquiringDeviceHardwareLock:(NSError *)error {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Focus Unavailable"
                                                                  message:@"Tap to focus is currently unavailable. Try again in a little while."
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {}];
    
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)shouldEndSessionAfterFirstSuccessfulScan {
    return NO;
}

- (void)cameraAccessDenied {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Unable to access camera"
                                                                  message:@"Please check permissions in Settings"
                                                           preferredStyle:UIAlertControllerStyleAlert];
    __weak BarcodeScanViewController *weakSelf = self;
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                                {
                                    weakSelf.barcodeScannerCallback(@[@{@"error": @"camera access denied"}, [NSNull null]]);
                                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                }];
    
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}
- (IBAction)stopScannning:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initFakeNavbar {
    self.fakeNavbar = [[UIView alloc] initWithFrame:CGRectZero];
    self.fakeNavbar.translatesAutoresizingMaskIntoConstraints = NO;
    self.fakeNavbar.backgroundColor = [UIColor blackColor];
    [self.view addSubview: self.fakeNavbar];
    
    [self.fakeNavbar.leftAnchor constraintEqualToAnchor: self.view.leftAnchor constant: [[UIScreen mainScreen] bounds].size.width - 44].active = YES;
    [self.fakeNavbar.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.fakeNavbar.widthAnchor constraintEqualToConstant: 44].active = YES;
    [self.fakeNavbar.heightAnchor constraintEqualToConstant: [[UIScreen mainScreen] bounds].size.height].active = YES;

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.text = @"SCAN BARCODE";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.transform = CGAffineTransformMakeRotation( ( 90 * M_PI ) / 180 );
    self.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:18];
    [self.view addSubview: self.titleLabel];
    
    [self.titleLabel.centerXAnchor constraintEqualToAnchor:self.fakeNavbar.centerXAnchor].active = YES;
    [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.fakeNavbar.centerYAnchor].active = YES;
    
    self.closeButton = [[UIButton alloc] initWithFrame: CGRectZero];
    self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.closeButton.transform = CGAffineTransformMakeRotation( ( 90 * M_PI ) / 180 );
    self.closeButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:18];
    [self.closeButton setTitle:@"Close" forState: UIControlStateNormal];
    [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeBarcodeScanner) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.closeButton];

    [self.closeButton.centerXAnchor constraintEqualToAnchor:self.fakeNavbar.centerXAnchor].active = YES;
    //[self.closeButton.topAnchor constraintEqualToAnchor:self.fakeNavbar.topAnchor].active = YES;
    [self.closeButton.topAnchor constraintEqualToAnchor:self.fakeNavbar.topAnchor constant:16].active = YES;
    //[self.closeButton.leftAnchor constraintEqualToAnchor:self.fakeNavbar.leftAnchor constant:16].active = YES;
    //[self.closeButton.widthAnchor constraintEqualToConstant:120].active = YES;
    [self.closeButton.heightAnchor constraintEqualToConstant:120];
        
    self.fakeNavbar.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
}

- (void)initFocusOverlay {
    self.focusOverlay = [[FocusOverlayView alloc] initWithFrame: CGRectZero];
    self.focusOverlay.translatesAutoresizingMaskIntoConstraints = NO;
    self.focusOverlay.userInteractionEnabled = NO;
    [self.view addSubview: self.focusOverlay];
    
    [[self.focusOverlay leftAnchor] constraintEqualToAnchor:[self.view leftAnchor] constant:20].active = YES;
    [[self.focusOverlay rightAnchor] constraintEqualToAnchor:[self.view rightAnchor] constant:-64].active = YES;
    [[self.focusOverlay topAnchor] constraintEqualToAnchor:[self.view topAnchor] constant:20].active = YES;
    [[self.focusOverlay bottomAnchor] constraintEqualToAnchor:[self.view bottomAnchor] constant:-20].active = YES;
}

- (void)closeBarcodeScanner {
    __weak BarcodeScanViewController *weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        weakSelf.barcodeScannerCallback(@[[NSNull null], [NSNull null]]);
    }];
}

@end
