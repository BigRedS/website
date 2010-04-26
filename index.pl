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
		if ($content =~ m/^[A-Za-z]/){
			&make_tr($date, $link, $content);
		}
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
		when(/picasa/){
			$url = "/images/picasa.ico";
			$alt = "Picasa";
			$link = "http://picasa.com";
		}
		when(/last\.fm/){
			$url = "/images/last.fm.ico";
			$alt = "Last.fm";
			$link = "http://last.fm";
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
		when ($interval < 6048000){
			return "ages ago";
		}
	return "before the dawn of time";
	}

}
