=head1 NAME

OneTool::Wiki::Server - OneTool Wiki Server module

=cut

package OneTool::Wiki::Server;

use strict;
use warnings;

use FindBin;
use Log::Log4perl;
use Moose;

use lib "$FindBin::Bin/../lib/";

use OneTool;
use OneTool::Configuration;
use OneTool::Wiki::Server::API qw( %server_api );
use OneTool::Wiki::Server::Page;

my $FILE_LOG = "$FindBin::Bin/../conf/onetool_wiki_server.log.conf";
our $VERSION = $OneTool::VERSION . '.1';

=head1 MOOSE OBJECT

=cut

extends 'OneTool::Daemon';

around BUILDARGS => sub 
{
    my $orig  = shift;
    my $class = shift;

    Log::Log4perl::init_and_watch($FILE_LOG, 10);
    my $logger = Log::Log4perl->get_logger('OneTool_wiki_server');
    
    if (@_ == 0)
    {
        # called as 'OneTool::Wiki::Server->new()'
        my $conf = OneTool::Configuration::Get({ module => 'onetool_wiki_server' });

        $conf->{api} = \%server_api;
        $conf->{logger} = $logger;
        
        return $class->$orig($conf);
    }
    elsif ( @_ == 1 && defined $_[0]->{file} )
    {
        # called as 'OneTool::Wiki::Server->new($fileconf)'
        my $conf = OneTool::Configuration::Get({ file => $_[0]->{file} });
        
        return $class->$orig($conf);
    }
    else 
    {
        return $class->$orig(@_);
    }
};

=head1 SUBROUTINES/METHODS

=head2 Configurations

=cut

sub Configurations
{
    my $conf = OneTool::Configuration::Get({ file => "$FindBin::Bin/../conf/onetool_web_wiki.conf" });
    
    return ($conf);
}

=head2 Page_Save

curl --data "page=demo2&text='text with space'" http://127.0.0.1:7770/api/wiki_server/page

=cut

sub Page_Save
{
    my ($self, $query, $content) = @_;
    
    #OneTool::Wiki::Server::Page::Save($query, '', '');
    return ({ status => 'ok', data => { query => $query, content => $content } });
}

=head2 Version()

Returns Server version

=cut

sub Version
{
    return ({ status => 'ok', data => { Version => $VERSION } });
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

=head1 AUTHOR

Sebastien Thebert <contact@onetool.pm>

=cut