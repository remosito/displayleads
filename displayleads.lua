local Addon = {}
Addon.Name = "displayleads"
Addon.DisplayName = "Display Leads"
Addon.Author = "remosito"
Addon.Version = "36.8"



-- Unitlist stuff adapted from Scroll List Example Addon

RDLUnitList = ZO_SortFilterList:Subclass()
RDLUnitList.defaults = {}


RDL.UnitList = nil
RDL.units = {}

RDLUnitList.SORT_KEYS = {
		["Lead"] = {},
		["Zone"] = {tiebreaker="Lead"},
		["Location"] = {tiebreaker="Lead"},
		["Diff"] = {tiebreaker="Lead"},
		["Lore"] = {tiebreaker="Lead"},
		["Dug"] = {tiebreaker="Lead"},
		["Set"] = {tiebreaker="Lead"},
		["Expiration"] = {tiebreaker="Lead"}
}

function RDLUnitList:New()
	local units = ZO_SortFilterList.New(self, RDLMainWindow)
	return units
end

function RDLUnitList:Initialize(control)
	ZO_SortFilterList.Initialize(self, control)

	self.sortHeaderGroup:SelectHeaderByKey("Lead")
	--ZO_SortHeader_OnMouseExit(RDLMainWindowHeadersName)

	self.masterList = {}
	ZO_ScrollList_AddDataType(self.list, 1, "RDLUnitRow", 30, function(control, data) self:SetupUnitRow(control, data) end)
	ZO_ScrollList_EnableHighlight(self.list, "ZO_ThinListHighlight")
	self.sortFunction = function(listEntry1, listEntry2) return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, self.currentSortKey, RDLUnitList.SORT_KEYS, self.currentSortOrder) end
	self:RefreshData()
end

function RDLUnitList:BuildMasterList()
	self.masterList = {}
	local units = RDL.units
	for k, v in pairs(units) do
		local data = v
		data["Aid"] = k
		table.insert(self.masterList, data)
	end
end



