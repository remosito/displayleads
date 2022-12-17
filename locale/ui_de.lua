-- Notes to Translators:
--   - You will have to create a copy of this file and change it's name to your language. Then translate stuff in that file.
--     List of languages and resulting file names:
--       German: ui_de.lua
--       French: ui_fr.lua
--       Russian: ui_ru.lua
--       Japanese: ui_jp.lua
--       Spanish: ui_es.lua
--       Portuguese: ui_br.lua
--       Polish: ui_pl.lua
--   - /n is newline. It might not work/diplay correctly in all entries. Tooltips should be safe.
--   - %s %d are substitution commands that Addon will replace with dynamic values. They need to stay in translation!
--   - |c ... |r is for coloring text. They need to stay in translation!
--   - Tables/Lists marked "LOOP" are displayed via for loop.  Meaning you can add/remove lines if advantageous for translation
--     If you need to add lines for one not marked loop try /n for newline inside the string
--     If you hit a wall with /n. Let me know. Some additional ones could be changed to LOOP implementation
--   - A lot of UI Elements are fixed width and rather narrow. I know might make translating hard. Please try to fit. 
--     Worst come worst. I might be able to make dimensions as part of the language files. But this would be quite some work I fear. Please try to fit.
--   - Working iterative might be time consuming (Translate some values. Save. /reloadui in game). But safer. 
--     Changing a hundred things. Then /reloadui and nothing works anymore. And trying to figure out which of the 100 changes was the culprit is not pleasant. 


RDL.ZONENAME_ALLZONES = "Alle Zonen"
RDL.ZONENAME_BGS = "Schlachtfelder"

RDL.KEYBINDINGTEXT = "Display Leads Fenster umschalten"

-- UI Filter Elements (Dropdowns)

RDL.DropdownTooltips = {
	major = "Komplexe Filterkriterien",
	zone = "Filter nach Zonen",
	settype = "Filter nach Set / Art der Antiquität",
}

RDL.DropdownData = {
	ChoicesMajor  = { "Kann gefunden werden", "Kann erspäht werden", "Fehlende Kodex-Einträge", "Nie ausgegraben", "Auffindbare Spuren", "Alle Spuren", "Gruppenverlies", "Neue DLCs",},
	
	TooltipsMajor  = {
		"Schließt gefundene, aber nicht erspähte Spuren sowie einmalige, bereits gefundene Spuren aus",
		"Zeigt nur Spuren, die gefunden, aber noch nicht erspäht wurden",
		"Zeigt nur Antiquitäten mit fehlenden Kodex-Einträgen",
		"Zeigt nur Antiquitäten, die noch nicht ausgegraben wurden",
		"Zeigt alle Spuren, mit Ausnahme der abgeschlossenen, einmaligen",
		"Zeigt alle Spuren, einschließlich der abgeschlossenen, einmaligen",
		"Zeigt nur Spuren aus 4er-Verliesen",
		"Zeigt nur neue, auffindbare Spuren der letzten DLC",
	},

	ChoicesZone = {RDL.ZONENAME_ALLZONES, "Aktuelle Zone", "Neue DLCs", "Ohne DLCs", },
	TooltipsZone = { 
		"Zeige Spuren aus allen Zonen",
		"Zeige nur Spuren, die sich in der aktuellen Zone befinden",
		"Zeigt nur neue, auffindbare Spuren der letzten DLC",
		"Zeige nur Spuren vom Basisspiel und Kapiteln",
	},
	TooltipsZoneGenerated = "Zeige ausschließlich Spuren von %s",
	ChoicesSetType  = { "Alles", "Verstecke offensichtliche", "Mehrteilige Antiquitäten",},
	TooltipsSetType   = {
		"Zeigt alle Antiquitäten",
		"Blendet Schatzkarten, Schatztruhen, Startmotive und Kaufbare aus.\nEs sei denn, Du befindest dich im 'Kann erspäht werden'-Modus. Dann werden nur die grünen Startmotive ausgeblendet.",
		"Zeige nur Spuren für mehrteilige Antiquitäten",
	},
	TooltipsSetTypeGenerated = "Zeige nur den Typ %s",
}

-- Alerts Label

RDL.LABEL_ALERTS_UD_MISSING = "|c%sAchtung: %d 7D; %d 1D; %d 1H; ?? UD|r"

RDL.LABEL_ALERTS = "|c%sAchtung: %d 7D; %d 1D; %d 1H; %d UD|r"

