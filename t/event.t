#!/usr/bin/perl

use strict;
use warnings;

use Net::Payjp;
#use Test::More tests => 5;
use Test::More skip_all => 'avoid real request';

my $api_key = 'sk_test_c62fade9d045b54cd76d7036';
my $payjp = Net::Payjp->new(api_key => $api_key);
my $res;

isa_ok($payjp->event, 'Net::Payjp::Event');


#List
can_ok($payjp->event, 'all');
$res = $payjp->event->all(limit => 10, offset => 0);
is($res->object, 'list', 'got a list object back');


#Set evnt_id.
$payjp->id($res->{data}->[0]->{id});


#Retrieve
can_ok($payjp->event, 'retrieve');
$res = $payjp->event->retrieve;
is($res->object, 'event', 'got a event object back');




