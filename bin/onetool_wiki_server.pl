#!/usr/bin/perl

=head1 NAME

onetool_wiki_server.pl - Wiki Program from the OneTool Suite

=cut

use strict;
use warnings;

use FindBin;

use lib "$FindBin::Bin/../lib/";

use OneTool::Wiki::Server::Command;

OneTool::Wiki::Server::Command->run(@ARGV);

=head1 AUTHOR

Sebastien Thebert <contact@onetool.pm>

=cut