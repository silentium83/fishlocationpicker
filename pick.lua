#!/usr/bin/env lua
-- [[
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
	DEBUG = true
	-- DEBUG_RARE_FISH_STRING = "1 2 3 4 5 6 7 8 9 10 11 12"
	-- DEBUG_RARE_FISH_STRING = "1 3 5 7 9 11"
	DEBUG_RARE_FISH_STRING = ""
	DEBUG_PLAYER_LURES_STRING = "9 7 8 6 10 11 3 3 9 1"
end
--]]

local rankings = require("rankings")
local progress = require("progress")

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
			"Spearfish Squid",
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
			"Spearfish Squid",
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
			"Spearfish Squid",
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
	["Sardine"] = { colors = { ["wt"] = 1, ["pk"] = 1, ["lb"] = 1, ["lg"] = 1, ["or"] = 1, ["rd"] = 1 } },
	["Black Rockfish"] = { colors = { ["bk"] = 1, ["lb"] = 1, ["bl"] = 1, ["gr"] = 1, ["or"] = 1 } },
	["Largescale Blackfish"] = { colors = { ["pk"] = 1, ["lb"] = 1, ["bl"] = 1, ["lg"] = 1, ["or"] = 1 } },
	["Dace"] = { colors = { ["pk"] = 1, ["lb"] = 1, ["or"] = 1, ["rd"] = 1 } },
	["Pale Chub"] = { colors = { ["br"] = 1, ["bl"] = 1, ["rd"] = 1 } },
	["Dark Chub"] = { colors = { ["pp"] = 1, ["lb"] = 1, ["bl"] = 1, ["gr"] = 1 } },
	["Bluegill"] = { colors = { ["bk"] = 1, ["pk"] = 1, ["lb"] = 1, ["bl"] = 1 } },
	["Crucian Carp"] = { colors = { ["lb"] = 1, ["bl"] = 1, ["or"] = 1, ["rd"] = 1 } },
	["Crayfish"] = { colors = { ["wt"] = 1, ["lb"] = 1, ["lg"] = 1, ["yl"] = 1, ["rd"] = 1 } },
	["Japanese Whiting"] = { colors = { ["br"] = 1, ["lb"] = 1, ["rd"] = 1 } },
	["Pacific Saury"] = { colors = { ["wt"] = 1, ["lb"] = 1, ["bl"] = 1, ["lg"] = 1 } },
	["Chicken Grunt"] = { colors = { ["gr"] = 1, ["lg"] = 1, ["rd"] = 1 } },
	["Blue Bat Star"] = { colors = { ["bl"] = 1, ["rd"] = 1 } },
	["Filefish"] = { colors = { ["bk"] = 1, ["br"] = 1, ["pp"] = 1, ["pk"] = 1, ["gr"] = 1, ["yl"] = 1 } },
	["Barracuda"] = { colors = { ["bk"] = 1, ["lb"] = 1, ["bl"] = 1, ["or"] = 1 } },
	["Tadpole"] = { colors = { ["bl"] = 1, ["rd"] = 1 } },
	["Spined Loach"] = { colors = { ["pp"] = 1, ["or"] = 1, ["rd"] = 1 } },
	["Dark Sleeper"] = { colors = { ["bl"] = 1, ["or"] = 1, ["rd"] = 1 } },
	["Mackerel"] = { colors = { ["wt"] = 1, ["bl"] = 1, ["rd"] = 1 } },
	["Pacific Herring"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["bl"] = 1, ["or"] = 1 } },
	["Japanese Horse Mackerel"] = { colors = { ["wt"] = 1, ["br"] = 1, ["lb"] = 1, ["gr"] = 1, ["or"] = 1, ["rd"] = 1 } },
	["Iwana Trout"] = { colors = { ["wt"] = 1, ["yl"] = 1, ["rd"] = 1 } },
	["Forktongue Goby"] = { colors = { ["bk"] = 1, ["pk"] = 1, ["lg"] = 1, ["rd"] = 1 } },
	["Lionfish"] = { colors = { ["pp"] = 1, ["pk"] = 1, ["bl"] = 1, ["lg"] = 1 } },
	["American Bullfrog"] = { colors = { ["bk"] = 1, ["br"] = 1, ["rd"] = 1 } },
	["Black Rabbitfish"] = { colors = { ["br"] = 1, ["pp"] = 1, ["rd"] = 1 } },
	["Spearfish Squid"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["lg"] = 1, ["rd"] = 1 } },
	["Pennant Coralfish"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["br"] = 1, ["bl"] = 1, ["gr"] = 1 } },
	["Convict Tang"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["bl"] = 1, ["yl"] = 1 } },
	["Yellow Perch"] = { colors = { ["bk"] = 1, ["yl"] = 1, ["rd"] = 1 } },
	["Indo-Pacific Sergeant"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["lb"] = 1, ["lg"] = 1, ["or"] = 1 } },
	["Butterflyfish"] = { colors = { ["pk"] = 1, ["yl"] = 1, ["or"] = 1, ["rd"] = 1 } },
	["Piranha"] = { colors = { ["bk"] = 1, ["br"] = 1, ["pp"] = 1, ["rd"] = 1 } },
	["Siamese Fighting Fish"] = { colors = { ["lb"] = 1, ["rd"] = 1 } },
	["Dwarf Gourami"] = { colors = { ["pk"] = 1, ["rd"] = 1 } },
	["Chinese Softshell Turtle"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["yl"] = 1, ["or"] = 1 } },
	["Blue Tang"] = { colors = { ["wt"] = 1, ["bl"] = 1, ["yl"] = 1 } },
	["Sweetfish"] = { colors = { ["wt"] = 1, ["lb"] = 1, ["bl"] = 1 } },
	["Red King Crab"] = { colors = { ["pp"] = 1, ["lb"] = 1, ["or"] = 1 } },
	["Boxfish"] = { colors = { ["wt"] = 1, ["bl"] = 1, ["gr"] = 1, ["yl"] = 1 } },
	["Cherry Salmon"] = { colors = { ["wt"] = 1, ["bl"] = 1, ["gr"] = 1, ["lg"] = 1 } },
	["Porcupinefish"] = { colors = { ["pp"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1 } },
	["Snow Crab"] = { colors = { ["br"] = 1, ["pk"] = 1, ["lb"] = 1, ["or"] = 1 } },
	["Red Gurnard"] = { colors = { ["pk"] = 1, ["rd"] = 1 } },
	["Clown Loach"] = { colors = { ["bk"] = 1, ["pk"] = 1, ["lg"] = 1, ["or"] = 1 } },
	["Clownfish"] = { colors = { ["wt"] = 1, ["gr"] = 1, ["lg"] = 1, ["or"] = 1 } },
	["Little Dragonfish"] = { colors = { ["pp"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1 } },
	["Orange-Striped Emperor"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["bl"] = 1 } },
	["Longnose Hawkfish"] = { colors = { ["wt"] = 1, ["pk"] = 1, ["bl"] = 1 } },
	["Koran Angelfish"] = { colors = { ["pk"] = 1, ["bl"] = 1, ["lg"] = 1, ["yl"] = 1 } },
	["Flying Fish"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["pp"] = 1, ["lb"] = 1 } },
	["Elephantnose Fish"] = { colors = { ["bk"] = 1, ["lb"] = 1, ["or"] = 1 } },
	["Angelfish"] = { colors = { ["lb"] = 1, ["bl"] = 1 } },
	["Giant Pikehead"] = { colors = { ["bl"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1 } },
	["Stickleback"] = { colors = { ["br"] = 1, ["gr"] = 1, ["yl"] = 1 } },
	["Spiny Lobster"] = { colors = { ["bk"] = 1, ["gr"] = 1, ["lg"] = 1 } },
	["Seahorse"] = { colors = { ["br"] = 1, ["gr"] = 1, ["yl"] = 1 } },
	["Pinecone Fish"] = { colors = { ["br"] = 1, ["pp"] = 1, ["gr"] = 1, ["yl"] = 1 } },
	["Flapjack Octopus"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["yl"] = 1 } },
	["Giant Isopod"] = { colors = { ["br"] = 1, ["or"] = 1 } },
	["Viperfish"] = { colors = { ["br"] = 1, ["gr"] = 1, ["yl"] = 1 } },
	["Ocellate River Stingray"] = { colors = { ["bk"] = 1, ["pp"] = 1 } },
	["Japanese Sea Bass"] = { colors = { ["pp"] = 1, ["gr"] = 1, ["lg"] = 1, ["rd"] = 1 } },
	["Black Sea Bream"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["br"] = 1, ["pk"] = 1, ["lb"] = 1, ["yl"] = 1 } },
	["Rainbow Trout"] = { colors = { ["wt"] = 1, ["bl"] = 1, ["gr"] = 1, ["yl"] = 1 } },
	["Smallmouth Bass"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["bl"] = 1, ["lg"] = 1 } },
	["Skipjack Tuna"] = { colors = { ["lb"] = 1, ["bl"] = 1, ["lg"] = 1 } },
	["Righteye Flounder"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["pk"] = 1, ["bl"] = 1 } },
	["Common Carp"] = { colors = { ["pp"] = 1, ["gr"] = 1, ["yl"] = 1, ["rd"] = 1 } },
	["Largehead Hairtail"] = { colors = { ["pk"] = 1, ["lb"] = 1, ["bl"] = 1 } },
	["Japanese Spanish Mackerel"] = { colors = { ["pp"] = 1, ["pk"] = 1, ["gr"] = 1, ["lg"] = 1, ["or"] = 1 } },
	["Catfish"] = { colors = { ["bk"] = 1, ["br"] = 1, ["yl"] = 1, ["rd"] = 1 } },
	["Largemouth Bass"] = { colors = { ["wt"] = 1, ["bl"] = 1, ["yl"] = 1, ["rd"] = 1 } },
	["Okhotsk Atka Mackerel"] = { colors = { ["wt"] = 1, ["lb"] = 1, ["bl"] = 1 } },
	["Alaska Pollack"] = { colors = { ["br"] = 1, ["pp"] = 1, ["rd"] = 1 } },
	["Flathead Mullet"] = { colors = { ["gr"] = 1, ["yl"] = 1, ["rd"] = 1 } },
	["Northern Barramundi"] = { colors = { ["br"] = 1, ["pk"] = 1, ["rd"] = 1 } },
	["Yellowtail"] = { colors = { ["br"] = 1, ["lb"] = 1, ["bl"] = 1 } },
	["Barred Knifejaw"] = { colors = { ["bk"] = 1, ["br"] = 1, ["pp"] = 1, ["gr"] = 1, ["yl"] = 1 } },
	["Moray Eel"] = { colors = { ["bk"] = 1, ["pk"] = 1, ["lg"] = 1, ["or"] = 1 } },
	["Chum Salmon"] = { colors = { ["wt"] = 1, ["pk"] = 1, ["lg"] = 1, ["or"] = 1 } },
	["Tiger Pufferfish"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["br"] = 1 } },
	["Pike"] = { colors = { ["lb"] = 1, ["gr"] = 1, ["or"] = 1 } },
	["Snakehead"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["lb"] = 1, ["lg"] = 1 } },
	["Iridescent Shark"] = { colors = { ["br"] = 1, ["bl"] = 1, ["or"] = 1 } },
	["Flounder"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["yl"] = 1, ["or"] = 1 } },
	["Eel"] = { colors = { ["pp"] = 1, ["bl"] = 1, ["gr"] = 1 } },
	["Chinook Salmon"] = { colors = { ["br"] = 1, ["pk"] = 1, ["lb"] = 1 } },
	["Lake Trout"] = { colors = { ["bk"] = 1, ["pk"] = 1, ["lg"] = 1, ["or"] = 1 } },
	["Saddled Bichir"] = { colors = { ["bk"] = 1, ["br"] = 1, ["lg"] = 1, ["or"] = 1 } },
	["Pacific Cod"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["pk"] = 1, ["yl"] = 1 } },
	["Japanese Bullhead Shark"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1 } },
	["Common Octopus"] = { colors = { ["wt"] = 1, ["br"] = 1, ["pk"] = 1, ["yl"] = 1, ["or"] = 1 } },
	["Alligator Snapping Turtle"] = { colors = { ["pp"] = 1, ["gr"] = 1, ["yl"] = 1 } },
	["Taimen"] = { colors = { ["pk"] = 1, ["lg"] = 1, ["or"] = 1 } },
	["Garfish"] = { colors = { ["rd"] = 1 } },
	["Longtooth Grouper"] = { colors = { ["pk"] = 1, ["lb"] = 1, ["gr"] = 1, ["yl"] = 1 } },
	["Tarpon"] = { colors = { ["bk"] = 1, ["br"] = 1, ["pk"] = 1 } },
	["Red Sea Bream"] = { colors = { ["bl"] = 1, ["yl"] = 1 } },
	["Japanese Spider Crab"] = { colors = { ["lb"] = 1, ["or"] = 1 } },
	["Mahi-Mahi"] = { colors = { ["bk"] = 1, ["pk"] = 1, ["gr"] = 1, ["yl"] = 1 } },
	["Amberjack"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["or"] = 1 } },
	["Splendid Alfonsino"] = { colors = { ["pk"] = 1, ["yl"] = 1, ["or"] = 1 } },
	["Sawshark"] = { colors = { ["pk"] = 1, ["lb"] = 1 } },
	["Arowana"] = { colors = { ["lb"] = 1, ["yl"] = 1, ["or"] = 1 } },
	["Dorado"] = { colors = { ["br"] = 1, ["pk"] = 1, ["gr"] = 1, ["yl"] = 1, ["or"] = 1 } },
	["Nile Perch"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["pk"] = 1, ["or"] = 1 } },
	["Koi"] = { colors = { ["pk"] = 1, ["lg"] = 1 } },
	["Humphead Wrasse"] = { colors = { ["br"] = 1, ["gr"] = 1, ["lg"] = 1 } },
	["Horseshoe Crab"] = { colors = { ["wt"] = 1, ["gr"] = 1 } },
	["Coelacanth"] = { colors = { ["pk"] = 1, ["lg"] = 1 } },
	["Stringfish"] = { colors = { ["br"] = 1, ["pk"] = 1 } },
	["Footballfish"] = { colors = { ["br"] = 1, ["lb"] = 1 } },
	["Frilled Shark"] = { colors = { ["wt"] = 1, ["br"] = 1 } },
	["Gigantic Carp"] = { colors = { ["bk"] = 1, ["lg"] = 1 } },
	["Mediterranean Dealfish"] = { colors = { ["wt"] = 1, ["br"] = 1 } },
	["Gulper Eel"] = { colors = { ["bk"] = 1, ["bl"] = 1 } },
	["Electric Eel"] = { colors = { ["br"] = 1, ["lb"] = 1 } },
	["African Lungfish"] = { colors = { ["br"] = 1, ["lb"] = 1 } },
	["Wels Catfish"] = { colors = { ["bk"] = 1, ["pk"] = 1, ["lb"] = 1, ["or"] = 1 } },
	["North Pacific Giant Octopus"] = { colors = { ["br"] = 1, ["bl"] = 1 } },
	["Scalloped Hammerhead"] = { colors = { ["pp"] = 1, ["lg"] = 1, ["rd"] = 1 } },
	["Alligator Gar"] = { colors = { ["bk"] = 1, ["lb"] = 1, ["gr"] = 1 } },
	["Bluefin Tuna"] = { colors = { ["bk"] = 1, ["br"] = 1, ["lg"] = 1, ["or"] = 1 } },
	["Great White Shark"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["pp"] = 1, ["gr"] = 1 } },
	["Marlin"] = { colors = { ["wt"] = 1, ["lg"] = 1, ["yl"] = 1 } },
	["Tawny Nurse Shark"] = { colors = { ["gr"] = 1, ["or"] = 1 } },
	["Sunfish"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["gr"] = 1 } },
	["Manta Ray"] = { colors = { ["pk"] = 1, ["gr"] = 1, ["rd"] = 1 } },
	["Giant Freshwater Stingray"] = { colors = { ["wt"] = 1, ["lg"] = 1 } },
	["Whale Shark"] = { colors = { ["br"] = 1, ["pp"] = 1, ["lg"] = 1 } },
	["Beluga"] = { colors = { ["bk"] = 1, ["pk"] = 1, ["gr"] = 1 } },
	["Arapaima"] = { colors = { ["br"] = 1, ["lg"] = 1, ["yl"] = 1 } },
	["Spotted Eagle Ray"] = { colors = { ["wt"] = 1, ["pk"] = 1, ["bl"] = 1 } },
	["Leedsichthys"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["gr"] = 1, ["rd"] = 1 } },
	["Rhizodus"] = { colors = { ["br"] = 1, ["lb"] = 1, ["lg"] = 1, ["yl"] = 1 } },
	["Dunkleosteus"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["bl"] = 1 } },
	["Nessie"] = { colors = { ["gr"] = 1, ["or"] = 1, ["rd"] = 1 } },
	["Kronosaurus"] = { colors = { ["lb"] = 1, ["gr"] = 1 } },
	["Dragon"] = { colors = { ["pp"] = 1, ["lg"] = 1, ["yl"] = 1 } },
	["Leviathan"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["lb"] = 1, ["bl"] = 1 } },
	["Kraken"] = { colors = { ["pk"] = 1, ["lg"] = 1, ["yl"] = 1 } },
	["UFO"] = { colors = { ["br"] = 1, ["lb"] = 1, ["gr"] = 1 } },
	["Giant Squid"] = { colors = { ["bk"] = 1, ["or"] = 1, ["rd"] = 1 }, rare = true },
	["Giant Oarfish"] = { colors = { ["wt"] = 1, ["bl"] = 1, ["gr"] = 1 }, rare = true },
	["Golden Bass"] = { colors = { ["br"] = 1, ["pk"] = 1, ["lb"] = 1, ["rd"] = 1 }, rare = true },
	["Golden Koi"] = { colors = { ["br"] = 1, ["pk"] = 1, ["bl"] = 1, ["lg"] = 1 }, rare = true },
	["Golden Bream"] = { colors = { ["br"] = 1, ["lb"] = 1, ["bl"] = 1, ["rd"] = 1 }, rare = true },
	["Golden Rainbow Trout"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["lb"] = 1, ["or"] = 1 }, rare = true },
	["Golden Salmon"] = { colors = { ["wt"] = 1, ["pk"] = 1, ["lg"] = 1, ["or"] = 1 }, rare = true },
	["Golden Tuna"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["bl"] = 1, ["lg"] = 1 }, rare = true },
	["Golden Marlin"] = { colors = { ["pp"] = 1, ["gr"] = 1, ["rd"] = 1 }, rare = true },
	["Golden Shark"] = { colors = { ["wt"] = 1, ["lb"] = 1, ["yl"] = 1, ["or"] = 1 }, rare = true },
	["Cheep Cheep"] = { colors = { ["wt"] = 1, ["bl"] = 1, ["yl"] = 1, ["or"] = 1 }, rare = true },
	["Blooper"] = { colors = { ["bk"] = 1, ["br"] = 1, ["pp"] = 1, ["rd"] = 1 }, rare = true },
	["Old Boot"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["br"] = 1, ["pp"] = 1, ["pk"] = 1, ["lb"] = 1, ["bl"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1, ["or"] = 1, ["rd"] = 1 } },
	["Tin Can"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["br"] = 1, ["pp"] = 1, ["pk"] = 1, ["lb"] = 1, ["bl"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1, ["or"] = 1, ["rd"] = 1 } },
	["Log"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["br"] = 1, ["pp"] = 1, ["pk"] = 1, ["lb"] = 1, ["bl"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1, ["or"] = 1, ["rd"] = 1 } },
	["Seaweed"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["br"] = 1, ["pp"] = 1, ["pk"] = 1, ["lb"] = 1, ["bl"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1, ["or"] = 1, ["rd"] = 1 } },
	["Jellyfish"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["br"] = 1, ["pp"] = 1, ["pk"] = 1, ["lb"] = 1, ["bl"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1, ["or"] = 1, ["rd"] = 1 } },
}

