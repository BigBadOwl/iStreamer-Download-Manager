//
//  DlMan.m
//  UnlimVideosiPad
//
//  Created by Enea Gjoka on 5/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DlMan.h"
#import "iplayerFetch.h"
#import "AppDelegate_iPhone.h"
#import "ASIHTTPRequest.h"
#import "PDColoredProgressView.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
#import <QuickLook/QuickLook.h>
#endif

@implementation DlMan

@synthesize contentArray, progArray, saveTo, allFiles,av, myTextField;

/*
 - (id)initWithFrame:(CGRect)frame {
 if ((self = [super initWithFrame:frame])) {
 // Initialization code
 }
 return self;
 }
 */

- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		
		self.navigationItem.rightBarButtonItem = self.editButtonItem;
		contentArray = [[NSMutableArray alloc] init];
		progArray = [[NSMutableArray alloc] init];
		self.view.backgroundColor = [UIColor clearColor];
		self.tabBarItem.image = [UIImage imageNamed:@"40-inbox.png"];
		self.tabBarItem.title = @"Transfers";
		//saveTo = [[NSUserDefaults standardUserDefaults] stringForKey:@"save_to"];
		
		AppDelegate_iPhone* delegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
		if([delegate saveTo] != nil)
		{
			saveTo = [delegate saveTo];
		}
		
		if(saveTo == nil)
		{
			//saveTo = @"/var/mobile/Library/Downloads/";
			// Determine the path to the folder where we will store the video file(s).
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex: 0];
			saveTo = [[documentsDirectory stringByAppendingPathComponent:@"downloads"] retain];
		}
		
		
		allFiles = [[NSMutableArray alloc] init];
		NSDirectoryEnumerator *dirEnum = [ [ NSFileManager defaultManager ] enumeratorAtPath:saveTo];
		NSString *file;
		while ((file = [ dirEnum nextObject ])) 
		{
			if(file != nil)
			{
				if([file rangeOfString:@".mp4" options: NSCaseInsensitiveSearch].length > 0 || [file rangeOfString:@".mov" options: NSCaseInsensitiveSearch].length > 0 || [file rangeOfString:@".m4v" options: NSCaseInsensitiveSearch].length > 0 || [file rangeOfString:@".pdf" options: NSCaseInsensitiveSearch].length > 0 )
					
				{
					[ allFiles addObject: file];
				}
			}
		}
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Downloads";
	// self.clearsSelectionOnViewWillAppear = NO;
	
}

//RootViewController.m
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if(section == 0)
		return @"Transfers";
	else
		return saveTo;
}

-(void)updateSaveToDL
{
	AppDelegate_iPhone* delegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
	if([delegate saveTo] != nil)
	{
		saveTo = [delegate saveTo];
	}
}

-(void)reloadMyData
{
	allFiles = [[NSMutableArray alloc] init];
	AppDelegate_iPhone* delegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
	if([delegate saveTo] != nil)
	{
		saveTo = [delegate saveTo];
	}
	
	NSDirectoryEnumerator *dirEnum = [ [ NSFileManager defaultManager ] enumeratorAtPath:saveTo];
	NSString *file;
	while ((file = [ dirEnum nextObject ])) 
	{
		if(file != nil)
		{
			//if([file rangeOfString:@".mp4" options: NSCaseInsensitiveSearch].length > 0 || [file rangeOfString:@".mov" options: NSCaseInsensitiveSearch].length > 0 || [file rangeOfString:@".mp3" options: NSCaseInsensitiveSearch].length > 0 )
			if([file rangeOfString:@".mp4" options: NSCaseInsensitiveSearch].length > 0 || [file rangeOfString:@".mov" options: NSCaseInsensitiveSearch].length > 0 || [file rangeOfString:@".m4v" options: NSCaseInsensitiveSearch].length > 0 || [file rangeOfString:@".pdf" options: NSCaseInsensitiveSearch].length > 0)
			{
				[ allFiles addObject: file];
			}
		}
	}
	
	
}

-(void)done
{
	/*AppDelegate_iPhone* delegate = [[UIApplication sharedApplication] delegate];
	 DetailViewController *temp = [delegate detailViewController];
	 [temp showPopover:nil];*/
}

