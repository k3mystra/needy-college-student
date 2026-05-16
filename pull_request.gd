class_name PullRequest extends Resource

var user: String
var title: String
var description: String
var good_merge_chance: float

# A structured pool of your coworkers' data
const PR_POOL: Array[Dictionary] = [
	{
		"user": "Jason",
		"title": "Refactored packet buffer array size",
		"description": "Optimized the network stream processing array to handle exactly 69 iterations maximum. Nice. Code runs smooth.",
		"good_merge_chance": 0.69
	},
	{
		"user": "Jason",
		"title": "Adjusted monitor anchor vector coordinates",
		"description": "Positioned the new UI bounding box. The calculation originally layout out to 68, but 69 felt way more correct. Do not change it back.",
		"good_merge_chance": 0.95
	},
	{
		"user": "Sean",
		"title": "Fixed bus routing backend... mostly",
		"description": "I went in to fix the MMU eBus time calculation, but then I noticed our font scaling looked weird so I updated that instead. Also added a hidden Snake mini-game in the console logs.",
		"good_merge_chance": 0.30
	},
	{
		"user": "Sean",
		"title": "Quick hotfix",
		"description": "Forgot what I actually changed in this branch, but the compiler stopped yelling at me so I'm pushing it. Let's get this merged before lunch.",
		"good_merge_chance": 0.50
	},
	{
		"user": "Izmin",
		"title": "Optimized database query handling for peak performance",
		"description": "Cleaned up the edge cases in the user session table. We are locked in, absolutely maxing out the server bandwidth. The logic is pristine, no cap. Thank me later.",
		"good_merge_chance": 0.99
	},
	{
		"user": "Izmin",
		"title": "Fixed memory leak in thread execution",
		"description": "The main thread was edging on 99% CPU usage for hours. Isolated the leaky loop and shut it down. Gyatt to get this merged immediately.",
		"good_merge_chance": 0.90
	},
	{
		"user": "Dane",
		"title": "Added nested collision layers for UI sectors",
		"description": "Implemented a deep nest of conditional if-statements. It's a bit of a labyrinth down there, like a true ruined kingdom. Found some crawly anomalies in the physics processing, left them in.",
		"good_merge_chance": 0.15 # Loves bugs!
	},
	{
		"user": "Dane",
		"title": "Updated pathfinding node infrastructure",
		"description": "The enemy wandering nodes now drift seamlessly through coordinates. Added a small void element to handle null exceptions. Do not challenge the vessel.",
		"good_merge_chance": 0.40
	},
	{
		"user": "Haqeem",
		"title": "update scripts",
		"description": "merged main branch. currently stuck on anor londo boss fight do not ping me on slack unless the server is literally on fire.",
		"good_merge_chance": 0.20
	},
	{
		"user": "Haqeem",
		"title": "fix everything",
		"description": "praise the sun. it compiles on my machine. just accept it i need to focus on this roll-time window.",
		"good_merge_chance": 0.35
	},
	{
		"user": "Yaro",
		"title": "Cleaned up project folder structure",
		"description": "The assets folder looked super messy! I renamed all the icons to be lowercase and deleted a bunch of weird .gd and .cs text files that were cluttering up my beautiful UI directories! <3",
		"good_merge_chance": 0.05 # Destructive artist code
	},
	{
		"user": "Yaro",
		"title": "Compressed UI typography font files",
		"description": "The fonts are now beautiful 4K high-resolution vector assets. The UI might take an extra 8 seconds to load now, but the line tracking looks absolutely immaculate.",
		"good_merge_chance": 0.80
	},
	{
		"user": "Sean",
		"title": "Cleaned up the UI layout container flags",
		"description": "The layout alignment flags were giving me a headache so I completely rewrote the anchor presets. While doing that, I accidentally changed the server ping interval to match my heart rate when drinking coffee. Feels faster now.",
		"good_merge_chance": 0.25
	},
	{
		"user": "Izmin",
		"title": "Implemented data compression algorithm",
		"description": "The old serialization logic was mid. I implemented a new streaming algorithm that absolutely shreds the packet weight. It is skibidi clean, lock in and merge this post-haste.",
		"good_merge_chance": 0.95
	},
	{
		"user": "Dane",
		"title": "Refactored the transit schedule update loops",
		"description": "Deep within the nested loop structures, I discovered a cluster of rogue conditions. They multiply if you touch them. I left a colony of nested if-statements to stabilize them. It feels like Deepnest down there now. Beautiful.",
		"good_merge_chance": 0.10
	},
	{
		"user": "Haqeem",
		"title": "patching database connections",
		"description": "re-routed the connection pools. had to do this with one hand while holding a shield against the Nameless King. if the database drops connection just retry, my focus is currently occupied.",
		"good_merge_chance": 0.45
	},
	{
		"user": "Yaro",
		"title": "Re-designed the system error console window",
		"description": "The debug terminal console looked way too industrial and depressing! I replaced the harsh red text warnings with soft pastel pink hex values and added a cute bouncing cat animation in the corner. You're welcome! <3",
		"good_merge_chance": 0.30
	},
	{
		"user": "Jason",
		"title": "Updated loop bounds for security key generation",
		"description": "The encryption algorithm was generating odd salt indices. Realigned the iteration cap from 65 up to 67. We are almost at peak optimization, just two more iterations to greatness.",
		"good_merge_chance": 0.85
	},
	{
		"user": "Sean",
		"title": "Blah Blah Blah",
		"description": "huh",
		"good_merge_chance": 0.40
	},
	{
		"user": "Izmin",
		"title": "Refactored client-side input validation checking",
		"description": "The input validation logic was letting absolute garbage through. Patched the boundary parameters so the server stops crying. This fix goes hard, built entirely with high-aura energy.",
		"good_merge_chance": 0.92
	}
]

func _init() -> void:
	# Randomly pick an index from our pool array
	var random_data: Dictionary = PR_POOL.pick_random()
	
	# Populate this specific resource instance with the chosen data
	user = random_data["user"]
	title = random_data["title"]
	description = random_data["description"]
	good_merge_chance = random_data["good_merge_chance"]
