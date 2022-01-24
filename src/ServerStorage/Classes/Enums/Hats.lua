local Framework = _G.Framework

local newParentEnum = _G.Class:new()
newParentEnum:setName(script.Name)

function createEnum(name, desc)
	local newEnum = _G.Class:new()
	newEnum:setName(name)
	newEnum:setParent(newParentEnum)
	newEnum.object = game.ReplicatedStorage.Assets.Hats:FindFirstChild(name)
	newEnum.description = desc
	return newEnum
end

local Hats = {
	["None"] = "You don't have a hat equipped.",
	["Robber's Beanie"] = "Mask not included.",
	["Night Vision Goggles"] = "These don't work.",
	["Scoobis"] = "Scoob.",
	["Domino Crown"] = "A crown with three dominoes on the top.",
	["News Boat"] = "Back on the scene of the sinking paper boat.",
	["Ice Crown"] = "Does not give you ice powers.",
	["Hockey Mask"] = "Does this remind you of something?",
	["Boom's Antenna"] = "Boom's antenna. Character from RDC 2018's Game Jam's BOOM & FRICKO.",
	["Purple Banded Tophat"] = "Purple's specialty hat.",
	["Scuba Helmet"] = "Does not help you breathe underwater.",
	["Black Crown"] = "A tyrannical ruler.",
	["Comedy Mask"] = "Funny.",
	["Gold Gift"] = "It doesn't have anything inside.",
	["Graduate's Cap"] = "A representation of knowledge.",
	["Sparkle Time Fedora"] = "Bright and shiny.",
	["Conductor"] = "Conductor of the train? Conductor of the casino.",
	["Bees"] = "BEES! Unlocked from the Beesmas event.",
	["Mouse Ears"] = "Squeak.",
	["Wizard's Hat"] = "Doesn't give you powers.",
	["White Ninja Headband"] = "Stay stealthy.",
	["Golden Top Hat of Bling Bling"] = "What a mouthful.",
	["Dominus Messor"] = "Unlocked by the ARG, this hat allows you to use your special move infinitely. Thank you for playing D20.",
	["Leprechaun Tophat"] = "Is there gold under it? No one knows.",
	["Gygax"] = "The Legendary Egg Of Gygax. Related to D20?",
	["Purple Squid"] = "A purple squid.",
	["Christmas Hat"] = "Santa's coming soon™.",
	["Fedora"] = "M'lady.",
	["Police Cap"] = "A clever disguise.",
	["Exclusive"] = "This isn't Team Fortress 2...",
	["Traffic Cone"] = "A traffic cone.",
	["Blue Eye"] = "An eye with the color of the sea.",
	["Beret"] = "The artist's choice of headwear.",
	["Cracked Egg"] = "The Cracked Egg of Pwnage.",
	["Evil Eye"] = "He's a mean one.",
	["Bucket"] = "Menacing. One hat can tell a story.",
	["Roblox Cap"] = "A cap with an R on it.",
	["Japanese Umbrella"] = "Stylish.",
	["Fez"] = "Classy.",
	["Cowboy Hat"] = "Lasso not included.",
	["Camera"] = "Does not record.",
	["None"] = "No hat is being worn.",
	["Headphones"] = "Clockwork brand headphones.",
	["Gold Crown"] = "A fair ruler.",
	["Chef's Hat"] = "Tasty.",
	["Groover's 'Do"] = "Groovy.",
	["Arrow Gag"] = "Oh no! D20 is dead! Oh no! I got pranked!",
	["Teapot"] = "Doesn't store actual liquids.",
	["Money Cap"] = "This, ironically, was a cheap hat.",
	["Squid"] = "An orange squid.",
	["Lady Liberty's Hat"] = "'Murica.",
	["Screw"] = "This hat is NOT safe for work..",
	["Space Helmet"] = "Does not help you breathe in space.",
	["LOLcat Bible"] = "Help",
	["Soldier's Helmet"] = "Stay strong.",
	["Drama Mask"] = "Sad.",
	["Black Banded Tophat"] = "White's specialty hat.",
	["Archer's Hat"] = "Don't copyright me, Disney.",
	["T-Pose Baszucki"] = "David Baszucki t-posing at RDC '18.",
	["Bluesteel Gift"] = "It doesn't have anything inside.",
	["Tixplosion"] = "They were removed two years ago.",
	["Black Ninja Headband"] = "Stay stealthy.",
	["Lampshade"] = "We're out here partyin'.",
	["Sword Prop"] = "Oh no! D20 is dead! Oh no! I got pranked!",
	["Pot"] = "This is the only thing I need to live.",
	["Shark"] = "It's eating your head.",
	["Black & White Helmet"] = "We're not going to war, are we?",
	["Satellite"] = "Unfortunately, does not work for radar.",
	["Blue Snorkel"] = "A blue snorkel. Only decoration.",
	["The Void Star"] = "The star of the void.",
	["Dice Hat"] = "A hat made out of luck.",
	["Incognito Glasses"] = "No one will ever know.",
	["Shell"] = "So long.",
	["Red & White Visor"] = "Stylish.",
	["Fricko's Antennas"] = "Fricko's antennas. Character from RDC 2018's Game Jam's BOOM & FRICKO.",
	["Epic Duck"] = "It's coming.",
	["Blue & Black Visor"] = "Stylish.",
	["Explorer's Hat"] = "A hat for exploring the deep jungles.",
	["Storm"] = "It's a sad life.",
	["Pyramid Hat"] = "How did you get this on?",
	["Robuxplosion"] = "What are tickets?",
	["Wizard's Apprentice"] = "Doesn't give you powers.",
	["Fruit Bowl"] = "Tasty, fake, plastic fruit in a bowl.",
	["Freddy Freaker's Ears"] = "It's the Freak Phone and here's the Party Freak: Freddy Freaker! National sensation, grabbin' on the nation, doin' the freak, call now- 1-900-490-FREAK. Join the party, the fast and easy way to hear what's scarin' from New York to L.A. Call now- 1-900-490-FREAK. $2 a call.",
	["Black-white Gift"] = "It doesn't have anything inside.",
	["Purple Snorkel"] = "A purple snorkel. Only decoration.",
	["Oh No Sign"] = "Oh no!",
	["Bluesteel Helmet"] = "We're not going to war, are we?",
	["Blue-gold Gift"] = "It doesn't have anything inside.",
	["TV"] = "What's on the TV? You, of course!",
	["Red Pumpkin"] = "The typical Halloween Jack-O-Lantern.",
	["Green Pumpkin"] = "Black and green.",
	["Blue-purple Gift"] = "It doesn't have anything inside.",
	["Green Banded Tophat"] = "Green's specialty hat.",
	["Bee Hat"] = "Buzz buzz.",
	["Blue Beanie"] = "Keeps you cozy.",
	["Bubble B. Man"] = "Praise bee to the bubble.",
	["Umbrella Hat"] = "Not guaranteed to protect you from rain.",
	["Red Banded Tophat"] = "Red's specialty hat.",
	["Flower Wizard"] = "Doesn't give you powers.",
	["Green Eye"] = "An eye with the color of nature.",
	["Purple Pumpkin"] = "Black and purple.",
	["Question Mark"] = "???",
	["Red Beanie"] = "Keeps you cozy."
}

local Exclusive = {
	["Bees"] = true,
	["Dominus Messor"] = true,
	["T-Pose Baszucki"] = true
}

for i,v in next, Hats do
	local newEnum = createEnum(i,v)
	newEnum.exclusive = Exclusive[i] == true
end


return newParentEnum