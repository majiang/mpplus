import std.stdio;
import mpplus;

enum ThreadName
{
	testUntil, receiver, ownerTerminatedReceiver
}

void main()
{
	import std.concurrency : receiveOnly;
	ThreadName.testUntil.spawn!testUntil;
	receiveOnly!string;
}

void testUntil()
{
	import std.concurrency : receiveOnly;
	ThreadName.receiver.spawn!testUntilReceiver;
	foreach (i; 0..10)
		ThreadName.receiver.send(i);
	ThreadName.receiver.send(End());
	receiveOnly!string.writeln;
	"OK".sendOwner;
	ThreadName.ownerTerminatedReceiver.spawn!testUntilOwnerTerminatedReceiver;
	foreach (i; 10..20)
		ThreadName.ownerTerminatedReceiver.send(i);
	receive((OwnerTerminated ownerTerminated){});
}

auto testUntilReceiver()
{
	(int x)
	{
		x.writeln;
	}.until!End;
	"exit testUntilReceiver".sendOwner;
}
auto testUntilOwnerTerminatedReceiver()
{
	(int x)
	{
		x.writeln;
	}.until;
	"exit testUntilOwnerTerminatedReceiver".writeln;
}

struct End
{}