-(void)addDownload:(NSString *)theURL withName:(NSString *)fileName withPid:(NSString *)thePid
{
	//AppDelegate_iPhone* delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
	
	//Update the Badge
	/*int num = [[[[ [[delegate tabBarController] myTabBar] items] objectAtIndex:2] badgeValue] intValue];
	 num = num +1;
	 UITabBarItem *temp = [[[[delegate tabBarController] myTabBar] items] objectAtIndex:2];
	 */
	
	BOOL isDir;
	NSFileManager *downloadsdir = [[NSFileManager alloc] init];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex: 0];
	NSString *tmpPath = [[documentsDirectory stringByAppendingPathComponent:@"tmp"] retain];
	
	if([downloadsdir fileExistsAtPath:tmpPath isDirectory:&isDir] && isDir)
	{
		NSLog(@"The Temp Dir Exists");
	}
	else{
		[downloadsdir createDirectoryAtPath:tmpPath attributes:nil];
	}
	
	//NSLog(saveTo);
	
	if([downloadsdir fileExistsAtPath:saveTo isDirectory:&isDir] && isDir)
	{
		NSLog(@"The Download Dir Exists");
	}
	else{
		[downloadsdir createDirectoryAtPath:saveTo attributes:nil];
	}
	
	
	[downloadsdir release];
	PDColoredProgressView *theProgress = [[PDColoredProgressView alloc] initWithFrame:CGRectMake(3, 17, 314, 14)];
	[theProgress setName:fileName];
	[theProgress setPl:@"Download Starting"];
	
	NSString *tmpExt;
	if([theURL rangeOfString:@"nextgenvidz.com" options:NSCaseInsensitiveSearch].length > 0)
	{
		tmpExt = @"_NGV";
	}
	else if([theURL rangeOfString:@"megaupload.com" options:NSCaseInsensitiveSearch].length > 0)
	{
		
		tmpExt = @"_Mega";
	}
	else if ([theURL rangeOfString:@"theogspot.com" options:NSCaseInsensitiveSearch].length > 0)
	{
		tmpExt = @"_theOG";
	}
	else {
		tmpExt = @"_etc";
	}
	
	
	if (thePid == nil) {
		NSLog(@"Downloading is: \"%@\"", theURL);
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:theURL]];
		//[request setTemporaryFileDownloadPath:[@"/tmp/" stringByAppendingString:[fileName stringByAppendingString:tmpExt]]];
		[request setTemporaryFileDownloadPath:[tmpPath stringByAppendingString:[@"/" stringByAppendingString:fileName]]];
		[tmpExt release];

		if(([theURL rangeOfString:@"download.iplayer.bbc.co.uk" options:NSCaseInsensitiveSearch].length > 0) || ([theURL rangeOfString:@"securegate.iplayer.bbc.co.uk" options:NSCaseInsensitiveSearch].length > 0)){
			[request addRequestHeader:@"User-Agent" value:@"Apple iPhone v1.1.4 CoreMedia v1.0.0.4A102"];
			[request addRequestHeader:@"Accept" value:@"*/*"];
			[request addRequestHeader:@"Connection" value:@"close"];
			[request addRequestHeader:@"Range" value:@"bytes=0-"];
			[request addRequestHeader:@"Host" value:@"download.iplayer.bbc.co.uk"];
		}

		[request setDownloadDestinationPath:[saveTo stringByAppendingString:[@"/" stringByAppendingString:fileName]]];
		[request setDelegate:self];
		[request setDownloadProgressDelegate:theProgress];
		request.allowResumeForFileDownloads = YES;
		[request startAsynchronous];
		[contentArray addObject:request];
		[progArray addObject:theProgress];
		[theProgress retain];
	}
	else{
		iplayerFetch * ipFetch = [iplayerFetch alloc];
		[ipFetch setDownloadProgressDelegate:theProgress];
		//[ipFetch release];
		[contentArray addObject:ipFetch];
		[progArray addObject:theProgress];
		[theProgress retain];
		
		[ipFetch beginDownload:thePid withDocumentsFolder:saveTo andTempFolder:tmpPath];
		
	}
	
	[self.tableView reloadData];
	
	self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[contentArray count]];
	
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	[self reloadMyData];
	[self.tableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	//NSError *error = [request error];
	//NSLog([error localizedDescription]);
	NSLog(@"The download finished");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self reloadMyData];
}

