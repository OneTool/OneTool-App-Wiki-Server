#!/usr/bin/perl

=head1 NAME

onetool_wiki_server - Wiki Program from the OneTool Suite

=cut

use strict;
use warnings;

use FindBin;

use lib "$FindBin::Bin/../lib/";

use OneTool::Wiki::Server::App;

ITTool::Wiki::Server::App->run(@ARGV);

=head1 AUTHOR

Sebastien Thebert <contact@onetool.pm>

=cut