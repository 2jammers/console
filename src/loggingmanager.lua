--!nonstrict

export type logType = "log" | "warn" | "error" | "silent_error" | "info" | "assertion" | "silent_assertion" | "trace" | "timer" | "group" | "count" | "table"

-- // Package

local Package = { }

-- // Variables

local Settings = require(script.Parent.Parent.Settings)

local logPattern = Settings.logPattern
local warnLogPattern = Settings.warnLogPattern
local errLogPattern = Settings.errLogPattern
local infoLogPattern = Settings.infoLogPattern
local traceLogPattern = Settings.traceLogPattern
local timerLogPattern = Settings.timerLogPattern

local function errorWrapper(msg: string)
	error(msg, 0)
end

local function silentError(msg: string)
	local thread = task.spawn(error, msg)
	task.cancel(thread)
	thread = nil
end

local logTypes = {
	["warn"] = {pattern = warnLogPattern, func = warn};
	["error"] = {pattern = errLogPattern, func = errorWrapper};
	["log"] = {pattern = logPattern, func = print};
	["info"] = {pattern = infoLogPattern, func = print};
	["silent_error"] = {pattern = errLogPattern, func = silentError};
	["silent_assertion"] = {pattern = errLogPattern, func = silentError};
	["assertion"] = {pattern = errLogPattern, func = errorWrapper};
	["trace"] = {pattern = traceLogPattern, func = print};
	["timer"] = {pattern = timerLogPattern, func = print};
	["group"] = {pattern = "%s", func = print};
	["count"] = {pattern = "%s", func = print};
	["table"] = {pattern = logPattern, func = print};
}

Package.consoleLogs = {} :: {[string]: string}

-- // Functions

function Package.logMessage(msg: string, t: logType)
	local logType = logTypes[t]

	logType.func(string.format(logType.pattern, msg))
	Package.consoleLogs[t] = msg
end

function Package.clearLogs()
	table.clear(Package.consoleLogs)
end

return Package
