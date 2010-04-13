#! /usr/bin/perl

use strict;

sub start_html() {

	my $title = shift;
	my $head_lines = shift;
#	my $head_lines = "\t\t".$head_lines;

print <<EOF
content-type: text/html; charset=utf-8;
content-language: en



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<link rel='stylesheet' type='text/css' href='/styles.css'/>
		$head_lines
		
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>Avi $title</title>
	</head>
	<body>
		<div id='top'>
			<div class='avi' id='left'>
				Avi :)
			</div>
			<div class='links' id='right'>
					<a href='/'>home</a> 
					<a href='/doc/'> doc</a> 
<!--					<a href='/about/'>about</a> 	-->
					<a href='/contact/'>contact</a>
					<a href='/find/'>find</a>
					<a href='/blog/'>blog</a> 
			</div>
		</div>
EOF
}

sub end_html() {
print <<EOF
	</body>
</html>
EOF
}

sub header(){
print <<EOF
	<div class='content'>
EOF
}


sub footer(){
print <<EOF
	</div>
EOF
}

sub mainpage_header(){

print <<EOF
		<div>
			<div class='intro'>
				There are several hundred thousand terabytes of data on The Internet. Here are my latest contributions to it:
			</div>
		</div>
		<div id='middle'>
			<table class='main'>
EOF
}

sub mainpage_footer(){
print <<EOF

			</table>
			<div class='footer'>
				<a href='http://github.com/BigRedS/play/tree/master/website/'>Source</a>
			</div>
EOF
}
1
