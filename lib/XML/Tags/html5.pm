#! /usr/bin/perl
package XML::Tags::html5;
use XML::Tags;
use Exporter 'import';
our @EXPORT = qw<
    pre p div span hr
    script
    html head body title import_css import_js meta http_equiv meta_name
    h1 h2 h3 h4 h5 h6
    table cell row th table_heads table_rows
    tspan rowspan colspan
    form label
    input input_form input_text input_pwd
    input_tag input_check input_checked input_keep_check input_radio
    submit input_submit
    select_tag option input_select 
    a anchor
    ul ol li list
    dl dt dd dl_hash
    link link_to
>;

sub label   (&) { tag label   => @_ }
sub form    (&) { tag form    => @_ }
sub input   (&) { tag input   => @_ }
sub p       (&) { tag p       => @_ }
sub ul      (&) { tag ul      => @_ }
sub ol      (&) { tag ol      => @_ }
sub li      (&) { tag li      => @_ }
sub a       (&) { tag a       => @_ }
sub h1      (&) { tag h1      => @_ }
sub h2      (&) { tag h2      => @_ }
sub h3      (&) { tag h3      => @_ }
sub h4      (&) { tag h4      => @_ }
sub h5      (&) { tag h5      => @_ }
sub h6      (&) { tag h6      => @_ }
sub hr      (&) { tag hr      => @_ }
sub title   (&) { tag title   => @_ }
sub html    (&) { tag html    => @_ }
sub head    (&) { tag head    => @_ }
sub body    (&) { tag body    => @_ }
sub table   (&) { tag table   => @_ }
sub th      (&) { tag th      => @_ }
sub cell    (&) { tag td      => @_ }
sub row     (&) { tag tr      => @_ }
sub div     (&) { tag div     => @_ }
sub span    (&) { tag span    => @_ }
sub script  (&) { tag script  => @_ }
sub pre     (&) { tag pre     => @_ }
sub http_equiv    { qq!<meta http-equiv="$_[0]" content="$_[1]"/>! }
sub meta_name     { qq!<meta name="$_[0]" content="$_[1]"/>! }
sub meta_keywords { qq!<meta name="keywords" content="$_[0]"/>! }
sub meta_author   { qq!<meta name="author"  content="$_[0]"/>! }
sub link_to     {
    my ( $link, @data ) = @_;
    tag a =>  sub { @data }, +{ href => $link }
}
sub import_css { qq{<link rel="stylesheet" href="$_[0]" />} }
sub import_js  { qq{<script src="$_[0]"></script>} }

sub submit { tag input => 0, +{ qw< type submit name   >, @_ } }

sub input_form (&) { tag form => $_[0], +{ qw< method post > } }
sub input_tag {
    my %form;
    @form{qw< type name value >} = splice @_,0,3;
    tag input => 0, +{ %form, @_ }
}
sub input_pwd     { input_tag password => @_ }
sub input_text    { input_tag text     => @_ }
sub input_keep_check {
    (shift)
    ? input_tag checkbox => @_, qw< checked checked >
    : input_tag checkbox => @_
}
sub input_check   { input_tag checkbox => @_ }
sub input_checked { input_tag checkbox => @_, qw<  checked checked > }
sub input_radio   { input_tag radio    => @_ }
sub input_submit  { input_tag submit   => @_ }

sub select_tag  (&) { tag select => @_ }
sub option      (&) { tag option => @_ }
sub input_select {
    my ($name,$options,$default) = @_;
    my @selected = ('selected')x2;
    defined $default
    ? select_tag {
        +{ name => $name}
        , map {
            option {
                if (ref) {
                    +{ name => $$_[0]
                    ,   ( $$_[1] ~~ $default
                        ? @selected
                        : () )
                    }
                    , $$_[1]
                } else { +{ $_ ~~ $default ? @selected : () } , $_ }
            }
        } @$options
    }
    : select_tag {
        +{ name => $name}
        , map {
            if (ref) { option {+{ name => $$_[0]} , $$_[1] } }
            else     { option { $_ }
            }
        } @$options
    }
}

sub dl     (&) { tag dl     => @_ }
sub dt     (&) { tag dt     => @_ }
sub dd     (&) { tag dd     => @_ }
sub dl_hash {
    my $hash = shift;
    dl { map { dt {$_}, dd { $$hash{$_} } } keys %$hash }
}

sub list {
    my @l = @_;
    ul {map {li{$_}} @l}
}
sub table_rows { map { row { map {cell{$_}} @$_ } } @_ }
sub table_heads {
    my @r = @_;
    row { map { (ref) ? th{@$_} : th{$_} } @r }
}

sub tspan {
    my $span = shift;
    my $cell = pop;
    my %args = ( "${span}span" =>  @_ );
    tag cell => $cell, \%args
}

sub rowspan { tspan row => @_ }
sub colspan { tspan col => @_ }

sub top_menu  (&) {
    my ($chunk) = shift;
    div { +{class => "navbar navbar-fixed-top"},
	div { +{class => "navbar-inner"},
	    div { +{class => "container-fluid"}, &$chunk }
	}
    }
}

1;