/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 return YES;
 }*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(section == 0)
	{
		return [progArray count];
	}
	else {
		return [allFiles count];
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellIdentifier_%i_%i",indexPath.section,indexPath.row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	cell = nil;
	if(indexPath.section == 0)
	{
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		[cell addSubview:[progArray objectAtIndex:indexPath.row]];
    }
	else {
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		cell.textLabel.text = [allFiles objectAtIndex:indexPath.row];
	}
	
	return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(indexPath.section == 0)
	{
		
		if (editingStyle == UITableViewCellEditingStyleDelete) 
		{
			Selected = indexPath.row;
			//Remove The Temporary File
			NSFileManager *fileManager = [NSFileManager defaultManager];
			if([fileManager fileExistsAtPath:[(ASIHTTPRequest *)[contentArray objectAtIndex:indexPath.row] temporaryFileDownloadPath]])
			{
				
				UIActionSheet	*actionSheet = [[UIActionSheet alloc] initWithTitle:@"What do You Want to Do?...\n" 
																		 delegate:self 
																cancelButtonTitle:@"Save to Resume" 
														   destructiveButtonTitle:nil 
																otherButtonTitles:@"Delete It",nil];
				[actionSheet setActionSheetStyle:UIBarStyleBlackTranslucent];
				[actionSheet showInView:self.view];
				[actionSheet release];
				
			}
			else {
				[[contentArray objectAtIndex:Selected] cancel];
				[contentArray removeObjectAtIndex:Selected];
				
				int num = [[self.tabBarItem badgeValue] intValue];
				num = num - 1;
				if(num == 0)
				{
					self.tabBarItem.badgeValue = nil;
				}
				else {
					self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",num];	
				}
				
				[self.tableView reloadData];
				
			}
			[fileManager release];
			[progArray removeObjectAtIndex:Selected];
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
			[self.tableView reloadData];
		}
	}
	else {
		if (editingStyle == UITableViewCellEditingStyleDelete) {
			// Delete the row from the data source
			NSFileManager *fileManager = [NSFileManager defaultManager];
			[fileManager removeItemAtPath:[[saveTo stringByAppendingString:@"/"] stringByAppendingString:[allFiles objectAtIndex:indexPath.row]] error:nil];
			[allFiles removeObjectAtIndex:indexPath.row];
			[fileManager release];
			
		}
		
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		[tableView reloadData];
	}
	
	
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	selectedRow = indexPath.row;
	if(indexPath.section == 1)
	{
		if([[allFiles objectAtIndex:(int)selectedRow] rangeOfString:@".pdf" options:NSCaseInsensitiveSearch].length > 0 || [[allFiles objectAtIndex:(int)selectedRow] rangeOfString:@".epub" options: NSCaseInsensitiveSearch].length > 0)
		{
			UIActionSheet *playSheet = [[UIActionSheet alloc] initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Play on iPhone",nil];
			[playSheet setActionSheetStyle:UIBarStyleBlackTranslucent];
			[playSheet showInView:self.view];
			[playSheet release];
		}
		else {
			UIActionSheet *playSheet = [[UIActionSheet alloc] initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Play on iPhone",@"Play on TV",@"Save to Photo Library",@"Rename",nil];
			[playSheet setActionSheetStyle:UIBarStyleBlackTranslucent];
			[playSheet showInView:self.view];
			[playSheet release];
		}
	}
	
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
	return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
	return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
	return self.view.frame;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ([actionSheet buttonTitleAtIndex:buttonIndex]== @"Play on iPhone")
	{
		if ([[UIApplication sharedApplication] respondsToSelector:@selector(beginBackgroundTaskWithExpirationHandler:)])
		{
		
		if([[allFiles objectAtIndex:(int)selectedRow] rangeOfString:@".pdf" options:NSCaseInsensitiveSearch].length > 0 || [[allFiles objectAtIndex:(int)selectedRow] rangeOfString:@".epub" options: NSCaseInsensitiveSearch].length > 0)
		{
			NSString *myString = [NSString stringWithFormat:@"%@",[allFiles objectAtIndex:(int)selectedRow]];
			UIDocumentInteractionController* docController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:[saveTo stringByAppendingString:myString]]];
			docController.delegate = self;
			[docController presentPreviewAnimated:YES];
			[docController retain];
		}
		else {
		
		AppDelegate_iPhone* delegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
		
		NSString *myString = [NSString stringWithFormat:@"%@",[allFiles objectAtIndex:(int)selectedRow]];
		
		NSLog(@"playing is: \"%@\"", [saveTo stringByAppendingString:[@"/" stringByAppendingString:myString]]);
		
		MPMoviePlayerViewController *theMovieView = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:[saveTo stringByAppendingString:[@"/" stringByAppendingString:myString]]]];
		[[theMovieView moviePlayer] setAllowsWirelessPlayback:YES];
		[theMovieView moviePlayer].movieSourceType = MPMovieSourceTypeFile;
		[theMovieView shouldAutorotateToInterfaceOrientation:YES];
		theMovieView.moviePlayer.useApplicationAudioSession = NO;
		[theMovieView moviePlayer].shouldAutoplay = TRUE;
		[[theMovieView moviePlayer].view setBackgroundColor:[UIColor blackColor]];
		[[theMovieView moviePlayer].backgroundView setBackgroundColor:[UIColor blackColor]];
		[[NSNotificationCenter defaultCenter] addObserver:[delegate tabBarController] selector:@selector(moviePlayBackDidFinish:) name:@"MPMoviePlayerPlaybackDidFinishNotification" object:theMovieView];			
		//[[theMovieView moviePlayer] play];
		//[[delegate tabBarController] playedMovie:TRUE];
		[[delegate myDownloadManager] presentMoviePlayerViewControllerAnimated:theMovieView ];
		}
		}
		else {
			
			av = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:[[saveTo stringByAppendingString:@"/"] stringByAppendingString:[allFiles objectAtIndex:selectedRow]]]];	
			//[av setOrientation:UIDeviceOrientationLandscapeLeft animated:NO];
			[av play];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:@"MPMoviePlayerPlaybackDidFinishNotification" object:av];			
			id y = [av valueForKeyPath:@"_internal._videoViewController"];
			[y setTVOutEnabled:NO];
		}

		
	}
	
	if ([actionSheet buttonTitleAtIndex:buttonIndex]== @"Play on TV")
	{
		if ([[UIApplication sharedApplication] respondsToSelector:@selector(beginBackgroundTaskWithExpirationHandler:)])
		{
		AppDelegate_iPhone* delegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
		
		NSString *myString = [NSString stringWithFormat:@"%@",[allFiles objectAtIndex:(int)selectedRow]];
		
		MPMoviePlayerViewController *theMovieView = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:[[saveTo stringByAppendingString:@"/"] stringByAppendingString:myString]]];
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
			[[theMovieView view] setBounds:CGRectMake(0, 0, 1024, 768)];
			[[theMovieView view] setCenter:CGPointMake(384, 512)];
			[[theMovieView view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)]; 
			[[theMovieView view] setFrame:CGRectMake(0, 0, 1024, 768)];
		}
		else{
			[[theMovieView view] setBounds:CGRectMake(0, 0, 480, 320)];
			[[theMovieView view] setCenter:CGPointMake(160, 240)];
			[[theMovieView view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)]; 
			[[theMovieView view] setFrame:CGRectMake(0, 0, 480, 320)];
		}
		
		[theMovieView moviePlayer].movieSourceType = MPMovieSourceTypeFile;
		[theMovieView shouldAutorotateToInterfaceOrientation:YES];
		theMovieView.moviePlayer.useApplicationAudioSession = NO;
		[theMovieView moviePlayer].shouldAutoplay = TRUE;
		[[theMovieView moviePlayer].view setBackgroundColor:[UIColor blackColor]];
		[[theMovieView moviePlayer].backgroundView setBackgroundColor:[UIColor blackColor]];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:@"MPMoviePlayerPlaybackDidFinishNotification" object:[theMovieView moviePlayer]];			
		//[[theMovieView moviePlayer] play];
		//[[delegate tabBarController] playedMovie:TRUE];
		[[delegate tabBarController] presentMoviePlayerViewControllerAnimated:theMovieView ];

		id y = [[theMovieView moviePlayer] valueForKeyPath:@"_internal._implementation._videoViewController"];
		//NSLog(@"Y is now a %@",y);
		[y setTVOutEnabled:YES];
		[y displayVideoViewOnTV];
		}
		else {
			av = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:[[saveTo stringByAppendingString:@"/"] stringByAppendingString:[allFiles objectAtIndex:selectedRow]]]];	
			//[av setOrientation:UIDeviceOrientationLandscapeLeft animated:NO];
			[av play];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:@"MPMoviePlayerPlaybackDidFinishNotification" object:av];			
			id y = [av valueForKeyPath:@"_internal._videoViewController"];
			[y setTVOutEnabled:YES];
			[y displayVideoViewOnTV];
		}

	}
	
	if ([actionSheet buttonTitleAtIndex:buttonIndex]== @"Rename")
	{
		UIAlertView *alert1 = [ [ UIAlertView alloc ] initWithTitle: @"Rename"
															message:@"Please Enter The New File Name\n Without an Extension\n\n"
														   delegate: self
												  cancelButtonTitle: @"Cancel"
												  otherButtonTitles: @"Save",nil];
		self.myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 93.0, 260.0, 25.0)];
		[self.myTextField setBackgroundColor:[UIColor whiteColor]];
		[alert1 addSubview:self.myTextField];	
		CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, 100.0);
		[alert1 setTransform:myTransform];
		[self.myTextField becomeFirstResponder];
		[alert1 show];
		[alert1 release];
	}
	
	if([actionSheet buttonTitleAtIndex:buttonIndex] == @"Delete It")
	{
		NSFileManager *fileManager = [NSFileManager defaultManager];
		[fileManager removeItemAtPath:[(ASIHTTPRequest *)[contentArray objectAtIndex:Selected] temporaryFileDownloadPath] error:nil];
		[fileManager release];
		
		[[contentArray objectAtIndex:Selected] cancel];
		[contentArray removeObjectAtIndex:Selected];
		
		
		int num = [[self.tabBarItem badgeValue] intValue];
		num = num - 1;
		if(num == 0)
		{
			self.tabBarItem.badgeValue = nil;
		}
		else {
			self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",num];	
		}
		[self.tableView reloadData];
	} 
	else if([actionSheet buttonTitleAtIndex:buttonIndex] == @"Save to Resume"){
		[[contentArray objectAtIndex:Selected] cancel];
		[contentArray removeObjectAtIndex:Selected];
		
		int num = [[self.tabBarItem badgeValue] intValue];
		num = num - 1;
		if(num == 0)
		{
			self.tabBarItem.badgeValue = nil;
		}
		else {
			self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",num];	
		}
		
		[self.tableView reloadData];
	}
	else if ([actionSheet buttonTitleAtIndex:buttonIndex] == @"Save to Photo Library")
	{
		NSString *tempPath = [NSString stringWithFormat:@"%@",[allFiles objectAtIndex:selectedRow]];
		tempPath = [[saveTo stringByAppendingString:@"/"] stringByAppendingString:tempPath];
		
		//NSLog(@"The video path to transfer is: %@",tempPath);
		
		UISaveVideoAtPathToSavedPhotosAlbum(tempPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
	}
	
}

