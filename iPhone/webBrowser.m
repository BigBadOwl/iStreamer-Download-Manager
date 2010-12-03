//
//  webBrowser.m
//  DownloadManager
//
//  Created by Enea Gjoka on 9/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "webBrowser.h"
#import "AppDelegate_iPhone.h"

@implementation webBrowser
@synthesize webView, string, bbcpid;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//[NSMutableURLRequest setupUserAgentOverwrite];
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.bbc.co.uk/iplayer"]]];
	webView.scalesPageToFit = TRUE;
	webView.delegate = self;
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType 
{	
	NSURL *url = request.URL;
	NSString *main = url.absoluteString;
	
	NSLog(@"The download URL is: %@", main);
	
	if([main rangeOfString:@"repo://" options:NSCaseInsensitiveSearch].length > 0)
	{
		self.string = url.absoluteString;
		UIActionSheet	*actionSheet = [[UIActionSheet alloc] initWithTitle:@"This Looks Like a Repo Link...\n" 
																 delegate:self 
														cancelButtonTitle:NSLocalizedString(@"Cancel",nil) 
												   destructiveButtonTitle:nil 
														otherButtonTitles:@"Add to Cydia",nil];
		[actionSheet setActionSheetStyle:UIBarStyleBlackTranslucent];
		[actionSheet showInView:self.view];
		[actionSheet release];
		return NO;
		
	}
	
	if(main != nil)
	{
		if(([main rangeOfString:@".html" options:NSCaseInsensitiveSearch].length==0 && [main rangeOfString:@".htm" options:NSCaseInsensitiveSearch].length==0 && [main rangeOfString:@".php" options:NSCaseInsensitiveSearch].length==0) && [main rangeOfString:@"nextgenvidz.com/video/" options:NSCaseInsensitiveSearch].length>0 && [main rangeOfString:@".mp4" options:NSCaseInsensitiveSearch].length>0 )
		{
			self.string = url.absoluteString;
			UIActionSheet	*actionSheet = [[UIActionSheet alloc] initWithTitle:@"Options...\n" 
																	 delegate:self 
															cancelButtonTitle:NSLocalizedString(@"Cancel",nil) 
													   destructiveButtonTitle:nil 
															otherButtonTitles:@"Download",@"Play",@"Play on TV",@"Download w/SDM",nil];
			[actionSheet setActionSheetStyle:UIBarStyleBlackTranslucent];
			[actionSheet showInView:self.view];
			[actionSheet release];
			
			return NO;
		}
		
		//Download ipa,mp3 and mp4 with megaupload
		if([main rangeOfString:@"megaupload.com" options:NSCaseInsensitiveSearch].length>0 && ([main rangeOfString:@".mp4" options:NSCaseInsensitiveSearch].length>0 || [main rangeOfString:@".mp3" options:NSCaseInsensitiveSearch].length>0 || [main rangeOfString:@".ipa" options:NSCaseInsensitiveSearch].length>0 || [main rangeOfString:@"/files/" options:NSCaseInsensitiveSearch].length > 0))
		{
			self.string = url.absoluteString;
			UIActionSheet	*actionSheet = [[UIActionSheet alloc] initWithTitle:@"Options...\n" 
																	 delegate:self 
															cancelButtonTitle:NSLocalizedString(@"Cancel",nil) 
													   destructiveButtonTitle:nil 
															otherButtonTitles:@"Download",@"Download w/SDM",nil];
			[actionSheet setActionSheetStyle:UIBarStyleBlackTranslucent];
			[actionSheet showInView:self.view];
			[actionSheet release];
			return NO;
		}
		
		//Download ipa,mp3 and mp4 with megaupload
		if([main rangeOfString:@"pmsrvr.com" options:NSCaseInsensitiveSearch].length==0 && [main rangeOfString:@"mediafire.com" options:NSCaseInsensitiveSearch].length>0 && ([main rangeOfString:@".mp4" options:NSCaseInsensitiveSearch].length>0 || [main rangeOfString:@".mp3" options:NSCaseInsensitiveSearch].length>0 || [main rangeOfString:@".ipa" options:NSCaseInsensitiveSearch].length>0 || [main rangeOfString:@"/files/" options:NSCaseInsensitiveSearch].length > 0))
		{
			self.string = url.absoluteString;
			UIActionSheet	*actionSheet = [[UIActionSheet alloc] initWithTitle:@"Options...\n" 
																	 delegate:self 
															cancelButtonTitle:NSLocalizedString(@"Cancel",nil) 
													   destructiveButtonTitle:nil 
															otherButtonTitles:@"Download",@"Download w/SDM",nil];
			[actionSheet setActionSheetStyle:UIBarStyleBlackTranslucent];
			[actionSheet showInView:self.view];
			[actionSheet release];
			return NO;
		}
		else if ([main rangeOfString:@"pmsrvr.com" options:NSCaseInsensitiveSearch].length>0)
		{
			return NO;			
		}
		
		
		//Download ipa,mp3 and mp4 with megaupload
		if([main rangeOfString:@".html" options:NSCaseInsensitiveSearch].length==0 &&[main rangeOfString:@"hotfile.com" options:NSCaseInsensitiveSearch].length>0 && ([main rangeOfString:@".mp4" options:NSCaseInsensitiveSearch].length>0 || [main rangeOfString:@".mp3" options:NSCaseInsensitiveSearch].length>0 || [main rangeOfString:@".ipa" options:NSCaseInsensitiveSearch].length>0 || [main rangeOfString:@"/files/" options:NSCaseInsensitiveSearch].length > 0))
		{
			self.string = url.absoluteString;
			UIActionSheet	*actionSheet = [[UIActionSheet alloc] initWithTitle:@"Options...\n" 
																	 delegate:self 
															cancelButtonTitle:NSLocalizedString(@"Cancel",nil) 
													   destructiveButtonTitle:nil 
															otherButtonTitles:@"Download",@"Download w/SDM",nil];
			[actionSheet setActionSheetStyle:UIBarStyleBlackTranslucent];
			[actionSheet showInView:self.view];
			[actionSheet release];
			return NO;
		}
		
		if(([main rangeOfString:@".html" options:NSCaseInsensitiveSearch].length==0 && [main rangeOfString:@".htm" options:NSCaseInsensitiveSearch].length==0 && [main rangeOfString:@".php" options:NSCaseInsensitiveSearch].length==0) && ([main rangeOfString:@".m4v" options:NSCaseInsensitiveSearch].length>0 ||[main rangeOfString:@".mp4" options:NSCaseInsensitiveSearch].length>0 || [main rangeOfString:@".mp3" options:NSCaseInsensitiveSearch].length>0 || [main rangeOfString:@".ipa" options:NSCaseInsensitiveSearch].length>0 || [main rangeOfString:@".pdf" options:NSCaseInsensitiveSearch].length>0))
		{
			self.string = url.absoluteString;
			UIActionSheet	*actionSheet = [[UIActionSheet alloc] initWithTitle:@"Options...\n" 
																	 delegate:self 
															cancelButtonTitle:NSLocalizedString(@"Cancel",nil) 
													   destructiveButtonTitle:nil 
															otherButtonTitles:@"Download",@"Play",@"Play on TV",@"Download w/SDM",nil];
			[actionSheet setActionSheetStyle:UIBarStyleBlackTranslucent];
			[actionSheet showInView:self.view];
			[actionSheet release];
			return NO;
		}
		
	}
	
	return YES;
}

