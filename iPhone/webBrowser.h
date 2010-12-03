//
//  webBrowser.h
//  DownloadManager
//
//  Created by Enea Gjoka on 9/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface webBrowser : UIViewController <UIWebViewDelegate, UIActionSheetDelegate> {

	IBOutlet UIWebView *webView;
	NSString *string;
	NSString *bbcpid;
	NSTimer * timer;
	
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *string;
@property (nonatomic, retain) NSString *bbcpid;

@end
