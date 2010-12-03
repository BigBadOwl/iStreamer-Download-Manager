//
//  PDColoredProgressView.m
//  PDColoredProgressViewDemo
//
//  Created by Pascal Widdershoven on 03-01-09.
//  Copyright 2009 Pascal Widdershoven. All rights reserved.
//  

#import "PDColoredProgressView.h"
#import "drawing.m"
#import "ASIProgressDelegate.h"

@implementation PDColoredProgressView

@synthesize pLab;

- (id) initWithCoder: (NSCoder*)aDecoder {
	if(self=[super initWithCoder: aDecoder]) {
	}
	return self;
}

- (id) initWithProgressViewStyle: (UIProgressViewStyle) style {
	if(self=[super initWithProgressViewStyle: style]) {
	}
	return self;
}

-(void)setProgress:(float)myProgress
{
	float dBytes = myProgress*[fileLength floatValue];
	pLab.text = [NSString stringWithFormat:@"%.2f MB of %.2fMB (%.2f%%)",dBytes,[fileLength floatValue],myProgress*100];
	
	[super setProgress:myProgress];
}

- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength
{
	const unsigned int bytes = 1024 * 1024;
	fileLength = [[NSNumber numberWithFloat:(float)newLength/bytes] retain];
	//NSLog(@"The file length set is %f",[fileLength floatValue]);
}

-(void)setName: (NSString *)fileName
{
	nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -17, 320, 14)];
	nameLabel.backgroundColor = [UIColor clearColor];
	nameLabel.text = [fileName retain];
	nameLabel.font = [UIFont boldSystemFontOfSize:15];
	[self addSubview:nameLabel];
	//NSLog(@"Filename set to %@",nameLabel.text);
	
}

-(void)setPl:(NSString *)pL
{
	pLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 320, 20)];
	pLab.backgroundColor = [UIColor clearColor];
	pLab.font = [UIFont systemFontOfSize:13];
	pLab.textColor = [UIColor grayColor];
	pLab.text = [pL retain];
	[self addSubview:pLab];
}

- (void)dealloc {
    [super dealloc];
}


@end