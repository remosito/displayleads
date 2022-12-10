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


RDL.ZONENAME_ALLZONES = "Toutes Zones"
RDL.ZONENAME_BGS = "Champ de batailles"

RDL.KEYBINDINGTEXT = "Fenétre de Changement d'affichage des pistes"

-- UI Filter Elements (Dropdowns) 	

RDL.DropdownTooltips = {
	major = "Critères de filtrage complexes",
	zone = "Filtre par Zone",
	settype = "Filtre par ensemble ou type d'antiquité",
}

RDL.DropdownData = {
	ChoicesMajor  = { "Vous pouvez trouver", "Vous pouvez localiser", "Entrées Codex manquantes", "Jamais creusé", "Pistes exploitables", "Toutes les pistes", "Donjons de groupe", "dernière DLC",},
  
	TooltipsMajor  = {
		"Exclut les pistes trouvées mais non scrutés, ainsi que celles non répétables déjà trouvées une fois",
		"Ne montre que les pistes qui ont été trouvés mais pas encore localiser",
		"Ne montre que les antiquités qui n'ont pas d'entrées au Codex",
		"Ne montre que des antiquités qui n'ont pas encore été déterrées",
		"Affiche tous les pistes, sauf les non-répétables finis",
		"Affiche toutes les pistes, y compris les non-répétables finis",
		"Affiche uniquement les pistes provenant des donjons a 4 ",
		"Affiche uniquement les nouvelles pistes provenant de la dernière DLC",
	},
	
	ChoicesZone = {RDL.ZONENAME_ALLZONES, "Zone actuelle", "dernière DLC", "Exclus les DLC mineur", },
	TooltipsZone = { 
		"Affiche les pistes de toutes les zones",
		"Affiche uniquement les pistes se rapportant à la zone actuelle",
		"Affiche uniquement les nouvelles pistes provenant de la dernière DLC",
		"Affiche uniquement les pistes se rapportant aux zones de base et aux chapitres",
	},
	TooltipsZoneGenerated = "Affiche uniquement les pistes relative à %s",
	ChoicesSetType  = { "Tout", "Masquer l'évidence", "Antiquités en plusieurs parties",},
	TooltipsSetType   = {
		"Affiche les pistes pour tous les types et ensembles",
		"Masque les cartes anciennes, les pistes de trésor gratuites ainsi que les chapitres de motifs\nSauf si vous pouvez localiser, en Mode majeur. Ne cache alors que le trésor de couleur verte",
		"Affiche uniquement les pistes pour les antiquités en plusieurs parties",
	},
	TooltipsSetTypeGenerated = "Afficher uniquement la piste de type/ensemble %s",
}

-- Alerts Label

RDL.LABEL_ALERTS_UD_MISSING = "|c%sAlertes : %d 7D; %d 1D; %d 1H; ?? UD|r"

RDL.LABEL_ALERTS = "|c%sAlertes : %d 7D; %d 1D; %d 1H; %d UD|r"

-- LOOP
RDL.TOOLTIP_ALERTS_UD_MISSING = {
	"UndauntedDaily Addon manquant! Je ne peux pas",
	"Calculer si les quotidiennes ont des pistes pour vous",
}

RDL.TOOLTIP_ALERTS_1HOUR = " Pistes expirant dans < 1 heure : %d"
RDL.TOOLTIP_ALERTS_1DAY = " Pistes expirant dans < 1 jour : %d"
RDL.TOOLTIP_ALERTS_7DAYS = " Pistes expirant dans < 7 jour : %d"
RDL.TOOLTIP_ALERTS_UD_NONEFOUND = "Non Undaunted Dailies n'a pas de pistes pour vous"
RDL.TOOLTIP_ALERTS_UD_SCRYFIRST = " (Vous avez déjà cette piste, localiser / fouillez-le d'abord)"

