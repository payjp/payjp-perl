# Net::Payjp
# Perl version

5.10 or higher is required

# SYNOPSIS

In advance, you need to get a token by [Checkout](https://pay.jp/docs/checkout) or [payjp.js](https://pay.jp/docs/payjs).

```perl
# Create charge
my $payjp = Net::Payjp->new(api_key => $API_KEY);
my $res = $payjp->charge->create(
  card => 'token_id_by_Checkout_or_payjp.js',
  amount => 3500,
  currency => 'jpy',
  description => 'test charge',
);
if(my $e = $res->error){
  print "Error";
  print $e->{message}."\n";
}

# Retrieve a charge
$payjp->id($res->id); # Set id of charge
$res = $payjp->charge->retrieve; # or $payjp->charge->retrieve($res->id);
```

# DESCRIPTION
This module is a wrapper around the Pay.jp HTTP API.Methods are generally named after the object name and the acquisition method.

This method returns json objects for responses from the API.

# METHODS
## new PARAMHASH
This creates a new Payjp api object. The following parameters are accepted:

###api_key
This is required. You get this from your account settings on PAY.JP.

## ATTRIBUTES
### api_key
Reader: api_key

Type: Str

This attribute is required.

# API Reference

https://pay.jp/docs/api/

# Contribute
## Setup

```sh
$ cmanm package
or
$ perl -MCPAN -e shell
cpan> install LWP::UserAgent
cpan> install LWP::Protocol::https
cpan> install HTTP::Request::Common
cpan> install JSON
cpan> install Test::More
```

## Test

```sh
$ perl Makefile.PL
$ make test
```

## Publish

```sh
$ make dist
```

use `cpan-upload` to upload Net-Payjp tar.gz
