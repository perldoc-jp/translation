package Thread::Conveyor::Monitored;

# Make sure we have version info for this module
# Make sure we do everything by the book from now on

$VERSION = '0.12';
use strict;

# Make sure we only load stuff when we actually need it

use load;

# Make sure we have conveyor belts

use Thread::Conveyor ();

# Number of times this namespace has been CLONEd
# Allow for self referencing within monitoring thread
# Set default optimization
# Set default checkpoint frequency

our $cloned = 0;
our $BELT;
our $OPTIMIZE = 'memory';
our $FREQUENCY = 1000;

# Satisfy -require-

1;

#---------------------------------------------------------------------------

# Routines for standard Perl features

#---------------------------------------------------------------------------
#  IN: 1 namespace being cloned (ignored)

sub CLONE { $cloned++ } #CLONE

#---------------------------------------------------------------------------

# All subroutines after here are loaded on demand only

__END__

#---------------------------------------------------------------------------
#  IN: 1 instantiated object

sub DESTROY {

# Return now if we're in a rogue DESTROY

    return unless UNIVERSAL::isa( $_[0],__PACKAGE__ ); #HACK

# Obtain the object
# Return now if we're not allowed to run DESTROY

    my $self = shift;
    return unless $self->{'cloned'} == $cloned;

# Tell the monitoring thread to quit now

    $self->shutdown;
} #DESTROY

#---------------------------------------------------------------------------

# Class methods

#---------------------------------------------------------------------------
#  IN: 1 class to bless with
#      2 hash reference with parameters
#      3..N parameters to be passed to "pre" routine
# OUT: 1 instantiated object

sub new {

# Obtain the class
# Obtain the parameter hash reference and make it an object
# Save the clone level (so we can check later if we've been cloned)
# Set the default optimization to be used

    my $class = shift;
    my $self = bless shift,$class;
    $self->{'cloned'} = $cloned;
    $self->{'optimize'} ||= $OPTIMIZE;

# Obtain local copy of code to execute
# Die now if nothing specified
# Create the namespace
# If we don't have a code reference yet, make it one

    my $monitor = $self->{'monitor'};
    die "Must specify subroutine to monitor the conveyor belt" unless $monitor;
    my $namespace = caller().'::';
    $monitor = _makecoderef( $namespace,$monitor ) unless ref($monitor);

# Obtain local copy of the pre subroutine reference
# If we have one but it isn't a code reference yet, make it one
# Obtain local copy of the post subroutine reference
# If we have one but it isn't a code reference yet, make it one
# Obtain local copy of the checkpoint subroutine reference
# If we have one but it isn't a code reference yet, make it one

    my $pre = $self->{'pre'};
    $pre = _makecoderef( $namespace,$pre ) if $pre and !ref($pre);
    my $post = $self->{'post'};
    $post = _makecoderef( $namespace,$post ) if $post and !ref($post);
    my $checkpoint = $self->{'checkpoint'};
    $checkpoint = _makecoderef( $namespace,$checkpoint )
     if $checkpoint and !ref($checkpoint);

# Initialize the belt
# If we already have a belt
#  For all the special methods
#   Reloop if the field is not specified
#   Execute the method on that object

    my $belt;
    if ($belt = $self->{'belt'}) {
        foreach (qw(maxboxes minboxes)) {
            next unless exists( $self->{$_} );
            $belt->$_( $self->{$_} );
        }

# Else (we don't have a belt yet)
#  For all of the parameters that we need to pass on
#   Set the field if it was specified
#  Create a belt with these parameters

    } else {
        foreach (qw(optimize maxboxes minboxes)) {
            $belt->{$_} = $self->{$_} if exists( $self->{$_} );
        }
        $self->{'belt'} = $belt = Thread::Conveyor->new( $belt );
    }

# Create a thread monitoring the belt
# Return the blessed object

    $self->{'thread'} = threads->new(
     \&_monitor,
     $belt,
     $monitor,
     $self->{'exit'},	# don't care if not available: then undef = exit value
     $checkpoint,
     $self->{'frequency'},
     $post,
     $pre,
     @_
    );
    $self;
} #new

