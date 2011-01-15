#! /usr/bin/perl

use strict;
use 5.010;

use XML::RAI;
use XML::RSSLite;	# libxml-rsslite-perl
use XML::FeedPP;	# libxml-feedpp-perl
use LWP::Simple;	
use DateTime;		# libdatetime-perl
use DateTime::Format::Atom;	# -cpan
use XML::RSS;		# libxml-rss-perl
use DBI;		# libdbd-mysql-perl
use Data::Dumper;

my ($f, $dbUser, $dbHost, $dbPass);
my $config = "/home/avi/.website-db.conf";
open($f,"<",$config) or die "Error opening config file $config";
foreach(<$f>){
	chomp $_;
	my ($k,$v) = split(/=/, $_);
	given($k){
		when(/db_user/){
			$dbUser = $v;
		}
		when(/db_host/){
			$dbHost = $v;
		}
		when(/db_pass/){
			$dbPass = $v;
		}
	}
}
close($f);	

my $dataSource = "dbi:mysql:avi_datagetter:avi.co";
my $db = DBI->connect($dataSource, $dbUser, $dbPass);

my %atom = (
	'identica' => "http://identi.ca/api/statuses/user_timeline/99267.atom", 
	'thereg' => "http://forums.theregister.co.uk/feed/user/40790", 
	'twitter' => "http://twitter.com/statuses/user_timeline/21741277.atom",
#	'git.avi-utils' => "http://github.com/BigRedS/avi-utils/commits/master.atom",
#	'' => "http://github.com/BigRedS/play/commits/master.atom",
#	'' => "http://github.com/BigRedS/work-web/commits/master.atom",
#	'' => "http://github.com/BigRedS/dotfiles/commits/master.atom",
#	'' => "http://github.com/BigRedS/java/commits/master.atom",
#	'' => "http://github.com/BigRedS/website/commits/master.atom",
	'wikipedia' => "http://en.wikipedia.org/w/index.php?title=Special:Contributions/Lordandmaker&feed=atom&limit=50&target=Lordandmaker&year=&month="
);

my %rss = (
	'slashdot' => [ "http://slashdot.org/firehose.pl?op=rss&content_type=rss&view=userhomepage&fhfilter=%22home%3Alordandmaker%22&orderdir=DESC&orderby=createtime&color=black&duration=-1&startdate=&user_view_uid=960504&logtoken=960504%3A%3AqQuPZQpQoZTAkoJGfmbG6g", "content" ],
	picasa_dropbox => ["http://picasaweb.google.com/data/feed/base/user/ialoneambest/albumid/5369778250591696225?alt=rss&kind=photo&hl=en_GB", "title"],
	picasa_albums =>["http://picasaweb.google.com/data/feed/base/user/ialoneambest?alt=rss&kind=album&hl=en_GB", "title"],
#	'lastfm' => [ "http://ws.audioscrobbler.com/1.0/user/lordandmaker/recenttracks.rss", "title" ]
#	'blog' => [ "http://aviswebsite.co.uk/blog/feed/", "content" ]
);

my $query = "insert into feeds (time, link, title, name) VALUES (?, ?, ?, ?)";
my $q = $db->prepare($query);
my $cQuery = "select UNIX_TIMESTAMP(time) from feeds where name=? order by time desc limit 1";
my $c = $db->prepare($cQuery);

#foreach(keys(%atom)){
#	&atom($_);
#	last;
#}

foreach(keys(%rss)){
	&rss($_)
}

# # # #


sub atom() {
	my $name = shift;
	my $url = $atom{$name};
	$c->execute($name);
	my ($lastSeen) = $c->fetchrow_array();	
	my $feed = XML::FeedPP->new($url);
	foreach my $item($feed->get_item()){
		my $d=DateTime::Format::Atom->new();
		my $dt=$d->parse_datetime($item->pubDate);
		my $time=$dt->ymd." ".$dt->hms;
		my $link = $item->link;
		my $title = $item->title;
		if($lastSeen < $dt->epoch){
			$q->execute($time, $link, $title, $name);
		}else{
			last;
		}
	}
}

sub rss() {
	my $name = $_;
	my $url = ${$rss{$name}}[0];
	my $part = ${$rss{$name}}[1];

	$c->execute($name);
	my ($lastSeen) = $c->fetchrow_array();
	my $xml = get($url);
	my $rss = XML::RAI->parse_string($xml);
	$rss->time_format("EPOCH");
	foreach my $item (@{$rss->items}){
		my $title = $item->abstract || $item->content;
		my $date = $item->created || $item->published;
		my $url = $item->link;
		if ($lastSeen < $date){
			$q->execute($date,$url,$title,$name);
		}
#		print "| $date |||| $url |||| $title |\n"
	}
}


exit 0

#sub rss(){
#	my ($url,$part) = @_;
#	my $content = get($url);
#	my $rai = XML::RAI->parse_string($content);
#	foreach my $item ( @{$rai->items} ) {
#		$content = substr($item->content, 0, 100);
#		$content.="...";  
#		$content = $item->$part;
#		## This was supposed to be done by TimeDate::Format::RSS
#		## but I couldn't persuade CPAN to tell me why it	
#		## couldn't install it.				
#
#		my $time = $item->issued;			
#		my ($date, $time) = split (/T/, $time);		
#		my ($time, $tz) = split (/\+/, $time);		
#		my ($year,$month,$day) = split(/-/, $date);	
#		my ($h,$m,$s) = split(/:/, $time);
#		my $dt = DateTime->new( 
#			year   => $year,
#			month  => $month,
#			day    => $day,
#			hour   => $h,
#			minute => $m,
#			second => $s,
#			time_zone => "+$tz",
#               );
#		$time = $dt->epoch;
#		my $link = $item->link;
##	$return{$time} = [$link, $content];
#	}
##	return $time, $link, $content;
#}
#
#	}
#}
#close FILE;
#
##sub rss(){
##	my %return
##	my $url = shift;
###my $part = shift;
###my $content = get($url)
##
##	my $rss = XML::RSS->new();
##	my $data = get( $url );
##	$rss->parse( $data );
##
##	my $channel = $rss->{channel};
##	my $image   = $rss->{image};
##
##
##
###	$return{$time} = [$link,$content];	
##
##}
#
#sub atom(){
#	my $url = shift;
#	my %return;
#	if (my $feed = XML::FeedPP->new( $url )){
#		foreach my $item ( $feed->get_item() ) {
#			my $d = DateTime::Format::Atom->new();
#			my $dt = $d->parse_datetime( $item->pubDate );
#			my $time = $dt->epoch;
#			$return{ $time } = [$item->link, $item->title()];
#		}
#	}
#	return %return;
#}
##
#
#
#
