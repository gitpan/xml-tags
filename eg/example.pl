#! /usr/bin/perl
use Modern::Perl;
use XML::Dialect;

sub foo (&) { tag foo => @_ }

say foo{
    + {qw< class bar id bang >}
    , {qw< style text-align:center >}
    , "this is "
    , "the content"
};






