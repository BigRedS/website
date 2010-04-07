#! /usr/bin/perl

use strict;
use LWP::Simple;

my $facebook = get "http://www.facebook.com/profile.php?id=512860984";

print $facebook;
