--!nonstrict

-- // Package

local Package = { }

-- // Variables

local loggingManager = require(script.Parent.LoggingManager)

Package.timerLog = { } :: {[string]: {completed: boolean; frames: number}}

-- // Functions

function Package.logTimer(label: string, frames: number)
	loggingManager.logMessage(string.format("%s: timer started", label), "timer")
	
	Package.timerLog[label] = {completed = false, frames = frames}
	
	task.defer(function()
		repeat
			task.wait()
			Package.timerLog[label].frames += 1
		until
		Package.timerLog[label].completed
	end)
end

function Package.requestTimer(label: string, complete: boolean)
	local requestedTimer = Package.timerLog[label]

	if requestedTimer then
		local cachedFrames: number = nil
		
		if complete then
			requestedTimer.completed = true
			cachedFrames = requestedTimer.frames
			requestedTimer = nil
		else
			cachedFrames = requestedTimer.frames
		end
		
		loggingManager.logMessage(string.format("%s: %dfrms", label, cachedFrames), "timer")
	else
		loggingManager.logMessage(string.format("%s is not a valid timer.", label), "silent_error")
	end
end

return Package
