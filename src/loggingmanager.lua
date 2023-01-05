--!nonstrict

export type logType = "log" | "warn" | "error" | "silent_error" | "info" | "assertion" | "silent_assertion" | "trace" | "timer"

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

local logTypes = {
	["warn"] = {pattern = warnLogPattern, func = warn};
	["error"] = {pattern = errLogPattern, func = Package.errorWrapper};
	["log"] = {pattern = logPattern, func = print};
	["info"] = {pattern = infoLogPattern, func = print};
	["silent_error"] = {pattern = errLogPattern, func = warn};
	["silent_assertion"] = {pattern = errLogPattern, func = warn};
	["assertion"] = {pattern = errLogPattern, func = Package.errorWrapper};
	["trace"] = {pattern = traceLogPattern, func = print};
	["timer"] = {pattern = timerLogPattern, func = print};
}

Package.consoleLogs = {} :: {[string]: string}

-- // Functions

function Package.errorWrapper(msg: string)
	error(msg, 0)
end

function Package.logMessage(msg: string, severity: logType)
	local logType = logTypes[severity]

	logType.func(string.format(logType.pattern, msg))
	Package.consoleLogs[severity] = msg
end

function Package.clearLogs()
	table.clear(Package.consoleLogs)
end

return Package
