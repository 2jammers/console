--!nonstrict

export type logType = "log" | "warn" | "error" | "silent_error" | "trace" | "timer" | "group" | "count" | "table"

-- // Package

local Package = { }

-- // Variables

local TestService = game:GetService("TestService")

local Settings = require(script.Parent.Parent.Settings)

local logTypes = {
	["warn"] = warn;
	["error"] = error;
	["log"] = print;
	["trace"] = print;
	["timer"] = print;
	["group"] = print;
	["count"] = print;
	["table"] = print;
}

Package.consoleLogs = {} :: {[string]: string}

-- // Functions

function Package.logMessage<a...>(t: logType, ...: a...)
	logTypes[t](...)
	Package.consoleLogs[t] = {...}
end

function Package.logSilentError<T>(msg: T)
	local thread = task.spawn(error, msg, 0)
	task.cancel(thread)
	thread = nil
	Package.consoleLogs["silent_error"] = tostring(msg)
end

function Package.logError<T>(msg: T)
	logTypes["error"](msg, 0)
	Package.consoleLogs["error"] = tostring(msg)
end

function Package.logMessageSilently<T>(msg: T)
	Package.consoleLogs["silent_log"] = tostring(msg)
end

function Package.logInfo<T>(msg: T)
	TestService:Message(tostring(msg))
end

function Package.clearLogs()
	table.clear(Package.consoleLogs)
end

return Package
