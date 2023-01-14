--!nonstrict

-- // Package

local Package = { }

-- // Variables

local loggingManager = require(script.Parent.LoggingManager)

Package.timerLog = { } :: {[string]: {isCompleted: boolean; startTime: number, endTime: number}}

-- // Functions

function Package.logTimer(label: string)
	loggingManager.logMessage(string.format("%s: timer started", label), "timer")
	
	Package.timerLog[label] = {isCompleted = false, startTime = os.clock(), endTime = 0}
end

function Package.requestTimer(label: string, complete: boolean)
	local requestedTimer = Package.timerLog[label]

	if requestedTimer then
		local cachedTime: number = nil
		
		if complete then
			requestedTimer.isCompleted = true
			cachedTime = os.clock() - requestedTimer.startTime
			requestedTimer.endTime = cachedTime
			requestedTimer = nil
		else
			cachedTime = os.clock() - requestedTimer.startTime
		end
		
		loggingManager.logMessage(string.format("%s: %fms", label, cachedTime * 1000), "timer")
	else
		loggingManager.logMessage(string.format("'%s' is not a valid timer.", label), "silent_error")
	end
end

return Package
