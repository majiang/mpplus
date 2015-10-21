/** An module which provides experimental API constructed over <a href="http://dlang.org/phobos/std_concurrency.html">std.concurrency</a>.
*/
module mpplus;

import std.concurrency : receive, locate, register, OwnerTerminated, ownerTid;
import std.concurrency : _spawn = spawn, _send = send;
import std.conv : to;

/** Process received messages by <var>loops</var> until a message of type <var>EndCondition</var> is received.
*/
auto until(EndCondition=OwnerTerminated, Delegates...)(Delegates loops)
{
	auto conti = true;
	while (conti)
		receive(loops,
			(EndCondition end)
		{
			conti = false;
		});
}

/** Start <var>func</var>(<var>args</var>) in a new logical thread and register the thread to <var>threadName</var>.
*/
auto spawn(alias func, ThreadName, Args...)(ThreadName threadName, Args args)
{
	threadName.to!string.register(_spawn(&func, args));
}

/** Send <var>args</var> to the thread registered as <var>threadName</var>.
*/
auto send(ThreadName, Args...)(ThreadName threadName, Args args)
{
	threadName.to!string.locate._send(args);
}

/** Send <var>args</var> to the owner thread of the current thread.
*/
auto sendOwner(Args...)(Args args)
{
	ownerTid._send(args);
}
