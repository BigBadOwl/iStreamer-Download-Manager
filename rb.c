#import <UIKit/UIKit.h>
#import "ruby.h"
#import "rb.h"

extern void Init_socket();
extern void Init_zlib();

static char **sc_argv;
static int    sc_argc;

void RubySetup() {	
	NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
	NSString *rubyLib = [NSString stringWithFormat:@"%@/lib", resourcePath];
	NSString *rubyVendor = [NSString stringWithFormat:@"%@/vendor", resourcePath];
	NSString *entryPoint = [NSString stringWithFormat:@"%@/main.rb", rubyVendor];
	
	sc_argc = 2;
	sc_argv = (char **)malloc(sizeof(char *) * (sc_argc));
	sc_argv[0] = "Download Manager Ruby";
	sc_argv[1] = (char *)[entryPoint UTF8String];
	
	{
	RUBY_INIT_STACK;
	ruby_init();
	ruby_options(sc_argc, sc_argv);
	}
	
	VALUE load_path = rb_gv_get(":");
	rb_funcall(load_path, rb_intern("push"), 1, rb_str_new2([resourcePath UTF8String]));
	rb_funcall(load_path, rb_intern("push"), 1, rb_str_new2([rubyLib UTF8String]));
	rb_funcall(load_path, rb_intern("push"), 1, rb_str_new2([rubyVendor UTF8String]));
	
	Init_zlib();
	Init_socket();
}



void RubyDownload(){
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex: 0];
	NSString *loc = [NSString stringWithFormat:@"-d %@ -f b00wfl8t.mov b00wfl8t", documentsDirectory];
	
	NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
	NSString *rubyVendor = [NSString stringWithFormat:@"%@/vendor", resourcePath];
	NSString *entryPoint = [NSString stringWithFormat:@"%@/iplayer-dl.rb", rubyVendor];
	
	ruby_script((char *)[entryPoint UTF8String]);
	
	static char **argv;
	static int    argc;
	argc = 1;
	argv = (char **)malloc(sizeof(char *) * (argc));
	
	 argv[0] = (char *)[loc UTF8String];
	/*argv[0] = "-d";
	argv[1] = (char *)[documentsDirectory UTF8String];
	argv[2] = "-f";
	argv[3] = "b00wfl8t.mov";
	argv[4] = "b00wfl8t";*/
	
	ruby_options(argc, argv);
	rb_load_file((char *)[entryPoint UTF8String]);
	ruby_run();
	
	printf ("after load_file errinfo=");
	rb_p (ruby_errinfo);
}

void RubyStop() {
	ruby_stop(0);
	free(sc_argv);
}
