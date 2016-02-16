#!/usr/bin/perl

use strict;
use warnings;

use Net::Payjp;
#use Test::More tests => 7;
use Test::More skip_all => 'avoid real request';

my $api_key = 'sk_test_c62fade9d045b54cd76d7036';
my $payjp = Net::Payjp->new( api_key => $api_key );
my $res;

isa_ok( $payjp->transfer, 'Net::Payjp::Transfer' );


#List
can_ok( $payjp->transfer, 'all' );
$res = $payjp->transfer->all( "limit" => 3, offset => 0 );
is( $res->object, 'list', 'got a list object back' );


#Set tr_id.
$payjp->id( $res->{data}->[0]->{id} );


#Retrieve
can_ok( $payjp->transfer, 'retrieve' );
$res = $payjp->transfer->retrieve;
is( $res->object, 'transfer', 'got a transfer object back' );


#Charges
can_ok( $payjp->transfer, 'charges' );
$res = $payjp->transfer->charges(
    limit  => 3,
    offset => 0
);
is( $res->object, 'list', 'got a list object back' );


