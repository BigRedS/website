#! /usr/bin/perl

use strict;
use 5.010;

push (@INC, "/home/avi/www");

require fun;

my $data = "./data";

open(DATA, "<$data")
 or print "Error opening data file";

&start_html();

&mainpage_header();

{
	local $/ = "";
	while (<DATA>){
		my ($date, $link, $content) = (split(/\n/, $_))[0,1,2];
		&make_tr($date, $link, $content);
	}
}
&mainpage_footer();
&end_html();

close DATA;

# # # 

sub make_tr(){
	my $date = shift;
	my $link = shift;
	my $content = shift;

	$date = &friendly_date($date);

	if (length($content) > 1){

		print "\t\t\t\t<tr><td class='icon'>";
		print get_icon($link);
		say "</td><td class='text'><a href='$link'>$content</a></td><td class='date'>$date</td></tr>";
	}
}

sub get_icon{
	my ($url, $alt, $link);
	given (@_[0]){
		when(/slashdot/){
			$url = "/images/slashdot.ico";
			$alt = "Slashdot";
			$link = "http://www.slashdot.org";
		}
		when(/theregister/){
			$url = "/images/theregister.ico";
			$alt = "The Register";
			$link = "http://theregister.co.uk";
		}
		when(/identi/){
			$url = "/images/identi.ico";
			$alt = "Identi.ca";
			$link = "http://identi.ca";
		}
		when(/github/){
			$url = "/images/github.ico";
			$alt = "GitHub";
			$link = "http://github.com";
		}
	}
	return "<a href='$link'><img src='$url' alt='$alt' style='border:none;' /></a>";
}


sub friendly_date() {
	my $date = shift;
	my $time;

	my $interval = time() - $date;

	given($interval){
		when ($interval < 600){
			int $interval;
			return "$interval seconds ago";
		}
		when ($interval < 3600){
			$time = int $interval/60;
			return "$time minutes ago";
		}
		when ($interval < 86400){
			$time = int $interval/60;
			return "$time minutes ago";
		}
		when ($interval < 604800){
			$time =int $interval/3600;
			return "$time hours ago";
		}
	}
	return "ages ago";

}


#sub start_html() {
#
#print <<EOF
#<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
#"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
#
#<html xmlns="http://www.w3.org/1999/xhtml">
#	<head>
#<!--		<link rel='stylesheet' type='text/css' href='./styles.css'/>-->
#		<link rel='stylesheet' type='text/css' href='http://localhost/styles.css'/>
#		<title>Avi</title>
#	</head>
#	<body>
#		<div id='top'>
#			<div class='avi' id='left'>
#				Avi :)
#			</div>
#			<div class='links' id='right'>
#					<a href='./doc/'> doc</a> 
#					<a href='./blog/'>blog</a> 
#					<a href='./about/'>about</a> 
#					<a href='./contact/'>contact</a>
#			</div>
#		</div>	
#			<div class='intro'>
#				There are several hundred thousand terabytes of data on The Internet. Here are my latest contributions to it:
#			</div>
#		</div>
#		<div id='middle'>
#			<table class='main'>
#
#EOF
#}
#
#sub end_html() {
#print <<EOF
#			</table>
#		</div>
#		<div class='footer'>
#			<a href='http://github.com/BigRedS/play/tree/master/website/'>Source</a>
#		</div>
#	</body>
#</html>
#EOF
#}

