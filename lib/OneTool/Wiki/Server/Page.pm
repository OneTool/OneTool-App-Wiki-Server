=head1 NAME

OneTool::Wiki::Server::Page - OneTool Wiki Server Page module

=cut

package OneTool::Wiki::Server::Page;

use strict;
use warnings;

use File::Slurp;
use Git::Repository;

my $DIR_DATA = "/Users/seb/OneTool_Wiki";
Git::Repository->run(init => $DIR_DATA);
my $GIT_REPO = Git::Repository->new(work_tree => $DIR_DATA);

my $MSG_PAGE_DELETE = "Page '%s' deleted";
my $MSG_PAGE_SAVE = "Page '%s' modified";

=head1 SUBROUTINES/METHODS

=head2 Load($page)

Loads Wiki Page '$page'

=cut

sub Load
{
    my $page = shift;
    
    my $path = $page;
    $path =~ s/::/\//g; 
    my ($file_text, $file_authors, $file_tags) = map { "$DIR_DATA/${path}." . $_ } (qw/md authors tags/);
    my $text = (-r $file_text ? read_file($file_text) : '');
    #my @authors = (-r $file_authors ? read_file($file_authors) : ());
    #my @tags = (-r $file_tags ? read_file($file_tags) : ());        

    return ($text); #, \@authors, \@tags);
}

=head2 Delete($page)

Deletes Wiki Page '$page'

=cut

sub Delete
{
    my $page = shift;
    
    my $path = $page;
    $path =~ s/::/\//g; 
    $GIT_REPO->run(rm => "$DIR_DATA/${path}.md");
    $GIT_REPO->run(commit => '-m', sprintf "$MSG_PAGE_DELETE", $page);
    unlink "$DIR_DATA/${path}.txt";
    
    return ($page);
}

=head2 Save($page, $text, $tags)

Saves Wiki Page '$page'

=cut

sub Save
{
    my ($page, $text, $tags) = @_;
    
    my $path = $page;
    $path =~ s/::/\//g;
    #$tags =~ s/\s*,\s*/\n/g;
    return (undef)  
        if (!defined write_file("$DIR_DATA/${path}.md", $text));
    #write_file("$DIR_DATA/${path}.tags", $tags);
    $GIT_REPO->run(add => "$DIR_DATA/${path}.md");
    $GIT_REPO->run(commit => '-m', sprintf "$MSG_PAGE_SAVE", $page);
    
    return ($page);
}

1;

=head1 AUTHOR

Sebastien Thebert <contact@onetool.pm>

=cut