-- FIXME: check if necessary
local function indexLocations()
	for i, v in ipairs(locations) do
		v.index = i
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
					rareFishes[#rareFishes+1] = { island = island, location = location, fish = fish, fishIndex = fishIndex }
				end
			end
		end
	end
	if #rareFishes > 0 then
		-- print list as formatted table
		local table = table
		local formatString = table.concat{"%2d : %-", maxWidthIsland, "s : %-", maxWidthLocation, "s : %s\n"}
		local io, string = io, string
		local io_write, string_format = io.write, string.format
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
				if DEBUG then print(table.concat{"removing fish #", v.fishIndex, " from ", v.location.name}) end
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

local function calculateLocationScores(playerLures)
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
						if progress[fishName] < ranking then
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

local function compareLocationScores(i, j)
	assert(i.score, "location " .. i.name .. " has no score!")
	assert(j.score, "location " .. j.name .. " has no score!")
	return i.score > j.score
end

local function sortLocations()
	table.sort(locations, compareLocationScores)
end

local function printTopLocations()
	local math_max = math.max
	local maxWidthIsland, maxWidthLocation = 0, 0
	for i = 1, 10, 1 do
		local location = locations[i]
		maxWidthIsland = math_max(maxWidthIsland, #location.island)
		maxWidthLocation = math_max(maxWidthLocation, #location.name)
	end
	local formatString = table.concat{"%2d : %-", maxWidthIsland, "s : %-", maxWidthLocation, "s : %f\n"}
	local io_write, string_format = io.write, string.format
	for i = 1, 10, 1 do
		local location = locations[i]
		io_write(string_format(formatString, i, location.island, location.name, location.score))
	end
end

local function printFishLocationCounts()
	local io, math, string, table = io, math, string, table
	local io_read, io_write, math_max = io.read, io.write, math.max
	local string_format, table_concat = string.format, table.concat
	repeat
		io_write("Enter a location number to see how many locations each fish has: ")
		local locationId = io_read("n")
		if locationId then
			local location = locations[locationId]
			if location then
				io_write(string_format("%s : %s\n", location.island, location.name))
				local fish = location.fish
				local maxFishNameLength = 0
				for _, name in ipairs(fish) do
					maxFishNameLength = math_max(maxFishNameLength, #name)
				end
				local formatString = table_concat{"%d : %-", maxFishNameLength, "s : %d\n"}
				for index, name in ipairs(fish) do
					io_write(string_format(formatString, index, name, fishes[name].locations))
				end
			end
			io_write("\n")
		end
	until not locationId
end

local function main()
	indexLocations()
	filterRares()
	calculateFishScoreWeights()
	local playerLures = getPlayerLures()
	calculateLocationScores(playerLures)
	sortLocations()
	printTopLocations()
	printFishLocationCounts()
end

main()
