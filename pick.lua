#!/usr/bin/env lua
-- [[
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
	DEBUG = true
	DEBUG_PLAYER_MODE = "1"
	-- DEBUG_RARE_FISH_STRING = "1 2 3 4 5 6 7 8 9 10 11 12"
	-- DEBUG_RARE_FISH_STRING = "1 3 5 7 9 11"
	DEBUG_RARE_FISH_STRING = ""
	DEBUG_PLAYER_LURES_STRING = "9 7 8 6 10 11 3 3 9 1"
end
--]]

local playerModes = {
	"medals",
	"top 10",
}

local rankings = require("rankings")
local progressMedals = require("progress_medals")
local progressTop10 = require("progress_top10")

-- medal ranking requirements
local medals = {
	bronze = rankings.bcd,
	silver = rankings.a,
	gold = rankings.a_plus,
}

local scoreFactors = {
	rare = 10,
	[medals.bronze] = 4,
	[medals.silver] = 2,
	[medals.gold] = 1,
}

local colors = {
	"bk", -- black
	"wt", -- white
	"br", -- brown
	"pp", -- purple
	"pk", -- pink
	"lb", -- light blue
	"bl", -- blue
	"gr", -- green
	"lg", -- light green
	"yl", -- yellow
	"or", -- orange
	"rd", -- red
}

