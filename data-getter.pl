#! /usr/bin/perl

use strict;
use 5.010;

use XML::FeedPP;	# libxml-feedpp-perl
use LWP::Simple;
use DateTime;		# libdatetime-perl
use DateTime::Format::Atom;	# -cpan
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
my $dbTable = 'feeds_dev';
close($f);	

my $dataSource = "dbi:mysql:avi_datagetter:avi.co";
my $db = DBI->connect($dataSource, $dbUser, $dbPass);


my %rss = (
	'identica' => ["http://identi.ca/api/statuses/user_timeline/99267.atom", "title" ],
	'thereg' => ["http://forums.theregister.co.uk/feed/user/40790",  "title" ],
	'twitter' => ["http://twitter.com/statuses/user_timeline/21741277.atom", "title" ],
#	'git.avi-utils' => ["http://github.com/BigRedS/avi-utils/commits/master.atom", "title" ],
#	'git.play' => ["http://github.com/BigRedS/play/commits/master.atom", "title" ],
#	'git.work-web' => ["http://github.com/BigRedS/work-web/commits/master.atom", "title" ],
#	'dotfiles' => ["http://github.com/BigRedS/dotfiles/commits/master.atom", "title" ],
#	'java' => ["http://github.com/BigRedS/java/commits/master.atom", "title" ],
#	'website' => "http://github.com/BigRedS/website/commits/master.atom", "title" ],
	'wikipedia' => ["http://en.wikipedia.org/w/index.php?title=Special:Contributions/Lordandmaker&feed=atom&limit=50&target=Lordandmaker&year=&month=", "title" ],
	'slashdot' => [ "http://slashdot.org/firehose.pl?op=rss&content_type=rss&view=userhomepage&fhfilter=%22home%3Alordandmaker%22&orderdir=DESC&orderby=createtime&color=black&duration=-1&startdate=&user_view_uid=960504&logtoken=960504%3A%3AqQuPZQpQoZTAkoJGfmbG6g", "content" ],
	'picasa_dropbox' => ["http://picasaweb.google.com/data/feed/base/user/ialoneambest/albumid/5369778250591696225?alt=rss&kind=photo&hl=en_GB", "title"],
	'picasa_albums' => ["http://picasaweb.google.com/data/feed/base/user/ialoneambest?alt=rss&kind=album&hl=en_GB", "title"],
	'lastfm_loved' => ["http://ws.audioscrobbler.com/2.0/user/lordandmaker/lovedtracks.rss", "title"]
#	'lastfm' => [ "http://ws.audioscrobbler.com/1.0/user/lordandmaker/recenttracks.rss", "title" ]
#	'blog' => [ "http://aviswebsite.co.uk/blog/feed/", "content" ]
);

my $query = "insert into $dbTable (time, link, title, name) VALUES (?, ?, ?, ?)";
my $q = $db->prepare($query);
my $cQuery = "select UNIX_TIMESTAMP(time) from $dbTable where name=? order by time desc limit 1";
my $c = $db->prepare($cQuery);

foreach(keys(%rss)){
	&rss($_)
}

sub rss() {
	my $name = shift;
	print "$name\n";
	my $url = $rss{$name}[0];
	my $part = $rss{$name}[1];
	$c->execute($name);
	my ($lastSeen) = $c->fetchrow_array();	
	my $feed = XML::FeedPP->new($url);
	foreach my $item($feed->get_item()){
		print ".";
		my $d=DateTime::Format::Atom->new();
		my $dt=$d->parse_datetime($item->pubDate);
		my $time=$dt->ymd." ".$dt->hms;
		my $link = $item->link;
		my $title;
		if ($part =~ /title/){
			$title = $item->title;
		}else{
			$title = $item->description;
		}
		print $dt->ymd."\n";
		if($lastSeen < $dt->epoch){
			$q->execute($time, $link, $title, $name);
		}else{
			last;
		}
	}
	print "\n";
}

exit 0
