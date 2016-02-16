#!/usr/bin/perl

use strict;
use warnings;

use Net::Payjp;
#use Test::More tests => 19;
use Test::More skip_all => 'avoid real request';

my $api_key = 'sk_test_c62fade9d045b54cd76d7036';
my $payjp = Net::Payjp->new(api_key => $api_key);
my $res;

isa_ok($payjp->charge, 'Net::Payjp::Charge');


#Create
my $card = {
    number      => '4242424242424242',
    exp_month   => '02',
    exp_year    => '2020',
    address_zip => '2020014',
};
can_ok($payjp->charge, 'create');
$res = $payjp->charge->create(
    card             => $card,
    amount           => 3500,
    currency         => 'jpy',
    description      => 'test description.',
    'metadata[hoge]' => 'fuga'
);
is($res->object, 'charge', 'got a charge object back');
is($res->metadata->{hoge}, 'fuga', 'got a charge metadata');


#Set ch_id.
$payjp->id($res->id);


#Retrieve
can_ok($payjp->charge, 'retrieve');
$res = $payjp->charge->retrieve;
is($res->object, 'charge', 'got a charge object back');
is($res->metadata->{hoge}, 'fuga', 'got a charge metadata');


#Update
can_ok($payjp->charge, 'save');
$res = $payjp->charge->save(
    description      => 'update description.',
    'metadata[hoge]' => 'piyo'
);
is($res->object, 'charge', 'got a charge object back');
is($res->metadata->{hoge}, 'piyo', 'got a charge metadata');

#Update remove metadata
can_ok($payjp->charge, 'save');
$res = $payjp->charge->save(
    description      => 'update description.',
    'metadata[hoge]' => ''
);
is($res->object, 'charge', 'got a charge object back');
is_deeply($res->metadata, { }, 'got a charge metadata');


#Refund
can_ok($payjp->charge, 'refund');
$res = $payjp->charge->refund(amount => 1000, refund_reason => 'refund test.');
is($res->object, 'charge', 'got a charge object back');


#Capture
$res = $payjp->charge->create(
    card     => $card,
    amount   => 3500,
    currency => 'jpy',
    capture  => 'false'
);
$payjp->id($res->id);
can_ok($payjp->charge, 'capture');
$res = $payjp->charge->capture(amount => 2000);
is($res->object, 'charge', 'got a charge object back');


#List
can_ok($payjp->charge, 'all');
$res = $payjp->charge->all("limit" => 2, "offset" => 0);
is($res->object, 'list', 'got a list object back');