#---------------------------------------------------------------------------
#  IN: 1 class (ignored) or instantiated object
# OUT: 1 instantiated Thread::Conveyor::xxx object

sub belt {

# Obtain the object
# Return the appropriate belt object

    my $self = shift;
    return ref($self) ? $self->{'belt'} : $BELT;
} #belt

#---------------------------------------------------------------------------
#  IN: 1 class (ignored) or instantiated object
#      2 new default checkpoint frequency (if called as class method only)
# OUT: 1 default frequency

sub frequency {

# Obtain the object
# If called as an object method
#  Return undef if no checkpointing active
#  Return frequency with which checkpointing is occurring

    my $self = shift;
    if (ref($self)) {
        return unless $self->{'checkpoint'};
        return $self->{'frequency'} || $FREQUENCY;
    }

# Set new default frequency if specified
# Return current default frequency

    $FREQUENCY = shift if @_;
    $FREQUENCY;
} #frequency

#---------------------------------------------------------------------------
#  IN: 1 class (ignored)
#      2 new default optimization type
# OUT: 1 current default optimization type

sub optimize {

# Set new optimized value if specified
# Return current optimized value

    $OPTIMIZE = $_[1] if @_ > 1;
    $OPTIMIZE;
} #optimize

#---------------------------------------------------------------------------

# Instance methods

#---------------------------------------------------------------------------
#  IN: 1 instantiated object
#      2..N values to be placed on the belt

sub put { shift->{'belt'}->put( @_ ) } #put

#---------------------------------------------------------------------------
#  IN: 1 instantiated object (ignored)

sub take { _die() } #take

#---------------------------------------------------------------------------
#  IN: 1 instantiated object (ignored)

sub take_dontwait { _die() } #take_dontwait

#---------------------------------------------------------------------------
#  IN: 1 instantiated object (ignored)

sub clean { _die() } #clean

#---------------------------------------------------------------------------
#  IN: 1 instantiated object (ignored)

sub clean_dontwait { _die() } #clean_dontwait

#---------------------------------------------------------------------------
#  IN: 1 instantiated object (ignored)

sub peek { _die() } #peek

#---------------------------------------------------------------------------
#  IN: 1 instantiated object (ignored)

sub peek_dontwait { _die() } #peek_dontwait

#---------------------------------------------------------------------------
#  IN: 1 instantiated object
# OUT: 1 number of boxes on the belt

sub onbelt { shift->{'belt'}->onbelt( @_ ) } #onbelt

#---------------------------------------------------------------------------
#  IN: 1 instantiated object
#      2 new maximum number of boxes
# OUT: 1 current maximum number of boxes on the belt

sub maxboxes { shift->{'belt'}->maxboxes( @_ ) } #maxboxes

#---------------------------------------------------------------------------
#  IN: 1 instantiated object
#      2 new minimum number of boxes
# OUT: 1 current minimum number of boxes on the belt

sub minboxes { shift->{'belt'}->minboxes( @_ ) } #minboxes

#---------------------------------------------------------------------------
#  IN: 1 instantiated object
# OUT: 1 whatever was returned by the monitoring thread

sub shutdown {

# Obtain the object
# Return now if already shutdown
# Mark the object as shut down

    my $self = shift;
    return if exists $self->{'shutdown'};
    $self->{'shutdown'} = 1;

# Obtain the belt
# Put the exit value on the belt
# Wait for the monitoring thread to shutdown and keep its values
# Wait for the belt to shutdown
# Return whatever was returned from the monitoring thread

    my $belt = $self->{'belt'};
    $belt->put( $self->{'exit'} );
    my @return = $self->{'thread'}->join;
    $belt->shutdown;
    @return;
} #shutdown

#---------------------------------------------------------------------------
#  IN: 1 instantiated object
# OUT: 1 monitoring thread

sub thread { shift->{'thread'} } #thread

