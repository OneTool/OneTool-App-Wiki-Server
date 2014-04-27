#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use Test::More;

use lib "$FindBin::Bin/../../../../lib/";

use OneTool::Wiki::Server::Page;

my $test_page = 'test_page';
my $test_tag = 'tag';
my $test_text = <<END;
# header1
## header 2
**bold**
  * item list 1
  * item list 2
END

my $result = OneTool::Wiki::Server::Page::Save($test_page, $test_text, $test_tag);
ok(defined $result && $result eq $test_page, 
    'OneTool::Wiki::Server::Page::Save()');

$result = OneTool::Wiki::Server::Page::Load($test_page);
cmp_ok($result, 'eq', $test_text, "OneTool::Wiki::Server::Page::Load('$test_page')");

$result = OneTool::Wiki::Server::Page::Delete($test_page);
ok(defined $result && $result eq $test_page, 
    "OneTool::Wiki::Server::Page::Delete('$test_page')");

done_testing(3);

=head1 AUTHOR

Sebastien Thebert <contact@onetool.pm>

=cut