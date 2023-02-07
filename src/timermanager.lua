--!nonstrict

-- // Package

local Package = { }

-- // Variables

local loggingManager = require(script.Parent.LoggingManager)

Package.timerLog = { } :: {[string]: {isCompleted: boolean; startTime: number; endTime: number}}

-- // Functions

function Package.logTimer(label: string, clock: number)
	Package.timerLog[label] = {isCompleted = false, startTime = clock, endTime = 0}
	
	loggingManager.logMessage("timer", `{label}: timer started`)
end

function Package.requestTimer(label: string, clock: number, complete: boolean)
	local requestedTimer = Package.timerLog[label]

	if not requestedTimer then
		return
	end
	
	local cachedTime = (clock - requestedTimer.startTime) * 1000000
		
	if complete then
		requestedTimer.isCompleted = true
		requestedTimer.endTime = cachedTime
		requestedTimer = nil
	end
	
	loggingManager.logMessage("timer", `{label}: {cachedTime}µs`)
end

return Package
