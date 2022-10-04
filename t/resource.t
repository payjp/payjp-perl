#!/usr/bin/perl

use strict;
use warnings;

use Test::Mock::LWP;
use Test::More tests => 2;

use Net::Payjp;

my $payjp = Net::Payjp::Resource->new(api_key => 'api_key');

is($payjp->_class_url, 'https://api.pay.jp/v1/resources');
$payjp->id('id1');
is($payjp->_instance_url, 'https://api.pay.jp/v1/resources/id1');
