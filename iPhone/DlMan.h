//
//  DlMan.h
//  UnlimVideosiPad
//
//  Created by Enea Gjoka on 5/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import <MediaPlayer/MediaPlayer.h>

@interface DlMan : UITableViewController <ASIHTTPRequestDelegate, UIActionSheetDelegate,UIAlertViewDelegate,UIDocumentInteractionControllerDelegate> {
	
	NSMutableArray *contentArray;
	NSMutableArray *progArray;
	NSString *saveTo;
	int Selected;
	
	//File Manager
	NSMutableArray *allFiles;
	int selectedRow;
	MPMoviePlayerController  *av;
	UITextField *myTextField;
	
	//xml parser
	NSXMLParser * xmlParser;
	NSString * currentElement;
	NSMutableString * currentTitle;
	
}

@property (nonatomic, retain) NSMutableArray *contentArray;
@property (nonatomic, retain) NSMutableArray *progArray;
@property (nonatomic, retain) NSString *saveTo;

@property (nonatomic, retain) NSMutableArray *allFiles;
@property (nonatomic, retain) MPMoviePlayerController  *av;
@property (nonatomic, retain) UITextField *myTextField;

-(void)reloadMyData;

-(void)addDownload:(NSString *)theURL withName:(NSString *)fileName withPid:(NSString *)thePid;
-(void)updateSaveToDL;
- (void)video:(NSString *) videoPath didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo;
@end

@interface MPMoviePlayerControllerInternalHack: NSObject
- (void)setTVOutEnabled:(BOOL)enabled;
- (void)displayVideoViewOnTV;
@end