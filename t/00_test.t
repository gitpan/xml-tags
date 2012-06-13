#! /usr/bin/perl
use XML::Tags::html5;
use Test::More 'no_plan';

my $string = join '', html {"test"};
is( $string, "<html>test</html>" );
