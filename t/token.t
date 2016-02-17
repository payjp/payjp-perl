#!/usr/bin/perl

use strict;
use warnings;

use Net::Payjp;
#use Test::More tests => 5;
use Test::More skip_all => 'avoid real request';

my $api_key = 'sk_test_c62fade9d045b54cd76d7036';
my $payjp = Net::Payjp->new(api_key => $api_key);
my $res;

isa_ok($payjp->token, 'Net::Payjp::Token');


#Create
my $card = {
    number    => '4242424242424242',
    cvc       => '1234',
    exp_month => '02',
    exp_year  => '2020'
};
can_ok($payjp->token, 'create');
$res = $payjp->token->create(
    card => $card,
);
is($res->object, 'token', 'got a token object back');


#Set tok_id.
$payjp->id($res->id);


#Retrieve
can_ok($payjp->token, 'retrieve');
$res = $payjp->token->retrieve;
is($res->object, 'token', 'got a token object back');