#---------------------------------------------------------------------------
#  IN: 1 instantiated object
# OUT: 1 thread id of monitoring thread

sub tid { shift->{'thread'}->tid } #tid

#---------------------------------------------------------------------------

# Internal subroutines

#---------------------------------------------------------------------------
#  IN: 1 instantiated object (ignored)

sub _die {

# Obtain the name of the caller
# Die with the name of the caller

    (my $caller = (caller(1))[3]) =~ s#^.*::##;
    die "You cannot '$caller' on a monitored conveyor belt";
} #_die

#---------------------------------------------------------------------------
#  IN: 1 namespace prefix
#      2 subroutine name
# OUT: 1 code reference

sub _makecoderef {

# Obtain namespace and subroutine name
# Prefix namespace if not fully qualified
# Return the code reference

    my ($namespace,$code) = @_;
    $code = $namespace.$code unless $code =~ m#::#;
    \&{$code};
} #_makecoderef

#---------------------------------------------------------------------------
#  IN: 1 belt object to monitor
#      2 code reference of monitoring routine
#      3 exit value
#      4 code reference of preparing routine (if available)
#      5..N parameters passed to creation routine

sub _monitor {

# Obtain the belt object
# Obtain the monitor code reference
# Obtain the exit value

    my $belt = $BELT = shift;
    my $monitor = shift;
    my $exit = shift;

# Obtain any checkpoint reference
# Obtain the frequence (if any)
# Initialize the number of boxes to be monitored

    my $checkpoint = shift;
    my $frequency = $checkpoint ? (shift || $FREQUENCY) : shift;
    my $tomonitor = $frequency;

# Obtain the post subroutine reference or create an empty one
# Obtain the preparation subroutine reference
# Execute the preparation routine if there is one

    my $post = shift || sub {};
    my $pre = shift;
    $pre->( @_ ) if $pre;

# While we're processing
#  Obtain frozen copies of all the boxes and clean the belt
#  For all of the boxes just obtained
#   If there is a defined exit value
#    Return now with result of post() if so indicated
#   Elsif found value is not defined (so same as exit value)
#    Return now with result of post()
#   Call the monitoring routine with all the values

    while( 1 ) {
        my @value = $belt->clean;
        foreach my $list (@value) {
            if (defined($exit)) {
                return $post->( @_ ) if $list->[0] eq $exit;
            } elsif (!defined( $list->[0] )) {
                return $post->( @_ );
            }
            $monitor->( @{$list} );

#   Reloop if we're not checkpointing
#   Reloop if it's not the right moment to checkpoint
#   Execute the checkpoint routine
#   Reset the number of boxes to monitor

            next unless $checkpoint;
            next if --$tomonitor;
            &$checkpoint;
            $tomonitor = $frequency;
        }
    }
} #_monitor

#---------------------------------------------------------------------------

__END__

=head1 NAME

Thread::Conveyor::Monitored - monitor a belt for specific content

=head1 SYNOPSIS

    use Thread::Conveyor::Monitored;
    my $mbelt = Thread::Conveyor::Monitored->new(
     {
      monitor => sub { print "monitoring value $_[0]\n" }, # is a must
      pre => sub { print "prepare monitoring\n" },         # optional
      post => sub { print "stop monitoring\n" },           # optional
      belt => $belt,   # use existing belt, create new if not specified
      exit => 'exit',  # defaults to undef

      checkpoint => sub { print "checkpointing\n" },
      frequency => 1000,

      optimize => 'memory', # optimization
      maxboxes => 50,       # specify throttling
      minboxes => 25,       # parameters
     }
    );

    $mbelt->put( "foo",['listref'],{'hashref'} );
    $mbelt->put( undef ); # exit value by default
    $mbelt->shutdown;

    $mthread = $mbelt->thread;
    $mtid = $mbelt->tid;

    $belt = $mbelt->belt;

    @post = $mthread->join; # optional, wait for monitor thread to end

    $belt = Thread::Conveyor::Monitored->belt; # "pre", "do", "post"

