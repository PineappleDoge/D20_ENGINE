-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

return function (context, text)
	context:BroadcastEvent("Message", text, context.Executor)

	return "Created announcement."
end