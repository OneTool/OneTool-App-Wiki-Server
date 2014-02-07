
=head1 NAME

OneTool::Wiki::Server::App - Module handling everything for onetool_wiki_server.pl

=head1 DESCRIPTION

Module handling everything for onetool_wiki_server.pl

=head1 SYNOPSIS

onetool_wiki_server.pl [options]

=head1 OPTIONS

=over 8

=item B<-h,--help>

Prints this Help

=back

=cut

package OneTool::Wiki::Server::App;

use strict;
use warnings;

use FindBin;
use Getopt::Long qw(:config no_ignore_case);
use Pod::Find qw(pod_where);
use Pod::Usage;

use lib "$FindBin::Bin/../lib/";

use OneTool::App;
use OneTool::Wiki::Server;

__PACKAGE__->run(@ARGV) unless caller;

=head1 SUBROUTINES/METHODS

=head2 Daemon()

Launch OneTool Wiki Server as Daemon

=cut

sub Daemon
{
    my $server = OneTool::Wiki::Server->new();

    if (fork())
    {    #father -> API Listener
        $server->Listener();
    }

=head2 comment
    else
    { #child -> monitoring loop
        $server->Log('info', 'Monitoring Server Loop Started !');
        while (1)
        {
            foreach my $device (@{$server->{devices}})
            {
                my $time = time();
                $device->{last_check} = 0    if (!defined $device->{last_check});
                if (($time - $device->{last_check}) >= $device->{interval})
                {
                    $server->Log('debug', "Device '$device->{name}'");
                    #my $result = $agent->Check($check->{name});
                    #$check->Data_Write($result) if (defined $result);
                    $device->{last_check} = $time;
                }
            }
            sleep(1);
        }
    }
=cut

    return (undef);
}

=head2 run(@ARGV)

=cut

sub run
{
    my $self = shift;
    my %opt  = ();

    local @ARGV = @_;
    
    printf "%s\n", join(',', @ARGV);
    my @options = @OneTool::App::DEFAULT_OPTIONS;
    push @options, 'start', 'stop';
    my $status = GetOptions(\%opt, @options);

    pod2usage(
        -exitval => 'NOEXIT', 
        -input => pod_where({-inc => 1}, __PACKAGE__)) 
        if ((!$status) || ($opt{help}));
        
    if ($opt{version})
    {
        printf "OneTool v%s\n", $OneTool::VERSION;
    }

    Daemon() if ($opt{start});
    
    return ($status);
}

1;

=head1 AUTHOR

Sebastien Thebert <contact@onetool.pm>

=cut