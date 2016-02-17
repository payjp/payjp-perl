#!/usr/bin/perl

use strict;
use warnings;

use Net::Payjp;
#use Test::More tests => 17;
use Test::More skip_all => 'avoid real request';

my $api_key = 'sk_test_c62fade9d045b54cd76d7036';
my $payjp = Net::Payjp->new(api_key => $api_key);
my $res;

isa_ok($payjp->plan, 'Net::Payjp::Plan');


#Create
can_ok($payjp->plan, 'create');
$res = $payjp->plan->create(
    amount           => 500,
    currency         => 'jpy',
    interval         => 'month',
    trial_days       => 30,
    name             => 'test_plan',
    'metadata[hoge]' => 'fuga'
);
is($res->object, 'plan', 'got a plan object back');
is($res->metadata->{hoge}, 'fuga', 'got a plan metadata');


#Set pln_id.
$payjp->id($res->id);


#Retrieve
can_ok($payjp->plan, 'retrieve');
$res = $payjp->plan->retrieve;
is($res->object, 'plan', 'got a plan object back');
is($res->metadata->{hoge}, 'fuga', 'got a plan metadata');


#Update
can_ok($payjp->plan, 'save');
$res = $payjp->plan->save(
    name             => 'update plan',
    'metadata[hoge]' => 'piyo'
);
is($res->object, 'plan', 'got a plan object back');
is($res->metadata->{hoge}, 'piyo', 'got a plan metadata');


#Update remove metadata
can_ok($payjp->plan, 'save');
$res = $payjp->plan->save(
    name             => 'update plan',
    'metadata[hoge]' => ''
);
is($res->object, 'plan', 'got a plan object back');
is_deeply($res->metadata, { }, 'got a plan metadata');


#Delete
can_ok($payjp->plan, 'delete');
$res = $payjp->plan->delete;
ok($res->deleted, 'delete was successful');


#List
can_ok($payjp->plan, 'all');
$res = $payjp->plan->all(limit => 5, offset => 0);
is($res->object, 'list', 'got a list object back');

