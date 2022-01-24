local Numbers = {}

function Numbers:invLerp(lerp, reqt, curt) --lerp .25 in 1/60 second, but 1/30 seconds have passed
	return 1 - (1 - lerp)^(curt/reqt)
end

return Numbers