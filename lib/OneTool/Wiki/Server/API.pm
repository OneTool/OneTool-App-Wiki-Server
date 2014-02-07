=head1 NAME

OneTool::Wiki::Server::API - OneTool Wiki Server API module

=cut

package OneTool::Wiki::Server::API;

use strict;
use warnings;

use Exporter 'import';
use FindBin;
use JSON;

use lib "$FindBin::Bin/../lib/";
use OneTool::Wiki::Server;

our @EXPORT_OK = qw(%server_api);

my $API_ROOT = '/api/wiki_server';

our %server_api = (
    "$API_ROOT/page" => {
        method => 'POST',
        action => sub {
            my ($self, $query, $content) = @_;
            return (to_json($self->Page_Save($query, $content))); 
            } 
        },
    "$API_ROOT/version" => {
        method => 'GET',
        action => sub {
            my ($self) = @_;
            return (to_json($self->Version())); 
            } 
        },
    "$API_ROOT/get_config" => {
        method => 'GET',
        action => sub {
            my ($self) = @_;           
            return (to_json([$self->Devices_List()])); 
            } 
        },
    );


1;

=head1 AUTHOR

Sebastien Thebert <contact@onetool.pm>

=cut