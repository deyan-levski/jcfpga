#!/usr/bin/perl
#|------------------------------------------------------------|
#| bin2hex.pl: binary.coe to hex converter tool               |
#|------------------------------------------------------------|
#|                                                            |
#| Example: ./bin2hex.pl machine.coe -o machinecode.hex       |
#|                                                            |
#| AUTHOR:                                                    |
#| Deyan Levski, deyan.levski@eng.ox.ac.uk                    |
#|------------------------------------------------------------|
#|------------------------------------------------------------|
#| Version: A, 30-11-2016                                     |
#|------------------------------------------------------------|
#
#

use strict;
use warnings;
use Getopt::Long;
use File::Basename;
use Text::Wrap;
use Fcntl qw(SEEK_END);
use Fcntl qw(SEEK_CUR);
use Fcntl qw(SEEK_SET);

#|-------------|
#| Subroutines |
#|-------------|

# Print help
sub print_help
{
	print<<EOM;

Usage: $0 <file> [--output=<file>] [--help]

Options:
    <file>             Input machine code
    -o|--output <file> Output machine code 
    -h|--help          Help

EOM
}

# Get a line,
sub get_line
{
	my $filehandle = shift;
	my $line_ptr = shift;
	my $this_line = ${$line_ptr};
	LINE: while (defined(${$line_ptr} = <$filehandle>))
	{
		chomp(${$line_ptr});
		last LINE;
	}
	return $this_line;
}

# Print line and fold
sub print_line
{

	my($filehandle, $line) = @_;
	if ($line =~/^\s*$/){	# don't print empty lines / unrecognized instructions
	}
	else
	{
		print {$filehandle} $line;
	}
}

sub b2h {
    my $num   = shift;
    my $WIDTH = 32;
    my $index = length($num) - $WIDTH;
    my $hex = '';
    do {
        my $width = $WIDTH;
        if ($index < 0) {
            $width += $index;
            $index = 0;
        }
        my $cut_string = substr($num, $index, $width);
        $hex = sprintf('%8X', oct("0b$cut_string")) . $hex;
	$hex=~ tr/ /0/; # add leading zeros
        $index -= $WIDTH;
    } while ($index > (-1 * $WIDTH));
    return $hex;
}

#|------|
#| Main |
#|------|
#
my $help_flag = '';
my $ofile_flag = '';
my $ifname = '';
my $ifpath = '';
my $ifsuffix = '';
my $ofname = '';
my $ofpath = '';
my $ofsuffix = '';
#
# Parse command line arguments
GetOptions('h|help'     => \$help_flag,
	'o|output=s' => \$ofile_flag)
	or exit 1;

if ($help_flag || $#ARGV lt 0)
{
	print_help();
	exit;
}

($ifname, $ifpath, $ifsuffix) = fileparse($ARGV[0],'.bin') or exit 1;
if ($ofile_flag)
{
	($ofname, $ofpath, $ofsuffix) = fileparse($ofile_flag,'.hex') or exit 1; # default extension
}
else
{
	$ofname = $ifname . '.bin';
	$ofpath = $ifpath;
	$ofsuffix = $ifsuffix;
}

# Open files
open(my $ifile, "<" . $ifpath . $ifname . $ifsuffix) or die $!;
open(my $ofile, ">" . $ofpath . $ofname . $ofsuffix) or die $!;

# Parse input file
my $prev_line = <$ifile>;
my $line = '';
my $parsd_line = '';
my $lst_line = '';
my $prnt_flag = '';
my $ld_flag = '';
my $ld_flag_old = '';
my $parsd_line_hex = '';

#|----------------|
#| Prepare header |
#|----------------|
#

while (defined($line = get_line($ifile, \$prev_line)))    # for every line
{ 

			if ($line =~ m/.*memory.*/) {
			   # Do nothing
			}
			else{
			$line=~ s/,//g; # add remove trailing commas
			$line=~ s/;//g; # add remove trailing commas
			$line=~ s/^.*memory.*//s; # remove lines with memory

				$parsd_line_hex = b2h($line);
				print_line($ofile,$parsd_line_hex);
			}
}
# Print last word one more time (4 bytes)
			print_line($ofile,$parsd_line_hex);

# Close files
close($ifile);
close($ofile);
