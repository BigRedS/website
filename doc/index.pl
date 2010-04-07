#! /usr/bin/perl

use strict;
use 5.010;
use CGI;
use Text::Markdown 'markdown'; # libtext-markdown-perl

push (@INC, "/home/avi/bin");

require website::fun;


&start_html();
&header();
&start();

my $dir = "./dir";
if (CGI::param('doc') !~ /^$/){

	my $doc = CGI::param('doc');

	open(D, "<$dir");
	my $file;
	while(<D>){
		if (/^$doc\t/){
			$file = (split(/\t/, $_))[1];
			last;
		}
	}

	open (F, "<$file");
	my $text;
	{
		local $/ = undef;
		$text = <F>;
	}
	my $html = markdown($text);
#my $html ="3";
	say $html;
}else{

	open (D,"<$dir");
	my (@names, @descriptions);
	while (<D>){
		if ($_ !~ /^#/){
			my ($name, $description) = (split(/\t/, $_))[0,2];
			push(@names, $name);
			push(@descriptions, $description);
		}
	}

	for(my $i = 0; $i<=@names; $i++){
		say "<a href='./$names[$i].html'>$names[$i]</a> $descriptions[$i]";
	}
}

&end();
&footer();
&end_html();

sub start(){
print <<EOF
	<div id='doc'>
EOF
}
sub end(){
print <<EOF
	</div>
EOF
}
