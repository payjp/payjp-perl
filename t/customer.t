#!/usr/bin/perl

use strict;
use warnings;

use Net::Payjp;
#use Test::More tests => 40;
use Test::More skip_all => 'avoid real request';

my $api_key = 'sk_test_c62fade9d045b54cd76d7036';
my $payjp = Net::Payjp->new(api_key => $api_key);
my $res;

isa_ok($payjp->customer, 'Net::Payjp::Customer');


#Create
can_ok($payjp->customer, 'create');
$res = $payjp->customer->create(
    description    => 'test description.',
    'metadata[hoge]' => 'fuga'
);
is($res->object, 'customer', 'got a customer object back');
is($res->metadata->{hoge}, 'fuga', 'got a customer metadata');


#Set cus_id.
$payjp->id($res->id);


#Retrieve
can_ok($payjp->customer, 'retrieve');
$res = $payjp->customer->retrieve;
is($res->object, 'customer', 'got a customer object back');
is($res->metadata->{hoge}, 'fuga', 'got a customer metadata');


#Update
can_ok($payjp->customer, 'save');
$res = $payjp->customer->save(
    email            => 'test@test.jp',
    'metadata[hoge]' => 'piyo'
);
is($res->object, 'customer', 'got a customer object back');
is($res->metadata->{hoge}, 'piyo', 'got a customer metadata');


#Update remove metadata
can_ok($payjp->customer, 'save');
$res = $payjp->customer->save(
    email            => 'test@test.jp',
    'metadata[hoge]' => ''
);
is($res->object, 'customer', 'got a customer object back');
is_deeply($res->metadata, { }, 'got a customer metadata');


#Delete
can_ok($payjp->customer, 'delete');
$res = $payjp->customer->delete;
ok($res->deleted, 'delete was successful');


#List
can_ok($payjp->customer, 'all');
$res = $payjp->customer->all(limit => 2, offset => 0);
is($res->object, 'list', 'got a list object back');


#Create card
$res = $payjp->customer->create(
    description => 'test card.',
);
can_ok($payjp->customer, 'card');
my $card = $payjp->customer->card($res->id);
isa_ok($card, 'Net::Payjp::Customer::Card');
can_ok($card, 'create');
my $res_card = $card->create(
    number           => '4242424242424242',
    exp_year         => '2020',
    exp_month        => '02',
    'metadata[hoge]' => 'fuga'
);
is($res_card->object, 'card', 'got a card object back');
is($res_card->metadata->{hoge}, 'fuga', 'got a card metadata');


#Retrieve card
can_ok($card, 'retrieve');
$res_card = $card->retrieve($res_card->id);
is($res_card->object, 'card', 'got a card object back');
is($res_card->metadata->{hoge}, 'fuga', 'got a card metadata');


#Update card
can_ok($card, 'save');
$res_card = $card->save(
    exp_year         => '2026',
    exp_month        => '05',
    name             => 'test',
    'metadata[hoge]' => 'piyo'
);
is($res_card->object, 'card', 'got a card object back');
is($res_card->metadata->{hoge}, 'piyo', 'got a card metadata');


#Update card remove metadata
can_ok($card, 'save');
$res_card = $card->save(
    exp_year         => '2026',
    exp_month        => '05',
    name             => 'test',
    'metadata[hoge]' => ''
);
is($res_card->object, 'card', 'got a card object back');
is_deeply($res_card->metadata, { }, 'got a card metadata');


#Delete card
can_ok($card, 'delete');
$res_card = $card->delete;
ok($res_card->deleted, 'delete was successful');


#List card
$card->create(
    number    => '4242424242424242',
    exp_year  => '2020',
    exp_month => '02'
);
can_ok($card, 'all');
$res_card = $card->all(limit => 2, offset => 0);
is($res_card->object, 'list', 'got a list object back');


#Retrieve subscription
my $pln_res = $payjp->plan->create(
    amount     => 500,
    currency   => 'jpy',
    interval   => 'month',
    trial_days => 30,
);

my $res_subscription = $payjp->subscription->create(
    customer => $res->id,
    plan     => $pln_res->id
);

can_ok($payjp->customer, 'subscription');
my $subscription = $payjp->customer->subscription($res->id);
can_ok($subscription, 'retrieve');
my $res_sub = $subscription->retrieve($res_subscription->id);
is($res_sub->object, 'subscription', 'got a subscription object back');


#List subscription
can_ok($subscription, 'all');
$res_sub = $subscription->all(limit => 5, offset => 0);
is($res_card->object, 'list', 'got a list object back');



