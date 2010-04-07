#! /usr/bin/perl

package Website;

use strict;
use 5.010;

sub new {
	my $proto = shift;
	my $class = ref($proto)||$proto;
        my $self  = {};
	$self->{top} 	= undef;
        $self->{title}	= undef;
        bless($self, $class);
        return $self;
}


sub title{
	my $self = shift;
	$self->{title} = 'title';
	return $self->{title};

}

sub top {
	my $self = shift;
	$self->{top} = 	"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\"";
#			"\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">",
#			"<html xmlns=\"http://www.w3.org/1999/xhtml\">";
#        <head>
#!--            <link rel='stylesheet' type='text/css' href='./styles.css'/>-->
#               <link rel='stylesheet' type='text/css' href='http://localhost/styles.css'/>
#               <title>Avi</title>
#        </head>
#        <body>
#                <div id='top'>
#                        <div class='avi' id='left'>
#                                Avi :)
 #                       </div>
 #                       <div class='links' id='right'>
 #                                       <a href='./rant/'>rants</a> 
 #                                       <a href='./doc/'> docs</a> 
 #                                       <a href='./blog/'>blog</a> 
 #                                       <a href='./about/'>about</a> 
 #                                       <a href='./contact/'>contact</a>
 #                       </div>
 #               </div>  
#);
return $self->{top};
}

1
