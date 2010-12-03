//
//  AppDelegate_iPhone.h
//  DownloadManager
//
//  Created by Enea Gjoka on 9/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_Shared.h"
#import "webBrowser.h"
#import "DlMan.h"


@interface AppDelegate_iPhone : AppDelegate_Shared <UITabBarControllerDelegate> {
	
	UITabBarController *tabBarController;
	
	webBrowser *myBrowser;
	DlMan *myDownloadManager;
	
}

@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) DlMan *myDownloadManager;

-(NSString *) saveTo;

@end

