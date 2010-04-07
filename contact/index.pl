#! /usr/bin/perl

use strict;
use 5.010;
use CGI;

push(@INC, "/home/avi/bin");
require website::fun;

my ($subject, $body, $from, $given_answer);

&start_html();
&header();

my $submit = CGI::param('submit');
#my $submit = "Go";

if ($submit =~ /Go/){
	my $from 	= CGI::param('from');
	my $subject	= CGI::param('subject');
	my $body 	= CGI::param('body');
	my $antispam	= CGI::param('antispam');
	my $pos		= CGI::param('pos');
	my $string	= CGI::param('string');
	
	$pos--;
	my $error;
	if ((substr($string, 0, $pos, 1) != $antispam) || ($antispam !~ m/^\d+$/)){
		$error.= "incorrect antispam value: $antispam <br />";
	}
	if ($subject =~ /^$/){
		$error.= "No Subject Line<br />";
	}
	if ($body =~ /^$/){
		$error.= "No message body<br >";
	}

	if (length($error) > 1){
		&form($error, $from, $subject, $body);
	}else{

#		$body = s/^[\w \*\+\-\=\#\?\!\"\"]//g;


	my $sendmail = "/usr/sbin/sendmail -t"; 
	my $reply_to = "Reply-to: $from\n"; 
	my $subject = "Subject: $subject\n"; 
	my $content = $body; 
	my $to = "To: avi";

	open(SENDMAIL, "|$sendmail") or die "Cannot open $sendmail: $!"; 
		print SENDMAIL $reply_to; 
		print SENDMAIL $subject; 
		print SENDMAIL $to; 
		print SENDMAIL "Content-type: text/plain\n\n"; 
		print SENDMAIL $content; close(SENDMAIL); 
	close SENDMAIL;
	

		say "<h3>Message sent:</h3>";
		say "<tt>From: $from</tt><br />";
		say "<tt>To: Avi</tt><br />";
		say "<tt>Subject: $subject</tt><br />";
		say "<pre width='75'>$body</tt>";
	}

}else{
	&form;
}

&footer;
&end_html;

sub form{
	my $error = shift;
	my $from = shift;
	my $subject = shift;
	my $body = shift;

	if ($error){
		say "<h3> Error: $error</h3>";
	}


	## Captcha-alike!

	my $big_number = rand();
	$big_number =~ s/^\d+\.+//g;
	$big_number = substr ($big_number, 0, 6);
	my $pos = int rand(length($big_number));
	my $answer = substr($big_number, $pos, 1);
	$pos++;
	$big_number =~ s/(\d{1})/$1 /g;

	my $pos_string;
	given($pos){
		when (1){
			$pos_string = "1st";
		}
		when (2){
			$pos_string = "2nd";
		}
		when (3){
			$pos_string = "3rd";
		}
		default{
			$pos_string = $pos."th";
		}
	}


	my $from_width = 10 + int(rand(10));
	my $subject_width = 20 + int(rand(20));
	my $message_width = 30 + int(rand(45));
	my $message_height = 5 + int(rand(35));
	
	say "	<form action='#' method='post'>";
	say "		<p><label for='from'>Your Email:</label><input type='text' name='from' value='$from' size='$from_width'></p>";
	say "		<p><label for='subject'>Subject:</label><input type='text' name='subject' value='$subject' size='$subject_width'></p>";
	say "		<p><label for='body'>Message:</label><textarea name='body' cols='$message_width' rows='$message_height'>$body</textarea></p>";
	say "		<p><label for='antispam'>Antispam: What is the $pos_string digit in <br /> <tt>$big_number</tt>?</label><input type='text' name='antispam' value=$given_answer></p>";
	say "		<input type='hidden' name='string' value='$big_number' />";
	say "		<input type='hidden' name='pos' value='$pos' />";
	say "		<p class='submit'><input type='submit' value='Go Go Gadget emailer!' name='submit'></p>";
	say "	</form>";
}