-- LOOP
RDL.TOOLTIP_ALERTS_UD_MISSING = {
	"'Undaunted Daily'-Addon fehlt!",
	"(Kann nicht prüfen, ob Dailies Spuren für dich enthalten)",
}

RDL.TOOLTIP_ALERTS_1HOUR = "Auslaufende Spur < 1 Stunde : %d"
RDL.TOOLTIP_ALERTS_1DAY = "Auslaufende Spur < 1 Tag : %d"
RDL.TOOLTIP_ALERTS_7DAYS = "Auslaufende Spur < 7 Tage : %d"
RDL.TOOLTIP_ALERTS_UD_NONEFOUND = "Keine Unerschrockenen-Daily hat eine Spur für Dich"
RDL.TOOLTIP_ALERTS_UD_SCRYFIRST = " (Du hast die Spur bereits. Suche/Erspähe sie zuerst)"

RDL.LABEL_URL_INITIAL = "Bisher keine Spur entdeckt"
RDL.LABEL_URL_LEADFOUND = "|c3A92FFNeuen Fund melden, ID %d|r"

-- LOOP
RDL.TOOLTIP_URL = {
	"Berichterstattung über neue Standorte: ",
	"Hast Du eine Spur gefunden, wird dieses Addon:",
	" - Informationen zur Antiquitäten-ID in dieses Feld eintragen",
	" - vorhandene Standorte in Feld rechts eintragen",
	" - Wenn Du die Antiquität anderswo gefunden hast:",
	" 		- Entferne, was in der EditBox steht",
	" 		- Beschreibe Deinen Standort",
	" 		- Klicke hier auf das Feld",
	"Das Addon macht dann:",
	" - die Informationen in eine URL umwandeln",
	" - Diese URL im Browser öffnen (nachdem Du dem ZOS-Popup zugestimmt hast)",
}

RDL.EDITBOX_INITIAL = "Wenn Du einen neuen Standort findest: Ersetze was hier steht und klicke dann auf 'Neuen Standort melden'."
RDL.EDITBOX_LOCATION_DATA_COMPLETE = "Bitte nur einreichen, wenn Dein Fund nicht bereits durch eine bestehende Beschreibung abgedeckt ist."
RDL.EDITBOX_NO_LEAD_FOUND_OR_SELECTED = "Finde zuerst die neue Spur, klicke dann auf die Spur, welche Du melden möchtest"
RDL.EDITBOX_NOT_EDITED = "Um einen neuen Fund einzureichen: Ersetze zunächst den Inhalt dieser Editbox durch Deinen neuen Standort. Klicke dann auf 'Neuen Standort melden'."
RDL.EDITBOX_LOCDATA_EMPTY = "Du musst Deinen neuen Standort in diesem Feld eingeben. Klicke dann auf 'Neuen Standort melden'."
RDL.EDITBOX_THANKS = "Danke für die Übermittlung des neuen Standortes."

RDL.SORTHEADER_NAMES = { "Spur", "Zone", "Ort", "Stufe", "Kodex", "Anz.", "Set/Art", "Restzeit", }
RDL.SORTHEADER_TOOLTIP = {
	"Name der Antiquität",
	"Zone in der die Antiquität gefunden/erspäht werden kann",
	"Legende Kürzel\n(G) = Gewölbe\n(OV) = Offenes Verlies\n(GV) = Gruppenverlies\n(P) = Prüfung\n(WB) = Weltboss",
	"Tatsächliche Seltenheit der Antiquität (Außer Stufe ist 5). ",
	"Wieviele Kodex-Einträge fehlen noch",
	"Wie oft wurde die Antiquität schon ausgegraben",
	"Name des Sets, zu dem die Spur gehört.\n Oder Art der Belohnung, wenn es sich um eine einteilige Antiquität handelt",
	"Zeit bis zum Auslaufen der Spur.\n (Für einige Spuren beginnt die Auslaufzeit erst nach ein paar Tagen)",
}

-- LOOP
RDL.TOOLTIP_LEAD_HOWUPDATE = {
	"Wenn Du einen zusätzlichen Fundort kennst:",
	"Auf Spur klicken, um den Standort für diese Spur zu aktualisieren.",
	"Ersetze den Inhalt der Box durch deinen Standort und drücke dann auf 'Neuen Standort melden'."
}

-- LOOP
RDL.TOOLTIP_INKLING = {
	"Originale Standortdaten bereitgestellt von @inklings (Discord, Twitch)",
	"Vielen Dank, dass ich diese benutzen durfte.",
}

RDL.TOOLTIP_MAPPINS = "Teil von Hoft's MapPins Addon"
