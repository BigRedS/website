#! /usr/bin/perl

use strict;
use 5.010;
use CGI;
use Text::Markdown 'markdown'; # libtext-markdown-perl

push (@INC, "/home/avi/www");

require fun;


&start_html();
&header();
#&start();

my $dir = "./dir";

if (CGI::param('doc') !~ /^$/){
	my $file = CGI::param('doc');
	$file.=".mkd";
	open (F, "<$file");
	my $text;
	{
		local $/ = undef;
		$text = <F>;
	}
	my $html = markdown($text);
	say $html;
}else{

	open (D,"<$dir");
	my (@names, @filenames, @descriptions);
	while (<D>){
		if ($_ !~ /^#/){
			my ($name,$filename, $description) = (split(/\t/, $_))[0,1,2];
			$filename =~ s/mkd$/html/;
			push(@names, $name);
			push(@filenames, $filename);
			push(@descriptions, $description);
		}
	}
	say "<div id='doc'>";
	for(my $i = 0; $i<=@names; $i++){
		if ($names[$i] !~ /^$/){
			say "<a href='./$filenames[$i]'>$names[$i]</a> $descriptions[$i] <br />";
		}
	}
	say "</div>";
}

#&end();
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
