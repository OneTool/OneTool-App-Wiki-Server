#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use Test::More;

use lib "$FindBin::Bin/../../../../lib/";

BEGIN { use_ok('OneTool::Wiki::Server::Command'); }

my $BIN = 'onetool_wiki_server.pl';

my @DEFAULT_OPTIONS = ('-h', '--help', '-v', '--version');

#
# Checks default program options 
#

foreach my $opt (@DEFAULT_OPTIONS)
{
    my $status = OneTool::Wiki::Server::Command->run($opt);
    cmp_ok($status, '==', 1, "$BIN $opt");
}

#
# Checks wrong option
#
my $wrong_status = OneTool::Wiki::Server::Command->run('--not-a-valid-option');
cmp_ok($wrong_status, '==', 0, "$BIN --not-a-valid-option");

done_testing(1 + scalar(@DEFAULT_OPTIONS) + 1);

=head1 AUTHOR

Sebastien Thebert <contact@onetool.pm>

=cut