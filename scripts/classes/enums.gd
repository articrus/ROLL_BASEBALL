extends Node
class_name Enums

enum DICE_TIERS {
	HR,
	TP,
	DB,
	UT
}

enum DIE_TYPES {
	POWER,
	NORMAL,
	CONTACT
}

enum BATTING_RESULT {
	SINGLE,
	DOUBLE,
	TRIPLE,
	HOMERUN,
	STRIKEOUT,
	NONE
}

enum CITY {
	MTL,
	TOR,
	MIA,
	SAJOS,
	LA,
	CHI,
	BOS,
	SAFRA,
	SADIE,
	KH,
	DEN,
	NY
}

const CITY_COLORS = {
	CITY.MTL: Color(1.0, 1.0, 1.0, 1.0),
	CITY.TOR: Color(0.106, 0.506, 0.816, 1.0),
	CITY.MIA: Color(0.196, 0.196, 0.196, 1.0),
	CITY.SAJOS: Color(1.0, 1.0, 0.0, 1.0),
	CITY.LA: Color(0.631, 0.161, 0.733, 1.0),
	CITY.CHI: Color(0.0, 0.694, 0.365, 1.0),
	CITY.BOS: Color(0.671, 0.0, 0.071, 1.0),
	CITY.SAFRA: Color(0.831, 0.263, 0.0, 1.0),
	CITY.SADIE: Color(1.0, 0.624, 0.267, 1.0),
	CITY.KH: Color(0.357, 0.0, 0.0, 1.0),
	CITY.DEN: Color(0.0, 0.3, 0.162, 1.0),
	CITY.NY: Color(0.106, 0.0, 0.604, 1.0),
}
