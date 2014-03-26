//
//  ConsultaNavigationViewController.m
//  Consulta Multa
//
//  Created by Ernesto Carrion on 3/26/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "ConsultaNavigationViewController.h"

#define FOTOMULTAS_BASE_URL @"http://www.medellin.gov.co/qxi_tramites/consultas/consultarComparendoElectronico.jsp"

@interface ConsultaNavigationViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView * webView;
@property (nonatomic, copy) webCompletionBlock completionlBlock;

@end

@implementation ConsultaNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
        self.navigationBar.translucent = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.webView.delegate = self;
    self.webView.userInteractionEnabled = NO;
    self.webView.alpha = 0.4;
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    
}

-(void)reloadBaseUrlOnCompletion:(webCompletionBlock)block {
    
    self.completionlBlock = block;
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:FOTOMULTAS_BASE_URL]];
    [self.webView loadRequest:request];
}

#pragma mark - Foto multa methods

-(void)selectSearchCriteria:(NSInteger)number  onCompletion:(webCompletionBlock)block {
    
    self.completionlBlock = block;
    
    NSString * line1 = @"select = document.getElementsByName(\"criterioBusqueda\")[0];";
    NSString * line2 = [NSString stringWithFormat:@"select.options[%d].selected = true;", number];
    NSString * line3 = @"document.ConsultarComparendoElectronicoForm.submit();";
    NSString * js = [NSString stringWithFormat:@"%@ %@ %@", line1, line2, line3];
    
    [self.webView stringByEvaluatingJavaScriptFromString:js];
}

-(void)setPlate:(NSString *)plate onCompletion:(webCompletionBlock)block {
    
    self.completionlBlock = block;
    
    NSString * line1 = @"placa = document.getElementsByName(\"placa\")[0];";
    NSString * line2 = [NSString stringWithFormat:@"placa.value = \"%@\";", plate];
    NSString * line3 = @"consultarBut = document.getElementsByClassName(\"button\")[0];";
    NSString * line4 =  @"consultarBut.click();";
    NSString * js = [NSString stringWithFormat:@"%@ %@ %@ %@", line1, line2, line3, line4];
    
    [self.webView stringByEvaluatingJavaScriptFromString:js];
}

-(void)selectAddress:(NSInteger)addresIndex onCompletion:(webCompletionBlock)block {
    
    self.completionlBlock = block;
    
    NSString * line1 = @"radios = document.getElementsByName(\"direccionSeleccionada\");";
    NSString * line2 = [NSString stringWithFormat:@"radios[%d].checked = true;", addresIndex];
    NSString * line3 = @"consultarBut = document.getElementsByClassName(\"button\")[0];";
    NSString * line4 =  @"consultarBut.click();";
    NSString * js = [NSString stringWithFormat:@"%@ %@ %@ %@", line1, line2, line3, line4];
    
    [self.webView stringByEvaluatingJavaScriptFromString:js];
}

-(void)openPDFAtIndex:(NSInteger)index onCompletion:(webCompletionBlock)block {
    
    self.completionlBlock = block;
    
    NSString * line1 = [NSString stringWithFormat:@"pdfLink = document.getElementById(\"resultados2\").getElementsByTagName(\"a\")[%d];", index];
    NSString * line2 = @"pdfLink.click();";
    NSString * js = [NSString stringWithFormat:@"%@ %@", line1, line2];
    
    [self.webView stringByEvaluatingJavaScriptFromString:js];
}

-(NSArray *)getAddresses {
    
    NSString * js1 =
    @"address1 = [];"
    @"tds1 = document.querySelectorAll(\"td.franjaGris\");"
    @"for (var i = 0; i < tds1.length; i++) { "
    @"  if (tds1[i].innerText.length > 0) { "
    @"      address1.push(tds1[i].innerText);"
    @"  }"
    @"}"
    @"address1.toString();";
    
    NSString * js2 =
    @"address2 = [];"
    @"tds2 = document.querySelectorAll(\"td.franjaBlanco\");"
    @"tds2 = tds2[0].getElementsByClassName(\"franjaBlanco\");"
    @"for (var i = 0; i < tds2.length; i++) { "
    @"  if (tds2[i].innerText.length > 0) { "
    @"      address2.push(tds2[i].innerText);"
    @"  }"
    @"}"
    @"address2.toString();";
    
    NSString * result1 = [self.webView stringByEvaluatingJavaScriptFromString:js1];
    NSString * result2 = [self.webView stringByEvaluatingJavaScriptFromString:js2];
    
    NSArray * array1 = [result1 componentsSeparatedByString:@","];
    NSArray * array2 = [result2 componentsSeparatedByString:@","];
    
    if (array1.count >= 3 && array2.count >= 2)
        return @[array1[0], array2[0], array1[1], array2[1], array1[2]];
    
    return nil;
}

#pragma mark - WebView

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    puts(request.URL.absoluteString.UTF8String);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    puts("finish");
    if (self.completionlBlock) {
        webCompletionBlock block = [self.completionlBlock copy];
        self.completionlBlock = nil;
        block(nil);
        block = nil;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    puts("fail");
    if (self.completionlBlock) {
        webCompletionBlock block = [self.completionlBlock copy];
        self.completionlBlock = nil;
        block(error);
        block = nil;
    }
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