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


RDL.ZONENAME_ALLZONES = "Все зоны"
RDL.ZONENAME_BGS = "Поля сражений"

RDL.KEYBINDINGTEXT = "Открыть окно Display Leads"

-- UI Filter Elements (Dropdowns) 	

RDL.DropdownTooltips = {
	major = "Комплексные фильтры",
	zone = "Фильтр по Зоне",
	settype = "Фильтр по Типу зацепок",
}

RDL.DropdownData = {
	ChoicesMajor  = { "Можно найти", "Можно выкопать", "Не все записи кодекса", "Ни разу не выкопанные", "Активные ", "Все", "Групповые подземелья", "Latest DLC",},
  
	TooltipsMajor  = {
		"Исключает найденные, но не лоцированые зацепки, а также неповторяющиеся, уже найденные однажды",
		"Показать найденные, но не выкопанные",
		"Показать только те, в которых не открыты все записи из кодекса",
		"Показать только те, которые ещё ни разу не выкопаны",
		"Показать все, кроме законченных не повторяющихся",
		"Показать все, включая законченные не повторяющиеся",
		"Показать только те, которые можно найти в подземельях на 4 человека",
		"Показать только новые зацепки из дополнения latest DLC",
	},
	
	ChoicesZone = {RDL.ZONENAME_ALLZONES, "Текущая зона", "Latest DLC", "Исключить второстепенные DLC", },
	TooltipsZone = { 
		"Показать зацепки из всех зон",
		"Показать зацепки, относящиеся к текущей зоне",
		"Показать зацепки, относящиеся к базовым зонам и главам",
	},
	TooltipsZoneGenerated = "Показать зацепки относящиеся к %s",
	ChoicesSetType  = { "Все", "Скрыть обычные", "Составные древности",},
	TooltipsSetType   = {
		"Показать зацепки всех Типов и Наборов",
		"Скрыть 'Старинные карты', сокровищ, а также главы мотивов.\n За исключением случаев, когда вы находитесь в основном режиме лоцирования. Тогда скрывает только самое первое Зеленое сокровище",
		"Показать только новые зацепки из дополнения latest DLC",
		"Показывать зацепки только составных древностей",
	},
	TooltipsSetTypeGenerated = "Показать зацепки определенного типа/набора %s",
}

-- Alerts Label

RDL.LABEL_ALERTS_UD_MISSING = "|c%sПредупреждения : %d 7Д; %d 1Д; %d 1Ч; ?? UD|r"

RDL.LABEL_ALERTS = "|c%sПредупреждения : %d 7Д; %d 1Д; %d 1Ч; %d UD|r"

-- LOOP
RDL.TOOLTIP_ALERTS_UD_MISSING = {
	"UndauntedDaily аддон не установлен! Невозможно",
	"узнать есть ли в ежедневных заданиях Неустрашимых зацепки для вас",
}

RDL.TOOLTIP_ALERTS_1HOUR = " Срок действия зацепки истекает через < 1 час : %d"
RDL.TOOLTIP_ALERTS_1DAY = " Срок действия зацепки истекает через < 1 день : %d"
RDL.TOOLTIP_ALERTS_7DAYS = " Срок действия зацепки истекает через < 7 дней : %d"
RDL.TOOLTIP_ALERTS_UD_NONEFOUND = "В ежедневных заданиях Неустрашимых нет зацепок для вас"
RDL.TOOLTIP_ALERTS_UD_SCRYFIRST = " (У вас уже есть эта зацепка, для начала Лоцируйте/Выкопайте)"

RDL.LABEL_URL_INITIAL = "На данный момент зацепок не обнаружено"
RDL.LABEL_URL_LEADFOUND = "|c3A92FFСообщить о последней зацепке с ID %d|r"

-- LOOP
RDL.TOOLTIP_URL = {
	"Чтобы упростить отчетность о новых местоположениях: ",
	"Если вы найдете зацепку, этот аддон будет:",
	" - размещать информацию о зацепке в этом поле",
	" - разместит существующее местоположение в поле справа",
	"   (если я посчитаю, что информация о местоположении завершена, я опубликую её",
	"    просьба дважды проверить что ваша информация действительно новая)",
	" - Если вы нашли зацепку в другом месте, пожалуйста:",
	"   - удалить то, что находится в поле редактирования",
	"   - опишите ваше местоположение",
	"   - щелкните это поле здесь",
	"Тогда аддон:",
	" - преобразует информацию в URL",
	" - откроет URL-адрес в браузере после того, как вы дадите согласие в оповещении ZOS",
}

RDL.EDITBOX_INITIAL = "Если вы найдете НОВОЕ местоположение: замените то, что здесь написано; Нажмите «Ярлык» слева, чтобы отправить в браузер."
RDL.EDITBOX_LOCATION_DATA_COMPLETE = "Информация о местоположении считается полной. Отправляйте только в том случае, если ваша находка еще не включена в существующее описание."
RDL.EDITBOX_NO_LEAD_FOUND_OR_SELECTED = "Сначала найдите зацепку или щелкните строку зацепки, о которой вы хотите сообщить."
RDL.EDITBOX_NOT_EDITED = "Чтобы отправить новую находку: сначала замените то, что находится в этом поле редактирования, вашим новым местоположением. Затем нажмите «Ярлык» слева."
RDL.EDITBOX_LOCDATA_EMPTY = "Вам необходимо ввести новое местоположение в это поле редактирования. Затем нажмите «Ярлык» слева."
RDL.EDITBOX_THANKS = "Спасибо за отправку новых данных о местоположении."

RDL.SORTHEADER_NAMES = { "Зацепки", "Зоны", "Местоположения", "Разное", "Кодекс", "Выкопанные", "Наборы", "Срок действия", }
RDL.SORTHEADER_TOOLTIP = {
	"Название древности",
	"Зона в которой зацепка может быть найдена/лоцирована",
	"Краткое описание местоположения\n(Л) = Логово\n(ОП) = Открытое подземелье\n(ГП) = Групповое подземелье\n(МБ) = Мировой босс",
	"Фактическая редкость зацепок. За исключением случаев, когда сложность равна 5.",
	"Как много записей в лоре/кодексе все еще отсутствует",
	"Как много раз древности уже были выкопаны",
	"Название набора, который будет собран, если составлен из нескольких частей древностей\n. Или тип награды, при наличии только одной зацепки.",
	"Время до истечения срока действия зацеки.\n Для некоторых зацепок время истечения срока не уменьшается в течение первых двух дней.",
}

-- LOOP
RDL.TOOLTIP_LEAD_HOWUPDATE = {
	"Если вы знаете о дополнительном местоположении:",
	"Выберите «Строку», чтобы активировать обновление данных о местоположении для этой зацепки.",
	"Замените содержимое окна редактирования своим местоположением, затем нажмите на ярлык слева от него."
}

-- LOOP
RDL.TOOLTIP_INKLING = {
	"Исходные данные о местоположении предоставлены @inklings (Discord, Twitch)",
	"Большое спасибо за то, что позволили мне их использовать.",
	
	"Перевод на русский язык @AWEyeforaneye",
}

RDL.TOOLTIP_MAPPINS = "Included in Hoft's MapPins Addon"



