#! /usr/bin/perl

use strict;
use 5.010;

sub start_html() {

	my $title = shift;
	my $head_lines = shift;
#	my $head_lines = "\t\t".$head_lines;

	if ($title !~ /\w/){
		$title = "Avi's Website";
	}

print <<EOF
content-type: text/html; charset=utf-8;
content-language: en



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<link rel='stylesheet' type='text/css' href='/styles.css'/>
		<link rel='shortcut icon' type='image/png' href='/favicon.png' />

		$head_lines
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name='author' content='Avi Greenbury' />
		<meta name='description' content='Avis Website' />

		<title>$title</title>
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
	my $back_to_url = shift;
	my $back_to_link = shift;
print <<EOF

		</div>
		<div class='footer'>
			<a href='$back_to_url'>$back_to_link</a>
		</div>
		<div class='footerImages'>
			<a href='http://validator.w3.org/check?uri=referer'><img src='/images/footer/xhtml.png' alt='valid XHTML' /></a>
<!--			<a href='http://jigsaw.w3.org/validator'><img src='/images/footer/css.png' alt='valid CSS' /></a>	-->
			<a href='http://vim.org'><img src='/images/footer/vim.gif' alt='Vim' /></a>
			<a href='http://perl.org'><img src='/images/footer/perl.png' alt='Perl' /></a>
			<a href='http://httpd.apache.org'><img src='/images/footer/apache.png' alt='Apache'/></a>
			<a href='http://debian.org'><img src='/images/footer/debian.png' alt='Debian' /></a>
			<br />
			<p style='text-align:center;'><a href='http://github.com/BigRedS/website/'>View Source</a></p>
		</div>
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
EOF
}
1