function RDLUnitList:FilterScrollList()

	local function passesMajor(data)
	

	
		if RDL.savedVars.DropdownChoice["Major"] == RDL.DropdownData["ChoicesMajor"][RDL_DROPDOWN_MAJOR_ALL] then 
			return true
		elseif RDL.savedVars.DropdownChoice["Major"] == RDL.DropdownData["ChoicesMajor"][RDL_DROPDOWN_MAJOR_ACTIONABLE] then
			return  not (  ( not data.Repeatable and  data.Dug == 1 ) or ( data.SetId > 0 and data.Dug > RDL.setsminfound[data.SetId] ) )
		elseif RDL.savedVars.DropdownChoice["Major"] == RDL.DropdownData["ChoicesMajor"][RDL_DROPDOWN_MAJOR_CANSCRY] then
			return data.HaveLead
		elseif RDL.savedVars.DropdownChoice["Major"] == RDL.DropdownData["ChoicesMajor"][RDL_DROPDOWN_MAJOR_CANFIND] then
			if ( not data.HaveLead and  not ( not data.Repeatable and ( data.Dug == 1 ) ) and not ( data.SetId > 0 and data.Dug > RDL.setsminfound[data.SetId] ) ) then
				return true
			else
				return false
			end
		elseif RDL.savedVars.DropdownChoice["Major"] == RDL.DropdownData["ChoicesMajor"][RDL_DROPDOWN_MAJOR_MISSINGCODEX] then
			return ( data.Lore > 0 ) 
		elseif RDL.savedVars.DropdownChoice["Major"] == RDL.DropdownData["ChoicesMajor"][RDL_DROPDOWN_MAJOR_NEVERDUGOUT] then
			return ( data.Dug == 0 ) 
		elseif RDL.savedVars.DropdownChoice["Major"] == RDL.DropdownData["ChoicesMajor"][RDL_DROPDOWN_MAJOR_GROUPDUNGEONS] then
			return ( RDL.isGroupDungeon[data.Aid] ~= nil )
		elseif RDL.savedVars.DropdownChoice["Major"] == RDL.DropdownData["ChoicesMajor"][RDL_DROPDOWN_MAJOR_LATESTDLC] then
			return ( data.Aid >= RDL.LATESTDLC_FIRSTANTIQUITY and not  ( not data.Repeatable and ( data.Dug == 1 ) ) )
		end
	end



	local function passesZone(data)
	

		local currentZoneIndex = GetCurrentMapZoneIndex()
		local currentZoneId = GetZoneId(currentZoneIndex)
		--artaeum partentzone is summerset...does not work for us
		while not (currentZoneId == RDL.ZONEID_ARTAEUM or GetParentZoneId(currentZoneId) == currentZoneId) do 
			currentZoneId = GetParentZoneId(currentZoneId)
		end
		-- Blackreach Caverns are not coded as Child Zones of Western Skyrim/The Reach. Do it ourselves.
		if currentZoneId == RDL.ZONEID_WSKYRIMCAVERN then currentZoneId = RDL.ZONEID_WSKYRIM end
		if currentZoneId == RDL.ZONEID_THEREACHCAVERN then currentZoneId = RDL.ZONEID_THEREACH end
	
		local currentZoneName = ZO_CachedStrFormat("<<C:1>>",GetZoneNameById(currentZoneId))
		if RDL.savedVars.DropdownChoice["Zone"] == RDL.DropdownData["ChoicesZone"][RDL_DROPDOWN_ZONE_ALL] then 
			return true
		elseif RDL.savedVars.DropdownChoice["Zone"] == RDL.DropdownData["ChoicesZone"][RDL_DROPDOWN_ZONE_CURRENT] then 
			if data.ZoneId < RDL.ZONEID_ALLZONES then 
				return ( data.ZoneId == currentZoneId )
			else
				if data.ZoneId == RDL.ZONEID_ALLZONES or data.ZoneId == RDL.ZONEID_UNKNOWN then 
					return true
				elseif data.ZoneId == RDL.ZONEID_BGS then 
					return false -- its from reward coffers
				elseif data.ZoneId == RDL.ZONEID_ARTAEUM_SUMMERSET then 
					return ( ( currentZoneId == RDL.ZONEID_ARTAEUM ) or ( currentZoneId == RDL.ZONEID_SUMMERSET ))
				elseif data.ZoneId == RDL.ZONEID_EASTMARCH_RIFT then 
					return ( ( currentZoneId == RDL.ZONEID_EASTMARCH) or ( currentZoneId == RDL.ZONEID_RIFT))
				elseif data.ZoneId == RDL.ZONEID_CYRODIIL_IMPERIALCITY then 
					return ( ( currentZoneId == RDL.ZONEID_CYRODIIL) or ( currentZoneId == RDL.ZONEID_IMPERIALCITY))
				elseif data.ZoneId == RDL.ZONEID_GALEN_HIGHISLE then 
					return ( ( RDL.savedVars.DropdownChoice["Zone"] == ZO_CachedStrFormat("<<C:1>>", GetZoneNameById(RDL.ZONEID_GALEN)) ) or ( RDL.savedVars.DropdownChoice["Zone"] == ZO_CachedStrFormat("<<C:1>>", GetZoneNameById(RDL.ZONEID_HIGHISLE)) ))
				end
			end
		elseif RDL.savedVars.DropdownChoice["Zone"] == RDL.DropdownData["ChoicesZone"][RDL_DROPDOWN_ZONE_NODLC] then 
			local test =  RDL.zoneType[data.ZoneId] 
			if test == nil or test == RDL.ZONETYPE_CHAPTER or data.ZoneId >= RDL.ZONEID_ALLZONES then
				return true
			else
				return false
			end
		elseif RDL.savedVars.DropdownChoice["Zone"] == RDL.DropdownData["ChoicesZone"][RDL_DROPDOWN_ZONE_LATESTDLC] then
			return ( data.Aid >= RDL.LATESTDLC_FIRSTANTIQUITY and not  ( not data.Repeatable and ( data.Dug == 1 ) ) )
		else
			if data.ZoneId < RDL.ZONEID_ALLZONES then 
				return ( data.Zone == RDL.savedVars.DropdownChoice["Zone"] )
			else
				if data.ZoneId == RDL.ZONEID_ALLZONES or data.ZoneId == RDL.ZONEID_UNKNOWN then 
					return true
				elseif data.ZoneId == RDL.ZONEID_BGS then 
					return false -- its from reward coffers
				elseif data.ZoneId == RDL.ZONEID_ARTAEUM_SUMMERSET then 
					return ( ( RDL.savedVars.DropdownChoice["Zone"] == ZO_CachedStrFormat("<<C:1>>", GetZoneNameById(RDL.ZONEID_ARTAEUM )) ) or ( RDL.savedVars.DropdownChoice["Zone"] == ZO_CachedStrFormat("<<C:1>>", GetZoneNameById(RDL.ZONEID_SUMMERSET)) ))
				elseif data.ZoneId == RDL.ZONEID_EASTMARCH_RIFT then 
					return ( ( RDL.savedVars.DropdownChoice["Zone"] == ZO_CachedStrFormat("<<C:1>>", GetZoneNameById(RDL.ZONEID_EASTMARCH)) ) or ( RDL.savedVars.DropdownChoice["Zone"] == ZO_CachedStrFormat("<<C:1>>", GetZoneNameById(RDL.ZONEID_RIFT)) ))
				elseif data.ZoneId == RDL.ZONEID_CYRODIIL_IMPERIALCITY then 
					return ( ( RDL.savedVars.DropdownChoice["Zone"] == ZO_CachedStrFormat("<<C:1>>", GetZoneNameById(RDL.ZONEID_CYRODIIL)) ) or ( RDL.savedVars.DropdownChoice["Zone"] == ZO_CachedStrFormat("<<C:1>>", GetZoneNameById(RDL.ZONEID_IMPERIALCITY)) ))
				elseif data.ZoneId == RDL.ZONEID_GALEN_HIGHISLE then 
					return ( ( RDL.savedVars.DropdownChoice["Zone"] == ZO_CachedStrFormat("<<C:1>>", GetZoneNameById(RDL.ZONEID_GALEN)) ) or ( RDL.savedVars.DropdownChoice["Zone"] == ZO_CachedStrFormat("<<C:1>>", GetZoneNameById(RDL.ZONEID_HIGHISLE)) ))
				end
			end
		end
	end
	

	local function passesSetType(data)
	
		if RDL.savedVars.DropdownChoice["SetType"] == RDL.DropdownData["ChoicesSetType"][RDL_DROPDOWN_SETTYPE_ALL] then 
			return true
		elseif RDL.savedVars.DropdownChoice["SetType"] == RDL.DropdownData["ChoicesSetType"][RDL_DROPDOWN_SETTYPE_MULTIPART] then  
			local test = RDL.isSet[data.Set]
			if test == nil then
				return true
			else 
				return false
			end
		elseif RDL.savedVars.DropdownChoice["SetType"] == RDL.DropdownData["ChoicesSetType"][RDL_DROPDOWN_SETTYPE_NOOBVIOUS] then
			if RDL.savedVars.DropdownChoice["Major"] == RDL.DropdownData["ChoicesMajor"][RDL_DROPDOWN_MAJOR_CANSCRY] then
				return not ( data.Diff == 1 and data.Set == RDL.TREASURE )
			else
				return not ( ( data.Set == RDL.MOTIF_CHAPTER ) or ( data.Diff < 4 and data.Set == RDL.TREASURE ) or ( data.Diff < 2 and data.Set == RDL.FURNISHING ) )
			end
		else 
			return ( data.Set == RDL.savedVars.DropdownChoice["SetType"] )
		end
	end



	local scrollData = ZO_ScrollList_GetDataList(self.list)
	ZO_ClearNumericallyIndexedTable(scrollData)
	for i = 1, #self.masterList do
		local data = self.masterList[i]
		if passesMajor(data) and passesZone(data) and passesSetType(data) then
			table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
		end
	end
