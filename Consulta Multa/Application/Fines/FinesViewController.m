//
//  FinesViewController.m
//  Consulta Multa
//
//  Created by Ernesto Carrion on 3/26/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "FinesViewController.h" 
#import "Fine.h"
#import "FineCell.h"

@interface FinesViewController () <UITableViewDataSource, UITableViewDelegate, FineCellDelegate> {
    
    GADBannerView * bannerView;
}

@property (nonatomic, strong) NSArray * fines;

@end

@implementation FinesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.screenName = @"Fines screen";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.finesTableView registerNib:[UINib nibWithNibName:@"FineCell" bundle:nil] forCellReuseIdentifier:@"FineCell"];
    self.finesTableView.tableFooterView = [[UIView alloc] init];
    
    self.fines = [self.consultaController getFines];
    if (self.fines.count == 0) {
        
        infoLabel.hidden = NO;
        imageView.hidden = NO;
        
        self.title = @"Lo sentimos";
        
    } else {
        
        self.title = @"Multas";
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.fines.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return bannerView.frame.size.height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return bannerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FineCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FineCell"];
    Fine * fine = self.fines[indexPath.row];
    
    cell.dateLabel.text = fine.dateString;
    cell.addressLabel.text = fine.address;
    cell.descriptionLabel.text = fine.description;
    [cell.descriptionLabel sizeToFit];
    cell.delegate = self;
    
    return cell;
}

-(void)viewButtonPressedInCell:(FineCell *)fineCell {
    
    NSInteger index = [self.finesTableView indexPathForCell:fineCell].row;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [self.consultaController openPDFAtIndex:index onCompletion:^(NSError *error) {
        
        if (!error) {
            
            [SVProgressHUD dismiss];
            [self.consultaController showWebView];
            
        } else {
            
            [SVProgressHUD dismiss];
            [self.consultaController handleError:error];
        }
    }];
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