local locations = {
	{
		name = "Beginner's Point",
		island = "Prelude Island",
		fish = {
			"Sardine",
			"Black Rockfish",
			"Largescale Blackfish",
			"Japanese Sea Bass",
			"Black Sea Bream",
		},
	},
	{
		name = "Greenhorn River",
		island = "Prelude Island",
		fish = {
			"Dace",
			"Pale Chub",
			"Dark Chub",
			"Rainbow Trout",
		},
	},
	{
		name = "Cypress Lake",
		island = "Prelude Island",
		fish = {
			"Bluegill",
			"Crucian Carp",
			"Crayfish",
			"Smallmouth Bass",
		},
	},
	{
		name = "Prelude Bay Cruise",
		island = "Prelude Island",
		fish = {
			"Japanese Whiting",
			"Pacific Saury",
			"Chicken Grunt",
			"Skipjack Tuna",
			"Red Sea Bream",
			"Leedsichthys",
		},
	},
	{
		name = "Cove Sands",
		island = "Lobe Island",
		fish = {
			"Blue Bat Star",
			"Filefish",
			"Barracuda",
			"Righteye Flounder",
		},
	},
	{
		name = "Copse Pool",
		island = "Lobe Island",
		fish = {
			"Tadpole",
			"Spined Loach",
			"Dark Sleeper",
			"Common Carp",
		},
	},
	{
		name = "Verthaven Pier",
		island = "Lobe Island",
		fish = {
			"Mackerel",
			"Pacific Herring",
			"Japanese Horse Mackerel",
			"Largehead Hairtail",
			"Japanese Spanish Mackerel",
		},
	},
	{
		name = "Peaceful Lake",
		island = "Lobe Island",
		fish = {
			"Crucian Carp",
			"Bluegill",
			"Chinese Softshell Turtle",
			"Catfish",
		},
	},
	{
		name = "Brumefall River",
		island = "Lobe Island",
		fish = {
			"Pale Chub",
			"Dark Chub",
			"Iwana Trout",
			"Rainbow Trout",
			"Rhizodus",
		},
	},
	{
		name = "Keyhole Cliffs",
		island = "Ossein Island",
		fish = {
			"Forktongue Goby",
			"Lionfish",
			"Filefish",
			"Blue Tang",
			"Moray Eel",
		},
	},
	{
		name = "Mossmeadow Marsh",
		island = "Ossein Island",
		fish = {
			"Spined Loach",
			"Crucian Carp",
			"American Bullfrog",
			"Smallmouth Bass",
			"Largemouth Bass",
		},
	},
	{
		name = "Raynesse Falls",
		island = "Ossein Island",
		fish = {
			"Dace",
			"Iwana Trout",
			"Sweetfish",
			"Chum Salmon",
		},
	},
	{
		name = "Graupel Pier",
		island = "Ossein Island",
		fish = {
			"Pacific Herring",
			"Japanese Horse Mackerel",
			"Black Rabbitfish",
			"Okhotsk Atka Mackerel",
			"Tiger Pufferfish",
		},
	},
	{
		name = "Berg Cruise",
		island = "Ossein Island",
		fish = {
			"Pacific Saury",
			"Spear Squid",
			"Red King Crab",
			"Alaska Pollack",
			"Yellowtail",
			"Dunkleosteus",
		},
	},
	{
		name = "Tail Point",
		island = "The Isle of Loch",
		fish = {
			"Filefish",
			"Pennant Coralfish",
			"Convict Tang",
			"Black Sea Bream",
			"Barred Knifejaw",
		},
	},
	{
		name = "Souwester Rocks",
		island = "The Isle of Loch",
		fish = {
			"Black Rabbitfish",
			"Barracuda",
			"Boxfish",
			"Okhotsk Atka Mackerel",
			"Flathead Mullet",
		},
	},
	{
		name = "Craggy Tarn",
		island = "The Isle of Loch",
		fish = {
			"American Bullfrog",
			"Dark Sleeper",
			"Yellow Perch",
			"Pike",
		},
	},
	{
		name = "Cardia Lake",
		island = "The Isle of Loch",
		fish = {
			"Tadpole",
			"Spined Loach",
			"Chinese Softshell Turtle",
			"Snakehead",
			"Golden Bass",
		},
	},
	{
		name = "Maple Burn",
		island = "The Isle of Loch",
		fish = {
			"Iwana Trout",
			"Sweetfish",
			"Cherry Salmon",
			"Rainbow Trout",
			"Iridescent Shark",
		},
	},
	{
		name = "Loch Placid",
		island = "The Isle of Loch",
		fish = {
			"Crucian Carp",
			"Bluegill",
			"Yellow Perch",
			"Snakehead",
			"Pike",
			"Nessie",
		},
	},
	{
		name = "Dayton Point",
		island = "Titan Island",
		fish = {
			"Mackerel",
			"Boxfish",
			"Porcupinefish",
			"Common Octopus",
			"Flounder",
		},
	},
	{
		name = "Oldmead Pond",
		island = "Titan Island",
		fish = {
			"Tadpole",
			"American Bullfrog",
			"Crayfish",
			"Smallmouth Bass",
			"Eel",
		},
	},
	{
		name = "Kohu Lake",
		island = "Titan Island",
		fish = {
			"Crucian Carp",
			"Dark Sleeper",
			"Chinese Softshell Turtle",
			"Koi",
			"Golden Koi",
		},
	},
	{
		name = "Wisply Falls",
		island = "Titan Island",
		fish = {
			"Iwana Trout",
			"Sweetfish",
			"Cherry Salmon",
			"Rainbow Trout",
			"Chinook Salmon",
		},
	},
	{
		name = "Greydale Lake",
		island = "Titan Island",
		fish = {
			"Crucian Carp",
			"Bluegill",
			"Yellow Perch",
			"Smallmouth Bass",
			"Lake Trout",
		},
	},
	{
		name = "Fretfield Moor",
		island = "Titan Island",
		fish = {
			"Tadpole",
			"Spined Loach",
			"Crayfish",
			"Saddled Bichir",
			"Wels Catfish",
		},
	},
	{
		name = "Icebarrow Point",
		island = "Titan Island",
		fish = {
			"Pacific Saury",
			"Spear Squid",
			"Snow Crab",
			"Pacific Cod",
			"Kronosaurus",
			"Giant Squid",
		},
	},
	{
		name = "Seraphia Pier",
		island = "Wyrm Island",
		fish = {
			"Largescale Blackfish",
			"Black Rabbitfish",
			"Porcupinefish",
			"Largehead Hairtail",
			"Japanese Bullhead Shark",
			"North Pacific Giant Octopus",
		},
	},
	{
		name = "Clarion Lake",
		island = "Wyrm Island",
		fish = {
			"Crucian Carp",
			"Bluegill",
			"Stickleback",
			"Smallmouth Bass",
			"Alligator Snapping Turtle",
		},
	},
	{
		name = "Elin Rapids",
		island = "Wyrm Island",
		fish = {
			"Pale Chub",
			"Dark Chub",
			"Cherry Salmon",
			"Rainbow Trout",
			"Taimen",
		},
	},
	{
		name = "Aruna Rocks",
		island = "Wyrm Island",
		fish = {
			"Convict Tang",
			"Pennant Coralfish",
			"Indo-Pacific Sergeant",
			"Garfish",
			"Longtooth Grouper",
			"Tarpon",
		},
	},
	{
		name = "Sunset Cruise",
		island = "Wyrm Island",
		fish = {
			"Chicken Grunt",
			"Red Gurnard",
			"Japanese Spider Crab",
			"Mahi-Mahi",
			"Bluefin Tuna",
			"Golden Tuna",
		},
	},
	{
		name = "Wyverdun Lake",
		island = "Wyrm Island",
		fish = {
			"Bluegill",
			"Chinese Softshell Turtle",
			"Clown Loach",
			"Eel",
			"Lake Trout",
			"Dragon",
		},
	},
	{
		name = "Gloaming Reef",
		island = "The Isle of Envy",
		fish = {
			"Butterflyfish",
			"Clownfish",
			"Little Dragonfish",
			"Japanese Bullhead Shark",
			"Scalloped Hammerhead",
		},
	},
	{
		name = "Foxmere Lake",
		island = "The Isle of Envy",
		fish = {
			"Dark Sleeper",
			"Crayfish",
			"Yellow Perch",
			"Smallmouth Bass",
			"Alligator Gar",
		},
	},
	{
		name = "Bridgcliff Beach",
		island = "The Isle of Envy",
		fish = {
			"Porcupinefish",
			"Spiny Lobster",
			"Seahorse",
			"Garfish",
			"Humphead Wrasse",
			"Cheep Cheep",
		},
	},
	{
		name = "Sunset Sea Cruise",
		island = "The Isle of Envy",
		fish = {
			"Japanese Whiting",
			"Spear Squid",
			"Amberjack",
			"Splendid Alfonsino",
			"Coelacanth",
			"Golden Bream",
		},
	},
	{
		name = "Mauvain Cove",
		island = "The Isle of Envy",
		fish = {
			"Forktongue Goby",
			"Orange-Striped Emperor",
			"Pinecone Fish",
			"Horseshoe Crab",
			"Great White Shark",
			"Golden Shark",
		},
	},
	{
		name = "Hazeldown River",
		island = "The Isle of Envy",
		fish = {
			"Dace",
			"Pale Chub",
			"Dark Chub",
			"Stringfish",
			"Golden Rainbow Trout",
		},
	},
	{
		name = "Aurora Sea Cruise",
		island = "The Isle of Envy",
		fish = {
			"Pacific Saury",
			"Red King Crab",
			"Snow Crab",
			"Frilled Shark",
			"Footballfish",
			"Leviathan",
		},
	},
	{
		name = "Rainbow Sea Cruise",
		island = "Marinus Island",
		fish = {
			"Flapjack Octopus",
			"Giant Isopod",
			"Flying Fish",
			"Sawshark",
			"Marlin",
			"Golden Marlin",
		},
	},
	{
		name = "Seacut Cave",
		island = "Marinus Island",
		fish = {
			"Spiny Lobster",
			"Longnose Hawkfish",
			"Koran Angelfish",
			"Garfish",
			"Tawny Nurse Shark",
			"Blooper",
		},
	},
	{
		name = "Thunderhead Falls",
		island = "Marinus Island",
		fish = {
			"Piranha",
			"Siamese Fighting Fish",
			"Dwarf Gourami",
			"Northern Barramundi",
			"Arowana",
		},
	},
	{
		name = "Cypress Swamp",
		island = "Marinus Island",
		fish = {
			"Piranha",
			"Dwarf Gourami",
			"Angelfish",
			"Dorado",
			"Gigantic Carp",
		},
	},
	{
		name = "Slatecrest Sea Cruise",
		island = "Marinus Island",
		fish = {
			"Japanese Whiting",
			"Flying Fish",
			"Mediterranean Dealfish",
			"Whale Shark",
			"Kraken",
			"Giant Oarfish",
		},
	},
	{
		name = "Crystal Seas Cruise",
		island = "Mysteria Island",
		fish = {
			"Red Gurnard",
			"Viperfish",
			"Gulper Eel",
			"Sunfish",
			"Manta Ray",
			"Spotted Eagle Ray",
		},
	},
	{
		name = "Greybanks River",
		island = "Mysteria Island",
		fish = {
			"Iwana Trout",
			"Sweetfish",
			"Cherry Salmon",
			"Rainbow Trout",
			"Beluga",
			"Golden Salmon",
		},
	},
	{
		name = "Mangrow Bayou",
		island = "Mysteria Island",
		fish = {
			"Piranha",
			"Siamese Fighting Fish",
			"Ocellate River Stingray",
			"Nile Perch",
			"Giant Freshwater Stingray",
		},
	},
	{
		name = "Ironfalls Gorge",
		island = "Mysteria Island",
		fish = {
			"Dwarf Gourami",
			"Elephantnose Fish",
			"Angelfish",
			"Electric Eel",
			"Arapaima",
		},
	},
	{
		name = "Enigma Cave",
		island = "Mysteria Island",
		fish = {
			"Stickleback",
			"Giant Pikehead",
			"Alligator Snapping Turtle",
			"Saddled Bichir",
			"African Lungfish",
			"UFO",
		},
	},
}

