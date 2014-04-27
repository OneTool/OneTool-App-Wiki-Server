package OneTool::Wiki::Server::Command;

=head1 NAME

OneTool::Wiki::Server::Command - Module handling everything for onetool_wiki_server.pl

=head1 DESCRIPTION

Module handling everything for onetool_wiki_server.pl

=head1 SYNOPSIS

onetool_wiki_server.pl [options]

=head1 OPTIONS

=over 8

=item B<-D,--debug>

Sets Debug mode

=item B<-h,--help>

Prints this Help

=item B<-v,--version>

Prints version

=back

=cut

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

my $PROGRAM = 'onetool_wiki_server.pl';

=head1 SUBROUTINES/METHODS

=head2 Daemon_Start()

Launch OneTool Wiki Server as Daemon

=cut

sub Daemon_Start
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

Runs Command Line

=cut

sub run
{
    my $self = shift;
    my %opt  = ();

    local @ARGV = @_;
    my @options = @OneTool::App::DEFAULT_OPTIONS;
    push @options, 'start', 'stop';
    my $status = GetOptions(\%opt, @options);

    pod2usage(
        -exitval => 'NOEXIT', 
        -input => pod_where({-inc => 1}, __PACKAGE__)) 
        if ((!$status) || ($opt{help}));
        
    if ($opt{version})
    {
        printf "%s v%s\n", $PROGRAM, $OneTool::Wiki::Server::VERSION;
    }

    Daemon_Start() if ($opt{start});
    
    return ($status);
}

1;

=head1 AUTHOR

Sebastien Thebert <contact@onetool.pm>

=cut