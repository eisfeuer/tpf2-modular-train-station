local Stylelist = require('motras_gamescript.stylelist')

local function isThemeSelection(layout)
    if not layout then
      return false
    end
  
    if layout:getNumItems() < 2 then
      return false
    end

    if layout:getItem(1):getName() ~= 'ToggleButtonGroup' then
      return false
    end
  
    if layout:getItem(0):getName() ~= 'ParamsListComp::ButtonParam::Label' then
      return false
    end
  
    return layout:getItem(0):getText() == 'motras_theme'
  end

  local function renameButton(buttonComponent, newName)
      if not buttonComponent:getLayout() then
        return
      end

      if buttonComponent:getLayout():getNumItems() < 1 then
        return
      end

      if buttonComponent:getLayout():getItem(0):getName() ~= 'ToggleButton::Text' then
        return
      end

      buttonComponent:getLayout():getItem(0):setText(newName)
  end
  
  local function handleThemeSelection(layout)
    local label = layout:getItem(0)
    local buttonGrp = layout:getItem(1)

    if buttonGrp:getLayout():getNumItems() < 2 then
        label:setVisible(false, false)
        buttonGrp:setVisible(false, false)
        return
    end

    label:setText(_('motras_theme'))

    local stylelist = Stylelist:new()
    stylelist:collectFromModules()
    local styleNames = stylelist:getNames()
    
    local buttonGrpLayout = buttonGrp:getLayout()
    for i = 1, buttonGrpLayout:getNumItems() do
        local buttonComponent = buttonGrpLayout:getItem(i)

        if i > #styleNames then
            buttonComponent:setVisible(false, false)
        else
            renameButton(buttonComponent, styleNames[i])
        end
    end
  end

function data()
    return {
      guiHandleEvent = function (id, name, param)
        if id == 'constructionBuilder'  then
          local component = api.gui.util.getById("menu.construction.rail.settings")
          local layout = component:getLayout()

          for i = 0, layout:getNumItems() - 1 do
            local item = layout:getItem(i)
            local itemLayout = item:getLayout()
            if isThemeSelection(itemLayout) then
              handleThemeSelection(itemLayout)
            end
          end
        end
      end,
    }
end