RDL.LABEL_URL_INITIAL = "0 Piste découverte jusqu’ici"
RDL.LABEL_URL_LEADFOUND = "|c3A92FFSignaler la piste avec ID %d|r"

-- LOOP
RDL.TOOLTIP_URL = {
	"Pour rationaliser le signalement de nouveaux emplacements: ",
	"Si vous trouvez une piste avec cet Addon:",
	" - publier les informations d'identification de la piste dans cette boîte",
	" - afficher l'emplacement existant dans le champ à droite",
	"   (si je pense que les informations de localisation sont complètes, elles seront publiées ",
	"   un argument supplémentaire pour vérifier si vos informations sont vraiment nouvelle)",
	" - Si vous avez trouvé la piste ailleurs, veuillez:",
	"   - supprimer ce qui est dans le champ d'édition",
	"   - décrivez votre emplacement",
	"   - Cliquez sur le champ ICI",
	"l'Addon va alors:",
	" - transmogrifier les informations dans une URL",
	" - ouvrez l'URL dans le navigateur après avoir consenti au Popup de ZOS",
}

RDL.EDITBOX_INITIAL = "Si vous trouvez un NOUVEL emplacement: remplacez ce qui apparaîtra ici; Cliquez sur l'étiquette à gauche pour envoyer"
RDL.EDITBOX_LOCATION_DATA_COMPLETE = "Informations de localisation considérées comme complètes. Veuillez soumettre uniquement si votre recherche n'est pas déjà couverte par une description existante"
RDL.EDITBOX_NO_LEAD_FOUND_OR_SELECTED = "Recherchez d'abord une piste ou cliquez sur la ligne de piste que vous souhaitez signaler."
RDL.EDITBOX_NOT_EDITED = "Pour soumettre une nouvelle recherche: Remplacez d'abord ce qui se trouve dans cette boîte d'édition par votre nouvel emplacement. Cliquez ensuite sur l'étiquette à gauche."
RDL.EDITBOX_LOCDATA_EMPTY = "Vous devez entrer votre nouvel emplacement dans cette boîte d'édition. Cliquez ensuite sur l'étiquette à gauche."
RDL.EDITBOX_THANKS = "Merci d'avoir soumis de nouvelles données de localisation"

RDL.SORTHEADER_NAMES = { "Pistes", "Zone", "Emplacement", "Diff", "Conn", "Creusé", "Ensemble", "Expiration", }
RDL.SORTHEADER_TOOLTIP = {
	"Nom de l'Antiquité",
	"Zone où la piste peut être trouvé / localisé",
	"Brève description de l'emplacement\n(D) = fouiller dans\n(PD) = Dongon public\n(GD) = Dongon de groupe\n(WB) = Boss de Zone",
	"Rareté actuelle de la piste. Sauf lorsque la difficulté est 5.",
	"Combien d'entrées connaissance/Codex sont encore manquantes",
	"Combien de fois l'antiquité a-t-elle déjà été creusée",
	"Nom de l'ensemble qui sera récompensé si l'Antiquité et en plusieurs parties\n. Ou type de récompense si piste d'antiquité unique",
	"Délai jusqu'à l'expiration de la piste.\N Pour certaines pistes, le délai d'expiration ne diminue pas pendant les deux premiers jours.",
}

-- LOOP
RDL.TOOLTIP_LEAD_HOWUPDATE = {
	"Si vous connaissez un emplacement supplémentaire:",
	"Cliquez sur la ligne pour activer la mise à jour des données de localisation pour cette piste.",
	"Remplacez le contenu de la boite d'édition, par votre emplacement, puis cliquez sur l'étiquette à gauche de celui-ci"
}

-- LOOP
RDL.TOOLTIP_INKLING = {
	"Données de localisation d'origine fournies par @inklings (Discord, Twitch)",
	"Merci beaucoup de me laisser l'utiliser",
}

RDL.TOOLTIP_MAPPINS = "Inclus dans MapPins Addon de Hoft"



