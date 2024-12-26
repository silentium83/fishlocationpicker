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
			"sardine",
			"black rockfish",
			"largescale blackfish",
			"Japanese sea bass",
			"black sea bream",
		},
	},
	{
		name = "Greenhorn River",
		island = "Prelude Island",
		fish = {
			"dace",
			"pale chub",
			"dark chub",
			"rainbow trout",
		},
	},
	{
		name = "Cypress Lake",
		island = "Prelude Island",
		fish = {
			"bluegill",
			"crucian carp",
			"crayfish",
			"smallmouth bass",
		},
	},
	{
		name = "Prelude Bay Cruise",
		island = "Prelude Island",
		fish = {
			"Japanese whiting",
			"Pacific saury",
			"chicken grunt",
			"skipjack tuna",
			"red sea bream",
			"Leedsichthys",
		},
	},
	{
		name = "Cove Sands",
		island = "Lobe Island",
		fish = {
			"blue bat star",
			"filefish",
			"barracuda",
			"righteye flounder",
		},
	},
	{
		name = "Copse Pool",
		island = "Lobe Island",
		fish = {
			"tadpole",
			"spined loach",
			"dark sleeper",
			"common carp",
		},
	},
	{
		name = "Verthaven Pier",
		island = "Lobe Island",
		fish = {
			"mackerel",
			"Pacific herring",
			"Japanese horse mackerel",
			"largehead hairtail",
			"Japanese Spanish mackerel",
		},
	},
	{
		name = "Peaceful Lake",
		island = "Lobe Island",
		fish = {
			"crucian carp",
			"bluegill",
			"Chinese softshell turtle",
			"catfish",
		},
	},
	{
		name = "Brumefall River",
		island = "Lobe Island",
		fish = {
			"pale chub",
			"dark chub",
			"iwana trout",
			"rainbow trout",
			"Rhizodus",
		},
	},
	{
		name = "Keyhole Cliffs",
		island = "Ossein Island",
		fish = {
			"forktongue goby",
			"lionfish",
			"filefish",
			"blue tang",
			"moray eel",
		},
	},
	{
		name = "Mossmeadow Marsh",
		island = "Ossein Island",
		fish = {
			"spined loach",
			"crucian carp",
			"American bullfrog",
			"smallmouth bass",
			"largemouth bass",
		},
	},
	{
		name = "Raynesse Falls",
		island = "Ossein Island",
		fish = {
			"dace",
			"iwana trout",
			"sweetfish",
			"chum salmon",
		},
	},
	{
		name = "Graupel Pier",
		island = "Ossein Island",
		fish = {
			"Pacific herring",
			"Japanese horse mackerel",
			"black rabbitfish",
			"Okhotsk Atka mackerel",
			"tiger pufferfish",
		},
	},
	{
		name = "Berg Cruise",
		island = "Ossein Island",
		fish = {
			"Pacific saury",
			"spear squid",
			"red king crab",
			"Alaska pollock",
			"yellowtail",
			"Dunkleosteus",
		},
	},
	{
		name = "Tail Point",
		island = "The Isle of Loch",
		fish = {
			"filefish",
			"pennant coralfish",
			"convict tang",
			"black sea bream",
			"barred knifejaw",
		},
	},
	{
		name = "Souwester Rocks",
		island = "The Isle of Loch",
		fish = {
			"black rabbitfish",
			"barracuda",
			"boxfish",
			"Okhotsk Atka mackerel",
			"flathead mullet",
		},
	},
	{
		name = "Craggy Tarn",
		island = "The Isle of Loch",
		fish = {
			"American bullfrog",
			"dark sleeper",
			"yellow perch",
			"pike",
		},
	},
	{
		name = "Cardia Lake",
		island = "The Isle of Loch",
		fish = {
			"tadpole",
			"spined loach",
			"Chinese softshell turtle",
			"snakehead",
			"golden bass",
		},
	},
	{
		name = "Maple Burn",
		island = "The Isle of Loch",
		fish = {
			"iwana trout",
			"sweetfish",
			"cherry salmon",
			"rainbow trout",
			"iridescent shark",
		},
	},
	{
		name = "Loch Placid",
		island = "The Isle of Loch",
		fish = {
			"crucian carp",
			"bluegill",
			"yellow perch",
			"snakehead",
			"pike",
			"Nessie",
		},
	},
	{
		name = "Dayton Point",
		island = "Titan Island",
		fish = {
			"mackerel",
			"boxfish",
			"porcupinefish",
			"common octopus",
			"flounder",
		},
	},
	{
		name = "Oldmead Pond",
		island = "Titan Island",
		fish = {
			"tadpole",
			"American bullfrog",
			"crayfish",
			"smallmouth bass",
			"eel",
		},
	},
	{
		name = "Kohu Lake",
		island = "Titan Island",
		fish = {
			"crucian carp",
			"dark sleeper",
			"Chinese softshell turtle",
			"koi",
			"golden koi",
		},
	},
	{
		name = "Wisply Falls",
		island = "Titan Island",
		fish = {
			"iwana trout",
			"sweetfish",
			"cherry salmon",
			"rainbow trout",
			"chinook salmon",
		},
	},
	{
		name = "Greydale Lake",
		island = "Titan Island",
		fish = {
			"crucian carp",
			"bluegill",
			"yellow perch",
			"smallmouth bass",
			"lake trout",
		},
	},
	{
		name = "Fretfield Moor",
		island = "Titan Island",
		fish = {
			"tadpole",
			"spined loach",
			"crayfish",
			"saddled bichir",
			"wels catfish",
		},
	},
	{
		name = "Icebarrow Point",
		island = "Titan Island",
		fish = {
			"Pacific saury",
			"spear squid",
			"snow crab",
			"Pacific cod",
			"Kronosaurus",
			"giant squid",
		},
	},
	{
		name = "Seraphia Pier",
		island = "Wyrm Island",
		fish = {
			"largescale blackfish",
			"black rabbitfish",
			"porcupinefish",
			"largehead hairtail",
			"Japanese bullhead shark",
			"North Pacific giant octopus",
		},
	},
	{
		name = "Clarion Lake",
		island = "Wyrm Island",
		fish = {
			"crucian carp",
			"bluegill",
			"stickleback",
			"smallmouth bass",
			"alligator snapping turtle",
		},
	},
	{
		name = "Elin Rapids",
		island = "Wyrm Island",
		fish = {
			"pale chub",
			"dark chub",
			"cherry salmon",
			"rainbow trout",
			"taimen",
		},
	},
	{
		name = "Aruna Rocks",
		island = "Wyrm Island",
		fish = {
			"convict tang",
			"pennant coralfish",
			"Indo-Pacific sergeant",
			"garfish",
			"longtooth grouper",
			"tarpon",
		},
	},
	{
		name = "Sunset Cruise",
		island = "Wyrm Island",
		fish = {
			"chicken grunt",
			"red gurnard",
			"Japanese spider crab",
			"mahi-mahi",
			"bluefin tuna",
			"golden tuna",
		},
	},
	{
		name = "Wyverdun Lake",
		island = "Wyrm Island",
		fish = {
			"bluegill",
			"Chinese softshell turtle",
			"clown loach",
			"eel",
			"lake trout",
			"Dragon",
		},
	},
	{
		name = "Gloaming Reef",
		island = "The Isle of Envy",
		fish = {
			"butterflyfish",
			"clownfish",
			"little dragonfish",
			"Japanese bullhead shark",
			"scalloped hammerhead",
		},
	},
	{
		name = "Foxmere Lake",
		island = "The Isle of Envy",
		fish = {
			"dark sleeper",
			"crayfish",
			"yellow perch",
			"smallmouth bass",
			"alligator gar",
		},
	},
	{
		name = "Bridgcliff Beach",
		island = "The Isle of Envy",
		fish = {
			"porcupinefish",
			"spiny lobster",
			"seahorse",
			"garfish",
			"humphead wrasse",
			"Cheep Cheep",
		},
	},
	{
		name = "Sunset Sea Cruise",
		island = "The Isle of Envy",
		fish = {
			"Japanese whiting",
			"spear squid",
			"amberjack",
			"splendid alfonsino",
			"coelacanth",
			"golden bream",
		},
	},
	{
		name = "Mauvain Cove",
		island = "The Isle of Envy",
		fish = {
			"forktongue goby",
			"orange-striped emperor",
			"pinecone fish",
			"horseshoe crab",
			"great white shark",
			"golden shark",
		},
	},
	{
		name = "Hazeldown River",
		island = "The Isle of Envy",
		fish = {
			"dace",
			"pale chub",
			"dark chub",
			"stringfish",
			"golden rainbow trout",
		},
	},
	{
		name = "Aurora Sea Cruise",
		island = "The Isle of Envy",
		fish = {
			"Pacific saury",
			"red king crab",
			"snow crab",
			"frilled shark",
			"footballfish",
			"Leviathan",
		},
	},
	{
		name = "Rainbow Sea Cruise",
		island = "Marinus Island",
		fish = {
			"flapjack octopus",
			"giant isopod",
			"flying fish",
			"sawshark",
			"marlin",
			"golden marlin",
		},
	},
	{
		name = "Seacut Cave",
		island = "Marinus Island",
		fish = {
			"spiny lobster",
			"longnose hawkfish",
			"Koran angelfish",
			"garfish",
			"tawny nurse shark",
			"Blooper",
		},
	},
	{
		name = "Thunderhead Falls",
		island = "Marinus Island",
		fish = {
			"piranha",
			"Siamese fighting fish",
			"dwarf gourami",
			"northern barramundi",
			"arowana",
		},
	},
	{
		name = "Cypress Swamp",
		island = "Marinus Island",
		fish = {
			"piranha",
			"dwarf gourami",
			"angelfish",
			"dorado",
			"gigantic carp",
		},
	},
	{
		name = "Slatecrest Sea Cruise",
		island = "Marinus Island",
		fish = {
			"Japanese whiting",
			"flying fish",
			"Mediterranean dealfish",
			"whale shark",
			"Kraken",
			"giant oarfish",
		},
	},
	{
		name = "Crystal Seas Cruise",
		island = "Mysteria Island",
		fish = {
			"red gurnard",
			"viperfish",
			"gulper eel",
			"sunfish",
			"manta ray",
			"spotted eagle ray",
		},
	},
	{
		name = "Greybanks River",
		island = "Mysteria Island",
		fish = {
			"iwana trout",
			"sweetfish",
			"cherry salmon",
			"rainbow trout",
			"beluga",
			"golden salmon",
		},
	},
	{
		name = "Mangrow Bayou",
		island = "Mysteria Island",
		fish = {
			"piranha",
			"Siamese fighting fish",
			"ocellate river stingray",
			"Nile perch",
			"giant freshwater stingray",
		},
	},
	{
		name = "Ironfalls Gorge",
		island = "Mysteria Island",
		fish = {
			"dwarf gourami",
			"elephantnose fish",
			"angelfish",
			"electric eel",
			"arapaima",
		},
	},
	{
		name = "Enigma Cave",
		island = "Mysteria Island",
		fish = {
			"stickleback",
			"giant pikehead",
			"alligator snapping turtle",
			"saddled bichir",
			"African lungfish",
			"UFO",
		},
	},
}