-(void) webViewDidFinishLoad:(UIWebView *)theWebView {
	NSLog(@"Load is finished");
	
	NSString *js=@"document.getElementsByTagName(\"embed\").length;";
	NSString *res=[webView stringByEvaluatingJavaScriptFromString:js];
	
	if(res && res.length>0) {
		int embedCount=[res intValue];
		if(embedCount>0) {
			NSString *pid = [webView stringByEvaluatingJavaScriptFromString:@"$$.mediaplayer.pid;"];
			NSString *movieUrlJs=@"document.getElementsByTagName('embed')[0].getAttribute('href');";
			NSString *moviePath=[webView stringByEvaluatingJavaScriptFromString:movieUrlJs];
			
			
			self.string = moviePath;
			self.bbcpid = pid;
			
			UIActionSheet	*actionSheet = [[UIActionSheet alloc] initWithTitle:@"Options...\n" 
																	 delegate:self 
															cancelButtonTitle:NSLocalizedString(@"Cancel",nil) 
													   destructiveButtonTitle:nil 
															otherButtonTitles:@"Download",@"Download Flash",nil];
			[actionSheet setActionSheetStyle:UIBarStyleBlackTranslucent];
			[actionSheet showInView:self.view];
			[actionSheet release];
			
		}
	}
}

- (void)actionSheet:(UIActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if([sheet buttonTitleAtIndex:buttonIndex] == @"Download")
	{
		AppDelegate_iPhone* delegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
		NSURLResponse *getName = [[NSURLResponse alloc] initWithURL:[NSURL URLWithString:self.string] MIMEType:@"Unknow" expectedContentLength:-1 textEncodingName:nil];
		NSLog(@"The Name is: %@", [getName suggestedFilename]);
		[[delegate myDownloadManager] addDownload:self.string withName:[getName suggestedFilename] withPid:nil ];
		[getName release];
		
		
	}
	if([sheet buttonTitleAtIndex:buttonIndex] == @"Download Flash")
	{
		AppDelegate_iPhone* delegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
		NSURLResponse *getName = [[NSURLResponse alloc] initWithURL:[NSURL URLWithString:self.string] MIMEType:@"Unknow" expectedContentLength:-1 textEncodingName:nil];
		NSLog(@"The Name is: %@", [getName suggestedFilename]);
		[[delegate myDownloadManager] addDownload:self.string withName:[getName suggestedFilename] withPid:self.bbcpid ];
		[getName release];
	}
	else if([sheet buttonTitleAtIndex:buttonIndex] == @"Download w/SDM")
	{
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.string]]; 
	}
	
	
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
