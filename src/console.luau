--!strict

--[[

	A Luau implementation of JavaScript's `console` object.

--]]

-- // Package

local Package = { }

local Assets = script.Assets
local Plugins = script.Plugins
local Settings = script.Settings

-- // Variables

local timerManager = require(Assets.TimerManager)
local loggingManager = require(Assets.LoggingManager)
local archUtility = require(Plugins.ArchUtility)
local dictionary = archUtility.dictionary


-- // Functions

--[[

	Logs the provided message in the console.
	
	@param [string] msg - The message to be logged.
	@returns [void]

--]]

function Package.log(msg: string)
	loggingManager.logMessage(msg, "log")
end

--[[

	Errors the provided message in the console.
	
	@param [string] msg - The message to be errored.
	@returns [void]

--]]

function Package.error(msg: string)
	loggingManager.logMessage(msg, "error")
end

--[[

	Soft-errors the provided message in the console.
	
	@param [string] msg - The message to be silently errored.
	@returns [void]

--]]

function Package.silentError(msg: string)
	loggingManager.logMessage(msg, "silent_error")
end

--[[

	Warns the provided message in the console.
	
	@param [string] msg - The message to be warned.
	@returns [void]

--]]

function Package.warn(msg: string)
	loggingManager.logMessage(msg, "warn")
end

--[[

	Logs the provided message in the console, with an info tag.
	
	@param [string] msg - The message to be logged.
	@returns [void]

--]]

function Package.info(msg: string)
	loggingManager.logMessage(msg, "info")
end

--[[

	Throws an error in the console if the provided value is false or nil.
	
	@param [any] assertion - The value to be asserted against.
	@param [string] msg - The message to be errored.
	@returns [any | nil] Returns the provided value if the assertion res-
	olves to true, else nil.

--]]

function Package.assert<a>(assertion: a, msg: string): a?
	if not (assertion) then
		loggingManager.logMessage(msg, "assertion")
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

function Package.silentAssert<a>(assertion: a, msg: string): a?
	if not (assertion) then
		loggingManager.logMessage(msg, "silent_assertion")
		return nil
	end
	return assertion
end

--[[

	Starts a timer in frames. Starts at `frames`.
	
	@param [string] label - The name of the new timer.
	@param [number] [frames=0] - The amount of frames to start the timer at.
	@returns [void]

--]]

function Package.time(label: string, frames: number?)
	frames = archUtility.optionalParameter(frames, 0)
	timerManager.logTimer(label, frames :: number)
end

--[[

	Ends the timer named `label` and logs the end time.
	
	@param [string] label - The name of the timer to end.
	@returns [void]

--]]

function Package.timeEnd(label: string)
	timerManager.requestTimer(label, true)
end

--[[

	Logs the current frame/time in the console.
	
	@param [string] label - The name of the timer to log.
	@returns [void]

--]]

function Package.timeLog(label: string)
	timerManager.requestTimer(label, false)
end

--[[

	Logs the current stack trace.
	
	@returns [void]

--]]

function Package.trace()
	loggingManager.logMessage(debug.traceback("", 2), "trace")
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

function Package.getTimers(): number
	return dictionary.getn(timerManager.timerLog)
end

return Package