end

function RDLUnitList:SortScrollList()
	local scrollData = ZO_ScrollList_GetDataList(self.list)
	table.sort(scrollData, self.sortFunction)
end




local function getColorCode(intvalue)

	if intvalue == 1 then 
		return RDL.GREEN_TEXT 
	elseif intvalue == 2 then
		return RDL.BLUE_TEXT
	elseif intvalue == 3 then
		return RDL.PURPLE_TEXT
	elseif intvalue == 4 then
		return RDL.GOLD_TEXT
	elseif intvalue == 5 then
		return RDL.ORANGE_TEXT	
	else
		return RDL.DEFAULT_TEXT
	end
end	

local function formatExpiration(leadtimeleft)

	local ltld = 33
	local ltlh = 0
	local ltlm = 0
	local ltls = 0
	ltld = math.floor(leadtimeleft/86400)
	ltlh = math.floor( (leadtimeleft - ltld*86400)/3600)
	ltlm = math.floor( (leadtimeleft - ltld*86400 - ltlh*3600)/60)
	return string.format("%dd %dh %dm", ltld, ltlh, ltlm)
end

local function colorizeExpiration(leadtimeleft)

	if leadtimeleft < 3600 then
		return RDL.RED_TEXT
	elseif leadtimeleft < 86400 then
		return RDL.ORANGE_TEXT
	elseif leadtimeleft < 604800 then
		return RDL.YELLOW_TEXT
	else
		return RDL.GREEN_TEXT
	end
end