=head1 DESCRIPTION

                 *** A note of CAUTION ***

 This module only functions on Perl versions 5.8.0 and later.
 And then only when threads are enabled with -Dusethreads.
 It is of no use with any version of Perl before 5.8.0 or
 without threads enabled.

                 *************************

The C<Thread::Conveyor::Monitored> module implements a single worker thread
that takes of boxes of values from a belt created with L<Thread::Conveyor>
and which checks the boxes for specific content.

It can be used for simply logging actions that are placed on the belt. Or
only output warnings if a certain value is encountered in a box.  Or create
a safe sandbox for Perl modules that are not thread-safe yet.

The action performed in the thread, is determined by a name or reference
to a subroutine.  This subroutine is called for every box of values obtained
from the belt.

Any number of threads can safely put boxes with values and reference on the
belt.

Optional checkpointing allows you to check and save intermediate status.

=head1 CLASS METHODS

=head2 new

 $mbelt = Thread::Conveyor::Monitored->new(
  {
   pre => \&pre,
   monitor => 'monitor',
   post => \&module::post,
   belt => $belt,   # use existing belt, create new if not specified
   exit => 'exit',  # defaults to undef

   checkpoint => \&checkpoint,
   frequency => 1000,

   optimize => 'memory',
   maxboxes => 50,
   minboxes => 25,
  },
  @parameters
 );


The C<new> function creates a monitoring function on an existing or on a new
(empty) belt.  It returns the instantiated Thread::Conveyor::Monitored object.

The first input parameter is a reference to a hash that should at least
contain the "monitor" key with a subroutine reference.

The other input parameters are optional.  If specified, they are passed to the
the "pre" routine which is executed once when the monitoring is started.

The following field B<must> be specified in the hash reference:

=over 2

=item do

 monitor => 'monitor_the_belt',	# assume caller's namespace

or:

 monitor => 'Package::monitor_the_belt',

or:

 monitor => \&SomeOther::monitor_the_belt,

or:

 monitor => sub {print "anonymous sub monitoring the belt\n"},

The "monitor" field specifies the subroutine to be executed for each set of
values that is removed from the belt.  It must be specified as either the
name of a subroutine or as a reference to a (anonymous) subroutine.

The specified subroutine should expect the following parameters to be passed:

 1..N  set of values obtained from the box on the belt

What the subroutine does with the values, is entirely up to the developer.

=back

The following fields are B<optional> in the hash reference:

=over 2

=item pre

 pre => 'prepare_monitoring',		# assume caller's namespace

or:

 pre => 'Package::prepare_monitoring',

or:

 pre => \&SomeOther::prepare_monitoring,

or:

 pre => sub {print "anonymous sub preparing the monitoring\n"},

The "pre" field specifies the subroutine to be executed once when the
monitoring of the belt is started.  It must be specified as either the
name of a subroutine or as a reference to a (anonymous) subroutine.

The specified subroutine should expect the following parameters to be passed:

 1..N  any extra parameters that were passed with the call to L<new>.

=item post

 post => 'stop_monitoring',		# assume caller's namespace

or:

 post => 'Package::stop_monitoring',

or:

 post => \&SomeOther::stop_monitoring,

or:

 post => sub {print "anonymous sub when stopping the monitoring\n"},

The "post" field specifies the subroutine to be executed once when the
monitoring of the belt is stopped.  It must be specified as either the
name of a subroutine or as a reference to a (anonymous) subroutine.

The specified subroutine should expect the following parameters to be passed:

 1..N  any parameters that were passed with the call to L<new>.

Any values returned by the "post" routine, can be obtained with the C<join>
method on the thread object.

=item belt

 belt => $belt,  # create new one if not specified

The "belt" field specifies the Thread::Conveyor object that should be
monitored.  A new L<Thread::Conveyor> object will be created if it is not
specified.

=item exit

 exit => 'exit',   # defaults to undef

The "exit" field specifies the value that will cause the monitoring thread
to seize monitoring.  The "undef" value will be assumed if it is not specified.
This value should be L<put> in a box on the belt to have the monitoring thread
stop.

