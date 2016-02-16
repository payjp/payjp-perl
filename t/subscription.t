#!/usr/bin/perl

use strict;
use warnings;

use Net::Payjp;
#use Test::More tests => 23;
use Test::More skip_all => 'avoid real request';

my $api_key = 'sk_test_c62fade9d045b54cd76d7036';
my $payjp = Net::Payjp->new(api_key => $api_key);
my $res;

isa_ok($payjp->subscription, 'Net::Payjp::Subscription');


#Create
my $cus_res = $payjp->customer->create(
    "description" => "test description.",
);
my $card = $payjp->customer->card($cus_res->id);
my $card_res = $card->create(
    number           => '4242424242424242',
    exp_year         => '2020',
    exp_month        => '02',
    'metadata[hoge]' => 'fuga'
);
my $pln_res = $payjp->plan->create(
    amount     => 500,
    currency   => "jpy",
    interval   => "month",
    trial_days => 30,
);

can_ok($payjp->subscription, 'create');
$res = $payjp->subscription->create(
    customer         => $cus_res->id,
    plan             => $pln_res->id,
    'metadata[hoge]' => 'fuga'
);
is($res->object, 'subscription', 'got a subscription object back');
is($res->metadata->{hoge}, 'fuga', 'got a subscription metadata');


#Set sub_id.
$payjp->id($res->id);


#retrieve
can_ok($payjp->subscription, 'retrieve');
$res = $payjp->subscription->retrieve;
is($res->object, 'subscription', 'got a subscription object back');
is($res->metadata->{hoge}, 'fuga', 'got a subscription metadata');


#Update
can_ok($payjp->subscription, 'save');
$res = $payjp->subscription->save(
    'metadata[hoge]' => 'piyo'
);
is($res->object, 'subscription', 'got a subscription object back');
is($res->metadata->{hoge}, 'piyo', 'got a subscription metadata');


#Update remove metadata
can_ok($payjp->subscription, 'save');
$res = $payjp->subscription->save(
    'metadata[hoge]' => ''
);
is($res->object, 'subscription', 'got a subscription object back');
is_deeply($res->metadata, { }, 'got a subscription metadata');


#Pause
can_ok($payjp->subscription, 'pause');
$res = $payjp->subscription->pause;
is($res->object, 'subscription', 'got a subscription object back');


#Resume
can_ok($payjp->subscription, 'resume');
$res = $payjp->subscription->resume;
is($res->object, 'subscription', 'got a subscription object back');


#Cancel
can_ok($payjp->subscription, 'cancel');
$res = $payjp->subscription->cancel;
is($res->object, 'subscription', 'got a subscription object back');


#Delete
can_ok($payjp->subscription, 'delete');
$res = $payjp->subscription->delete;
ok($res->deleted, 'delete was successful');


#List
can_ok($payjp->subscription, 'all');
$res = $payjp->subscription->all(limit => 3, offset => 0);
is($res->object, 'list', 'got a list object back');

