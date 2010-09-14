#! /usr/bin/perl

use strict;
use 5.010;

use XML::RAI;
use XML::RSSLite;
use XML::FeedPP;
use LWP::Simple;
use DateTime;
use DateTime::Format::Atom;


my $file = "/home/avi/www/data";

#my %stuff = (&slashdot(), &picasa(),  &atom(), &blog());
my %stuff = &atom();


open (FILE , ">$file") || die ("Error opening $file");
binmode FILE, ":utf8";
for my $key (reverse sort (%stuff)){
	if ($stuff{$key}){			# This shouldn't be necessary.
		my $date = $key;
		my $arrayref = %stuff->{$key};
		my $url = ${$arrayref}[0];
		my $content = ${$arrayref}[1];

		$url =~ s/&{1}(amp;){0}/&amp;/g;
		my $content = substr($content, 0, 250);

		$content =~ s/&/&amp;/g;
		$content =~ s/</&lt;/g;
		$content =~ s/>/&gt;/g;


		print FILE "$date\n$url\n","$content\n\n";
	}
}
close FILE;

sub atom(){

	my @urls = (
		"http://identi.ca/api/statuses/user_timeline/99267.atom", 
		"http://forums.theregister.co.uk/feed/user/40790", 

	#	"http://github.com/BigRedS.atom",
		"http://github.com/BigRedS/play/commits/master.atom",
		"http://github.com/BigRedS/Work/commits/master.atom",
		"http://github.com/BigRedS/work-web/commits/master.atom",
		"http://github.com/BigRedS/dotfiles/commits/master.atom",
		"http://github.com/BigRedS/java/commits/master.atom",
		"http://github.com/BigRedS/website/commits/master.atom",
		"http://en.wikipedia.org/w/index.php?title=Special:Contributions/Lordandmaker&feed=atom&limit=50&target=Lordandmaker&year=&month="
#		"http://api.flickr.com/services/feeds/photos_public.gne?id=12396343\@N06&lang=en-us&format=atom"
	);
	my %return;

	foreach my $url (@urls){
		if (my $feed = XML::FeedPP->new( $url )){

			foreach my $item ( $feed->get_item() ) {
				my $d = DateTime::Format::Atom->new();
				my $dt = $d->parse_datetime( $item->pubDate );
				my $time = $dt->epoch;
				$return{ $time } = [$item->link, $item->title()];
#				$return{ $time } = [$item->link, $item->description()];

			}
		}
	}
	return %return;
}

#sub slashdot(){
#	my %return = &rss("http://slashdot.org/firehose.pl?op=rss&content_type=rss&view=userhomepage&fhfilter=%22home%3Alordandmaker%22&orderdir=DESC&orderby=createtime&color=black&duration=-1&startdate=&user_view_uid=960504&logtoken=960504%3A%3AqQuPZQpQoZTAkoJGfmbG6g", "content");
#	return %return;
#}

#sub picasa(){
#	my %drop_box = &rss("http://picasaweb.google.com/data/feed/base/user/ialoneambest/albumid/5369778250591696225?alt=rss&kind=photo&hl=en_GB", "title");
#	my %albums = &rss("http://picasaweb.google.com/data/feed/base/user/ialoneambest?alt=rss&kind=album&hl=en_GB", "title");
#	my %return = (%drop_box, %albums);
#	return %return;
#}
#sub lastfm(){
#	my %return = &rss("http://ws.audioscrobbler.com/1.0/user/lordandmaker/recenttracks.rss", "title");
#	return %return;
#}

#sub blog(){
#	my %return = &rss("http://aviswebsite.co.uk/blog/feed/", "content");
#	return %return;
#}

sub rss(){
	my %return;
	my $url = shift; 
	my $part = shift; 

	my $content = get($url);
	my $rai = XML::RAI->parse_string($content);
	foreach my $item ( @{$rai->items} ) {
		$content = substr($item->content, 0, 100);
		$content.="...";  
		$content = $item->$part;


		## This was supposed to be done by TimeDate::Format::RSS
		## but I couldn't persuade CPAN to tell me why it	
		## couldn't install it.				

		my $time = $item->issued;			
		my ($date, $time) = split (/T/, $time);		
		my ($time, $tz) = split (/\+/, $time);		
		my ($year,$month,$day) = split(/-/, $date);	
		my ($h,$m,$s) = split(/:/, $time);
		my $dt = DateTime->new( 
			year   => $year,
			month  => $month,
			day    => $day,
			hour   => $h,
			minute => $m,
			second => $s,
			time_zone => "+$tz",
                );
		$time = $dt->epoch;
		my $link = $item->link;
		$return{$time} = [$link, $content]
	}
	return %return
}
