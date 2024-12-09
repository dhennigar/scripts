use ExtUtils::MakeMaker;

WriteMakefile(
	NAME		=> 'i3::Utils',
	AUTHOR		=> 'Daniel Hennigar <danrhennigar@gmail.com>',
	ABSTRACT	=> 'A collection of scripts for i3/sway',
	VERSION		=> '0.01',
	EXE_FILES	=> [glob("bin/*")],
	INSTALLSCRIPT => sub {
        	my ($from) = @_;
	        $from =~ s/\.pl$//; # Strip .pl extension for installed scripts
        	return $from;
	},
	PREREQ_PM	=> {
		'AnyEvent::I3' => 0,
	},
	clean		=> { FILES => 'i3::Utils-*' },
);