=item checkpoint

 checkpoint => 'checkpointing',			# assume caller's namespace

or:

 checkpoint => 'Package::checkpointing',

or:

 checkpoint => \&SomeOther::checkpointing,

or:

 checkpoint => sub {print "anonymous sub to do checkpointing\n"},

The "checkpoint" field specifies the subroutine to be executed everytime a
checkpoint should be made (e.g. for saving or updating status).  It must be
specified as either the name of a subroutine or as a reference to a
(anonymous) subroutine.

No checkpointing will occur by default.  The frequency of checkpointing can
be specified with the "frequency" field.

The specified subroutine should not expect any parameters to be passed.  Any
values returned by the checkpointing routine, will be lost.

=item frequency

 frequency => 100,                             # default = 1000

The "frequency" field specifies the number of boxes that should have been
monitored before the "checkpoint" routine is called.  If a checkpoint routine
is specified but no frequency field is specified, then a frequency of B<1000>
will be assumed.

This field has no meaning if no checkpoint routine is specified with the
"checkpoint" field.  The default frequency can be changed with the L<frequency>
method.

=item optimize

 optimize => 'cpu', # default: 'memory'

The "optimize" field specifies which implementation of the belt will be
selected if there is no existing belt specified with the 'belt' field.
Currently there are two choices: 'cpu' and 'memory'.  By default, the
"memory" optimization will be selected if no specific optmization is specified.

You can call the class method L<optimize> to change the default optimization.

=item maxboxes

 maxboxes => 50,

 maxboxes => undef,  # disable throttling

The "maxboxes" field specifies the B<maximum> number of boxes that can be
sitting on the belt to be handled (throttling).  If a new L<put> would
exceed this amount, putting of boxes will be halted until the number of
boxes waiting to be handled has become at least as low as the amount
specified with the "minboxes" field.

Fifty boxes will be assumed for the "maxboxes" field if it is not specified.
If you do not want to have any throttling, you can specify the value "undef"
for the field.  But beware!  If you do not have throttling active, you may
wind up using excessive amounts of memory used for storing all of the boxes
that have not been handled yet.

The L<maxboxes> method can be called to change the throttling settings
during the lifetime of the object.

=item minboxes

 minboxes => 25, # default: maxboxes / 2

The "minboxes" field specified the B<minimum> number of boxes that can be
waiting on the belt to be handled before the L<put>ting of boxes is allowed
again (throttling).

If throttling is active and the "minboxes" field is not specified, then
half of the "maxboxes" value will be assumed.

The L<minboxes> method can be called to change the throttling settings
during the lifetime of the object.

=back

=head2 belt

 $belt = Thread::Conveyor::Monitored->belt; # only within "pre" and "do"

The class method "belt" returns the L<Thread::Conveyor>::xxx object that this
thread is monitoring.  It is available within the "pre" and "do" subroutine
only.

=head2 frequency

 Thread::Conveyor::Monitored->frequency( 100 );

 $frequency = Thread::Conveyor::Monitored->frequency;

The "frequency" class method allows you to specify the default frequency that
will be used when a checkpoint routine is specified with the "checkpoint"
field.  The default frequency is set to B<1000> if no other value has been
previously specified.

=head2 optimize

 Thread::Conveyor::Monitored->optimize( 'cpu' );

 $optimize = Thread::Conveyor::Monitored->optimize;

The "optimize" class method allows you to specify the default optimization
type that will be used if no "optimize" field has been explicitely specified
with a call to L<new>.  It returns the current default type of optimization.

Currently two types of optimization can be selected:

=over 2

=item memory

Attempt to use as little memory as possible.  Currently, this is achieved by
starting a seperate thread which hosts an unshared array.  This uses the
"Thread::Conveyor::Thread" sub-class.

=item cpu

Attempt to use as little CPU as possible.  Currently, this is achieved by
using a shared array (using the "Thread::Conveyor::Array" sub-class),
encapsulated in a hash reference if throttling is activated (then also using
the "Thread::Conveyor::Throttled" sub-class).