function RDLUnitList:SetupUnitRow(control, data)

	control.data = data
	control.Lead = GetControl(control, "Lead")
	control.Zone = GetControl(control, "Zone")
	control.Location = GetControl(control, "Location")
	control.Diff = GetControl(control, "Diff")
	control.Lore = GetControl(control, "Lore")
	control.Dug = GetControl(control, "Dug")
	control.Set = GetControl(control, "Set")
	control.Expiration = GetControl(control, "Expiration")

	local formatbegin = ""
	local formatend = ""
	if ( not data.Repeatable and ( data.Dug == 1 ) ) or ( data.SetId > 0 and data.Dug > RDL.setsminfound[data.SetId] ) then
			formatbegin = "|l0:1:0:-25%:2:000000|l"
			formatend = "|l"
	end
	control.Lead:SetText(formatbegin .. data.Lead .. formatend)
	control.Zone:SetText(formatbegin .. data.Zone .. formatend)
	control.Location:SetText(formatbegin .. data.Location .. formatend)
	control.Diff:SetText(data.Diff)
	control.Lore:SetText(data.Lore)
	control.Dug:SetText(data.Dug)
	control.Set:SetText(formatbegin .. data.Set .. formatend)
	if data.HaveLead then	
		control.Expiration:SetText(formatExpiration(data.Expiration))
	else
		control.Expiration:SetText("")
	end

	control.Lead.normalColor = getColorCode(data.Diff)
	control.Zone.normalColor = getColorCode(data.Diff)
	control.Location.normalColor = getColorCode(data.Diff)
	control.Diff.normalColor = getColorCode(data.Diff)
	control.Lore.normalColor = getColorCode(data.Diff)
	control.Dug.normalColor = getColorCode(data.Diff)
	control.Set.normalColor = getColorCode(data.SetQuality)
	control.Expiration.normalColor = colorizeExpiration(data.Expiration)
	
	ZO_SortFilterList.SetupRow(self, control, data)
end


function RDLUnitList:Refresh()
	self:RefreshData()
end


function RDL.HeaderMouseEnter(control, tooltipindex)
	
	if tooltipindex then
            InitializeTooltip(InformationTooltip, control, LEFT, -5, 0)
            SetTooltipText(InformationTooltip, RDL.SORTHEADER_TOOLTIP[tooltipindex])
    end
	
end

function RDL.HeaderMouseExit(control, tooltipindex)

	if tooltipindex then
        ClearTooltip(InformationTooltip)
    end
end

function RDL.AddInkling()

		ZO_Tooltip_AddDivider(InformationTooltip)
		for i = 1, #RDL.TOOLTIP_INKLING do
			InformationTooltip:AddLine(RDL.TOOLTIP_INKLING[i],"ZoFontGameSmall")
		end
end

function RDL.RowMouseEnter(control)
	
	if control.data.Aid then
		InitializeTooltip(InformationTooltip, control, LEFT, -5, 0)
		local minX, minY, maxX, maxY = InformationTooltip:GetDimensionConstraints()
		RDL.OrigToolTipMaxX = maxX
		InformationTooltip:SetDimensionConstraints(minX, minY, 500, maxY)
		InformationTooltip:SetAntiquityLead(control.data.Aid)
		InformationTooltip:AddVerticalPadding(6)
		ZO_Tooltip_AddDivider(InformationTooltip)
		InformationTooltip:AddVerticalPadding(10)
		SetTooltipText(InformationTooltip,"|c42D6D1"..RDL.Locations[control.data.Aid][1].."|r")
		InformationTooltip:AddVerticalPadding(10)
		if RDL.Locations[control.data.Aid][2] == RDL.LOCDATA_TYPE_FIXLOCATION then
			InformationTooltip:AddLine(RDL.TOOLTIP_MAPPINS)
			InformationTooltip:AddVerticalPadding(10)
		end
		ZO_Tooltip_AddDivider(InformationTooltip)
		if RDL.SETID_2_ITEMID[control.data.SetId] ~= nil then
			local til = string.format("|H1:item:%d:%d:50:0:0:0:0:0:0:0:0:0:0:0:0:%d:%d:0:0:%d:0|h|h", RDL.SETID_2_ITEMID[control.data.SetId], ITEM_DISPLAY_QUALITY_ARTIFACT, ITEMSTYLE_NONE, 0, 10000)
			local numreq, bonus = GetItemLinkSetBonusInfo(til, false, 1)
			local armortype = GetItemLinkArmorType(til)
			InformationTooltip:AddVerticalPadding(10)
			if armortype == 0 then
				InformationTooltip:AddLine(zo_strformat("<<1>>", GetString("SI_EQUIPTYPE",GetItemLinkEquipType(til)) ))
			else 
				InformationTooltip:AddLine(zo_strformat("<<1>> <<2>>", GetString("SI_ARMORTYPE",armortype), GetString("SI_EQUIPTYPE",GetItemLinkEquipType(til)) ))
			end
			SetTooltipText(InformationTooltip, zo_strformat("<<1>>", bonus))
			InformationTooltip:AddVerticalPadding(6)
			ZO_Tooltip_AddDivider(InformationTooltip)
		end
		
		for i = 1, #RDL.TOOLTIP_LEAD_HOWUPDATE do
			InformationTooltip:AddLine(RDL.TOOLTIP_LEAD_HOWUPDATE[i],"ZoFontGameSmall")
		end
		RDL.AddInkling()
	end	
	RDL.UnitList:Row_OnMouseEnter(control)
end

function RDL.RowMouseExit(control)

	if control.data.Aid then
		if RDL.OrigToolTipMaxX ~= nil then
			InformationTooltip:SetDimensionConstraints(minX, minY, RDL.OrigToolTipMaxX, maxY)
		end
		ClearTooltip(InformationTooltip)
	end
	RDL.UnitList:Row_OnMouseExit(control)