- (void)video:(NSString *) videoPath didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
	NSLog(@"Finished saving video with error: %@", error);
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if(buttonIndex == actionSheet.cancelButtonIndex)
	{
		return;
	}
	
	if([actionSheet buttonTitleAtIndex:buttonIndex] == @"Save")
	{			
		NSString *textValue= self.myTextField.text;
        if(textValue==nil){
			return;
        } 
		else 
		{
			NSFileManager *fileManager = [[NSFileManager alloc] init];
			[fileManager moveItemAtPath:[[saveTo stringByAppendingString:@"/"] stringByAppendingString:[allFiles objectAtIndex:selectedRow]] toPath:[[saveTo stringByAppendingString:@"/"] stringByAppendingString:[textValue stringByAppendingString:@".mp4"]] error:nil];
			[allFiles replaceObjectAtIndex:selectedRow withObject:textValue];
			[fileManager setAttributes:[NSDictionary dictionaryWithObject:[NSNumber numberWithLong:0755] forKey:NSFilePosixPermissions] ofItemAtPath:[[saveTo stringByAppendingString:@"/"] stringByAppendingString:[textValue stringByAppendingString:@".mp4"]] error:nil];
			[self reloadMyData];
			[self.tableView reloadData];
		}
    } 
	
	
}


-(void)moviePlayBackDidFinish:(NSNotification *) notification
{
	if ([[UIApplication sharedApplication] respondsToSelector:@selector(beginBackgroundTaskWithExpirationHandler:)])
	{
	//NSLog(@"Playback Finished Called");
	MPMoviePlayerController *player = notification.object;
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"MPMoviePlayerPlaybackDidFinishNotification" object:player];
	id y = [player valueForKeyPath:@"_internal._implementation._videoViewController"];
	[player stop];
	//NSLog(@"Y is now a %@",y);
	[y setTVOutEnabled:NO];
	[player autorelease];
	}
	else {
		MPMoviePlayerController *player = notification.object;
		[[NSNotificationCenter defaultCenter] removeObserver:self name:@"MPMoviePlayerPlaybackDidFinishNotification" object:player];
		id y = [player valueForKeyPath:@"_internal._videoViewController"];
		[player stop];
		[y setTVOutEnabled:NO];
		[player autorelease];
	}

}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

/*
 - (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
 
 // When a row is selected, set the detail view controller's detail item to the item associated with the selected row.
 
 //    detailViewController.detailItem = [NSString stringWithFormat:@"%@", [linksArray objectAtIndex:indexPath.row]];
 }
 */

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[contentArray release];
	[progArray release];
	[saveTo release];
	[xmlParser release];
    [super dealloc];
}


@end
