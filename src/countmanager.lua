--!nonstrict

-- // Package

local Package = { }

-- // Variables

local loggingManager = require(script.Parent.LoggingManager)

Package.countLog = { } :: {[string]: {count: number}}

-- // Functions

function Package.logCount(label: string)
	local requestedCount = Package.countLog[label]
	
	if requestedCount then
		local cachedCount: number = nil
		
		requestedCount.count += 1
		cachedCount = requestedCount.count
		
		loggingManager.logMessage(string.format("%s: %d", label, cachedCount), "count")
	else
		Package.countLog[label] = {count = 1}
		loggingManager.logMessage(string.format("%s: 1", label), "count")
	end
end

function Package.resetCount(label: string)
	local requestedCount = Package.countLog[label]
	
	if requestedCount then
		requestedCount.count = 0
		
		loggingManager.logMessage(string.format("%s: 0", label), "count")
	else
		loggingManager.logMessage(string.format("'%s' is not a valid counter.", label), "silent_error")
	end
end

function Package.getCountLog(): {[string]: {count: number}}
	return Package.countLog
end

return Package