end

function RDL.RowMouseUp(control)

	RDL.antiquityFound(0, control.data.Aid)
end


function RDL.LeadfoundMouseEnter(control)

	InitializeTooltip(InformationTooltip, control, BOTTOMLEFT, 0, 0)
	local minX, minY, maxX, maxY = InformationTooltip:GetDimensionConstraints()
	RDL.OrigToolTipMaxX = maxX
	InformationTooltip:SetDimensionConstraints(minX, minY, 450, maxY)
	for i = 1, #RDL.TOOLTIP_URL do
		InformationTooltip:AddLine(RDL.TOOLTIP_URL[i], "", 1,1,1, LEFT, MODIFY_TEXT_TYPE_NONE, TEXT_ALIGN_LEFT, true)
	end
	RDL.AddInkling()
end

function RDL.LeadfoundMouseExit(control)
	
	if RDL.OrigToolTipMaxX ~= nil then
		InformationTooltip:SetDimensionConstraints(minX, minY, RDL.OrigToolTipMaxX, maxY)
	end
	ClearTooltip(InformationTooltip)
end

function RDL.AlertsMouseEnter(control)

	InitializeTooltip(InformationTooltip, control, LEFT, -5, 0)
	local minX, minY, maxX, maxY = InformationTooltip:GetDimensionConstraints()
	RDL.OrigToolTipMaxX = maxX
	InformationTooltip:SetDimensionConstraints(minX, minY, 450, maxY)
	
	for i = 1, #RDL.AlertsTooltipmsg do
		InformationTooltip:AddLine(RDL.AlertsTooltipmsg[i])
	end
end

function RDL.AlertsMouseExit(control)

	if RDL.OrigToolTipMaxX ~= nil then
		InformationTooltip:SetDimensionConstraints(minX, minY, RDL.OrigToolTipMaxX, maxY)
	end
	ClearTooltip(InformationTooltip)
end



-- Combobox stuff adapted with permission from manavortex's fabulous FurnitureCatalogue 
-- who adapted it from LAM which is under Open License

-- show/hide Tooltips for 
function RDL.DropdownShowTooltip(control, dropdownname, reAnchor)
  InitializeTooltip(InformationTooltip, control, BOTTOM, 0, 0, 0)
  InformationTooltip:SetHidden(false)
  InformationTooltip:ClearLines()
  InformationTooltip:AddLine(RDL.DropdownTooltips[dropdownname])
end

function RDL.DropdownHideTooltip(control)
  InformationTooltip:ClearLines()
  InformationTooltip:SetHidden(true)
end


local function createInventoryDropdown(dropdownName)
	local controlName     = string.format("%s%s", "RDL_Dropdown", dropdownName)
	local control       = _G[controlName]
	local dropdownData     = RDL.DropdownData
	local validChoices     = dropdownData[string.format("%s%s", "Choices", dropdownName)]
	local choicesTooltips   = dropdownData[string.format("%s%s", "Tooltips", dropdownName)]
	local comboBox


	control.comboBox = control.comboBox or ZO_ComboBox_ObjectFromContainer(control)
	comboBox = control.comboBox
	comboBox:SetHeight(800)
	local function HideTooltip(control)
	  ClearTooltip(InformationTooltip)
	end


	local function SetupTooltips(comboBox, choicesTooltips)

	  local function ShowTooltip(control)
		InitializeTooltip(InformationTooltip, control, TOPRIGHT, -10, 0, TOPLEFT)
		SetTooltipText(InformationTooltip, control.tooltip)
		InformationTooltipTopLevel:BringWindowToTop()
	  end


	  -- allow for tooltips on the drop down entries
	  local originalShow = comboBox.ShowDropdownInternal
	  comboBox.ShowDropdownInternal = function(comboBox)
		originalShow(comboBox)
		local entries = ZO_Menu.items
		for i = 1, #entries do

		  local entry = entries[i]
		  local control = entries[i].item
		  control.tooltip = choicesTooltips[i]
		  if control.tooltip then
			entry.onMouseEnter = control:GetHandler("OnMouseEnter")
			entry.onMouseExit = control:GetHandler("OnMouseExit")
			ZO_PreHookHandler(control, "OnMouseEnter", ShowTooltip)
			ZO_PreHookHandler(control, "OnMouseExit", HideTooltip)
		  end

		end
	  end

	  local originalHide = comboBox.HideDropdownInternal
	  comboBox.HideDropdownInternal = function(self)
		local entries = ZO_Menu.items
		for i = 1, #entries do
		  local entry = entries[i]
		  local control = entries[i].item
		  control:SetHandler("OnMouseEnter", entry.onMouseEnter)
		  control:SetHandler("OnMouseExit", entry.onMouseExit)
		  control.tooltip = nil
		end
		HideTooltip(self)
		originalHide(self)
	  end
	end

	function OnItemSelect(control, choiceText, somethingElse)
	  local dropdownName = tostring(control.m_name):gsub("RDL_Dropdown", "")
	  RDL.savedVars.DropdownChoice[dropdownName] = choiceText
	  HideTooltip(control)
	  PlaySound(SOUNDS.POSITIVE_CLICK)
	  RDL.UnitList:RefreshData()
	end

	comboBox:SetSortsItems(false)
	local originalShow = comboBox.ShowDropdownInternal

	local choice = validChoices[1]
	if RDL.savedVars.DropdownChoice[dropdownName]  ~= nil then 
		choice = RDL.savedVars.DropdownChoice[dropdownName] 
	else
		RDL.savedVars.DropdownChoice[dropdownName] = choice
	end
	local foundStoredSelected = false
	for i = 1, #validChoices do
		entry = comboBox:CreateItemEntry(validChoices[i], OnItemSelect)
		comboBox:AddItem(entry)
		if validChoices[i] == choice then
			foundStoredSelected = true
			comboBox:SetSelectedItem(validChoices[i])
		end
	end
	if not foundStoredSelected then
		comboBox:SetSelectedItem(validChoices[1])
		RDL.savedVars.DropdownChoice[dropdownName] = validChoices[1]
	end
	SetupTooltips(comboBox, dropdownData["Tooltips"..dropdownName])

	return control
	end



