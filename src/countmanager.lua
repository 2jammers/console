--!nonstrict

-- // Package

local Package = { }

-- // Variables

local loggingManager = require(script.Parent.LoggingManager)

Package.countLog = { } :: {[string]: number}

-- // Functions

function Package.logCount(label: string)
	local requestedCount = Package.countLog[label]
	
	if requestedCount then
		local cachedCount: number = nil
		
		requestedCount += 1
		cachedCount = requestedCount
		
		loggingManager.logMessage(string.format("%s: %d", label, cachedCount), "count")
	else
		Package.countLog[label] = 1
		loggingManager.logMessage(string.format("%s: 1", label), "count")
	end
end

function Package.resetCount(label: string)
	local requestedCount = Package.countLog[label]
	
	if requestedCount then
		requestedCount = 0
		
		loggingManager.logMessage(string.format("%s: 0", label), "count")
	else
		loggingManager.logMessage(string.format("'%s' is not a valid counter.", label), "silent_error")
	end
end

return Package
