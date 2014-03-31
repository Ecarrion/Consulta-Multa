//
//  ChooseViewController.m
//  Consulta Multa
//
//  Created by Ernesto Carrion on 3/26/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "ChooseViewController.h"
#import "SelectAddressViewController.h"

@interface ChooseViewController () <UITextFieldDelegate> {
    
    GADBannerView * bannerView;
}

@end

@implementation ChooseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.screenName = @"Search Criteria screen";
        self.title = @"Ingresa tu placa";
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Atras" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([plateTextField respondsToSelector:@selector(setTintColor:)]) {
        plateTextField.tintColor = GREEN_APP_COLOR;
        
        
    } else {
        
        typeSegmented.tintColor = GREEN_APP_COLOR;
        userIDSegmented.tintColor = GREEN_APP_COLOR;
    }
    
    [self createBanner];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [plateTextField becomeFirstResponder];
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
    [self.consultaController reloadBaseUrlOnCompletion:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
    
}

-(void)createBanner {
    
    [bannerView removeFromSuperview];
    bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    bannerView.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CGRect frame = bannerView.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height;
    bannerView.frame = frame;
    
    // Specify the ad unit ID.
    bannerView.adUnitID = SEARCH_BANNER_UNIT_ID;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView.rootViewController = self;
    plateTextField.inputAccessoryView = bannerView;
    
    // Initiate a generic request to load it with an ad.
    [bannerView loadRequest:[GADRequest request]];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    __block BOOL loading = YES;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    SearchCriteriaType type = typeSegmented.selectedSegmentIndex + 1;
    [self.consultaController selectSearchCriteria:type onCompletion:^(NSError *error) {
       
        if (!error) {
            
            if (type == kPlate) {
                
                [self.consultaController setPlate:textField.text onCompletion:^(NSError *error) {
                    [SVProgressHUD dismiss];
                    loading = NO;
                    
                    if (!error) {
                        
                        SelectAddressViewController * savc = [[SelectAddressViewController alloc] init];
                        [self.navigationController pushViewController:savc animated:YES];
                        
                    } else {
                        
                        [self.consultaController handleError:error];
                    }
                }];
            }
            
            else if (type == kUser) {
                
                IdType idType = userIDSegmented.selectedSegmentIndex + 1;
                [self.consultaController setID:textField.text forIdType:idType onCompletion:^(NSError *error) {
                    
                    [SVProgressHUD dismiss];
                    loading = NO;
                    
                    if (!error) {
                        
                        SelectAddressViewController * savc = [[SelectAddressViewController alloc] init];
                        [self.navigationController pushViewController:savc animated:YES];
                        
                    } else {
                        
                        [self.consultaController handleError:error];
                    }
                    
                }];
            }
            
        } else {
            
            [self.consultaController handleError:error];
            loading = NO;
        }
        
    }];
    
    //Little hack for dismissing the HUD if app is stucked
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (loading) {
            
            [SVProgressHUD popActivity];
            loading = NO;
        }
    });
    
    return [textField resignFirstResponder];
}

#pragma mark - Segmented Controls

- (IBAction)typeChanged:(id)sender {
    
    switch (typeSegmented.selectedSegmentIndex) {
            
        case 0: {
            
            [UIView animateWithDuration:0.3 animations:^{
               
                userIDSegmented.alpha = 0;
                valueHolder.frame = CGRectOffset(valueHolder.frame, 0, -40);
                label.text = @"Placa";
                plateTextField.keyboardType = UIKeyboardTypeAlphabet;
                [plateTextField reloadInputViews];
            }];
            
            break;
        }
            
        case 1: {
            
            [UIView animateWithDuration:0.3 animations:^{
                
                userIDSegmented.alpha = 1;
                valueHolder.frame = CGRectOffset(valueHolder.frame, 0, 40);
                label.text = @"Número";
                plateTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                [plateTextField reloadInputViews];
            }];
            
            break;
        }
            
            
        default:
            break;
    }
}


- (IBAction)documentChanged:(id)sender {
}


#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && self.view.window == nil) {
        
        self.view = nil;
    }
    
    if (![self isViewLoaded]) {
        
        //Clean outlets here
    }
    
    //Clean rest of resources here eg:arrays, maps, dictionaries, etc
}

@end