function RDL.setAlerts(d7, d1, h1)

	local udc = 0
	local function getAlertsColor(d7, d1, h1, udc)
		if h1 > 0 then return RDL.RED_TEXT:ToHex() end
		if d1 > 0 then return RDL.ORANGE_TEXT:ToHex() end
		if udc > 0 then return RDL.BLUE_TEXT:ToHex() end
		if d7 > 0 then return RDL.YELLOW_TEXT:ToHex() end
		return RDL.GREEN_TEXT:ToHex()
	end

	RDL.AlertsTooltipmsg = {}
	table.insert(RDL.AlertsTooltipmsg, string.format(RDL.TOOLTIP_ALERTS_1HOUR, h1))
	table.insert(RDL.AlertsTooltipmsg, string.format(RDL.TOOLTIP_ALERTS_1DAY, d1))
	table.insert(RDL.AlertsTooltipmsg, string.format(RDL.TOOLTIP_ALERTS_7DAYS, d7))

	local pledgedungeons = {}
	local undaunted = UndauntedDaily
	if undaunted ~= nil then
		pledgedungeons = UndauntedDaily.GetPledgeDungeons()
	end
	local udc = 0
	if pledgedungeons ~= nil then
		for i = 1, #pledgedungeons do
			local daid = RDL.ActivityId2AntiquityId[pledgedungeons[i]:GetNormalId()]
			if daid ~= nil then
				local havelead = DoesAntiquityHaveLead(daid)
				local aname = GetAntiquityName(daid)
				local setid = GetAntiquitySetId(daid)
				local setname = GetAntiquitySetName(GetAntiquitySetId(daid))
				local numrecovered = GetNumAntiquitiesRecovered(daid)
				local repeatable = IsAntiquityRepeatable(daid)
				if repeatable or  ( numrecovered == 0 and not havelead ) then 
					if setid > 0 then 
						table.insert(RDL.AlertsTooltipmsg, string.format("%s : %s", pledgedungeons[i]:GetName(), setname))
					else
						table.insert(RDL.AlertsTooltipmsg, string.format("%s : %s", pledgedungeons[i]:GetName(), aname))
					end
					if havelead and repeatable then 
						table.insert(RDL.AlertsTooltipmsg, RDL.TOOLTIP_ALERTS_UD_SCRYFIRST)
					end
					udc = udc + 1
				end
			end
		end
		if udc == 0 then
			table.insert(RDL.AlertsTooltipmsg, RDL.TOOLTIP_ALERTS_UD_NONEFOUND)
		end
		local color = getAlertsColor(d7, d1, h1, udc)
		RDLMainWindowTitleAlerts:SetText(string.format(RDL.LABEL_ALERTS, color, d7, d1, h1, udc))
	else
		for i = 1, #RDL.TOOLTIP_ALERTS_UD_MISSING do
			table.insert(RDL.AlertsTooltipmsg, RDL.TOOLTIP_ALERTS_UD_MISSING[i])
		end
		local color = getAlertsColor(d7, d1, h1, 0)
		RDLMainWindowTitleAlerts:SetText(string.format(RDL.LABEL_ALERTS_UD_MISSING, color, d7, d1, h1))
	end
end



