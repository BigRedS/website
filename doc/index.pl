#! /usr/bin/perl

use strict;
use 5.010;
use CGI;
use Text::Markdown 'markdown'; # libtext-markdown-perl

push (@INC, "/home/avi/www");

require fun;



my $dir = "./dir";

if (CGI::param('doc') !~ /^$/){


my $file = CGI::param('doc');
	my $head_lines = "<link rel='alternate' href='$file.txt' type='text/plain' />";
	&start_html(" | doc | $file", $head_lines);
	&header();

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

	&start_html(" | doc");
	&header();
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
	say "<dl class='doc'>";
	for(my $i = 0; $i<=@names; $i++){
		if ($names[$i] !~ /^$/){
#			say "<div class='doclist'><a href='./$filenames[$i]'>$names[$i]</a> $descriptions[$i] </div>";
			say "<dt><a href='./$filenames[$i]'>$names[$i]</a></dt><dd>$descriptions[$i]</dd>";
		}
	}
	say "</dl>";
	say "</div>";
}

&footer();
&end_html();

sub intro(){
print <<EOF
<div class='intro'>
	<p>Here's a bunch of stuff I've written at some point and been called upon at some other point to reproduce. It's a mix of useful information and ranting. Currently it's a bit empty while I slowly get round to finding and markdowning all the rest.</p>
</div>

EOF
}