local fishes = {
	["Sardine"] = { colors = { ["wt"] = 1, ["pk"] = 1, ["lb"] = 1, ["lg"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "Coastal" },
	["Black Rockfish"] = { colors = { ["bk"] = 1, ["lb"] = 1, ["bl"] = 1, ["gr"] = 1, ["or"] = 1 }, type = "Coastal" },
	["Largescale Blackfish"] = { colors = { ["pk"] = 1, ["lb"] = 1, ["bl"] = 1, ["lg"] = 1, ["or"] = 1 }, type = "Coastal" },
	["Dace"] = { colors = { ["pk"] = 1, ["lb"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "River" },
	["Pale Chub"] = { colors = { ["br"] = 1, ["bl"] = 1, ["rd"] = 1 }, type = "River" },
	["Dark Chub"] = { colors = { ["pp"] = 1, ["lb"] = 1, ["bl"] = 1, ["gr"] = 1 }, type = "River" },
	["Bluegill"] = { colors = { ["bk"] = 1, ["pk"] = 1, ["lb"] = 1, ["bl"] = 1 }, type = "Stillwater" },
	["Crucian Carp"] = { colors = { ["lb"] = 1, ["bl"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "Stillwater" },
	["Crayfish"] = { colors = { ["wt"] = 1, ["lb"] = 1, ["lg"] = 1, ["yl"] = 1, ["rd"] = 1 }, type = "Stillwater" },
	["Japanese Whiting"] = { colors = { ["br"] = 1, ["lb"] = 1, ["rd"] = 1 }, type = "Deep Sea" },
	["Pacific Saury"] = { colors = { ["wt"] = 1, ["lb"] = 1, ["bl"] = 1, ["lg"] = 1 }, type = "Deep Sea" },
	["Chicken Grunt"] = { colors = { ["gr"] = 1, ["lg"] = 1, ["rd"] = 1 }, type = "Deep Sea" },
	["Blue Bat Star"] = { colors = { ["bl"] = 1, ["rd"] = 1 }, type = "Coastal" },
	["Filefish"] = { colors = { ["bk"] = 1, ["br"] = 1, ["pp"] = 1, ["pk"] = 1, ["gr"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["Barracuda"] = { colors = { ["bk"] = 1, ["lb"] = 1, ["bl"] = 1, ["or"] = 1 }, type = "Coastal" },
	["Tadpole"] = { colors = { ["bl"] = 1, ["rd"] = 1 }, type = "Stillwater" },
	["Spined Loach"] = { colors = { ["pp"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "Stillwater" },
	["Dark Sleeper"] = { colors = { ["bl"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "Stillwater" },
	["Mackerel"] = { colors = { ["wt"] = 1, ["bl"] = 1, ["rd"] = 1 }, type = "Coastal" },
	["Pacific Herring"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["bl"] = 1, ["or"] = 1 }, type = "Coastal" },
	["Japanese Horse Mackerel"] = { colors = { ["wt"] = 1, ["br"] = 1, ["lb"] = 1, ["gr"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "Coastal" },
	["Iwana Trout"] = { colors = { ["wt"] = 1, ["yl"] = 1, ["rd"] = 1 }, type = "River" },
	["Forktongue Goby"] = { colors = { ["bk"] = 1, ["pk"] = 1, ["lg"] = 1, ["rd"] = 1 }, type = "Coastal" },
	["Lionfish"] = { colors = { ["pp"] = 1, ["pk"] = 1, ["bl"] = 1, ["lg"] = 1 }, type = "Coastal" },
	["American Bullfrog"] = { colors = { ["bk"] = 1, ["br"] = 1, ["rd"] = 1 }, type = "Stillwater" },
	["Black Rabbitfish"] = { colors = { ["br"] = 1, ["pp"] = 1, ["rd"] = 1 }, type = "Coastal" },
	["Spear Squid"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["lg"] = 1, ["rd"] = 1 }, type = "Deep Sea" },
	["Pennant Coralfish"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["br"] = 1, ["bl"] = 1, ["gr"] = 1 }, type = "Coastal" },
	["Convict Tang"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["bl"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["Yellow Perch"] = { colors = { ["bk"] = 1, ["yl"] = 1, ["rd"] = 1 }, type = "Stillwater" },
	["Indo-Pacific Sergeant"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["lb"] = 1, ["lg"] = 1, ["or"] = 1 }, type = "Coastal" },
	["Butterflyfish"] = { colors = { ["pk"] = 1, ["yl"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "Coastal" },
	["Piranha"] = { colors = { ["bk"] = 1, ["br"] = 1, ["pp"] = 1, ["rd"] = 1 }, type = "River" },
	["Siamese Fighting Fish"] = { colors = { ["lb"] = 1, ["rd"] = 1 }, type = "River" },
	["Dwarf Gourami"] = { colors = { ["pk"] = 1, ["rd"] = 1 }, type = "River" },
	["Chinese Softshell Turtle"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["yl"] = 1, ["or"] = 1 }, type = "Stillwater" },
	["Blue Tang"] = { colors = { ["wt"] = 1, ["bl"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["Sweetfish"] = { colors = { ["wt"] = 1, ["lb"] = 1, ["bl"] = 1 }, type = "River" },
	["Red King Crab"] = { colors = { ["pp"] = 1, ["lb"] = 1, ["or"] = 1 }, type = "Deep Sea" },
	["Boxfish"] = { colors = { ["wt"] = 1, ["bl"] = 1, ["gr"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["Cherry Salmon"] = { colors = { ["wt"] = 1, ["bl"] = 1, ["gr"] = 1, ["lg"] = 1 }, type = "River" },
	["Porcupinefish"] = { colors = { ["pp"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["Snow Crab"] = { colors = { ["br"] = 1, ["pk"] = 1, ["lb"] = 1, ["or"] = 1 }, type = "Deep Sea" },
	["Red Gurnard"] = { colors = { ["pk"] = 1, ["rd"] = 1 }, type = "Deep Sea" },
	["Clown Loach"] = { colors = { ["bk"] = 1, ["pk"] = 1, ["lg"] = 1, ["or"] = 1 }, type = "Stillwater" },
	["Clownfish"] = { colors = { ["wt"] = 1, ["gr"] = 1, ["lg"] = 1, ["or"] = 1 }, type = "Coastal" },
	["Little Dragonfish"] = { colors = { ["pp"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["Orange-Striped Emperor"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["bl"] = 1 }, type = "Coastal" },
	["Longnose Hawkfish"] = { colors = { ["wt"] = 1, ["pk"] = 1, ["bl"] = 1 }, type = "Coastal" },
	["Koran Angelfish"] = { colors = { ["pk"] = 1, ["bl"] = 1, ["lg"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["Flying Fish"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["pp"] = 1, ["lb"] = 1 }, type = "Deep Sea" },
	["Elephantnose Fish"] = { colors = { ["bk"] = 1, ["lb"] = 1, ["or"] = 1 }, type = "River" },
	["Angelfish"] = { colors = { ["lb"] = 1, ["bl"] = 1 }, type = "River" },
	["Giant Pikehead"] = { colors = { ["bl"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1 }, type = "Stillwater" },
	["Stickleback"] = { colors = { ["br"] = 1, ["gr"] = 1, ["yl"] = 1 }, type = "Stillwater" },
	["Spiny Lobster"] = { colors = { ["bk"] = 1, ["gr"] = 1, ["lg"] = 1 }, type = "Coastal" },
	["Seahorse"] = { colors = { ["br"] = 1, ["gr"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["Pinecone Fish"] = { colors = { ["br"] = 1, ["pp"] = 1, ["gr"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["Flapjack Octopus"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["yl"] = 1 }, type = "Deep Sea" },
	["Giant Isopod"] = { colors = { ["br"] = 1, ["or"] = 1 }, type = "Deep Sea" },
	["Viperfish"] = { colors = { ["br"] = 1, ["gr"] = 1, ["yl"] = 1 }, type = "Deep Sea" },
	["Ocellate River Stingray"] = { colors = { ["bk"] = 1, ["pp"] = 1 }, type = "River" },
	["Japanese Sea Bass"] = { colors = { ["pp"] = 1, ["gr"] = 1, ["lg"] = 1, ["rd"] = 1 }, type = "Coastal" },
	["Black Sea Bream"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["br"] = 1, ["pk"] = 1, ["lb"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["Rainbow Trout"] = { colors = { ["wt"] = 1, ["bl"] = 1, ["gr"] = 1, ["yl"] = 1 }, type = "River" },
	["Smallmouth Bass"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["bl"] = 1, ["lg"] = 1 }, type = "Stillwater" },
	["Skipjack Tuna"] = { colors = { ["lb"] = 1, ["bl"] = 1, ["lg"] = 1 }, type = "Deep Sea" },
	["Righteye Flounder"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["pk"] = 1, ["bl"] = 1 }, type = "Coastal" },
	["Common Carp"] = { colors = { ["pp"] = 1, ["gr"] = 1, ["yl"] = 1, ["rd"] = 1 }, type = "Stillwater" },
	["Largehead Hairtail"] = { colors = { ["pk"] = 1, ["lb"] = 1, ["bl"] = 1 }, type = "Coastal" },
	["Japanese Spanish Mackerel"] = { colors = { ["pp"] = 1, ["pk"] = 1, ["gr"] = 1, ["lg"] = 1, ["or"] = 1 }, type = "Coastal" },
	["Catfish"] = { colors = { ["bk"] = 1, ["br"] = 1, ["yl"] = 1, ["rd"] = 1 }, type = "Stillwater" },
	["Largemouth Bass"] = { colors = { ["wt"] = 1, ["bl"] = 1, ["yl"] = 1, ["rd"] = 1 }, type = "Stillwater" },
	["Okhotsk Atka Mackerel"] = { colors = { ["wt"] = 1, ["lb"] = 1, ["bl"] = 1 }, type = "Coastal" },
	["Alaska Pollack"] = { colors = { ["br"] = 1, ["pp"] = 1, ["rd"] = 1 }, type = "Deep Sea" },
	["Flathead Mullet"] = { colors = { ["gr"] = 1, ["yl"] = 1, ["rd"] = 1 }, type = "Coastal" },
	["Northern Barramundi"] = { colors = { ["br"] = 1, ["pk"] = 1, ["rd"] = 1 }, type = "River" },
	["Yellowtail"] = { colors = { ["br"] = 1, ["lb"] = 1, ["bl"] = 1 }, type = "Deep Sea" },
	["Barred Knifejaw"] = { colors = { ["bk"] = 1, ["br"] = 1, ["pp"] = 1, ["gr"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["Moray Eel"] = { colors = { ["bk"] = 1, ["pk"] = 1, ["lg"] = 1, ["or"] = 1 }, type = "Coastal" },
	["Chum Salmon"] = { colors = { ["wt"] = 1, ["pk"] = 1, ["lg"] = 1, ["or"] = 1 }, type = "River" },
	["Tiger Pufferfish"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["br"] = 1 }, type = "Coastal" },
	["Pike"] = { colors = { ["lb"] = 1, ["gr"] = 1, ["or"] = 1 }, type = "Stillwater" },
	["Snakehead"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["lb"] = 1, ["lg"] = 1 }, type = "Stillwater" },
	["Iridescent Shark"] = { colors = { ["br"] = 1, ["bl"] = 1, ["or"] = 1 }, type = "River" },
	["Flounder"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["yl"] = 1, ["or"] = 1 }, type = "Coastal" },
	["Eel"] = { colors = { ["pp"] = 1, ["bl"] = 1, ["gr"] = 1 }, type = "Stillwater" },
	["Chinook Salmon"] = { colors = { ["br"] = 1, ["pk"] = 1, ["lb"] = 1 }, type = "River" },
	["Lake Trout"] = { colors = { ["bk"] = 1, ["pk"] = 1, ["lg"] = 1, ["or"] = 1 }, type = "Stillwater" },
	["Saddled Bichir"] = { colors = { ["bk"] = 1, ["br"] = 1, ["lg"] = 1, ["or"] = 1 }, type = "Stillwater" },
	["Pacific Cod"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["pk"] = 1, ["yl"] = 1 }, type = "Deep Sea" },
	["Japanese Bullhead Shark"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["Common Octopus"] = { colors = { ["wt"] = 1, ["br"] = 1, ["pk"] = 1, ["yl"] = 1, ["or"] = 1 }, type = "Coastal" },
	["Alligator Snapping Turtle"] = { colors = { ["pp"] = 1, ["gr"] = 1, ["yl"] = 1 }, type = "Stillwater" },
	["Taimen"] = { colors = { ["pk"] = 1, ["lg"] = 1, ["or"] = 1 }, type = "River" },
	["Garfish"] = { colors = { ["rd"] = 1 }, type = "Coastal" },
	["Longtooth Grouper"] = { colors = { ["pk"] = 1, ["lb"] = 1, ["gr"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["Tarpon"] = { colors = { ["bk"] = 1, ["br"] = 1, ["pk"] = 1 }, type = "Coastal" },
	["Red Sea Bream"] = { colors = { ["bl"] = 1, ["yl"] = 1 }, type = "Deep Sea" },
	["Japanese Spider Crab"] = { colors = { ["lb"] = 1, ["or"] = 1 }, type = "Deep Sea" },
	["Mahi-Mahi"] = { colors = { ["bk"] = 1, ["pk"] = 1, ["gr"] = 1, ["yl"] = 1 }, type = "Deep Sea" },
	["Amberjack"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["or"] = 1 }, type = "Deep Sea" },
	["Splendid Alfonsino"] = { colors = { ["pk"] = 1, ["yl"] = 1, ["or"] = 1 }, type = "Deep Sea" },
	["Sawshark"] = { colors = { ["pk"] = 1, ["lb"] = 1 }, type = "Deep Sea" },
	["Arowana"] = { colors = { ["lb"] = 1, ["yl"] = 1, ["or"] = 1 }, type = "River" },
	["Dorado"] = { colors = { ["br"] = 1, ["pk"] = 1, ["gr"] = 1, ["yl"] = 1, ["or"] = 1 }, type = "River" },
	["Nile Perch"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["pk"] = 1, ["or"] = 1 }, type = "River" },
	["Koi"] = { colors = { ["pk"] = 1, ["lg"] = 1 }, type = "Stillwater" },
	["Humphead Wrasse"] = { colors = { ["br"] = 1, ["gr"] = 1, ["lg"] = 1 }, type = "Coastal" },
	["Horseshoe Crab"] = { colors = { ["wt"] = 1, ["gr"] = 1 }, type = "Coastal" },
	["Coelacanth"] = { colors = { ["pk"] = 1, ["lg"] = 1 }, type = "Deep Sea" },
	["Stringfish"] = { colors = { ["br"] = 1, ["pk"] = 1 }, type = "River" },
	["Footballfish"] = { colors = { ["br"] = 1, ["lb"] = 1 }, type = "Deep Sea" },
	["Frilled Shark"] = { colors = { ["wt"] = 1, ["br"] = 1 }, type = "Deep Sea" },
	["Gigantic Carp"] = { colors = { ["bk"] = 1, ["lg"] = 1 }, type = "River" },
	["Mediterranean Dealfish"] = { colors = { ["wt"] = 1, ["br"] = 1 }, type = "Deep Sea" },
	["Gulper Eel"] = { colors = { ["bk"] = 1, ["bl"] = 1 }, type = "Deep Sea" },
	["Electric Eel"] = { colors = { ["br"] = 1, ["lb"] = 1 }, type = "River" },
	["African Lungfish"] = { colors = { ["br"] = 1, ["lb"] = 1 }, type = "Stillwater" },
	["Wels Catfish"] = { colors = { ["bk"] = 1, ["pk"] = 1, ["lb"] = 1, ["or"] = 1 }, type = "Stillwater" },
	["North Pacific Giant Octopus"] = { colors = { ["br"] = 1, ["bl"] = 1 }, type = "Coastal" },
	["Scalloped Hammerhead"] = { colors = { ["pp"] = 1, ["lg"] = 1, ["rd"] = 1 }, type = "Coastal" },
	["Alligator Gar"] = { colors = { ["bk"] = 1, ["lb"] = 1, ["gr"] = 1 }, type = "Stillwater" },
	["Bluefin Tuna"] = { colors = { ["bk"] = 1, ["br"] = 1, ["lg"] = 1, ["or"] = 1 }, type = "Deep Sea" },
	["Great White Shark"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["pp"] = 1, ["gr"] = 1 }, type = "Coastal" },
	["Marlin"] = { colors = { ["wt"] = 1, ["lg"] = 1, ["yl"] = 1 }, type = "Deep Sea" },
	["Tawny Nurse Shark"] = { colors = { ["gr"] = 1, ["or"] = 1 }, type = "Coastal" },
	["Sunfish"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["gr"] = 1 }, type = "Deep Sea" },
	["Manta Ray"] = { colors = { ["pk"] = 1, ["gr"] = 1, ["rd"] = 1 }, type = "Deep Sea" },
	["Giant Freshwater Stingray"] = { colors = { ["wt"] = 1, ["lg"] = 1 }, type = "River" },
	["Whale Shark"] = { colors = { ["br"] = 1, ["pp"] = 1, ["lg"] = 1 }, type = "Deep Sea" },
	["Beluga"] = { colors = { ["bk"] = 1, ["pk"] = 1, ["gr"] = 1 }, type = "River" },
	["Arapaima"] = { colors = { ["br"] = 1, ["lg"] = 1, ["yl"] = 1 }, type = "River" },
	["Spotted Eagle Ray"] = { colors = { ["wt"] = 1, ["pk"] = 1, ["bl"] = 1 }, type = "Deep Sea" },
	["Leedsichthys"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["gr"] = 1, ["rd"] = 1 }, type = "Deep Sea" },
	["Rhizodus"] = { colors = { ["br"] = 1, ["lb"] = 1, ["lg"] = 1, ["yl"] = 1 }, type = "River" },
	["Dunkleosteus"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["bl"] = 1 }, type = "Deep Sea" },
	["Nessie"] = { colors = { ["gr"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "Stillwater" },
	["Kronosaurus"] = { colors = { ["lb"] = 1, ["gr"] = 1 }, type = "Deep Sea" },
	["Dragon"] = { colors = { ["pp"] = 1, ["lg"] = 1, ["yl"] = 1 }, type = "Stillwater" },
	["Leviathan"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["lb"] = 1, ["bl"] = 1 }, type = "Deep Sea" },
	["Kraken"] = { colors = { ["pk"] = 1, ["lg"] = 1, ["yl"] = 1 }, type = "Deep Sea" },
	["UFO"] = { colors = { ["br"] = 1, ["lb"] = 1, ["gr"] = 1 }, type = "Stillwater" },
	["Giant Squid"] = { colors = { ["bk"] = 1, ["or"] = 1, ["rd"] = 1 }, rare = true, type = "Deep Sea" },
	["Giant Oarfish"] = { colors = { ["wt"] = 1, ["bl"] = 1, ["gr"] = 1 }, rare = true, type = "Deep Sea" },
	["Golden Bass"] = { colors = { ["br"] = 1, ["pk"] = 1, ["lb"] = 1, ["rd"] = 1 }, rare = true, type = "Stillwater" },
	["Golden Koi"] = { colors = { ["br"] = 1, ["pk"] = 1, ["bl"] = 1, ["lg"] = 1 }, rare = true, type = "Stillwater" },
	["Golden Bream"] = { colors = { ["br"] = 1, ["lb"] = 1, ["bl"] = 1, ["rd"] = 1 }, rare = true, type = "Deep Sea" },
	["Golden Rainbow Trout"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["lb"] = 1, ["or"] = 1 }, rare = true, type = "River" },
	["Golden Salmon"] = { colors = { ["wt"] = 1, ["pk"] = 1, ["lg"] = 1, ["or"] = 1 }, rare = true, type = "River" },
	["Golden Tuna"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["bl"] = 1, ["lg"] = 1 }, rare = true, type = "Deep Sea" },
	["Golden Marlin"] = { colors = { ["pp"] = 1, ["gr"] = 1, ["rd"] = 1 }, rare = true, type = "Deep Sea" },
	["Golden Shark"] = { colors = { ["wt"] = 1, ["lb"] = 1, ["yl"] = 1, ["or"] = 1 }, rare = true, type = "Coastal" },
	["Cheep Cheep"] = { colors = { ["wt"] = 1, ["bl"] = 1, ["yl"] = 1, ["or"] = 1 }, rare = true, type = "Coastal" },
	["Blooper"] = { colors = { ["bk"] = 1, ["br"] = 1, ["pp"] = 1, ["rd"] = 1 }, rare = true, type = "Coastal" },
	["Old Boot"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["br"] = 1, ["pp"] = 1, ["pk"] = 1, ["lb"] = 1, ["bl"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "Junk" },
	["Tin Can"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["br"] = 1, ["pp"] = 1, ["pk"] = 1, ["lb"] = 1, ["bl"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "Junk" },
	["Log"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["br"] = 1, ["pp"] = 1, ["pk"] = 1, ["lb"] = 1, ["bl"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "Junk" },
	["Seaweed"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["br"] = 1, ["pp"] = 1, ["pk"] = 1, ["lb"] = 1, ["bl"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "Junk" },
	["Jellyfish"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["br"] = 1, ["pp"] = 1, ["pk"] = 1, ["lb"] = 1, ["bl"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "Junk" },
}

local function getPlayerMode()
	local io = io
	local io_read, io_write, tonumber = io.read, io.write, tonumber
	io_write([[
Please enter mode:
1 Medals
2 Top 10
]])
	while true do
		local playerInput = tonumber(DEBUG_PLAYER_MODE or io_read(), 10)
		if playerInput and playerModes[playerInput] then
			return playerInput
		end
		io_write("Please enter a valid number: ")
	end
end

local function discardGoldLocations()
	local ipairs = ipairs
	local rankings_a_plus = rankings.a_plus
	local j, n = 1, #locations
	for i = 1, n do
		local location, keep = locations[i], false
		for _, fish in ipairs(location.fish) do
			if progressMedals[fish] < rankings_a_plus then
				keep = true
				break
			end
		end
		if keep then
			if i ~= j then
				locations[j] = location
				locations[i] = nil
			end
			j = j + 1
		else
			locations[i] = nil
		end
	end
end

local function locationTypes()
	for _, location in ipairs(locations) do
		location.type = fishes[location.fish[1]].type
	end
end

local function filterRares()
	-- create list of known rare fish
	local rareFishes, maxWidthIsland, maxWidthLocation = {}, 0, 0
	local ipairs, math_max = ipairs, math.max
	for _, location in ipairs(locations) do
		if location.fish then
			for fishIndex, fish in ipairs(location.fish) do
				if fishes[fish] and fishes[fish].rare then
					local island = location.island
					maxWidthIsland = math_max(maxWidthIsland, #island)
					maxWidthLocation = math_max(maxWidthLocation, #location.name)
					rareFishes[#rareFishes + 1] = {
						fish = fish,
						fishIndex = fishIndex,
						island = island,
						location = location,
					}
				end
			end
		end
	end
	if #rareFishes > 0 then
		-- print list as formatted table
		local table = table
		local formatString = table.concat { "%2d : %-", maxWidthIsland, "s : %-", maxWidthLocation, "s : %s\n" }
		local io, string = io, string
		local io_write, string_format = io.write, string.format
		io_write("List of relevant rare fish:\n")
		for i, v in ipairs(rareFishes) do
			io_write(string_format(formatString, i, v.island, v.location.name, v.fish))
		end
		io_write("Enter numbers of available rare fish: ")
		local availableFishes = {}
		local inputFishes = DEBUG_RARE_FISH_STRING or io.read()
		if inputFishes and #inputFishes > 0 then
			local string_gmatch, tonumber = string.gmatch, tonumber
			for number in string_gmatch(inputFishes, "%d+") do
				availableFishes[tonumber(number, 10)] = true
			end
		end
		-- remove unavailable rare fish from locations
		local table_remove = table.remove
		for i, v in ipairs(rareFishes) do
			if not availableFishes[i] then
				-- this might break if a location had multiple rare fish, but there is no such location in the game
				if DEBUG then print(table.concat { "removing fish #", v.fishIndex, " from ", v.location.name }) end
				table_remove(v.location.fish, v.fishIndex)
			end
		end
	end
end

local function calculateFishScoreWeights()
	local ipairs, pairs = ipairs, pairs
	for _, location in ipairs(locations) do
		for _, fishName in ipairs(location.fish) do
			local fish = fishes[fishName]
			fish.locations = (fish.locations or 0) + 1
		end
	end
	for _, fish in pairs(fishes) do
		local scoreWeight = (fish.rare and scoreFactors.rare or 1) / (fish.locations or 1)
		local fish_colors = fish.colors
		for color, value in pairs(fish_colors) do
			--[[ modification of existing fields is allowed during traversal, see
				https://www.lua.org/manual/5.4/manual.html#pdf-next ]]
			fish_colors[color] = value * scoreWeight
		end
	end
end

local function getPlayerLures()
	local io = io
	io.write([[
Please enter your lures using the following codes, separated by spaces:
1 black   2 white   3 brown          4 purple    5 pink      6 light blue
7 blue    8 green   9 light green   10 yellow   11 orange   12 red
]])
	local inputLures = DEBUG_PLAYER_LURES_STRING or io.read()
	local playerLures = {}
	if inputLures and #inputLures > 0 then
		local string_gmatch, tonumber = string.gmatch, tonumber
		for lure in string_gmatch(inputLures, "%d+") do
			local color = colors[tonumber(lure, 10)]
			playerLures[color] = (playerLures[color] or 0) + 1
		end
	end
	return playerLures
end

local function calculateLocationScoresMedals(playerLures)
	local ipairs, pairs = ipairs, pairs
	for _, location in ipairs(locations) do
		local locationScore = 0
		for medal, ranking in pairs(medals) do
			local medalScore = 0
			for lure, lureCount in pairs(playerLures) do
				local fishScore = 0
				local fishCount = 0
				for _, fishName in ipairs(location.fish) do
					local fish = fishes[fishName]
					local fishWeight = fish.colors[lure]
					if fishWeight then
						fishCount = fishCount + 1
						if progressMedals[fishName] < ranking then
							fishScore = fishScore + fishWeight
						end
					end
				end
				if fishCount > 0 then
					medalScore = medalScore + lureCount * fishScore / fishCount
				end
			end
			locationScore = locationScore + medalScore * scoreFactors[ranking]
		end
		location.score = locationScore
	end
end

local function calculateLocationScoresTop10(playerLures)
	local ipairs, pairs = ipairs, pairs
	for _, location in ipairs(locations) do
		local locationScore = 0
		for lure, lureCount in pairs(playerLures) do
			local fishScore = 0
			local fishCount = 0
			for _, fishName in ipairs(location.fish) do
				local fish = fishes[fishName]
				local fishWeight = fish.colors[lure]
				if fishWeight then
					fishCount = fishCount + 1
					if progressTop10[fishName] then
						fishScore = fishScore + fishWeight * (progressTop10[fishName] - 1)
					end
				end
			end
			if fishCount > 0 then
				locationScore = locationScore + lureCount * fishScore / fishCount
			end
		end
		location.score = locationScore
	end
end

local function discardUselessLocations()
	local locations = locations
	local j, n = 1, #locations
	for i = 1, n do
		local location = locations[i]
		if location.score > 0 then
			if i ~= j then
				locations[j] = location
				locations[i] = nil
			end
			j = j + 1
		else
			locations[i] = nil
		end
	end
end

local function compareLocationScores(i, j)
	assert(i.score, "location " .. i.name .. " has no score!")
	assert(j.score, "location " .. j.name .. " has no score!")
	return i.score > j.score
end

local function sortLocations()
	table.sort(locations, compareLocationScores)
end

local function printTopLocations()
	local math = math
	local math_max, table_concat = math.max, table.concat
	local printLocationsCount = math.min(#locations, 10)
	local maxWidthIsland, maxWidthLocation, maxWidthType = 0, 0, 0
	for i = 1, printLocationsCount do
		local location = locations[i]
		maxWidthIsland = math_max(maxWidthIsland, #location.island)
		maxWidthLocation = math_max(maxWidthLocation, #location.name)
		maxWidthType = math_max(maxWidthType, #location.type)
	end
	local formatString = table_concat { "%2d : %-", maxWidthIsland,
		"s : %-", maxWidthLocation, "s : %-", maxWidthType, "s : %f\n" }
	local io_write, string_format = io.write, string.format
	io_write(table_concat { "Found ", #locations, " eligible locations:\n" })
	for i = 1, printLocationsCount do
		local location = locations[i]
		io_write(string_format(formatString, i, location.island, location.name, location.type, location.score))
	end
end

local function printFishLocationStats()
	local io, math, string, table = io, math, string, table
	local io_read, io_write, math_max = io.read, io.write, math.max
	local string_format, table_concat = string.format, table.concat
	repeat
		io_write("Enter a location number to see how many locations each fish has: ")
		local locationId = io_read("n")
		if locationId then
			local location = locations[locationId]
			if location then
				io_write(string_format("%s : %s : %s\n", location.island, location.name, location.type))
				local fish = location.fish
				local maxFishNameLength = 0
				for _, name in ipairs(fish) do
					maxFishNameLength = math_max(maxFishNameLength, #name)
				end
				local formatString = table_concat { "%d : %-", maxFishNameLength, "s : %d : %d\n" }
				for index, name in ipairs(fish) do
					io_write(string_format(formatString, index, name, fishes[name].locations, progressTop10[name]))
				end
			end
			io_write("\n")
		end
	until not locationId
end

local function main()
	local playerMode = getPlayerMode()
	if playerModes[playerMode] == "medals" then
		discardGoldLocations()
	end
	locationTypes()
	filterRares()
	calculateFishScoreWeights()
	local playerLures = getPlayerLures()
	if playerModes[playerMode] == "medals" then
		calculateLocationScoresMedals(playerLures)
	elseif playerModes[playerMode] == "top 10" then
		calculateLocationScoresTop10(playerLures)
	else
		io.write("Error: invalid player mode!\n")
		return
	end
	discardUselessLocations()
	sortLocations()
	printTopLocations()
	printFishLocationStats()
end

main()