=back

=head1 OBJECT METHODS

=head2 put

 $mbelt->put( $scalar,[],{} );
 $mbelt->put( 'exit' ); # stop monitoring

The "put" method freezes all specified parameters in a box and puts it on
the belt.  The monitoring thread will stop monitoring if the "exit" value
is put in the box.

Please note that if you need to be very efficient, it may be wortwhile to
extract the actual L<belt> object first and use that to put boxes on the
belt.  The monitored "put" method is in fact only a gateway to the actual
belt that is inside this object.

=head2 maxboxes

 $mbelt->maxboxes( 100 );
 $maxboxes = $mbelt->maxboxes;

The "maxboxes" method returns the maximum number of boxes that can be on the
belt before throttling sets in.  The input value, if specified, specifies the
new maximum number of boxes that may be on the belt.  Throttling will be
switched off if the value B<undef> is specified.

Specifying the "maxboxes" field when creating the object with L<new> is
equivalent to calling this method.

The L<minboxes> method can be called to specify the minimum number of boxes
that must be on the belt before the putting of boxes is allowed again after
reaching the maximum number of boxes.  By default, half of the "maxboxes"
value is assumed.

=head2 minboxes

 $mbelt->minboxes( 50 );
 $minboxes = $mbelt->minboxes;

The "minboxes" method returns the minimum number of boxes that must be on the
belt before the putting of boxes is allowed again after reaching the maximum
number of boxes.  The input value, if specified, specifies the new minimum
number of boxes that must be on the belt.

Specifying the "minboxes" field when creating the object with L<new> is
equivalent to calling this method.

The L<maxboxes> method can be called to set the maximum number of boxes that
may be on the belt before the putting of boxes will be halted.

=head2 belt

 $belt = $mbelt->belt;

The "belt" instance method returns the L<Thread::Conveyor>::xxx object that
is being monitored.

=head2 frequency

 $frequency = $mbelt->frequency;

The "frequency" instance method returns the frequency with which the checkpoint
routine is being called.  Returns undef if no checkpointing is being done.

=head2 shutdown

 $mbelt->shutdown;

 @from_monitor_thread = $mbelt->shutdown;

The "shutdown" method performs an orderly shutdown of the belt.  It waits
until all of the boxes on the belt have been removed before it returns.

Whatever was returned by the "post" routine of the monitoring thread, will
also be returned by the "shutdown" method.

=head2 thread

 $mthread = $mbelt->thread;

The "thread" method returns the thread object that is monitoring the contents
of the belt.

=head2 tid

 $tid = $mbelt->tid;

The "tid" method returns the thread id of the thread object that is monitoring
the contents of the belt.

=head1 REQUIRED MODULES

 load (any)
 Thread::Conveyor (0.15)

=head1 OPTIMIZATIONS

This module uses L<load> to reduce memory and CPU usage. This causes
subroutines only to be compiled in a thread when they are actually needed at
the expense of more CPU when they need to be compiled.  Simple benchmarks
however revealed that the overhead of the compiling single routines is not
much more (and sometimes a lot less) than the overhead of cloning a Perl
interpreter with a lot of subroutines pre-loaded.

=head1 CAVEATS

You cannot remove any boxes from the belt, as that is done by the monitoring
thread.  Therefore, the methods "take", "take_dontwait", "peek" and
"peek_dontwait" are disabled on this object.

Passing unshared values between threads is accomplished by serializing the
specified values using L<Thread::Serialize>.  Please see the CAVEATS section
there for an up-to-date status of what can be passed around between threads.

=head1 AUTHOR

Elizabeth Mattijsen, <liz@dijkmat.nl>.

Please report bugs to <perlbugs@dijkmat.nl>.

=head1 COPYRIGHT

Copyright (c) 2002-2003 Elizabeth Mattijsen <liz@dijkmat.nl>. All rights
reserved.  This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<threads>, L<threads::shared>, L<Thread::Conveyor>, L<Thread::Serialize>,
L<load>.

=cut
