//
//  SelectAddressViewController.m
//  Consulta Multa
//
//  Created by Ernesto Carrion on 3/26/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "SelectAddressViewController.h"
#import "FinesViewController.h"

@interface SelectAddressViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    GADBannerView * bannerView;
}

@property (nonatomic, strong) NSArray * addresses;

@end

@implementation SelectAddressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.screenName = @"Address screen";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    addressTableView.tableFooterView = [[UIView alloc] init];
    continueButton.layer.cornerRadius = 10;
    continueButton.enabled = NO;
    
    self.addresses = [self.consultaController getAddresses];
    if (self.addresses.count == 0) {
        
        if ([self.consultaController getToManyAttepmsError]) {
            
            self.title = @"Inténtalo más tarde";
            infoLabel.text = @"Has fallado varias veces consultando esta placa.";
            noFinesView.image = [UIImage imageNamed:@"error.png"];
            noFinesView.contentMode = UIViewContentModeScaleToFill;
            
        } else {
            
            self.title = @"¡Felicitaciones!";
            infoLabel.text = @"¡No tienes fotomultas!";
            noFinesView.image = [UIImage imageNamed:@"success.png"];
            noFinesView.contentMode = UIViewContentModeScaleAspectFill;
        }
        
        noFinesView.hidden = NO;
        infoLabel.hidden = NO;
        continueButton.hidden = YES;
        
    } else {
        
        self.title = @"Elige tu dirección";
    }

    [self createBanner];
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
    
    // Initiate a generic request to load it with an ad.
    [bannerView loadRequest:[GADRequest request]];
}

- (IBAction)goPressed:(id)sender {
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSInteger index = [addressTableView indexPathForSelectedRow].row;
    [self.consultaController selectAddress:index onCompletion:^(NSError *error) {
        [SVProgressHUD dismiss];
        
        if (!error) {
            
            FinesViewController * fvc = [[FinesViewController alloc] init];
            UIViewController * first = self.navigationController.viewControllers.firstObject;
            [self.navigationController setViewControllers:@[first, fvc] animated:YES];
            
        } else {
            
            [self.consultaController handleError:error];
        }
    }];
}


#pragma mark - Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.addresses.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return bannerView.frame.size.height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return bannerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"AddressCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        cell.textLabel.textColor = GREEN_APP_COLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = self.addresses[indexPath.row];
    
    return cell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;

    return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    continueButton.enabled = YES;
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
