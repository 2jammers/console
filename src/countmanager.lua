--!nonstrict

-- // Package

local Package = { }

-- // Variables

local loggingManager = require(script.Parent.LoggingManager)

Package.countLog = { } :: {[string]: number}

-- // Functions

function Package.logCount(label: string)
	local countLog = Package.countLog
	
	if countLog[label] then
		local cachedCount: number = nil
		
		countLog[label] += 1
		cachedCount = countLog[label]
		
		loggingManager.logMessage("count", `{label}: {cachedCount}`)
	else
		Package.countLog[label] = 1
		loggingManager.logMessage("count", `{label}: 1`)
	end
end

function Package.resetCount(label: string)
	local countLog = Package.countLog
	
	if not countLog[label] then
		return
	end
	
	countLog[label] = 0
		
	loggingManager.logMessage("count", `{label}: 0`)
end

return Package
