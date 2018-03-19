//
//  LinkingCustomViewController.m
//  WhiteLabelDemoApp
//
//  Created by ani on 7/12/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import "LinkingCustomViewController.h"

@interface LinkingCustomViewController ()
{
    BOOL deviceNameOverride;
}
@end

@implementation LinkingCustomViewController

@synthesize tfLinkingCode, tfDeviceName, switchDeviceName, btnLink, switchDeviceNameOverride;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title =  @"Linking View";
    
    [switchDeviceName addTarget:self
                          action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
    [switchDeviceNameOverride addTarget:self
                         action:@selector(stateChangedOverride:) forControlEvents:UIControlEventValueChanged];
    [btnLink setTitleColor:[UIColor colorWithRed:(61.0/255.0) green:(160.0/255.0) blue:(183.0/255.0) alpha:1.0] forState:UIControlStateNormal];
    
    deviceNameOverride = true;
}

#pragma mark - UISwitchDelegateMethods
- (void)stateChanged:(UISwitch *)switchState
{
    if ([switchState isOn])
    {
        tfDeviceName.enabled = true;
    }
    else
    {
        tfDeviceName.enabled = false;
        [tfDeviceName resignFirstResponder];
    }
}

- (void)stateChangedOverride:(UISwitch *)switchState
{
    if ([switchState isOn])
    {
        deviceNameOverride = true;
    }
    else
    {
        deviceNameOverride = false;
    }
}

#pragma mark - Button Methods
- (IBAction)btnLinkPressed:(id)sender
{
    NSString *qrCode = tfLinkingCode.text;
    
    if([qrCode length] == 7)
    {
        if ([switchDeviceName isOn])
        {
            NSString *deviceName = tfDeviceName.text;
                        
            if([deviceName length] < 3)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Device name should be at least 3 characters"]
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                
                [alert show];
            }
            else if([deviceName length] == 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Please enter a device name"]
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                
                [alert show];
            }
            else
            {
                [[AuthenticatorManager sharedClient] linkUser:qrCode withDeviceName:deviceName deviceNameOverride:deviceNameOverride withCompletion:^(NSError *error)
                 {
                     if(error != nil)
                     {
                         NSLog(@"Linking Error: %@", error);
                         
                         if(error.code == 5)
                         {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Device Already Exists"]
                                                                             message:[NSString stringWithFormat:@"The device name you chose is already assigned to another device associated with your account.  Please choose an alternative name or unlink the conflicting device, and then try again."]
                                                                            delegate:self
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                             
                             [alert show];
                         }
                    
                     }
                     else
                     {
                         [self.navigationController popViewControllerAnimated:NO];
                     }
                 }];
            }
        }
        else
        {            
            [[AuthenticatorManager sharedClient] linkUser:qrCode withDeviceName:nil deviceNameOverride:deviceNameOverride withCompletion:^(NSError *error)
            {
                if(error != nil)
                {
                    NSLog(@"Linking Error: %@", error);
                }
                else
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
            }];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"QR Code should be 7 characters"]
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
}


@end