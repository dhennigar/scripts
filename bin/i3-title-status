#!/usr/bin/perl

# sway-title-status.pl --- print status info in the focused window title bar

# Copyright (c) 2024 Daniel Hennigar

# This program is free software; you can redistribute it and/or modify
# it under the terms of either:
#
#   a) the Artistic License 2.0, or
#   b) the GNU General Public License as published by the Free Software
#      Foundation; either version 3, or (at your option) any later version.
#
# See the LICENSE file for more information.

use 5.032;
use AnyEvent;
use AnyEvent::I3;

my $i3 = i3();
$i3->connect->recv or die "Error connecting to i3.";

my %batthash = (
    "Discharging" => "-",
    "Charging" => "+"
    );

sub update_and_send_commands {
    chomp(my $timestring = qx(date "+%H:%M"));
    chomp(my $battstring = qx(cat /sys/class/power_supply/BAT0/capacity));
    chomp(my $battstatus = qx(cat /sys/class/power_supply/BAT0/status));
    my $battsymbol = $batthash{$battstatus} // "";

    say "Updating title bar status info.";
    $i3->command('[all] title_format "%title"');
    $i3->command(
	'title_format "[' . $timestring . '][' . $battstring . '%' . $battsymbol . '] %title"'
	);    
}

$i3->subscribe({
    window => sub {
        my $event = shift;
        if ($event->{change} eq 'focus') {
            say "Window focus event detected.";
	    update_and_send_commands();
        }
    }
})->recv->{success} or die "Error subscribing to events.";

my $timer = AnyEvent->timer(
    after => 60,
    interval => 60,
    cb => sub {
	say "60 seconds passed.";
	update_and_send_commands();
    }
);

AE::cv->recv
