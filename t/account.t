#!/usr/bin/perl

use strict;
use warnings;

use Net::Payjp;
#use Test::More tests => 3;
use Test::More skip_all => 'avoid real request';

my $api_key = 'sk_test_c62fade9d045b54cd76d7036';
my $payjp = Net::Payjp->new( api_key => $api_key );

isa_ok( $payjp->account, 'Net::Payjp::Account' );
can_ok( $payjp->account, 'retrieve' );
my $res = $payjp->account->retrieve;
is( $res->object, 'account', 'got a account object back' );
