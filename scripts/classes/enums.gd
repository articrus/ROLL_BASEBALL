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
	CITY.MTL: Color(0.294, 0.675, 0.878, 1.0),
	CITY.TOR: Color(0.976, 0.976, 0.973, 1.0),
	CITY.MIA: Color(0.247, 0.718, 0.369, 1.0),
	CITY.SAJOS: Color(0.129, 0.333, 0.431, 1.0),
	CITY.LA: Color(0.937, 0.302, 0.137, 1.0),
	CITY.CHI: Color(0.894, 0.176, 0.208, 1.0),
	CITY.BOS: Color(0.137, 0.514, 0.486, 1.0),
	CITY.SAFRA: Color(0.353, 0.239, 0.557, 1.0),
	CITY.SADIE: Color(0.678, 0.882, 0.98, 1.0),
	CITY.KH: Color(0.855, 0.698, 0.29, 1.0),
	CITY.DEN: Color(0.522, 0.086, 0.094, 1.0),
	CITY.NY: Color(0.02, 0.408, 0.224, 1.0),
}

const CITY_SECOND_COLORS = {
	CITY.MTL: Color(0.761, 0.125, 0.149, 1.0),
	CITY.TOR: Color(0.929, 0.125, 0.141, 1.0),
	CITY.MIA: Color(0.969, 0.588, 0.129, 1.0),
	CITY.SAJOS: Color(0.757, 0.612, 0.388, 1.0),
	CITY.LA: Color(0.294, 0.675, 0.878, 1.0),
	CITY.CHI: Color(1.0, 0.827, 0.404, 1.0),
	CITY.BOS: Color(0.98, 0.922, 0.788, 1.0),
	CITY.SAFRA: Color(0.11, 0.157, 0.349, 1.0),
	CITY.SADIE: Color(0.137, 0.239, 0.494, 1.0),
	CITY.KH: Color(0.937, 0.302, 0.137, 1.0),
	CITY.DEN: Color(0.294, 0.675, 0.878, 1.0),
	CITY.NY: Color(0.969, 0.588, 0.129, 1.0),
}

enum RULES {
	GENERAL,
	BATTING,
	PITCHING,
	SPECIAL,
	DICE
}
