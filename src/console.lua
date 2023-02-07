--!strict

type array = {[number]: string}

--[[

	A Luau implementation of JavaScript's `console` object.

--]]

-- // Package

local Package = { }

local Assets = script.Assets
local Plugins = script.Plugins
local Settings = require(script.Settings)

-- // Variables

local timerManager = require(Assets.TimerManager)
local loggingManager = require(Assets.LoggingManager)
local utility = require(Plugins.Utility)
local countManager = require(Assets.CountManager)

-- // Functions

--[[

	Logs the provided message in the console.
	
	@param [string] msg - The message to be logged.
	@returns [void]

--]]

function Package.log<T...>(...: T...)
	loggingManager.logMessage("log", ...)
end

--[[

	Logs the provided message in the console logs list.
	
	@param [string] msg - The message to be logged.
	@returns [void]

--]]

function Package.silentLog<a>(msg: a)
	loggingManager.logMessageSilently(msg)
end

--[[

	Errors the provided message in the console.
	
	@param [string] msg - The message to be errored.
	@returns [void]

--]]

function Package.error<a>(msg: a)
	loggingManager.logError(msg)
end

--[[

	Soft-errors the provided message in the console.
	
	@param [string] msg - The message to be silently errored.
	@returns [void]

--]]

function Package.silentError<a>(msg: a)
	loggingManager.logSilentError(msg)
end

--[[

	Warns the provided message in the console.
	
	@param [string] msg - The message to be warned.
	@returns [void]

--]]

function Package.warn<T...>(...: T...)
	loggingManager.logMessage("warn", ...)
end

--[[

	Logs the provided message in the console, with an info tag.
	
	@param [string] msg - The message to be logged.
	@returns [void]

--]]

function Package.info(msg: string)
	loggingManager.logInfo(msg)
end

--[[

	Throws an error in the console if the provided value is false or nil.
	
	@param [any] assertion - The value to be asserted against.
	@param [string] msg - The message to be errored.
	@returns [any | nil] Returns the provided value if the assertion res-
	olves to true, else nil.

--]]

function Package.assert<a, b>(assertion: a, msg: b): a?
	if not (assertion) then
		loggingManager.logError(msg)
		return nil
	end
	return assertion
end

--[[

	Throws a soft-error in the console if the provided value is false or nil.
	
	@param [any] assertion - The value to be asserted against.
	@param [string] msg - The message to be silently errored.
	@returns [any | nil] Returns the provided value if the assertion res-
	olves to true, else nil.

--]]

function Package.silentAssert<a, b>(assertion: a, msg: b): a?
	if not (assertion) then
		loggingManager.logSilentError(msg)
		return nil
	end
	return assertion
end

--[[

	Starts a timer in miliseconds.
	
	@param [string] label - The name of the new timer.
	@returns [void]

--]]

function Package.time(label: string)
	timerManager.logTimer(label, os.clock())
end

--[[

	Ends the timer named `label` and logs the end time.
	
	@param [string] label - The name of the timer to end.
	@returns [void]

--]]

function Package.timeEnd(label: string)
	timerManager.requestTimer(label, os.clock(), true)
end

--[[

	Logs the current frame/time in the console.
	
	@param [string] label - The name of the timer to log.
	@returns [void]

--]]

function Package.timeLog(label: string)
	timerManager.requestTimer(label, os.clock(), false)
end

--[[

	Logs the current stack trace.
	
	@returns [void]

--]]

function Package.trace()
	loggingManager.logMessage("trace", debug.traceback("", 2))
end

--[[

	Clears the log history.
	
	@returns [void]

--]]

function Package.clear()
	loggingManager.clearLogs()
end

--[[

	Gets the log history.
	
	@returns [dictionary] - A dictionary containing the log history.
	The key is the log type, and the value is the sent log.

--]]

function Package.getLogs(): {[string]: string}
	return loggingManager.consoleLogs
end

--[[

	Gets the amount of currently running timers.
	
	@returns [number] - The amount of running timers.

--]]

function Package.getTimers(): {[string]: {isCompleted: boolean, startTime: number, endTime: number}}
	return timerManager.timerLog
end

--[[

	Creates a group of logs, with the level provided serving as how
	many levels away a log is from the console.
	
	@param [number] level - The level for each log.
	@param [table] msgs - The messages to be logged.
	@returns [void]

--]]

function Package.group<a>(level: number, msgs: {a})
	for index, log: a in ipairs(msgs) do
		loggingManager.logMessage("group", `{string.rep("-", math.round(level * 2))}> {log}"`)
	end
end

--[[

	Logs `label`'s count everytime the function is called. The number
	will increase by one every time it is called too.
	
	@param [string] label - The name of the count to log.
	@returns [void]

--]]

function Package.count(label: string?)
	label = utility.optionalParam(label, "default")
	countManager.logCount(label :: string)
end

--[[

	Resets and logs the count associated with `label`.
	
	@param [string] label - The name of the count to log and reset.
	@returns [void]

--]]

function Package.countReset(label: string?)
	label = utility.optionalParam(label, "default")
	countManager.resetCount(label :: string)
end

--[[

	Returns the counters that have been created.
	
	@returns [dictionary] Name of each counter along with its current count.

--]]

function Package.getCounters(): {[string]: number}
	return countManager.countLog
end

--[[

	Logs the provided array as a string.
	
	@param [array] data - The array to be logged as a string.
	@returns [void]

--]]

function Package.table(data: array)
	local concatenatedArray = "{"
	
	for index, value in ipairs(data) do
		if index == #data then
			concatenatedArray = `{concatenatedArray}[{index}] = "{value}"}`
		else
			concatenatedArray = `{concatenatedArray}[{index}] = "{value}", `
		end
	end
	
	loggingManager.logMessage("table", concatenatedArray)
end

return Package