local fishes = {
	["sardine"] = { colors = { ["wt"] = 1, ["pk"] = 1, ["lb"] = 1, ["lg"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "Coastal" },
	["black rockfish"] = { colors = { ["bk"] = 1, ["lb"] = 1, ["bl"] = 1, ["gr"] = 1, ["or"] = 1 }, type = "Coastal" },
	["largescale blackfish"] = { colors = { ["pk"] = 1, ["lb"] = 1, ["bl"] = 1, ["lg"] = 1, ["or"] = 1 }, type = "Coastal" },
	["dace"] = { colors = { ["pk"] = 1, ["lb"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "River" },
	["pale chub"] = { colors = { ["br"] = 1, ["bl"] = 1, ["rd"] = 1 }, type = "River" },
	["dark chub"] = { colors = { ["pp"] = 1, ["lb"] = 1, ["bl"] = 1, ["gr"] = 1 }, type = "River" },
	["bluegill"] = { colors = { ["bk"] = 1, ["pk"] = 1, ["lb"] = 1, ["bl"] = 1 }, type = "Stillwater" },
	["crucian carp"] = { colors = { ["lb"] = 1, ["bl"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "Stillwater" },
	["crayfish"] = { colors = { ["wt"] = 1, ["lb"] = 1, ["lg"] = 1, ["yl"] = 1, ["rd"] = 1 }, type = "Stillwater" },
	["Japanese whiting"] = { colors = { ["br"] = 1, ["lb"] = 1, ["rd"] = 1 }, type = "Deep Sea" },
	["Pacific saury"] = { colors = { ["wt"] = 1, ["lb"] = 1, ["bl"] = 1, ["lg"] = 1 }, type = "Deep Sea" },
	["chicken grunt"] = { colors = { ["gr"] = 1, ["lg"] = 1, ["rd"] = 1 }, type = "Deep Sea" },
	["blue bat star"] = { colors = { ["bl"] = 1, ["rd"] = 1 }, type = "Coastal" },
	["filefish"] = { colors = { ["bk"] = 1, ["br"] = 1, ["pp"] = 1, ["pk"] = 1, ["gr"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["barracuda"] = { colors = { ["bk"] = 1, ["lb"] = 1, ["bl"] = 1, ["or"] = 1 }, type = "Coastal" },
	["tadpole"] = { colors = { ["bl"] = 1, ["rd"] = 1 }, type = "Stillwater" },
	["spined loach"] = { colors = { ["pp"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "Stillwater" },
	["dark sleeper"] = { colors = { ["bl"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "Stillwater" },
	["mackerel"] = { colors = { ["wt"] = 1, ["bl"] = 1, ["rd"] = 1 }, type = "Coastal" },
	["Pacific herring"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["bl"] = 1, ["or"] = 1 }, type = "Coastal" },
	["Japanese horse mackerel"] = { colors = { ["wt"] = 1, ["br"] = 1, ["lb"] = 1, ["gr"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "Coastal" },
	["iwana trout"] = { colors = { ["wt"] = 1, ["yl"] = 1, ["rd"] = 1 }, type = "River" },
	["forktongue goby"] = { colors = { ["bk"] = 1, ["pk"] = 1, ["lg"] = 1, ["rd"] = 1 }, type = "Coastal" },
	["lionfish"] = { colors = { ["pp"] = 1, ["pk"] = 1, ["bl"] = 1, ["lg"] = 1 }, type = "Coastal" },
	["American bullfrog"] = { colors = { ["bk"] = 1, ["br"] = 1, ["rd"] = 1 }, type = "Stillwater" },
	["black rabbitfish"] = { colors = { ["br"] = 1, ["pp"] = 1, ["rd"] = 1 }, type = "Coastal" },
	["spear squid"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["lg"] = 1, ["rd"] = 1 }, type = "Deep Sea" },
	["pennant coralfish"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["br"] = 1, ["bl"] = 1, ["gr"] = 1 }, type = "Coastal" },
	["convict tang"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["bl"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["yellow perch"] = { colors = { ["bk"] = 1, ["yl"] = 1, ["rd"] = 1 }, type = "Stillwater" },
	["Indo-Pacific sergeant"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["lb"] = 1, ["lg"] = 1, ["or"] = 1 }, type = "Coastal" },
	["butterflyfish"] = { colors = { ["pk"] = 1, ["yl"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "Coastal" },
	["piranha"] = { colors = { ["bk"] = 1, ["br"] = 1, ["pp"] = 1, ["rd"] = 1 }, type = "River" },
	["Siamese fighting fish"] = { colors = { ["lb"] = 1, ["rd"] = 1 }, type = "River" },
	["dwarf gourami"] = { colors = { ["pk"] = 1, ["rd"] = 1 }, type = "River" },
	["Chinese softshell turtle"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["yl"] = 1, ["or"] = 1 }, type = "Stillwater" },
	["blue tang"] = { colors = { ["wt"] = 1, ["bl"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["sweetfish"] = { colors = { ["wt"] = 1, ["lb"] = 1, ["bl"] = 1 }, type = "River" },
	["red king crab"] = { colors = { ["pp"] = 1, ["lb"] = 1, ["or"] = 1 }, type = "Deep Sea" },
	["boxfish"] = { colors = { ["wt"] = 1, ["bl"] = 1, ["gr"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["cherry salmon"] = { colors = { ["wt"] = 1, ["bl"] = 1, ["gr"] = 1, ["lg"] = 1 }, type = "River" },
	["porcupinefish"] = { colors = { ["pp"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["snow crab"] = { colors = { ["br"] = 1, ["pk"] = 1, ["lb"] = 1, ["or"] = 1 }, type = "Deep Sea" },
	["red gurnard"] = { colors = { ["pk"] = 1, ["rd"] = 1 }, type = "Deep Sea" },
	["clown loach"] = { colors = { ["bk"] = 1, ["pk"] = 1, ["lg"] = 1, ["or"] = 1 }, type = "Stillwater" },
	["clownfish"] = { colors = { ["wt"] = 1, ["gr"] = 1, ["lg"] = 1, ["or"] = 1 }, type = "Coastal" },
	["little dragonfish"] = { colors = { ["pp"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["orange-striped emperor"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["bl"] = 1 }, type = "Coastal" },
	["longnose hawkfish"] = { colors = { ["wt"] = 1, ["pk"] = 1, ["bl"] = 1 }, type = "Coastal" },
	["Koran angelfish"] = { colors = { ["pk"] = 1, ["bl"] = 1, ["lg"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["flying fish"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["pp"] = 1, ["lb"] = 1 }, type = "Deep Sea" },
	["elephantnose fish"] = { colors = { ["bk"] = 1, ["lb"] = 1, ["or"] = 1 }, type = "River" },
	["angelfish"] = { colors = { ["lb"] = 1, ["bl"] = 1 }, type = "River" },
	["giant pikehead"] = { colors = { ["bl"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1 }, type = "Stillwater" },
	["stickleback"] = { colors = { ["br"] = 1, ["gr"] = 1, ["yl"] = 1 }, type = "Stillwater" },
	["spiny lobster"] = { colors = { ["bk"] = 1, ["gr"] = 1, ["lg"] = 1 }, type = "Coastal" },
	["seahorse"] = { colors = { ["br"] = 1, ["gr"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["pinecone fish"] = { colors = { ["br"] = 1, ["pp"] = 1, ["gr"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["flapjack octopus"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["yl"] = 1 }, type = "Deep Sea" },
	["giant isopod"] = { colors = { ["br"] = 1, ["or"] = 1 }, type = "Deep Sea" },
	["viperfish"] = { colors = { ["br"] = 1, ["gr"] = 1, ["yl"] = 1 }, type = "Deep Sea" },
	["ocellate river stingray"] = { colors = { ["bk"] = 1, ["pp"] = 1 }, type = "River" },
	["Japanese sea bass"] = { colors = { ["pp"] = 1, ["gr"] = 1, ["lg"] = 1, ["rd"] = 1 }, type = "Coastal" },
	["black sea bream"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["br"] = 1, ["pk"] = 1, ["lb"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["rainbow trout"] = { colors = { ["wt"] = 1, ["bl"] = 1, ["gr"] = 1, ["yl"] = 1 }, type = "River" },
	["smallmouth bass"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["bl"] = 1, ["lg"] = 1 }, type = "Stillwater" },
	["skipjack tuna"] = { colors = { ["lb"] = 1, ["bl"] = 1, ["lg"] = 1 }, type = "Deep Sea" },
	["righteye flounder"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["pk"] = 1, ["bl"] = 1 }, type = "Coastal" },
	["common carp"] = { colors = { ["pp"] = 1, ["gr"] = 1, ["yl"] = 1, ["rd"] = 1 }, type = "Stillwater" },
	["largehead hairtail"] = { colors = { ["pk"] = 1, ["lb"] = 1, ["bl"] = 1 }, type = "Coastal" },
	["Japanese Spanish mackerel"] = { colors = { ["pp"] = 1, ["pk"] = 1, ["gr"] = 1, ["lg"] = 1, ["or"] = 1 }, type = "Coastal" },
	["catfish"] = { colors = { ["bk"] = 1, ["br"] = 1, ["yl"] = 1, ["rd"] = 1 }, type = "Stillwater" },
	["largemouth bass"] = { colors = { ["wt"] = 1, ["bl"] = 1, ["yl"] = 1, ["rd"] = 1 }, type = "Stillwater" },
	["Okhotsk Atka mackerel"] = { colors = { ["wt"] = 1, ["lb"] = 1, ["bl"] = 1 }, type = "Coastal" },
	["Alaska pollock"] = { colors = { ["br"] = 1, ["pp"] = 1, ["rd"] = 1 }, type = "Deep Sea" },
	["flathead mullet"] = { colors = { ["gr"] = 1, ["yl"] = 1, ["rd"] = 1 }, type = "Coastal" },
	["northern barramundi"] = { colors = { ["br"] = 1, ["pk"] = 1, ["rd"] = 1 }, type = "River" },
	["yellowtail"] = { colors = { ["br"] = 1, ["lb"] = 1, ["bl"] = 1 }, type = "Deep Sea" },
	["barred knifejaw"] = { colors = { ["bk"] = 1, ["br"] = 1, ["pp"] = 1, ["gr"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["moray eel"] = { colors = { ["bk"] = 1, ["pk"] = 1, ["lg"] = 1, ["or"] = 1 }, type = "Coastal" },
	["chum salmon"] = { colors = { ["wt"] = 1, ["pk"] = 1, ["lg"] = 1, ["or"] = 1 }, type = "River" },
	["tiger pufferfish"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["br"] = 1 }, type = "Coastal" },
	["pike"] = { colors = { ["lb"] = 1, ["gr"] = 1, ["or"] = 1 }, type = "Stillwater" },
	["snakehead"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["lb"] = 1, ["lg"] = 1 }, type = "Stillwater" },
	["iridescent shark"] = { colors = { ["br"] = 1, ["bl"] = 1, ["or"] = 1 }, type = "River" },
	["flounder"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["yl"] = 1, ["or"] = 1 }, type = "Coastal" },
	["eel"] = { colors = { ["pp"] = 1, ["bl"] = 1, ["gr"] = 1 }, type = "Stillwater" },
	["chinook salmon"] = { colors = { ["br"] = 1, ["pk"] = 1, ["lb"] = 1 }, type = "River" },
	["lake trout"] = { colors = { ["bk"] = 1, ["pk"] = 1, ["lg"] = 1, ["or"] = 1 }, type = "Stillwater" },
	["saddled bichir"] = { colors = { ["bk"] = 1, ["br"] = 1, ["lg"] = 1, ["or"] = 1 }, type = "Stillwater" },
	["Pacific cod"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["pk"] = 1, ["yl"] = 1 }, type = "Deep Sea" },
	["Japanese bullhead shark"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["common octopus"] = { colors = { ["wt"] = 1, ["br"] = 1, ["pk"] = 1, ["yl"] = 1, ["or"] = 1 }, type = "Coastal" },
	["alligator snapping turtle"] = { colors = { ["pp"] = 1, ["gr"] = 1, ["yl"] = 1 }, type = "Stillwater" },
	["taimen"] = { colors = { ["pk"] = 1, ["lg"] = 1, ["or"] = 1 }, type = "River" },
	["garfish"] = { colors = { ["rd"] = 1 }, type = "Coastal" },
	["longtooth grouper"] = { colors = { ["pk"] = 1, ["lb"] = 1, ["gr"] = 1, ["yl"] = 1 }, type = "Coastal" },
	["tarpon"] = { colors = { ["bk"] = 1, ["br"] = 1, ["pk"] = 1 }, type = "Coastal" },
	["red sea bream"] = { colors = { ["bl"] = 1, ["yl"] = 1 }, type = "Deep Sea" },
	["Japanese spider crab"] = { colors = { ["lb"] = 1, ["or"] = 1 }, type = "Deep Sea" },
	["mahi-mahi"] = { colors = { ["bk"] = 1, ["pk"] = 1, ["gr"] = 1, ["yl"] = 1 }, type = "Deep Sea" },
	["amberjack"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["or"] = 1 }, type = "Deep Sea" },
	["splendid alfonsino"] = { colors = { ["pk"] = 1, ["yl"] = 1, ["or"] = 1 }, type = "Deep Sea" },
	["sawshark"] = { colors = { ["pk"] = 1, ["lb"] = 1 }, type = "Deep Sea" },
	["arowana"] = { colors = { ["lb"] = 1, ["yl"] = 1, ["or"] = 1 }, type = "River" },
	["dorado"] = { colors = { ["br"] = 1, ["pk"] = 1, ["gr"] = 1, ["yl"] = 1, ["or"] = 1 }, type = "River" },
	["Nile perch"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["pk"] = 1, ["or"] = 1 }, type = "River" },
	["koi"] = { colors = { ["pk"] = 1, ["lg"] = 1 }, type = "Stillwater" },
	["humphead wrasse"] = { colors = { ["br"] = 1, ["gr"] = 1, ["lg"] = 1 }, type = "Coastal" },
	["horseshoe crab"] = { colors = { ["wt"] = 1, ["gr"] = 1 }, type = "Coastal" },
	["coelacanth"] = { colors = { ["pk"] = 1, ["lg"] = 1 }, type = "Deep Sea" },
	["stringfish"] = { colors = { ["br"] = 1, ["pk"] = 1 }, type = "River" },
	["footballfish"] = { colors = { ["br"] = 1, ["lb"] = 1 }, type = "Deep Sea" },
	["frilled shark"] = { colors = { ["wt"] = 1, ["br"] = 1 }, type = "Deep Sea" },
	["gigantic carp"] = { colors = { ["bk"] = 1, ["lg"] = 1 }, type = "River" },
	["Mediterranean dealfish"] = { colors = { ["wt"] = 1, ["br"] = 1 }, type = "Deep Sea" },
	["gulper eel"] = { colors = { ["bk"] = 1, ["bl"] = 1 }, type = "Deep Sea" },
	["electric eel"] = { colors = { ["br"] = 1, ["lb"] = 1 }, type = "River" },
	["African lungfish"] = { colors = { ["br"] = 1, ["lb"] = 1 }, type = "Stillwater" },
	["wels catfish"] = { colors = { ["bk"] = 1, ["pk"] = 1, ["lb"] = 1, ["or"] = 1 }, type = "Stillwater" },
	["North Pacific giant octopus"] = { colors = { ["br"] = 1, ["bl"] = 1 }, type = "Coastal" },
	["scalloped hammerhead"] = { colors = { ["pp"] = 1, ["lg"] = 1, ["rd"] = 1 }, type = "Coastal" },
	["alligator gar"] = { colors = { ["bk"] = 1, ["lb"] = 1, ["gr"] = 1 }, type = "Stillwater" },
	["bluefin tuna"] = { colors = { ["bk"] = 1, ["br"] = 1, ["lg"] = 1, ["or"] = 1 }, type = "Deep Sea" },
	["great white shark"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["pp"] = 1, ["gr"] = 1 }, type = "Coastal" },
	["marlin"] = { colors = { ["wt"] = 1, ["lg"] = 1, ["yl"] = 1 }, type = "Deep Sea" },
	["tawny nurse shark"] = { colors = { ["gr"] = 1, ["or"] = 1 }, type = "Coastal" },
	["sunfish"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["gr"] = 1 }, type = "Deep Sea" },
	["manta ray"] = { colors = { ["pk"] = 1, ["gr"] = 1, ["rd"] = 1 }, type = "Deep Sea" },
	["giant freshwater stingray"] = { colors = { ["wt"] = 1, ["lg"] = 1 }, type = "River" },
	["whale shark"] = { colors = { ["br"] = 1, ["pp"] = 1, ["lg"] = 1 }, type = "Deep Sea" },
	["beluga"] = { colors = { ["bk"] = 1, ["pk"] = 1, ["gr"] = 1 }, type = "River" },
	["arapaima"] = { colors = { ["br"] = 1, ["lg"] = 1, ["yl"] = 1 }, type = "River" },
	["spotted eagle ray"] = { colors = { ["wt"] = 1, ["pk"] = 1, ["bl"] = 1 }, type = "Deep Sea" },
	["Leedsichthys"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["gr"] = 1, ["rd"] = 1 }, type = "Deep Sea" },
	["Rhizodus"] = { colors = { ["br"] = 1, ["lb"] = 1, ["lg"] = 1, ["yl"] = 1 }, type = "River" },
	["Dunkleosteus"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["bl"] = 1 }, type = "Deep Sea" },
	["Nessie"] = { colors = { ["gr"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "Stillwater" },
	["Kronosaurus"] = { colors = { ["lb"] = 1, ["gr"] = 1 }, type = "Deep Sea" },
	["Dragon"] = { colors = { ["pp"] = 1, ["lg"] = 1, ["yl"] = 1 }, type = "Stillwater" },
	["Leviathan"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["lb"] = 1, ["bl"] = 1 }, type = "Deep Sea" },
	["Kraken"] = { colors = { ["pk"] = 1, ["lg"] = 1, ["yl"] = 1 }, type = "Deep Sea" },
	["UFO"] = { colors = { ["br"] = 1, ["lb"] = 1, ["gr"] = 1 }, type = "Stillwater" },
	["giant squid"] = { colors = { ["bk"] = 1, ["or"] = 1, ["rd"] = 1 }, rare = true, type = "Deep Sea" },
	["giant oarfish"] = { colors = { ["wt"] = 1, ["bl"] = 1, ["gr"] = 1 }, rare = true, type = "Deep Sea" },
	["golden bass"] = { colors = { ["br"] = 1, ["pk"] = 1, ["lb"] = 1, ["rd"] = 1 }, rare = true, type = "Stillwater" },
	["golden koi"] = { colors = { ["br"] = 1, ["pk"] = 1, ["bl"] = 1, ["lg"] = 1 }, rare = true, type = "Stillwater" },
	["golden bream"] = { colors = { ["br"] = 1, ["lb"] = 1, ["bl"] = 1, ["rd"] = 1 }, rare = true, type = "Deep Sea" },
	["golden rainbow trout"] = { colors = { ["bk"] = 1, ["pp"] = 1, ["lb"] = 1, ["or"] = 1 }, rare = true, type = "River" },
	["golden salmon"] = { colors = { ["wt"] = 1, ["pk"] = 1, ["lg"] = 1, ["or"] = 1 }, rare = true, type = "River" },
	["golden tuna"] = { colors = { ["wt"] = 1, ["pp"] = 1, ["bl"] = 1, ["lg"] = 1 }, rare = true, type = "Deep Sea" },
	["golden marlin"] = { colors = { ["pp"] = 1, ["gr"] = 1, ["rd"] = 1 }, rare = true, type = "Deep Sea" },
	["golden shark"] = { colors = { ["wt"] = 1, ["lb"] = 1, ["yl"] = 1, ["or"] = 1 }, rare = true, type = "Coastal" },
	["Cheep Cheep"] = { colors = { ["wt"] = 1, ["bl"] = 1, ["yl"] = 1, ["or"] = 1 }, rare = true, type = "Coastal" },
	["Blooper"] = { colors = { ["bk"] = 1, ["br"] = 1, ["pp"] = 1, ["rd"] = 1 }, rare = true, type = "Coastal" },
	["old boot"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["br"] = 1, ["pp"] = 1, ["pk"] = 1, ["lb"] = 1, ["bl"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "Junk" },
	["tin can"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["br"] = 1, ["pp"] = 1, ["pk"] = 1, ["lb"] = 1, ["bl"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "Junk" },
	["log"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["br"] = 1, ["pp"] = 1, ["pk"] = 1, ["lb"] = 1, ["bl"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "Junk" },
	["seaweed"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["br"] = 1, ["pp"] = 1, ["pk"] = 1, ["lb"] = 1, ["bl"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "Junk" },
	["jellyfish"] = { colors = { ["bk"] = 1, ["wt"] = 1, ["br"] = 1, ["pp"] = 1, ["pk"] = 1, ["lb"] = 1, ["bl"] = 1, ["gr"] = 1, ["lg"] = 1, ["yl"] = 1, ["or"] = 1, ["rd"] = 1 }, type = "Junk" },
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