function RDL.toggleRDL(extra)

	if RDLMainWindow:IsHidden() then
		RDL.units = {}
		RDL.setsminfound = {}
		local i = GetNextAntiquityId()
		local foundalreadytable = {}
		local zonestable = {}
		local settypetable = {}
		local d7, d1, h1 = 0, 0, 0
		while i  do
			local havelead = DoesAntiquityHaveLead(i)
			local azoneid = GetAntiquityZoneId(i)
			local azone = ZO_CachedStrFormat("<<C:1>>", GetZoneNameById(azoneid))
			local aname = ZO_CachedStrFormat("<<C:1>>",GetAntiquityName(i))
			local aquality = GetAntiquityQuality(i)
			local setid = GetAntiquitySetId(i)
			local setname = ZO_CachedStrFormat("<<C:1>>", GetAntiquitySetName(setid))
			local setquality = GetAntiquitySetQuality(setid)
			local diff = GetAntiquityDifficulty(i)
			local numrecovered = GetNumAntiquitiesRecovered(i)
			local repeatable = IsAntiquityRepeatable(i)
			if setid > 0 then 
				if RDL.setsminfound[setid] == nil or ( RDL.setsminfound[setid] > numrecovered and not havelead ) then 
					RDL.setsminfound[setid] = numrecovered 
				end
			end
			if setid == 22 then repeatable = false end
			if i == 310 or ( i > 498 and i < 509 ) then repeatable = false end -- ZOS returns true for this Lead even though it is not repeatable...overwrite
			if i == 248 and numrecovered == 1 then havelead = false end -- ZOS didnt clean up character data when fixing multi-purple Eyevea Bug
			local loreleft =  GetNumAntiquityLoreEntries(i) - GetNumAntiquityLoreEntriesAcquired(i)
			local leadtimeleft = GetAntiquityLeadTimeRemainingSeconds(i)
			-- to avoid high skill level boosting difficulty messing up our coloring
			-- some gold rarety leads are difficulty 5, here we need to keep difficulty
			if diff < 5 then 
				diff = aquality
			end
			if havelead then -- some expiration timers come back 0 for a couple of days set to 33
				if ( leadtimeleft == 0 ) then leadtimeleft = 2851200 end
				if leadtimeleft < 3600 then h1 = h1 + 1 
				elseif leadtimeleft < 86400 then d1 = d1 + 1
				elseif leadtimeleft < 604800 then d7 = d7 + 1
				end
			else -- Some Find Locations are different From Scry Location, switch scry for find location
				if RDL.FindScryDifferentZones[i] ~= nil then
					local findzoneid = RDL.FindScryDifferentZones[i]
					local findzonename = ""
					if findzoneid < RDL.ZONEID_ALLZONES then 
						findzonename = ZO_CachedStrFormat("<<C:1>>", GetZoneNameById(findzoneid))
					else
					    findzonename = RDL.ZONENAME_SPECIAL[findzoneid]
					end
					azone = findzonename
					azoneid = findzoneid
				end
			end
			local rewardid = GetAntiquityRewardId(i)
			local rewardtype = GetCollectibleCategoryType(GetCollectibleRewardCollectibleId(rewardid))
			if setname == "" and rewardid > 0 then
				setquality = GetAntiquityQuality(i)
				setname = REWARDS_MANAGER:GetRewardContextualTypeString(rewardid)
				if setname == "Motif Chapter" then setquality = 3 end
			end
			if i >= RDL.LATESTDLC_FIRSTANTIQUITY then -- debug out for new antiquities on pts--
				--d(string.format("%i, %s, %s, %i, %s", i, aname, azone, setid, setname))
			end
			if  azone ~= "" then 
			if RDL.Locations[i] == nil then
				RDL.Locations[i] = { RDL.UNKNOWN, RDL.UNKNOWN, RDL.UNKNOWN, "FALSE",}
			end
			local location = RDL.Locations[i][3]
				RDL.units[i] = {Lead=aname, Zone=azone, ZoneId=azoneid, Location=location, Diff=diff, Lore=loreleft, Dug=numrecovered, Set=setname, SetId=setid, Expiration=leadtimeleft, SetQuality=setquality, HaveLead=havelead, Repeatable=repeatable}
			end
			-- update our zone and set/type collector tables. first time only.
			if not RDL.alreadyrun then 
				if foundalreadytable[azone] == nil and azoneid < RDL.ZONEID_ALLZONES then --dont want fake zones in dropdown
					foundalreadytable[azone] = azone 
					table.insert(zonestable, azone)
				end
				if foundalreadytable[setname] == nil then 
					foundalreadytable[setname] = setname 
					table.insert(settypetable, setname)
				end
			end
			i = GetNextAntiquityId(i)
		end
		-- Populate our Filter Combobox datastructure with our collector tables
		if not RDL.alreadyrun then 
			RDL.alreadyrun = true
	
			local ttmsg
			table.sort(zonestable)
			for a,zone in pairs(zonestable) do
				table.insert(RDL.DropdownData["ChoicesZone"],zone)
				ttmsg = string.format(RDL.DropdownData["TooltipsZoneGenerated"], zone)
				table.insert(RDL.DropdownData["TooltipsZone"], ttmsg)
			end
			table.sort(settypetable)
			for a,settype in pairs(settypetable) do
				table.insert(RDL.DropdownData["ChoicesSetType"], settype)
				ttmsg = string.format(RDL.DropdownData["TooltipsSetTypeGenerated"], settype)
				table.insert(RDL.DropdownData["TooltipsSetType"], ttmsg)
			end
		end
		RDL.setAlerts(d7,d1,h1)
		RDL.UnitList:RefreshData()
	end	
	SCENE_MANAGER:ToggleTopLevel(RDLMainWindow)
