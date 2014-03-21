#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;

my %modules = ();

parse_verilog("foo.v");
print Dumper(\%modules);
interface();

sub interface {
    my @path = ();
    my @inst_path = ("top"); # TODO: hard-coded
    my $curr_module = $modules{top}; # TODO: hard-coded

    my $prompt = "> ";

    print $prompt;
    while(<>) {
        chomp;
        my @words = split(/\s+/);

        my $num_words = $#words + 1;
        next if($num_words == 0);

        if($words[0] eq 'descend') {
            my $dest = $words[1];
            if(exists $curr_module->{instantiations}->{$dest}) {
                push @path, $curr_module;
                push @inst_path, $dest;
                my $mod_name = $curr_module->{instantiations}->{$dest}->{module};
                $curr_module = $modules{$mod_name};
            }
            else {
                print "no such instantiation\n";
            }
        }
        elsif($words[0] eq 'ascend') {
            my $parent = pop @path;
            pop @inst_path;
            if(defined $parent) {
                $curr_module = $parent;
            }
            else {
                print "current instantiation has no parent\n";
            }
        }
        elsif($words[0] eq 'ls') {
            print join("\n", keys %{$curr_module->{signals}}) . "\n";
        }
        elsif($words[0] eq 'li') {
            print join("\n", keys %{$curr_module->{instantiations}}) . "\n";
        }
        elsif($words[0] eq 'driver') {
            my $sig = $words[1];

            if(exists $curr_module->{signals}->{$sig}) {
                print $curr_module->{signals}->{$sig}->{driver} . "\n";
            }
            elsif(exists $curr_module->{inputs}->{$sig}) {
                my $parent = $path[-1];
                my $inst_name = $inst_path[-1];
                print $parent->{instantiations}->{$inst_name}->{port_map}->{$sig} . "\n";
            }
            else {
                print "$sig is not an internal signal or input\n";
            }

        }
        elsif($words[0] eq 'pwd') {
            print join('.',@inst_path) . "\n";
        }
        elsif($words[0] eq 'quit') {
            last;
        }

        print $prompt;
    }

}

sub parse_new_module {
}

sub parse_verilog {

    my $filename = shift;

    open(my $fh, "<$filename") or die $!;
    my @lines = <$fh>;
    chomp foreach @lines;
    close($fh);

    my $state = 0;
    my $state_n = 0;

    my $curr_module = '';
    my $curr_inst = '';

    foreach my $line(@lines) {

        if($state == 0) {
            if($line =~ /^\s*module\s+(\w+)\s*\(\s*$/) {
                $curr_module = $1;
                $state_n = 1;
            }
        }
        elsif($state == 1) {
            if($line =~ /^\s*input\s+(\[\d+:\d+\])?\s*(\w+)\s*,?\s*$/) {
                $modules{$curr_module}->{inputs}->{$2} = 1;
            }
            elsif($line =~ /^\s*output\s+(\[\d+:\d+\])?\s*(\w+)\s*,?\s*$/) {
                $modules{$curr_module}->{outputs}->{$2} = 1;
            }
            elsif($line =~ /^\s*\);\s*$/) {
                $state_n = 2;
            }
        }
        elsif($state == 2) {
            if($line =~ /^\s*endmodule\s*$/) {
                $state_n = 0;
            }
            elsif($line =~ /^\s*(\w+)\s+(\w+)\(\s*$/) {
                $curr_inst = $2;
                $modules{$curr_module}->{instantiations}->{$2}->{module} = $1;
                $state_n = 3;
            }
            elsif($line =~ /^\s*logic\s+(\[\d+:\d+\])?\s*(\w+)\s*;$/) {
                $modules{$curr_module}->{signals}->{$2} = {};
            }
        }
        elsif($state == 3) {
            if($line =~ /^\s*\)\s*;\s*$/) {
                $state_n = 2;
            }
            elsif($line =~ /^\s*\.(\w+)\s*\(\s*(\w+)\s*\)\s*,?\s*$/) {
                $modules{$curr_module}->{instantiations}->{$curr_inst}->{port_map}->{$1} = $2;
            }
        }

        $state = $state_n;
    }

}
