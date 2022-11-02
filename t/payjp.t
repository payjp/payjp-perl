#!/usr/bin/perl

use strict;
use warnings;

use Test::Mock::LWP;
use Test::More;

use Net::Payjp;
use JSON;

use_ok('Net::Payjp');

my $payjp = Net::Payjp->new(api_key => 'api_key1');
is($payjp->{api_key}, 'api_key1', 'does not set by new()');
is($payjp->{api_base}, 'https://api.pay.jp', 'does not set by new()');
is($payjp->{id}, undef, 'does not set by new()');

is($payjp->{version}, $payjp->version, 'does not set by new()');
is($payjp->{version}, $payjp->version('9.9.9'), 'sets by version()');

is($payjp->api_key, 'api_key1', 'does not set by api_key()');
is($payjp->api_key('api_key2'), 'api_key2', 'does not set by api_key()');
is($payjp->{api_key}, 'api_key2', 'does not get api_key');

is($payjp->api_base, 'https://api.pay.jp', 'does not set by api_base()');
is($payjp->api_base('test'), 'test', 'does not set by api_base()');
is($payjp->{api_base}, 'test', 'does not get api_base');

is($payjp->id('id1'), 'id1', 'does not set by id()');
is($payjp->{id}, 'id1', 'does not get id');

isa_ok($payjp->charge, 'Net::Payjp::Charge', 'is not object');
is($payjp->charge->{api_key}, 'api_key2', 'does not get property');
is($payjp->charge->{id}, 'id1', 'does not get property');
is($payjp->charge->{api_base}, 'https://api.pay.jp', 'does not get property');
is($payjp->charge(id => 'ignore')->{id}, 'id1', 'does not get property');

isa_ok($payjp->customer, 'Net::Payjp::Customer');
is($payjp->customer->{api_key}, 'api_key2');
is($payjp->customer->{id}, 'id1');
is($payjp->customer(id => 'ignore')->{id}, 'id1');

isa_ok($payjp->subscription, 'Net::Payjp::Subscription');
is($payjp->subscription->{api_key}, 'api_key2');
is($payjp->subscription->{id}, 'id1');
is($payjp->subscription(id => 'ignore')->{id}, 'id1');

isa_ok($payjp->transfer, 'Net::Payjp::Transfer');
is($payjp->transfer->{api_key}, 'api_key2');
is($payjp->transfer->{id}, 'id1');
is($payjp->transfer(id => 'ignore')->{id}, 'id1');

isa_ok($payjp->transfer, 'Net::Payjp::Transfer');
is($payjp->transfer->{api_key}, 'api_key2');
is($payjp->transfer->{id}, 'id1');
is($payjp->transfer(id => 'ignore')->{id}, 'id1');

isa_ok($payjp->token, 'Net::Payjp::Token');
is($payjp->token->{api_key}, 'api_key2');
is($payjp->token->{id}, 'id1');
is($payjp->token(id => 'ignore')->{id}, 'id1');

isa_ok($payjp->event, 'Net::Payjp::Event');
is($payjp->event->{api_key}, 'api_key2');
is($payjp->event->{id}, 'id1');
is($payjp->event(id => 'ignore')->{id}, 'id1');

isa_ok($payjp->account, 'Net::Payjp::Account');
is($payjp->account->{api_key}, 'api_key2');
is($payjp->account->{id}, undef);

my $actual = $payjp->_to_object({
  object => 'test'
});
isa_ok($actual, 'Net::Payjp::Object');
is($actual->object, 'test');
is($actual->autoload, undef);

is_deeply($payjp->_api_param(
  param => {key => 'value'},
), {key => 'value'});

is_deeply($payjp->_api_param(
    param => {key => {nested => 'value'}},
), {'key[nested]' => 'value'});

$Mock_resp->mock( content => sub {'{"id":"id3"}'} );
$Mock_resp->mock( code => sub {200} );
$Mock_ua->mock( timeout => sub {is($_[1], 30)} );
$Mock_ua->mock( default_header => sub {
  my $self = shift;
  my %p = @_;
  like($p{'User-Agent'}, qr/Payjp\/v1 PerlBindings\//);
  my $ua = JSON->new->decode($p{'X-Payjp-Client-User-Agent'});
  is($ua->{'bindings_version'}, $payjp->version);
  is($ua->{'lang_version'}, $]);
  is($ua->{'publisher'}, 'payjp');
  is($ua->{'uname'}, $^O);
  is($ua->{'lang'}, 'perl');
} );

$Mock_req->mock( authorization_basic => sub {
  is($_[1], 'api_key2');
  is($_[2], '');
} );
my $got = $payjp->_request(method => 'GET', url => 'get');
is($Mock_req->{new_args}[1], 'GET');
is($Mock_req->{new_args}[2], 'get');
isa_ok($got, 'Net::Payjp::Object');
is($got->id, 'id3');
is($payjp->{id}, 'id3');

$payjp->_request(url => 'get', param => {'k1'=>'v1'});
is($Mock_req->{new_args}[1], 'GET');
is($Mock_req->{new_args}[2], 'get?k1=v1');

$Mock_req->mock( content => sub {
  my $p = $_[1];
  is($p, undef);
} );
my $posted = $payjp->_request(method => 'POST', url => 'post');
is($Mock_req->{new_args}[1], 'POST');
is($Mock_req->{new_args}[2], 'post');
isa_ok($posted, 'Net::Payjp::Object');

$Mock_req->mock( content => sub {
  my $p = $_[1];
  is($p, 'k1=v1');
} );
$payjp->_request(method => 'POST', url => 'post', param => {'k1'=>'v1'});

my $deleted = $payjp->_request(method => 'DELETE', url => 'delete');
is($Mock_req->{new_args}[1], 'DELETE');
is($Mock_req->{new_args}[2], 'delete');
isa_ok($deleted, 'Net::Payjp::Object');

$Mock_resp->mock( code => sub {400} );
$Mock_resp->mock( content => sub {'{"id":"id4"}'} );
my $e400 = $payjp->_request(url => 'e400');
isa_ok($e400, 'Net::Payjp::Object');
is($e400->id, 'id4');
is($payjp->{id}, 'id3');

$Mock_resp->mock( code => sub {500} );
$Mock_resp->mock( message => sub {'message'} );
my $e500 = $payjp->_request(url => 'e500');
isa_ok($e500, 'Net::Payjp::Object');
is_deeply($e500->error, {message=>'message', 'status_code'=>500});


is($payjp->_class_url, 'test/v1/payjps');
$payjp->id('id1');
is($payjp->_instance_url, 'test/v1/payjps/id1');

# 1000 / 2 + 1000 / 2 * Math.random()
$got = $payjp->_get_delay_sec(retry => 0, init_sec => 1, max_sec => 2);
ok(0.5 <= $got);
ok($got <= 1);
## 1000 * 2 ^ 2 / 2 + ...
$got = $payjp->_get_delay_sec(retry => 2, init_sec => 1, max_sec => 2);
ok(1 <= $got);
ok($got <= 2);
# Calcurated range is 500-1000 but the larger end is limited to 600
$got = $payjp->_get_delay_sec(retry => 0, init_sec => 1, max_sec => 0.6);
ok(0.3 <= $got);
ok($got <= 0.6);

done_testing();
