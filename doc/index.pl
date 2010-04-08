#! /usr/bin/perl

use strict;
use 5.010;
use CGI;
use Text::Markdown 'markdown'; # libtext-markdown-perl

push (@INC, "/home/avi/www");

require fun;


&start_html();
&header();

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

	&intro();
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

&footer();
&end_html();

sub intro(){
print <<EOF
<div class='intro'>
	<p>Here's a bunch of stuff I've written at some point and been called upon at some other point to reproduce. It's a mix of useful information and ranting.</p>
</div>

EOF
}