end 






function RDL.LocationBoxMouseEnter(control)

	if RDL.lastAntiquityFound ~= 0 then
		InitializeTooltip(InformationTooltip, control, LEFT, -25, 0)
		SetTooltipText(InformationTooltip,"|c42D6D1"..RDL.Locations[RDL.lastAntiquityFound][1].."|r")
	end
end

function RDL.LocationBoxMouseExit(control)

	if RDL.lastAntiquityFound ~= 0 then
		ClearTooltip(InformationTooltip)
	end
end	

function RDL.antiquityFound(EventCode, Aid)

	
	RDL.lastAntiquityFound = Aid
	RDLMainWindowLocationURL:SetText(string.format(RDL.LABEL_URL_LEADFOUND, Aid))
	if RDL.Locations[Aid][4] == "TRUE" then
		RDL.editboxcontent = (RDL.EDITBOX_LOCATION_DATA_COMPLETE)
	else
		RDL.editboxcontent = RDL.Locations[Aid][1]
	end
	RDLLocationBox:SetText(RDL.editboxcontent)
end

function RDL.transmogrify()

	local msg 
	if RDL.lastAntiquityFound == 0 then
		RDL.editboxcontent = RDL.EDITBOX_NO_LEAD_FOUND_OR_SELECTED
	else
		msg = string.format("https://remosito.github.io/sendupdate.html?a=%d\\%s\\%s\\", RDL.lastAntiquityFound, ZO_CachedStrFormat("<<C:1>>",GetZoneNameById(GetAntiquityZoneId(RDL.lastAntiquityFound))), GetAntiquityName(RDL.lastAntiquityFound))
		local locdata = RDLLocationBox:GetText()
		if locdata == RDL.editboxcontent then
			RDL.editboxcontent = RDL.EDITBOX_NOT_EDITED
		elseif locdata == "" then
			RDL.editboxcontent = RDL.EDITBOX_LOCDATA_EMPTY
		else
			locdata = string.gsub(locdata, "#", "%%23")
			locdata = string.gsub(locdata, "&", "%%26")
			locdata = string.gsub(locdata, "\"", "%%27")
			msg = string.format("%s %s", msg, locdata)
			RequestOpenUnsafeURL(msg)
			RDL.editboxcontent = RDL.EDITBOX_THANKS
		end
	end
	RDLLocationBox:SetText(RDL.editboxcontent)
end

function RDL.onLoad(eventCode, name)
	if name ~= Addon.Name then return end
	RDL.savedVars = ZO_SavedVars:NewAccountWide("RDLVars", 1, nil, nil)
	if RDL.savedVars.DropdownChoice == nil then 
		RDL.savedVars.DropdownChoice = {} 
		RDL.savedVars.DropdownChoice["Major"] = RDL.DropdownData["ChoicesMajor"][1]
		RDL.savedVars.DropdownChoice["Zone"] = RDL.DropdownData["ChoicesZone"][1]
		RDL.savedVars.DropdownChoice["SetType"] = RDL.DropdownData["ChoicesSetType"][1]
	end
	RDL.UnitList = RDLUnitList:New()

	RDL.toggleRDL()
	RDLMainWindow:SetHidden(true)
	
	createInventoryDropdown("Major")
	createInventoryDropdown("Zone")
	createInventoryDropdown("SetType")
	RDLLocationBox:SetText(RDL.EDITBOX_INITIAL)
	RDLMainWindowLocationURL:SetText(RDL.LABEL_URL_INITIAL)
	EVENT_MANAGER:RegisterForEvent(Addon.Name, EVENT_ANTIQUITY_LEAD_ACQUIRED, RDL.antiquityFound)
	SCENE_MANAGER:RegisterTopLevel(RDLMainWindow, false)
	EVENT_MANAGER:UnregisterForEvent(Addon.Name, EVENT_ADD_ON_LOADED)
end

SLASH_COMMANDS["/displayleads"] = RDL.toggleRDL
ZO_CreateStringId("SI_BINDING_NAME_TOGGLE_DISPLAY_LEADS", RDL.KEYBINDINGTEXT)
EVENT_MANAGER:RegisterForEvent(Addon.Name, EVENT_ADD_ON_LOADED, RDL.onLoad)


