--http://www.computercraft.info/forums2/index.php?/topic/16943-turtle-mining-swarm/
--http://pastebin.com/pa8LvVWe

--Extractor program
local fts = {[1]={["name"]="swarmsetup",["contents"]="local dir = shell.dir()\
os.loadAPI(fs.combine('/', 'apis.lua'))\
\
function setLabel(prefix)\
  if not os.setComputerLabel(prefix) then\
    local id = os.getComputerID()\
    local label\
    if turtle then\
      label = prefix .. '_' .. id\
    else\
      label = prefix .. '_'  .. id\
    end\
    os.setComputerLabel(label)\
    print(\"Label set as \" .. label)\
  end\
end\
\
function writeStartup(role)\
\
  if fs.exists('/startup.old') then\
    fs.delete('/startup.old')\
  end\
  if fs.exists('/startup') then\
    fs.copy('/startup', '/startup.old')\
  end\
\
  local contents = string.format(\
    'shell.run(\"%s\")\\n',\
    role)\
\
  Util.writeFile('/startup', contents)\
end\
\
function setup(role, labelPrefix, mustBeTurtle)\
  if mustBeTurtle and not turtle then\
    error('This program can only be run on a turtle')\
  end\
  setLabel(labelPrefix)\
  writeStartup(role)\
  if mustBeTurtle then\
    local fuel = turtle.getFuelLevel()\
    print('Fuel: ' .. fuel)\
    if fuel < 5000 then\
      print('Please add fuel (5000 is recommended)')\
    end\
  end\
end\
\
local startPage = UI.Page({\
  titleBar = UI.TitleBar({\
    title = 'Turtle Mining Swarm setup'\
  }),\
  menu = UI.Menu({\
    x = 12,\
    y = 5,\
    menuItems = { \
      { prompt = 'Set as Mine Worker', event = 'mineWorker' }, \
      { prompt = 'Set as Mining Boss', event = 'miningBoss' }, \
      { prompt = 'Set as Stats Viewer', event = 'miningStats' }, \
      { prompt = 'Quit', event = 'quit' }\
    }\
  })\
})\
\
function startPage:eventHandler(event)\
\
  if event.type == 'mineWorker' then\
    Event.exitPullEvents()\
    UI.term:reset()\
    setup('mineWorker', 'miner', true)\
    print('Break and load this turtle into the boss when ready')\
\
  elseif event.type == 'miningBoss' then\
    Event.exitPullEvents()\
    UI.term:reset()\
    setup('miningBoss', 'miningBoss', true)\
    print('Ready to boss some miners')\
    print('Reboot when ready')\
\
  elseif event.type == 'miningStats' then\
    Event.exitPullEvents()\
    UI.term:reset()\
    setup('miningStatus.lua', 'miningStatus', false)\
    print('Best to start this computer/turtle before the boss')\
    print('Reboot when ready')\
\
  elseif event.type == 'quit' then\
    Event.exitPullEvents()\
    UI.term:reset()\
  end\
\
  return UI.Page.eventHandler(self, event)\
end\
\
Logger.disable()\
\
local args = { ... }\
if #args > 0 then\
  if args[1] == 'miner' then\
    os.queueEvent('char', '1')\
  elseif args[1] == 'boss' then\
    os.queueEvent('char', '2')\
  elseif args[1] == 'stats' then\
    os.queueEvent('char', '3')\
  else\
    error('valid options are: miner, boss, or stats')\
  end\
end\
\
UI.pager:setPage(startPage)\
\
Event.pullEvents()\
",},[2]={["name"]="mineWorker",["contents"]="os.loadAPI('apis.lua')\
\
Peripheral.wrap(\"wireless_modem\")\
\
local slots\
local fillerSlots\
local fuelSlot\
local condenced = false\
\
function initSlots()\
  slots = TL2.getSlots()\
  fillerSlots = { }\
\
  for k,slot in ipairs(slots) do\
    if k == 1 then\
      slot.type = 'enderChest'\
      slot.qty = 1\
    elseif slot.qty == 1 then\
      slot.type = 'filler'\
      slot.qty = 64\
      table.insert(fillerSlots, slot)\
    else\
      break\
    end\
  end\
end\
\
function mineable(action)\
  if not action.detect() then\
    return false\
  end\
  for k,slot in ipairs(fillerSlots) do\
    turtle.select(slot.slotNo)\
    if action.compare() then\
      if turtle.getItemCount(slot.slotNo) == 64 then\
        condenced = false\
      end\
      if k ~= 1 then\
        table.remove(fillerSlots, k)\
        table.insert(fillerSlots, 1, slot)\
      end\
      if action.side == 'bottom' then\
        return true\
      end\
      return false\
    end\
  end\
  collectDrops(action.suck)\
  return true\
end\
\
function setFuelSlot()\
  -- if not try and find a slot with fuel\
  if not fuelSlot then\
    for _,slot in pairs(slots) do\
      if not slot.type then\
        local qty = turtle.getItemCount(slot.slotNo)\
        if qty > 1 then\
          turtle.select(slot.slotNo)\
          local fuelLevel = turtle.getFuelLevel()\
          if turtle.refuel(1) then\
            local fueled = turtle.getFuelLevel() - fuelLevel\
            if fueled > 15 then -- wood is 15, ash is 20, coal is 80\
              -- mark this one as fuel for later comparison\
              slot.type = 'fuel'\
              slot.qty = 64\
              fuelSlot = slot\
              break\
            end\
          end\
        end\
      end\
    end\
  end\
end\
\
function refuel()\
  setFuelSlot()\
  if turtle.getFuelLevel() < 7500 then\
    Logger.log('mineWorker', 'refueling')\
    for _,slot in pairs(slots) do\
      if not slot.type or slot.type == 'fuel' then\
        local qty = turtle.getItemCount(slot.slotNo)\
        if slot.type then\
          qty = qty - 1\
        end\
        if qty > 0 then\
          Logger.log('mineWorker', 'refueling ' .. qty)\
          turtle.select(slot.slotNo)\
          turtle.refuel(qty)\
        end\
      end\
    end\
  end\
end\
\
function unload()\
  Logger.log('mineWorker', 'unloading')\
  TL2.setDigStrategy('cautious')\
  if turtle.getItemCount(1) ~= 1 then\
    turtle.select(1)\
    if not turtle.digDown() then\
      Logger.log('mineWorker', 'Missing ender chest')\
      TL2.setDigStrategy('normal')\
      return\
    end\
  end\
  turtle.select(1)\
  if not Util.tryTimed(5, function()\
      TL2.digDown()\
      return turtle.placeDown()\
    end) then\
    Logger.log('mineWorker', 'placedown failed')\
  else\
    TL2.reconcileInventory(slots, turtle.dropDown)\
\
    turtle.select(1)\
    turtle.drop(64)\
    turtle.digDown()  \
  end\
  TL2.setDigStrategy('normal')\
end\
\
TLC.registerAction('plug', function(args)\
  if args.plug and not turtle.detectDown() then\
    if getFiller(1) then\
      turtle.placeDown()\
      turtle.select(2)\
    end\
  end\
  return true\
end)\
\
TLC.registerAction('enderChestUnload', function(args)\
  local reserveSlots = args.slots\
\
  fillerSlots = { }\
  for k,slot in pairs(slots) do\
    if k <= reserveSlots then\
      if k == 1 then\
        slot.type = 'enderChest'\
      else\
        slot.type = 'filler'\
        table.insert(fillerSlots, slot)\
      end\
      slot.qty = 1\
    else\
      slot.qty = 0\
      slot.type = nil\
    end\
  end\
  unload()\
  return true\
end)\
\
function getFiller(reserve)\
  for _,slot in pairs(fillerSlots) do\
    if turtle.getItemCount(slot.slotNo) > reserve then\
      turtle.select(slot.slotNo)\
      return true\
    end\
  end\
  if not condenced then\
    condenceAll()\
    return getFiller(reserve)\
  end\
  return false\
end\
\
function doCondence(slot, condenceSlots)\
  local iQty = turtle.getItemCount(slot)\
  turtle.select(slot)\
  for _,cslot in pairs(condenceSlots) do\
    if cslot.slotNo ~= slot then\
      if cslot.qty > 0 and turtle.compareTo(cslot.slotNo) then\
        turtle.select(cslot.slotNo)\
        turtle.transferTo(slot, cslot.qty)\
        iQty = iQty + cslot.qty\
        cslot.qty = 0\
        if iQty >= 64 then\
          break\
        end\
        turtle.select(slot)\
      end\
    end\
  end\
end\
\
function condenceAll()\
  if not condenced then\
    Logger.log('mineWorker', 'condencing')\
    local firstSlot\
    for k,slot in ipairs(slots) do\
      if not slot.type then\
        firstSlot = k\
        break\
      end\
    end\
    if firstSlot then\
      Logger.log('mineWorker', 'condence: first slot: ' .. firstSlot)\
      local condenceSlots = TL2.getFilledSlots(firstSlot)\
      if Util.size(condenceSlots) > 0 then\
        for _,slot in ipairs(fillerSlots) do\
          doCondence(slot.slotNo, condenceSlots)\
        end\
        if fuelSlot then\
          doCondence(fuelSlot.slotNo, condenceSlots)\
        end\
      end\
    end\
  end\
  condenced = true\
end\
\
-- let the boss know how much fuel we are carrying\
function setReserveFuel()\
  TL2.getState().reserveFuel = 0\
  if fuelSlot then\
    TL2.getState().reserveFuel = turtle.getItemCount(fuelSlot.slotNo)-1\
  end\
end\
\
TLC.registerAction('transferFuel', function()\
  if fuelSlot then\
    local qty = turtle.getItemCount(fuelSlot.slotNo)\
    turtle.select(fuelSlot.slotNo)\
    turtle.dropUp(qty-1)\
  end\
  TL2.getState().reserveFuel = 0\
\
  return true\
end)\
\
TLC.registerAction('bore', function(actionArgs, action)\
\
  TL2.setDigStrategy('normal')\
\
  local loc = TL2.getState()\
  local level = loc.z\
  local depth = actionArgs.depth or 9000\
\
  while true do\
    mine(TL2.actions.down)\
    if loc.z <= -depth then\
      break\
    end\
    if not Util.tryTimed(3, TL2.down) then\
      break\
    end\
\
    mine(TL2.actions.forward)\
    TL2.turnRight()\
    mine(TL2.actions.forward)\
\
    if loc.z % 10 == 0 then\
      TLC.performAction('status', { requestor = action.requestor })\
    end \
  end\
\
  TL2.turnRight()\
  mine(TL2.actions.forward)\
\
  TL2.turnRight()\
  mine(TL2.actions.forward)\
\
  TL2.turnLeft()\
\
  while true do\
    turtle.select(2)\
    Util.tryTimed(3, TL2.up)\
    if getFiller(2) then\
      turtle.placeDown()\
    end\
    if loc.z == level then\
      break\
    end\
    if loc.z >= 0 then\
      break\
    end\
\
    mine(TL2.actions.forward)\
    TL2.turnLeft()\
    mine(TL2.actions.forward)\
\
    if loc.z % 10 == 0 then\
      TLC.performAction('status', { requestor = action.requestor })\
    end \
  end\
\
  Logger.log('mineWorker', 'fuel: ' .. turtle.getFuelLevel())\
  if turtle.getFuelLevel() < 1500 then\
    refuel()\
  end\
\
  setReserveFuel()\
  Logger.log('mineWorker', 'reserve fuel: ' .. TL2.getState().reserveFuel)\
\
  TL2.setDigStrategy('cautious')\
  return true\
end)\
\
function checkSpace()\
  if turtle.getItemCount(16) > 0 then\
    refuel()\
    condenceAll()\
    unload()\
    turtle.select(2)\
  end\
end\
\
function collectDrops(suckAction)\
  turtle.select(2)\
  for i = 1, 50 do\
    checkSpace()\
    if not suckAction() then\
      break\
    end\
    condenced = false\
  end\
end\
\
function mine(action)\
  if mineable(action) then\
    checkSpace()\
    --turtle.select(2)\
    action.dig()\
    if action.side ~= 'bottom' and getFiller(2) then\
      turtle.place()\
    end\
  end\
end\
\
TL2.setDigStrategy('cautious')\
TL2.setMode('destructive')\
\
local options = {\
  logMethod = { arg = 'l', type = 'string', value = 'none',\
                desc = 'Logging: wireless or file' }\
}\
Util.getOptions(options, { ... })\
\
Logger.disable()\
Logger.filter('event')\
\
if options.logMethod.value == 'wireless' then\
  Message.enableWirelessLogging()\
elseif options.logMethod.value == 'file' then\
  Logger.setFileLogging('mine.log')\
elseif options.logMethod.value == 'screen' then\
  Logger.setScreenLogging()\
end\
\
TL2.getState().reserveFuel = 0\
initSlots()\
print('mineWorker started...')\
TLC.pullEvents('mineWorker', true)\
",},[3]={["name"]="miningBoss",["contents"]="os.loadAPI('apis.lua')\
\
Peripheral.wrap(\"wireless_modem\")\
\
local args = { ... }\
local options = {\
  chunks    = { arg = 'c', type = 'number', value = -1,\
                desc = 'Number of chunks to mine' },\
  depth     = { arg = 'd', type = 'number', value = 9000,\
                desc = 'Mining depth' },\
  plug      = { arg = 'f', type = 'flag',   value = false,\
                desc = 'Fill in top hole' },\
  logMethod = { arg = 'l', type = 'string', value = 'wireless',\
                desc = 'Logging: file, screen' },\
  help      = { arg = 'h', type = 'flag',   value = false,\
                desc = 'Displays the options' }\
}\
\
local miners = {}\
local pickupQueue = {}\
local workQueue = {}\
local miningStatus = {\
  fuel = 0,\
  activity = nil,\
  count = 0,\
  version = 'v1.3a',\
  prompt = 'm for menu'\
}\
\
local mining = {\
  status = 'idle',\
  firstTurtle,\
  diameter = 1,\
  chunkIndex = 0,\
  chunks = -1,\
  depth = 9000,\
  holes = 0,\
  plug = false\
}\
\
function getChunkCoordinates(diameter, index, x, y)\
  local dirs = { -- circumference of grid\
    { xd =  0, yd =  1, heading = 1 }, -- south\
    { xd = -1, yd =  0, heading = 2 },\
    { xd =  0, yd = -1, heading = 3 },\
    { xd =  1, yd =  0, heading = 0 }  -- east\
  }\
  -- always move east when entering the next diameter\
  if index == 0 then\
    dirs[4].x = x + 16\
    dirs[4].y = y\
    return dirs[4]\
  end\
  dir = dirs[math.floor(index / (diameter - 1)) + 1]\
  dir.x = x + dir.xd * 16\
  dir.y = y + dir.yd * 16\
  return dir\
end\
\
function getChunkLoadedBox()\
  local ax, ay = getCornerOf(TL2.getNamedLocation('chunkborder'))\
  if TL2.getNamedLocation('chunkloader1') then\
    ax, ay = getCornerOf(TL2.getNamedLocation('chunkloader1'))\
  end\
\
  local bx, by = getCornerOf(TL2.getNamedLocation('chunkloader2'))\
  local boundingBox = {\
    ax = math.min(ax, bx),\
    ay = math.min(ay, by),\
    bx = math.max(ax, bx)+15,\
    by = math.max(ay, by)+15\
  }\
  return boundingBox\
end\
\
function getBoreLocations(x, y)\
\
  local locations = {}\
\
  while true do\
    local a = math.abs(y)\
    local b = math.abs(x)\
\
    if x > 0 and y > 0 or\
       x < 0 and y < 0 then\
       -- rotate coords\
       a = math.abs(x)\
       b = math.abs(y)\
    end\
    if (a % 5 == 0 and b % 5 == 0) or\
       (a % 5 == 2 and b % 5 == 1) or\
       (a % 5 == 4 and b % 5 == 2) or\
       (a % 5 == 1 and b % 5 == 3) or\
       (a % 5 == 3 and b % 5 == 4) then\
       table.insert(locations, { x = x, y = y })\
    end\
    if y % 2 == 0 then -- forward dir\
      if (x + 1) % 16 == 0 then\
        y = y + 1\
      else\
        x = x + 1\
      end\
    else\
      if (x - 1) % 16 == 15 then\
        if (y + 1) % 16 == 0 then\
          break\
        end\
        y = y + 1\
      else\
        x = x - 1\
      end\
    end\
  end\
  return locations\
end\
\
-- get the bore location closest to the miner\
local function getClosestLocation(points, b)\
  local key = 1\
  local distance = 9000\
  for k,a in pairs(points) do\
    -- try and avoid floating point operation\
    local d = math.max(a.x, b.x) - math.min(a.x, b.x) + \
              math.max(a.y, b.y) - math.min(a.y, b.y)\
\
    if d < distance then\
      d = math.sqrt(\
        math.pow(a.x - b.x, 2) + math.pow(a.y - b.y, 2)) \
      if d < distance then\
        key = k \
        distance = d \
        if distance <= 1 then\
          break\
        end \
      end \
    end \
  end \
  return table.remove(points, key)\
end \
\
function getCornerOf(c)\
  return math.floor(c.x / 16) * 16, math.floor(c.y / 16) * 16\
end\
\
function showSetup(message)\
  message = message or ''\
  errorPage.message = message\
  UI.pager:setPage('error')\
end\
\
function releaseMiners()\
\
  if mining.status ~= 'mining' then -- chunk loaders are already placed if mining\
    local chunkloadersNeeded = 2\
    if  TL2.getNamedLocation('chunkloader1') then\
      chunkloadersNeeded = 1\
    end\
    if  TL2.getNamedLocation('chunkloader2') then\
      chunkloadersNeeded = chunkloadersNeeded - 1\
    end\
    if turtle.getItemCount(1) < chunkloadersNeeded then\
      showSetup('Not enough chunk loaders in slot 1')\
      return false\
    end\
  end\
\
  local maxMiners = turtle.getItemCount(2)\
  if maxMiners == 0 then\
    showSetup('No ender chests in slot 2')\
  end\
\
  if not mining.firstTurtle then\
    local firstTurtle\
\
    if maxMiners == 1 then\
      for i = 16, 3, -1 do\
        if turtle.getItemCount(i) == 1 then\
          firstTurtle = i\
          break\
        end\
      end\
    else\
      for i = 3, 16 do\
        local itemCount = turtle.getItemCount(i)\
        if itemCount == 0 then\
          break\
        end\
        if itemCount > 1 then\
          if itemCount < maxMiners then\
            maxMiners = itemCount\
          end\
        else\
          firstTurtle = i\
          break\
        end\
      end\
    end\
\
    if not firstTurtle then\
      showSetup('No turtles found in inventory')\
      return false\
    end\
Logger.log('miningBoss', 'firstTurtle: ' .. firstTurtle)\
Logger.log('miningBoss', 'maxMiners: ' .. maxMiners)\
\
    -- check resources\
    local minerCount = 0\
    for i = firstTurtle, 16 do\
      if turtle.getItemCount(i) == 1 then\
        minerCount = minerCount + 1\
      end\
    end\
Logger.log('miningBoss', 'minerCount: ' .. minerCount)\
    if minerCount > maxMiners then\
      for i = 3, firstTurtle-1 do\
        if turtle.getItemCount(i) == maxMiners then\
          showSetup('Not enough resources in slot ' .. i)\
          return false\
        end\
      end\
    end\
    -- sanity checking\
    for i = firstTurtle, 16 do\
      if turtle.getItemCount(i) > 1 then\
        showSetup('Invalid setup')\
        return false\
      end\
    end\
    mining.firstTurtle = firstTurtle\
  end\
\
  for i = mining.firstTurtle, 16 do\
    if turtle.getItemCount(i) == 1 then\
      queueWork(51, 'releaseMiner-' .. i, 'releaseMiner', { slot = i })\
    end\
  end\
\
  return true\
end\
\
function updateStatus(miner, status)\
\
  local function getIndicator(value, past)\
    local ind = ' '\
    if past then\
      if value > past then\
        ind = '^'\
      elseif value < past then\
        ind = 'v'\
      end\
    end\
    return ind\
  end\
\
  miner.statusD = miner.xStatus\
  if miner.xStatus ~= 'deployed' then\
    miner.statusD = miner.xStatus\
    if miner.xStatus == 'pickup' then\
      miner.statusD = 'pkup'\
    end\
  end\
\
  if not miner.lastFuel then\
    miner.lastFuel = miner.fuel\
  end\
  miner.fuelD = string.format(\"%s%dk\",\
    getIndicator(math.floor(miner.fuel/1024), math.floor(miner.lastFuel/1024)),\
    math.floor(miner.fuel/1024))\
  miner.lastFuel = miner.fuel\
\
  miner.depthD = string.format(\"%s%d\",\
    getIndicator(status.z, miner.lastLocation.z),\
    status.z)\
  miner.lastLocation = miner.location\
  miner.coordsD = string.format(\"%d,%d\", status.x, status.y)\
\
  miner.timestamp = os.clock()\
\
  local timer = Event.getNamedTimer('statusTimer')\
  if not timer or not Event.isTimerActive(timer) then\
    Event.addNamedTimer('statusTimer', 1, false, function()\
      if statusPage.enabled then\
        statusPage:draw()\
      end\
    end)\
  end\
end\
\
function releaseMiner(slot)\
\
  if mining.status ~= 'mining' then\
    return true\
  end\
\
  showActivity('Releasing miner')\
  local x, y = getCornerOf(TL2.getNamedLocation('chunkloader2'), 16, 16, 1)\
  local box = TL2.pointToBox({ x = x, y = y, z = 0 }, 16, 16, 1)\
  while true do\
    local deployPt = TL2.createPoint(TL2.getState())\
    deployPt.x = deployPt.x - 2\
    deployPt.y = deployPt.y - 2\
    local deployBox = TL2.pointToBox(deployPt, 4, 4, 1)\
    TL2.boxContain(box, deployBox)\
    if not TL2.pointInBox(TL2.getState(), deployBox) or TL2.isTurtleAt('bottom') then\
      local r = Util.random(15)\
      TL2.goto(deployBox.ax + math.floor(r / 4), deployBox.ay + r % 4, 0)\
    end\
    if not turtle.detectDown() then\
      break\
    end\
    if not TL2.isTurtleAt('bottom') and TL2.digDown() then\
      break\
    end\
  end\
\
  if turtle.getItemCount(slot) ~= 1 then\
    showActivity('Not a turtle')\
    return true\
  end\
\
  for i = 2, mining.firstTurtle - 1 do\
    if turtle.getItemCount(i) == 0 then\
      showActivity('Not enough resources')\
      return true\
    end\
  end\
\
  -- place miner\
  if not TL2.placeDown(slot) then\
    -- someone took out a turtle from the inventory :(\
    return true\
  end\
  os.sleep(.1)\
\
  -- give miner resources\
  for i = 2, mining.firstTurtle - 1 do\
    TL2.select(i)\
    turtle.dropDown(1)\
  end\
\
  peripheral.call('bottom', 'turnOn')\
\
  if not Util.tryTimed(5,\
    function()\
      local id = peripheral.call('bottom', 'getID')\
      if id then\
        local pt = TL2.createPoint(TL2.getState())\
        pt.heading = TL2.getState().heading\
        miners[id] = {\
          id = id,\
          status = 'idle',\
          xStatus = 'new',\
          deployLocation = pt,\
          location = pt,\
          lastLocation = pt,\
          name = 'turtle_' .. tostring(id)\
        }\
        TLC.requestState(id)\
        return true\
      end\
      os.sleep(.1)\
      return false\
    end) then\
    -- turtle won't start or this is not a turtle\
    TL2.select(slot)\
    turtle.digDown()\
  end\
\
  --pager:setPage('status')\
  return true\
end\
\
TLC.registerAction('releaseMiner', function(args)\
  return releaseMiner(args.slot)\
end)\
\
function collectMiner(miner)\
  showActivity('Picking up turtle')\
\
  if not TL2.pointInBox(miner.location, getChunkLoadedBox()) then\
    shutdownCommand(miner)\
    Logger.log('miningBoss', 'shutting down ' .. miner.id .. ' too far away')\
    return true\
  end\
\
  TL2.goto(miner.location.x, miner.location.y, 0)\
\
  if not TL2.isTurtleAt('bottom') then\
    queueWork(3,  'rescue-' .. miner.id, 'rescueMiner', miner)\
--[[\
      Logger.log('shutting down ' .. miner.id .. ' unable to locate')\
      TLC.sendAction(miner.id, 'shutdown', location)\
      miners[miner.id] = nil\
--]]\
    return true\
  end\
\
  local id = peripheral.call('bottom', 'getID')\
  if id and miners[id] then\
    local miner = miners[id]\
    local slots = TL2.getInventory()\
    for i = 2, mining.firstTurtle-1 do\
      TL2.select(i)\
      if turtle.suckDown() then\
        slots[i].qty = slots[i].qty + 1\
      end\
    end\
    TL2.reconcileInventory(slots)\
    local slot = TL2.selectOpenSlot(3)\
    miners[miner.id] = nil\
    if not slot then\
      -- too many turtles for inventory\
      peripheral.call('bottom', 'shutdown')\
      Logger.log('miningBoss', 'shutting down ' .. id .. ' no room')\
    elseif turtle.digDown() then\
      if mining.status == 'mining' and miner.fuel > 1024 then\
        -- check to see if we mined up something other than a turtle\
        if turtle.getItemCount(slot) == 1 then\
          releaseMiner(slot)\
        end\
      end\
    end\
    UI.pager:getCurrentPage():draw()\
    if Util.size(miners) == 0 then\
      UI.pager:setPage('menu')\
      local chunks = math.pow(mining.diameter-2, 2) + mining.chunkIndex\
      if mining.status == 'recalling' and\
         mining.chunks ~= -1 and \
         chunks >= mining.chunks then\
        -- automatically exit if we exceeded requested diameter\
        Event.exitPullEvents()\
      end\
    end\
  end\
  return true\
end\
\
function setStatus(status)\
  mining.status = status\
  showActivity()\
end\
\
function showActivity(currentActivity)\
  if currentActivity then\
    miningStatus.activity = currentActivity\
    Logger.log('miningBoss', currentActivity)\
  else\
    miningStatus.activity = mining.status\
  end\
  miningStatus.count = Util.size(miners)\
\
  if UI.pager:getCurrentPage().statusBar then\
    UI.pager:getCurrentPage().statusBar:draw()\
  end\
end\
\
optionsPage = UI.Page({\
  titleBar = UI.TitleBar({\
    title = 'Mining Options',\
    previousPage = true\
  }),\
  form = UI.Form({\
    fields = {\
      { label = 'Chunks', key = 'chunks',display = UI.Form.D.entry, limit = 4,\
        help = 'Number of chunks to mine' },\
      { label = 'Depth', key = 'depth', display = UI.Form.D.entry, limit = 3,\
        help = 'Leave blank for unlimited' },\
      { label = 'Fill top hole', key = 'plug', display = UI.Form.D.chooser,\
        choices = {\
          { name = 'No', value = 'n' },\
          { name = 'Yes', value = 'y' },\
        },\
        width = 7, help = '' },\
      { text = 'Accept', event = 'accept', display = UI.Form.D.button,\
          x = 5, y = 5, width = 10 },\
      { text = 'Cancel', event = 'cancel', display = UI.Form.D.button,\
          x = 19, y = 5, width = 10 }\
    },\
    labelWidth = 18,\
    valueWidth = UI.term.width-18,\
    x = 5,\
    y = 4,\
    height = UI.term.height-4\
  }),\
  statusBar = UI.StatusBar()\
})\
\
function optionsPage:enable()\
  local t = {\
    plug = 'n',\
    depth = '',\
    chunks = '',\
  }\
\
  if mining.plug then\
    t.plug = 'y'\
  end\
  if mining.depth ~= 9000 then\
    t.depth = tostring(mining.depth)\
  end\
  if mining.chunks ~= -1 then\
    t.chunks = tostring(mining.chunks)\
  end\
\
  self.form:setValues(t)\
  self:focusFirst()\
end\
\
function optionsPage:eventHandler(event)\
\
  if event.type == 'focus_change' then\
    self.statusBar:setStatus(event.focused.help)\
    self.statusBar:draw()\
\
  elseif event.type == 'cancel' then\
    UI.pager:setPreviousPage()\
\
  elseif event.type == 'accept' then\
    local values = self.form.values\
\
    values.chunks = tonumber(values.chunks)\
    if not values.chunks or not tonumber(values.chunks) then\
      values.chunks = -1\
    end\
\
    values.depth = tonumber(values.depth)\
    if not values.depth or not tonumber(values.depth) then\
      values.depth = 9000\
    end\
\
    if values.plug == 'Y' or values.plug == 'y' then\
      values.plug = true\
    else\
      values.plug = false\
    end\
\
    mining.depth = values.depth\
    mining.chunks = values.chunks\
    mining.plug = values.plug\
\
    UI.pager:setPreviousPage()\
  end\
\
  return UI.Page.eventHandler(self, event)\
end\
\
\
--[[ -- menuPage -- ]]--\
menuPage = UI.Page({\
  titleBar = UI.TitleBar({\
    title = 'Turtle Mining Swarm ' .. miningStatus.version\
  }),\
  menu = UI.Menu({\
    centered = true,\
    y = 4,\
    width = UI.term.width,\
    menuItems = {\
      { prompt = 'Deploy Miners', event = 'deploy' },\
      { prompt = 'Options',       event = 'options' },\
      { prompt = 'Stop mining',   event = 'stop' },\
      { prompt = 'Status',        event = 'status' },\
      { prompt = 'Help',          event = 'help' },\
      { prompt = 'Quit',          event = 'quit' }\
    }\
  }),\
--[[\
  progressWindow = UI.Window({\
    x = UI.term.width - 20,\
    y = 3,\
    width = 18,\
    height = 9,\
    backgroundColor = colors.blue,\
    totalHolesProgressBar = UI.VerticalMeter({\
      y = 7,\
      x = 2,\
      height = 8\
    }),\
    chunkHolesProgressBar = UI.VerticalMeter({\
      y = 10,\
      x = 2,\
      height = 8\
    }),\
  }),\
--]]\
  statusBar = UI.StatusBar({\
    columns = { \
      { '', 'activity', UI.term.width - 13 },\
      { '', 'fuel', 10 }\
    },\
    status = miningStatus\
  })\
})\
\
function menuPage:enable()\
  local fuel = turtle.getFuelLevel()\
  if fuel > 9999 then\
    miningStatus.fuel = string.format('Fuel: %dk', math.floor(fuel/1000))\
  else\
    miningStatus.fuel = 'Fuel: ' .. turtle.getFuelLevel()\
  end\
end\
\
function menuPage:eventHandler(event)\
  if event.type == 'deploy' then\
    if releaseMiners() then\
      setStatus('mining')\
      UI.pager:setPage('status')\
      if not TL2.getNamedLocation('chunkloader2') then\
        TL2.gotoNamedLocation('chunkborder')\
        TL2.placeUp(1)\
        TL2.saveNamedLocation('chunkloader2', 0, 0, 0)\
        Message.broadcast('alive')\
      end\
    end\
\
  elseif event.type == 'options' then\
    UI.pager:setPage('options')\
\
  elseif event.type == 'stop' then\
    if mining.status == 'mining' then\
      UI.pager:setPage('status')\
      setStatus('recalling')\
    end\
\
  elseif event.type == 'status' then\
    UI.pager:setPage('status')\
\
  elseif event.type == 'help' then\
    showSetup()\
\
  elseif event.type == 'quit' then\
    Event.exitPullEvents()\
    return true\
  end\
\
  return UI.Page.eventHandler(self, event)\
end\
\
--[[ -- statusPage -- ]]--\
statusPage = UI.Page({\
  grid = UI.Grid({\
    columns = {\
      { 'Name', 'name', 13 },\
      { 'Fuel', 'fuelD', 5 },\
      { 'Depth', 'depthD', 6 },\
      --{ 'Coords', 'coordsD', 6 },\
      { 'Time', 'timeD', 5 },\
      { '', 'statusD', 4 }\
    },\
    sortColumn = 'name',\
    pageSize = 11,\
    width = UI.term.width,\
    t = miners,\
    sizeMethod = 'count'\
  }),\
  statusBar = UI.StatusBar({\
    columns = { \
      { '', 'activity', UI.term.width - 13 },\
      { '', 'prompt', 10 }\
    },\
    --backgroundColor = colors.blue,\
    status = miningStatus\
  })\
})\
\
function statusPage:eventHandler(event)\
  if event.type == 'key' then\
    if event.key == 'm' or event.key == 'q' or event.key == 'enter' then\
      UI.pager:setPage('menu')\
      return true\
    end\
  end\
  return self.grid:eventHandler(event)\
end\
\
function statusPage:draw()\
  for _,miner in pairs(miners) do\
    if miner.timestamp then\
      miner.timeD =\
        string.format(\"%ds\",\
        math.floor(os.clock()-miner.timestamp))\
    end\
  end\
  self.grid:draw()\
  self.statusBar:draw()\
end\
\
--[[-- errorPage --]]--\
errorPage = UI.Page({\
  titleBar = UI.TitleBar({\
    title = 'Configuration'\
  }),\
  window = UI.Window({\
    y = 2,\
    height = UI.term.height -1,\
    backgroundColor = colors.blue,\
    focus = function() end\
  })\
})\
\
function errorPage:draw()\
  self.titleBar:draw()\
  self.window:draw()\
  self.window:setCursorPos(1, 1)\
  self.window:print(self.message)\
  self.window:setCursorPos(1, 3)\
  self.window:print('Slot 1: 2 chunk loaders')\
  self.window:print('Slot 2: ender chests ')\
  self.window:print('Slot 3 through x: resources that should not be mined')\
  self.window:print('Place turtles in the remainder of the slots immediately following the resources')\
  self.window:print('')\
  self.window:print('Press any key to continue')\
end\
\
function errorPage:eventHandler(event)\
  if event.type == 'key' then\
    UI.pager:setPage('menu')\
  end\
end\
\
-- tell the miner to unload chest, go to pickup plane and report when ready\
function pickupCommand(miner)\
  if miner.xStatus ~= 'pickup' then\
    TLC.sendActions(miner.id, {\
      { action = 'enderChestUnload', args = { slots = mining.firstTurtle-2 }},\
      { action = 'gotoZ', args = {\
          z = 0, digStrategy = 'cautious', mode = 'destructive' }},\
      { action = 'status' }\
    })\
    miner.xStatus = 'pickup'\
  end\
end\
\
function shutdownCommand(miner)\
  miners[miner.id] = nil\
  TLC.sendActions(miner.id, {\
    { action = 'enderChestUnload', args = { slots = mining.firstTurtle-2 }},\
    { action = 'shutdown' }\
  })\
end\
\
function transferFuelCommand(miner)\
  TLC.sendActions(miner.id, {\
    { action = 'gotoZ', args = {\
          z = 0, digStrategy = 'cautious', mode = 'destructive' }},\
    { action = 'transferFuel' }\
  })\
end\
\
function boreCommand(miner)\
  local bore = getClosestLocation(mining.locations,\
     miner.location)\
\
  mining.holes = mining.holes + 1 -- for status monitor only\
\
  miner.location.x = bore.x\
  miner.location.y = bore.y\
  miner.xStatus = 'busy'\
\
  local actions = {\
    { action = 'gotoZ', args = {\
        z = -1, -- make sure he is on the correct plane\
        digStrategy = 'cautious',\
        mode = 'destructive' }},\
    { action = 'plug', args = {\
        plug = mining.plug }},\
    { action = 'goto', args = {\
        x = bore.x, y = bore.y, z = -1,\
        digStrategy = 'cautious',\
        mode = 'destructive' }},\
    { action = 'gotoZ', args = {\
        z = -2,\
        digStrategy = 'cautious',\
        mode = 'destructive' }},\
    { action = 'bore', args = {\
        depth = mining.depth }},\
    { action = 'status' }\
  }\
  TLC.sendActions(miner.id, actions)\
  saveState()\
end\
\
TLC.registerAction('refuelFromMiner', function(miner)\
  local slot = TL2.selectOpenSlot()\
  if slot and TL2.pointInBox(miner.location, getChunkLoadedBox()) then\
    showActivity('Refueling')\
    TL2.goto(miner.location.x, miner.location.y)\
    transferFuelCommand(miner)\
    Event.waitForEvent('turtle_inventory', 3)\
    turtle.select(slot)\
    turtle.refuel(64)\
    if menuPage.enabled then\
      menuPage:draw()\
    end\
  end\
  return true\
end)\
\
TLC.registerAction('rescueMiner', function(miner)\
\
  --if miner.xStatus ~= 'lost' then\
    --return true\
  --end\
\
  local distance\
  Util.tryTimes(5, function()\
    Message.send(miner.id, 'alive')\
     _,_,_,distance = Message.waitForMessage('isAlive', 1, miner.id)\
    return distance\
  end)\
\
  if not distance then\
    if not miner.retryCount then\
      miner.retryCount = 0\
    end\
    miner.retryCount = miner.retryCount + 1\
    if miner.retryCount > 3 then\
      shutdownCommand(miner)\
      Logger.log('miningBoss', 'shutting down ' .. miner.id .. ' unable to locate')\
    else\
      queueWork(3,  'rescue-' .. miner.id, 'rescueMiner', miner)\
    end\
    return true\
  end\
\
  local boundingBox = getChunkLoadedBox()\
\
  showActivity('Rescuing turtle')\
  --pager:setPage('status')\
  local location = TLC.tracker(miner.id, distance, true, boundingBox)\
  if location then\
    -- miners start out 1 below boss plane\
    location.z = - location.z + 1\
    TLC.sendAction(miner.id, 'setLocation', location)\
  end\
\
  if not location or (args.fuel == 0 and location.z ~= 0) then\
    -- not in a place we can pick up (don't want to leave plane)\
    shutdownCommand(miner)\
    Logger.log('miningBoss', 'shutting down ' .. miner.id .. ' no fuel or too far away')\
  else\
    miner.xStatus = 'lost'\
    pickupCommand(miner)\
  end\
\
  UI.pager:getCurrentPage():draw()\
  Message.broadcast('alive')\
\
  return true\
end)\
\
Message.addHandler('turtleStatus', function(h, id, msg, distance)\
\
  local status = msg.contents\
\
--Logger.log(string.format('%d %s', id, status.status))\
\
  local miner = miners[id]\
\
--if miner then\
--Logger.log('xstatus: ' .. miner.xStatus)\
--end\
\
  if not miner then\
    Message.send(id, 'alive')\
    if mining.status ~= 'mining' or status.status ~= 'idle' then\
      return\
    end\
    miners[id] = {\
      id = id,\
      xStatus = 'lost',\
      lastLocation = { x = 0, y = 0, z = 0 }\
    }\
    miner = miners[id]\
    if status.x == 0 and status.y == 0 and status.z == 0 then\
      queueWork(3,  'rescue-' .. miner.id, 'rescueMiner', miner)\
    elseif TL2.pointInBox(status, getChunkLoadedBox()) then\
      miner.name = tostring(status.name)\
      miner.status = status.status\
      miner.fuel = status.fuel\
      miner.location = { x = status.x, y = status.y, z = status.z }\
      pickupCommand(miner)\
      return\
    else\
      queueWork(3,  'rescue-' .. miner.id, 'rescueMiner', miner)\
    end\
  end\
\
  miner.name = tostring(status.name)\
  miner.status = status.status\
  miner.fuel = status.fuel\
  miner.location = { x = status.x, y = status.y, z = status.z }\
\
  if miner.xStatus == 'new' then\
    -- just deployed\
    TLC.sendAction(id, 'setLocation', miner.deployLocation)\
    miner.location = miner.deployLocation\
    miner.xStatus = 'deployed' -- needed ?? shouldn't it be 'idle'\
  end\
\
  if miner.xStatus == 'lost' then\
    -- ignore\
\
  elseif miner.xStatus == 'pickup' then\
    if not pickupQueue[miner.id] then\
      pickupQueue[miner.id] = miner\
      queueWork(50, 'checkMiners', 'checkMiners')\
    end\
\
  elseif miner.status == 'idle' then\
\
    if mining.status == 'recalling' then\
      pickupCommand(miner)\
\
    elseif mining.status == 'mining' and TL2.getState().status == 'idle' then\
\
      if msg.contents.fuel > 1024 then\
        if #mining.locations == 0 then\
          if not isQueued('moveChunkLoaders') then\
            queueWork(75, 'moveChunkLoaders', 'moveChunkLoaders')\
          end\
        else\
          if turtle.getFuelLevel() < 15000 and status.reserveFuel > 0 then\
            TLC.performAction('refuelFromMiner', miner)\
          end\
          boreCommand(miner)\
        end\
      else\
        Logger.log('miningBoss', 'miner ' .. miner.id .. ' low fuel')\
        pickupCommand(miner)\
      end\
    end\
  end\
  updateStatus(miner, status)\
--Logger.log('end xstatus: ' .. miner.xStatus)\
end)\
\
function placeChunkLoader(direction, x, y, heading)\
  if direction == 'up' then\
    TL2.goto(x, y, 0)\
    TL2.placeUp(1)\
    TL2.saveNamedLocation('chunkloader1', x, y, 0)\
  else\
    TL2.goto(x, y, 0, heading)\
    TL2.up()\
    TL2.place(1)\
    TL2.down()\
    local heading = TL2.getHeadingInfo()\
    TL2.saveNamedLocation('chunkloader2',\
      x + heading.xd, y + heading.yd, 0)\
  end\
end\
\
function collectChunkLoaders()\
  showActivity('Collecting chunk loaders')\
  if TL2.gotoNamedLocation('chunkloader1') then\
    TL2.emptySlot(1)\
    TL2.select(1)\
    turtle.digUp()\
  end\
  if TL2.gotoNamedLocation('chunkloader2') then\
    TL2.select(1)\
    turtle.digUp(1)\
  end\
  showActivity()\
end\
\
function outsideBox(c, box)\
  return c.x < box.ax or c.y < box.ay or c.x > box.bx or c.y > box.by\
end\
\
function collectChunkLoader(namedLocation)\
  local c = TL2.getNamedLocation(namedLocation)\
  if c then\
    local cb = TL2.getNamedLocation('chunkborder')\
    local b = { ax = cb.x, ay = cb.y, bx = cb.x + 15, by = cb.y + 15 }\
    if outsideBox(c, b) then\
      local x, y = c.x, c.y\
      if c.x < cb.x then\
        x = math.max(c.x, cb.x)\
      elseif c.x > cb.x+15 then\
        x = math.min(c.x, cb.x+15)\
      end\
      if c.y < cb.y then\
        y = math.max(c.y, cb.y)\
      elseif c.y > cb.y+15 then\
        y = math.min(c.y, cb.y+15)\
      end\
      TL2.goto(x, y)\
      TL2.headTowards(c)\
      TL2.up()\
      TL2.select(1)\
      turtle.dig(1)\
      TL2.down()\
    else\
      TL2.gotoPoint(c)\
      TL2.select(1)\
      turtle.digUp(1)\
    end\
  end\
end\
\
TLC.registerAction('setLocation', function()\
  Logger.log('miningBoss', 'ignoring set location')\
  return true\
end)\
\
-- rise above to eliminate the rednet deadzone\
TLC.registerAction('gps', function()\
\
  -- become a mini-gps\
  Message.broadcast('alive')\
\
  local x, y = getCornerOf(TL2.getNamedLocation('chunkborder'))\
\
  local function broadcastPosition()\
    local pt = TL2.createPoint(TL2.getState())\
    pt.z = pt.z + 1\
    Message.broadcast('position', pt)\
  end\
\
  TL2.goto(x + 8, y + 5, 86)\
  -- drop down a couple of blocks in case we hit a bedrock roof (nether)\
  TL2.gotoZ(TL2.getState().z - 4)\
  local z = TL2.getState().z\
  broadcastPosition()\
\
  TL2.goto(x + 8, y + 11, z)\
  broadcastPosition()\
\
  TL2.goto(x + 5, y + 8, z-1)\
  broadcastPosition()\
\
  TL2.goto(x + 11, y + 8, z-1)\
  broadcastPosition()\
\
  queueWork(2,  'descend', 'descend')\
  mining.status = 'mining'\
  return true\
end)\
\
TLC.registerAction('descend', function()\
  if TL2.getState().z ~= 0 then\
    local x, y = getCornerOf(TL2.getNamedLocation('chunkborder'))\
    TL2.goto(x + 8, y + 8, 0)\
  end\
  return true\
end)\
\
TLC.registerAction('moveChunkLoaders', function()\
  showActivity('Moving chunk loaders')\
\
  local x, y = getCornerOf(TL2.getNamedLocation('chunkborder'))\
  local points = math.pow(mining.diameter, 2) - math.pow(mining.diameter-2, 2)\
  mining.chunkIndex = mining.chunkIndex + 1\
\
  if mining.chunkIndex >= points then\
    mining.diameter = mining.diameter + 2\
    mining.chunkIndex = 0\
  end\
\
  if mining.chunks ~= -1 then\
    local chunks = math.pow(mining.diameter-2, 2) + mining.chunkIndex\
    if chunks >= mining.chunks then\
      setStatus('recalling')\
      return true\
    end\
  end\
\
  local nc = getChunkCoordinates(mining.diameter, mining.chunkIndex, x, y)\
\
  local cl1 = { x = x + nc.xd * 15, y = y + nc.yd * 15 }\
  local cl2 = { x = x + nc.xd * 15, y = y + nc.yd * 15 }\
\
  -- brute force calculations\
  if nc.heading == 0 then\
    cl1.y = cl1.y + 1\
  elseif nc.heading == 1 then\
    cl1.x = cl1.x + 1\
  elseif nc.heading == 2 then\
    cl1.x = nc.x + 16\
    cl1.y = nc.y\
    cl2.x = nc.x + 16\
    cl2.y = nc.y + 1\
  elseif nc.heading == 3 then\
    cl1.x = nc.x + 15\
    cl1.y = nc.y + 16\
    cl2.x = nc.x + 14\
    cl2.y = nc.y + 16\
  end\
\
  -- collect prev chunk's loader\
  collectChunkLoader('chunkloader1')\
\
  local ocl = TL2.getNamedLocation('chunkloader2')\
  if cl1.x == ocl.x and cl1.y == ocl.y then\
    -- turning a corner - no need to move 2nd chunk loader\
    TL2.saveNamedLocation('chunkloader1', cl1.x, cl1.y, 0)\
  else\
    -- place at edge of loaded chunk\
    -- now 2 in chunk\
    placeChunkLoader('up', cl1.x, cl1.y)\
\
      -- get the first one\
    collectChunkLoader('chunkloader2')\
  end\
\
  -- place in next chunk\
  placeChunkLoader('front', cl2.x, cl2.y, nc.heading)\
\
  mining.locations = getBoreLocations(nc.x, nc.y)\
\
  -- enter next chunk\
  TL2.gotoPoint(TL2.getNamedLocation('chunkloader2'))\
  TL2.saveNamedLocation('chunkborder', nc.x, nc.y, 0, 0)\
  queueWork(50, 'checkMiners', 'checkMiners')\
  return true\
end)\
\
-- clear state every time we move\
-- if the server shuts down during movement, we cannot resume\
-- 99.9% of the time, we should be idle\
TLC.registerAction('clearState', function()\
  fs.delete('mining.state')\
  return true\
end)\
TLC.actionChainStart('clearState')\
\
function saveState()\
  local state = TL2.getState()\
  mining.x = state.x\
  mining.y = state.y\
  mining.heading = state.heading\
  mining.namedLocations = TL2.getMemory().locations\
\
  fs.delete('mining.state')\
  Util.writeTable('mining.state', mining)\
end\
\
TLC.registerAction('saveState', function()\
  saveState()\
  showActivity()\
  return true\
end)\
TLC.actionChainEnd('saveState')\
\
TLC.registerAction('checkMiners', function()\
\
  local chunkborder = TL2.getNamedLocation('chunkborder')\
\
  -- pickup any that are ready\
  if Util.size(pickupQueue) > 0 then\
    if TL2.selectOpenSlot(3) or mining.status == 'recalling' then\
      for _,miner in pairs(pickupQueue) do\
        -- pickup any miners in the deployment location\
        if miner.location.x == chunkborder.x and miner.location.y == chunkborder.y then\
          miner.distance = 0\
        else\
          miner.distance = TL2.calculateDistance(TL2.getState(), miner.location)\
        end\
      end\
      local k,miner = Util.first(pickupQueue,\
        function(a,b) return a.distance < b.distance end)\
      table.remove(pickupQueue, k)\
      collectMiner(miner)\
      queueWork(50, 'checkMiners', 'checkMiners')\
      return true\
    end\
  end\
\
  return true\
end)\
\
Message.addHandler('getMiningStatus', function(h, id, msg)\
  Message.send(id, 'miningStatus', { state = mining, status = miningStatus })\
end)\
\
function enableWirelessLogging()\
  Message.broadcast('logClient')\
  local _, id = Message.waitForMessage('logServer', 1)\
  if not id then\
    return false\
  end\
  Logger.setWirelessLogging(id)\
  return true\
end\
\
function resume()\
  if not fs.exists('mining.state') then\
    return false\
  end\
\
  local tmining = Util.readTable('mining.state')\
\
  if not tmining.namedLocations or \
     not tmining.x or\
     Util.size(tmining.namedLocations) == 0 then\
    return false\
  end\
\
  local state = TL2.getState()\
\
  state.x = tmining.x\
  state.y = tmining.y\
  state.heading = tmining.heading\
  TL2.getMemory().locations = tmining.namedLocations\
  mining = tmining\
  miningStatus.activity = 'Resuming mining'\
  -- release any miners that we did not release previously\
  if mining.status == 'mining' then\
    --releaseMiners()\
    UI.pager:setPage('status')\
  end\
  queueWork(1, 'gps', 'gps')\
  mining.status = 'resuming'\
\
  return true\
end\
\
function getWork()\
  local k,work = Util.first(workQueue, function(a,b) return a.priority < b.priority end)\
  if k then\
    workQueue[k] = nil\
    return work\
  end\
end\
\
Event.addHandler('workReady', function()\
  if TL2.getState().status ~= 'idle' then\
    Logger.log('miningBoss', 'busy')\
    Event.queueTimedEvent('endTimer', 2.5, 'workReady')\
    return\
  end\
\
  Logger.log('miningBoss', 'Queue size: ' .. Util.size(workQueue))\
  local work = getWork()\
  if work then\
    TLC.performAction(work.action, work.actionArgs)\
    if Util.size(workQueue) > 0 then\
      Event.queueTimedEvent('endTimer', 2.5, 'workReady')\
    end\
  end\
end)\
\
function isQueued(name)\
  return workQueue[name]\
end\
\
function queueWork(priority, name, action, actionArgs)\
  if not workQueue[name] then\
    workQueue[name] = {\
      priority = priority,\
      name = name,\
      action = action,\
      actionArgs = actionArgs\
    }\
  end\
  Event.queueTimedEvent('endTimer', 2.5, 'workReady')\
  Logger.log('miningBoss', 'Queuing: ' .. name)\
end\
\
TL2.setMode('destructive')\
TL2.setDigStrategy('wasteful')\
\
UI.pager:setPages({\
  [ 'menu'    ] = menuPage,\
  [ 'status'  ] = statusPage,\
  [ 'options' ] = optionsPage,\
  [ 'error'   ] = errorPage\
})\
\
if not Util.getOptions(options, args) then\
  return\
end\
\
mining.depth = options.depth.value\
mining.chunks = options.chunks.value\
mining.plug = options.plug.value\
\
if turtle.getFuelLevel() < 1000 then\
  error('Add at least 1000 fuel before starting')\
end\
\
Logger.disable()\
UI.pager:setPage('menu')\
\
if not resume() then\
  -- set the reference plane to 2 above deployment location\
  TL2.getState().z = -2\
  TL2.saveNamedLocation('chunkborder', 0, 0, 0, 0)\
  mining.locations = getBoreLocations(0, 0)\
end\
\
Logger.filter('event', 'rednet_send', 'rednet_receive', 'debug')\
\
if options.logMethod.value == 'wireless' then\
  Message.enableWirelessLogging()\
elseif options.logMethod.value == 'file' then\
  Logger.setFileLogging('mine.log')\
elseif options.logMethod.value == 'screen' then\
  Logger.setScreenLogging()\
end\
\
TLC.pullEvents('miningBoss')\
\
fs.delete('mining.state')\
collectChunkLoaders()\
TL2.gotoZ(-2)\
--TL2.goto(0, 0, -2, 0)\
UI.term:reset()\
",},[4]={["name"]="apis.lua",["contents"]="--Import \
-- From http://lua-users.org/wiki/SimpleLuaClasses\
\
-- class.lua\
-- Compatible with Lua 5.1 (not 5.0).\
_G.class = { }\
function class.class(base, init)\
  local c = {}    -- a new class instance\
  if not init and type(base) == 'function' then\
    init = base\
    base = nil\
  elseif type(base) == 'table' then\
    -- our new class is a shallow copy of the base class!\
    for i,v in pairs(base) do\
      c[i] = v\
    end\
    c._base = base\
  end\
  -- the class will be the metatable for all its objects,\
  -- and they will look up their methods in it.\
  c.__index = c\
\
  -- expose a constructor which can be called by <classname>(<args>)\
  local mt = {}\
  mt.__call =\
    function(class_tbl, ...)\
      local obj = {}\
      setmetatable(obj,c)\
      --if init then\
      --  init(obj,...)\
if class_tbl.init then\
  class_tbl.init(obj, ...)\
      else \
        -- make sure that any stuff from the base class is initialized!\
        if base and base.init then\
          base.init(obj, ...)\
        end\
      end\
      return obj\
    end\
\
  c.init = init\
  c.is_a =\
    function(self, klass)\
      local m = getmetatable(self)\
      while m do \
        if m == klass then return true end\
        m = m._base\
      end\
      return false\
    end\
  setmetatable(c, mt)\
  return c\
end\
\
\
--Import \
_G.Logger = { }\
\
local debugMon\
local logServerId\
local logFile\
local filteredEvents = {}\
\
local function nopLogger(text)\
end\
\
local function monitorLogger(text)\
  debugMon.write(text)\
  debugMon.scroll(-1)\
  debugMon.setCursorPos(1, 1)\
end\
\
local function screenLogger(text)\
  local x, y = term.getCursorPos()\
  if x ~= 1 then\
    local sx, sy = term.getSize()\
    term.setCursorPos(1, sy)\
    --term.scroll(1)\
  end\
  print(text)\
end\
\
local logger = screenLogger\
\
local function wirelessLogger(text)\
  if logServerId then\
    rednet.send(logServerId, {\
      type = 'log',\
      contents = text\
    })\
  end\
end\
\
local function fileLogger(text)\
  local mode = 'w'\
  if fs.exists(logFile) then\
    mode = 'a'\
  end\
  local file = io.open(logFile, mode)\
  if file then\
    file:write(text)\
    file:write('\\n')\
    file:close()\
  end\
end\
\
local function setLogger(ilogger)\
  logger = ilogger\
end\
\
function Logger.disable()\
  setLogger(nopLogger)\
end\
\
function Logger.setMonitorLogging(logServer)\
  debugMon = Util.wrap('monitor')\
  debugMon.setTextScale(.5)\
  debugMon.clear()\
  debugMon.setCursorPos(1, 1)\
  setLogger(monitorLogger)\
end\
\
function Logger.setScreenLogging()\
  setLogger(screenLogger)\
end\
\
function Logger.setWirelessLogging(id)\
  if id then\
    logServerId = id\
  end\
  setLogger(wirelessLogger)\
end\
\
function Logger.setFileLogging(fileName)\
  logFile = fileName\
  fs.delete(fileName)\
  setLogger(fileLogger)\
end\
\
function Logger.log(category, value, ...)\
  if filteredEvents[category] then\
    return\
  end\
\
  if type(value) == 'table' then\
    local str\
    for k,v in pairs(value) do\
      if not str then\
        str = '{ '\
      else\
        str = str .. ', '\
      end\
      str = str .. k .. '=' .. tostring(v)\
    end \
    value = str .. ' }'\
  elseif type(value) == 'string' then\
    local args = { ... }\
    if #args > 0 then\
      value = string.format(value, unpack(args))\
    end\
  else\
    value = tostring(value)\
  end\
  logger(category .. ': ' .. value)\
end\
\
function Logger.debug(value, ...)\
  Logger.log('debug', value, ...)\
end\
\
function Logger.logNestedTable(t, indent)\
  for _,v in ipairs(t) do\
    if type(v) == 'table' then\
      log('table')\
      logNestedTable(v) --, indent+1)\
    else\
      log(v)\
    end\
  end\
end\
\
function Logger.filter( ...)\
  local events = { ... }\
  for _,event in pairs(events) do\
    filteredEvents[event] = true\
  end\
end\
\
--Import \
_G.Util = { }\
-- _G.String = { }\
\
math.randomseed(os.time())\
\
function Util.tryTimed(timeout, f, ...)\
  local c = os.clock()\
  while not f(...) do\
    if os.clock()-c >= timeout then\
      return false\
    end\
  end\
  return true\
end\
\
function Util.tryTimes(attempts, f, ...)\
  local c = os.clock()\
  for i = 1, attempts do\
    local ret = f(...)\
    if ret then\
      return ret\
    end\
  end\
end\
\
function Util.print(value)\
  if type(value) == 'table' then\
    for k,v in pairs(value) do\
      print(k .. '=' .. tostring(v))\
    end\
  else\
    print(tostring(value))\
  end\
end\
\
function Util.clear(t)\
  local keys = Util.keys(t)\
  for _,k in pairs(keys) do\
    t[k] = nil\
  end\
end\
\
function Util.empty(t)\
  return Util.size(t) == 0\
end\
\
function Util.key(t, value)\
  for k,v in pairs(t) do\
    if v == value then\
      return k\
    end\
  end\
end\
\
function Util.keys(t)\
  local keys = {}\
  for k in pairs(t) do\
    keys[#keys+1] = k\
  end\
  return keys\
end\
\
function Util.find(t, name, value)\
  for k,v in pairs(t) do\
    if v[name] == value then\
      return v, k\
    end\
  end\
end\
\
function Util.findAll(t, name, value)\
  local rt = { }\
  for k,v in pairs(t) do\
    if v[name] == value then\
      table.insert(rt, v)\
    end\
  end\
  return rt\
end\
\
--http://lua-users.org/wiki/TableUtils\
function table.val_to_str ( v )\
  if \"string\" == type( v ) then\
    v = string.gsub( v, \"\\n\", \"\\\\n\" )\
    if string.match( string.gsub(v,\"[^'\\\"]\",\"\"), '^\"+$' ) then\
      return \"'\" .. v .. \"'\"\
    end\
    return '\"' .. string.gsub(v,'\"', '\\\\\"' ) .. '\"'\
  else\
    return \"table\" == type( v ) and table.tostring( v ) or\
      tostring( v )\
  end\
end\
\
function table.key_to_str ( k )\
  if \"string\" == type( k ) and string.match( k, \"^[_%a][_%a%d]*$\" ) then\
    return k\
  else\
    return \"[\" .. table.val_to_str( k ) .. \"]\"\
  end\
end\
\
function table.tostring( tbl )\
  local result, done = {}, {}\
  for k, v in ipairs( tbl ) do\
    table.insert( result, table.val_to_str( v ) )\
    done[ k ] = true\
  end\
  for k, v in pairs( tbl ) do\
    if not done[ k ] then\
      table.insert( result,\
        table.key_to_str( k ) .. \"=\" .. table.val_to_str( v ) )\
    end\
  end\
  return \"{\" .. table.concat( result, \",\" ) .. \"}\"\
end\
--end http://lua-users.org/wiki/TableUtils\
\
--https://github.com/jtarchie/underscore-lua\
function Util.size(list, ...)\
  local args = {...}\
\
  if Util.isArray(list) then\
    return #list\
  elseif Util.isObject(list) then\
    local length = 0\
    Util.each(list, function() length = length + 1 end)\
    return length\
  end\
\
  return 0\
end\
\
function Util.each(list, func)\
  local pairing = pairs\
  if Util.isArray(list) then pairing = ipairs end\
\
  for index, value in pairing(list) do\
    func(value, index, list)\
  end\
end\
\
function Util.isObject(value)\
  return type(value) == \"table\"\
end\
\
function Util.isArray(value)\
  return type(value) == \"table\" and (value[1] or next(value) == nil)\
end\
-- end https://github.com/jtarchie/underscore-lua\
\
function Util.random(max, min)\
  min = min or 0\
  return math.random(0, max-min) + min\
end\
\
function Util.readFile(fname)\
  local f = fs.open(fname, \"r\")\
  if f then\
    local t = f.readAll()\
    f.close()\
    return t\
  end\
end\
\
function Util.readTable(fname)\
  local t = Util.readFile(fname)\
  if t then\
    return textutils.unserialize(t)\
  end\
end\
\
function Util.writeTable(fname, data)\
  Util.writeFile(fname, textutils.serialize(data))\
end\
\
function Util.writeFile(fname, data)\
  local file = io.open(fname, \"w\")\
  if not file then\
    error('Unable to open ' .. fname, 2)\
  end\
  file:write(data)\
  file:close()\
end\
\
function Util.shallowCopy(t)\
  local t2 = {}\
  for k,v in pairs(t) do\
    t2[k] = v \
  end \
  return t2\
end\
\
function Util.split(str)\
  local t = {}\
  local function helper(line) table.insert(t, line) return \"\" end\
  helper((str:gsub(\"(.-)\\n\", helper))) \
  return t\
end\
\
-- http://snippets.luacode.org/?p=snippets/Check_string_ends_with_other_string_74\
-- Author: David Manura\
--String.endswith = function(s, send)\
  --return #s >= #send and s:find(send, #s-#send+1, true) and true or false\
--end\
-- end http://snippets.luacode.org/?p=snippets/Check_string_ends_with_other_string_74\
\
string.lpad = function(str, len, char)\
    if char == nil then char = ' ' end\
    return str .. string.rep(char, len - #str)\
end\
\
-- http://stackoverflow.com/questions/15706270/sort-a-table-in-lua\
function Util.spairs(t, order)\
  if not t then\
    error('spairs: nil passed')\
  end\
\
  -- collect the keys\
  local keys = {}\
  for k in pairs(t) do keys[#keys+1] = k end\
\
  -- if order function given, sort by it by passing the table and keys a, b,\
  -- otherwise just sort the keys \
  if order then\
    table.sort(keys, function(a,b) return order(t[a], t[b]) end)\
  else\
    table.sort(keys)\
  end\
\
  -- return the iterator function\
  local i = 0\
  return function()\
    i = i + 1\
    if keys[i] then\
      return keys[i], t[keys[i]]\
    end\
  end\
end\
\
function Util.first(t, order)\
  -- collect the keys\
  local keys = {}\
  for k in pairs(t) do keys[#keys+1] = k end\
\
  -- if order function given, sort by it by passing the table and keys a, b,\
  -- otherwise just sort the keys \
  if order then\
    table.sort(keys, function(a,b) return order(t[a], t[b]) end)\
  else\
    table.sort(keys)\
  end\
  return keys[1], t[keys[1]]\
end\
\
--[[\
pbInfo - Libs/lib.WordWrap.lua\
	v0.41\
	by p.b. a.k.a. novayuna\
	released under the Creative Commons License By-Nc-Sa: http://creativecommons.org/licenses/by-nc-sa/3.0/\
	\
	original code by Tomi H.: http://shadow.vs-hs.org/library/index.php?page=2&id=48\
]]\
function Util.WordWrap(strText, intMaxLength)\
	local tblOutput = {};\
	local intIndex;\
	local strBuffer = \"\";\
	local tblLines = Util.Explode(strText, \"\\n\");\
	for k, strLine in pairs(tblLines) do\
		local tblWords = Util.Explode(strLine, \" \");\
		if (#tblWords > 0) then\
			intIndex = 1;\
			while tblWords[intIndex] do\
				local strWord = \" \" .. tblWords[intIndex];\
				if (strBuffer:len() >= intMaxLength) then\
					table.insert(tblOutput, strBuffer:sub(1, intMaxLength));\
					strBuffer = strBuffer:sub(intMaxLength + 1);\
				else\
					if (strWord:len() > intMaxLength) then\
						strBuffer = strBuffer .. strWord;\
					elseif (strBuffer:len() + strWord:len() >= intMaxLength) then\
						table.insert(tblOutput, strBuffer);\
						strBuffer = \"\"\
					else\
						if (strBuffer == \"\") then\
							strBuffer = strWord:sub(2);\
						else\
							strBuffer = strBuffer .. strWord;\
						end;\
						intIndex = intIndex + 1;\
					end;\
				end;\
			end;\
			if strBuffer ~= \"\" then\
				table.insert(tblOutput, strBuffer);\
				strBuffer = \"\"\
			end;\
		end;\
	end;\
	return tblOutput;\
end\
\
function Util.Explode(strText, strDelimiter)\
	local strTemp = \"\";\
	local tblOutput = {};\
	for intIndex = 1, strText:len(), 1 do\
		if (strText:sub(intIndex, intIndex + strDelimiter:len() - 1) == strDelimiter) then\
			table.insert(tblOutput, strTemp);\
			strTemp = \"\";\
		else\
			strTemp = strTemp .. strText:sub(intIndex, intIndex);\
		end;\
	end;\
	if (strTemp ~= \"\") then\
		table.insert(tblOutput, strTemp)\
	end;\
	return tblOutput;\
end\
\
-- http://lua-users.org/wiki/AlternativeGetOpt\
local function getopt( arg, options )\
  local tab = {}\
  for k, v in ipairs(arg) do\
    if string.sub( v, 1, 2) == \"--\" then\
      local x = string.find( v, \"=\", 1, true )\
      if x then tab[ string.sub( v, 3, x-1 ) ] = string.sub( v, x+1 )\
      else      tab[ string.sub( v, 3 ) ] = true\
      end\
    elseif string.sub( v, 1, 1 ) == \"-\" then\
      local y = 2\
      local l = string.len(v)\
      local jopt\
      while ( y <= l ) do\
        jopt = string.sub( v, y, y )\
        if string.find( options, jopt, 1, true ) then\
          if y < l then\
            tab[ jopt ] = string.sub( v, y+1 )\
            y = l\
          else\
            tab[ jopt ] = arg[ k + 1 ]\
          end\
        else\
          tab[ jopt ] = true\
        end\
        y = y + 1\
      end\
    end\
  end\
  return tab\
end\
-- end http://lua-users.org/wiki/AlternativeGetOpt\
\
function Util.showOptions(options)\
  print('Arguments: ')\
  for k, v in pairs(options) do\
    print(string.format('-%s  %s', v.arg, v.desc))\
  end\
end\
\
function Util.getOptions(options, args, syntaxMessage)\
  local argLetters = ''\
  for _,o in pairs(options) do\
    if o.type ~= 'flag' then\
    argLetters = argLetters .. o.arg\
    end\
  end\
  local rawOptions = getopt(args, argLetters)\
\
  for k,ro in pairs(rawOptions) do\
    local found = false\
    for _,o in pairs(options) do\
      if o.arg == k then\
        found = true\
        if o.type == 'number' then\
          o.value = tonumber(ro)\
        elseif o.type == 'help' then\
          Util.showOptions(options)\
          return false\
        else\
          o.value = ro\
        end\
      end\
    end\
    if not found then\
      print('Invalid argument')\
      Util.showOptions(options)\
      return false\
    end\
  end\
\
  return true\
\
end\
\
--Import \
_G.Peripheral = { }\
\
function Peripheral.getAll()\
  local aliasDB = {\
    obsidian = 'chest',\
    diamond = 'chest',\
    container_chest = 'chest'\
  }\
\
  local t = { }\
  for _,side in pairs(peripheral.getNames()) do\
\
    local pType = peripheral.getType(side)\
\
    if pType == 'modem' then\
      if peripheral.call(side, 'isWireless') then\
        t[side] = {\
          type = 'wireless_modem',\
          side = side\
        }\
      else\
        t[side] = {\
          type = 'wired_modem',\
          side = side\
        }\
      end\
    else\
      t[side] = {\
        type = pType,\
        side = side,\
        alias = aliasDB[pType]\
      }\
    end\
  end\
  return t\
end\
\
function Peripheral.getBySide(pList, sideName)\
  return pList[sideName]\
end\
\
function Peripheral.getByType(pList, typeName)\
  return Util.find(pList, 'type', typeName)\
end\
\
function Peripheral.getByAlias(pList, aliasName)\
  return Util.find(pList, 'alias', aliasName)\
end\
\
function Peripheral.hasMethod(p, methodName)\
  local methods = peripheral.getMethods(p.side)\
  return Util.key(methods, methodName)\
end\
\
function Peripheral.getByMethod(pList, methodName)\
  for _,p in pairs(pList) do\
    if Peripheral.hasMethod(p, methodName) then\
      return p\
    end\
  end\
end\
\
-- peripheral must match all arguments\
function Peripheral.isAllPresent(args)\
  local t = Peripheral.getAll()\
  local p\
\
  if args.side then\
    p = Peripheral.getBySide(t, args.side)\
    if not p then\
      return\
    end\
  end\
\
  if args.type then\
    if p then\
      if p.type ~= args.type then\
        return\
      end\
    else\
      p = Peripheral.getByType(t, args.type)\
      if not p then\
        return\
      end\
    end\
  end\
\
  if args.method then\
    if p then\
      if not Peripheral.hasMethod(p, args.method) then\
        return\
      end\
    else\
      p = Peripheral.getByMethod(t, args.method)\
      if p then\
        return\
      end\
    end\
  end\
\
  return p\
end\
\
function Peripheral.isPresent(args)\
\
  if type(args) == 'string' then\
    args = { type = args }\
  end\
\
  local t = Peripheral.getAll()\
  args = args or { type = pType }\
\
  if args.type then\
    local p = Peripheral.getByType(t, args.type)\
    if p then\
      return p\
    end\
  end\
\
  if args.alias then\
    local p = Peripheral.getByAlias(t, args.alias)\
    if p then\
      return p\
    end\
  end\
\
  if args.method then\
    local p = Peripheral.getByMethod(t, args.method)\
    if p then\
      return p\
    end\
  end\
\
  if args.side then\
    local p = Peripheral.getBySide(t, args.side)\
    if p then\
      return p\
    end\
  end\
end\
\
local function _wrap(p)\
  Logger.log('peripheral', 'Wrapping ' .. p.type)\
  if p.type == 'wired_modem' or p.type == 'wireless_modem' then\
    rednet.open(p.side)\
    return p\
  end\
  return peripheral.wrap(p.side)\
end\
\
function Peripheral.wrap(args)\
\
  if type(args) == 'string' then\
    args = { type = args }\
  end\
\
  local p = Peripheral.isPresent(args)\
  if p then\
    return _wrap(p)\
  end\
\
  error('Peripheral ' .. table.tostring(args, '?') .. ' is not connected', 2)\
end\
\
function Peripheral.wrapAll()\
  local t = Peripheral.getAll()\
  Util.each(t, function(p) p.wrapper = _wrap(p) end)\
  return t\
end\
\
function Peripheral.wrapSide(sideName)\
  if peripheral.isPresent(sideName) then\
    return peripheral.wrap(sideName)\
  end\
  error('No Peripheral on side ' .. sideName, 2)\
end\
\
--Import \
_G.Event = { }\
\
local eventHandlers = {\
  namedTimers = {}\
}\
local enableQueue = {}\
local removeQueue = {}\
\
local function deleteHandler(h)\
  for k,v in pairs(eventHandlers[h.event].handlers) do\
    if v == h then\
      table.remove(eventHandlers[h.event].handlers, k)\
      break\
    end\
  end\
  --table.remove(eventHandlers[h.event].handlers, h.key)\
end\
\
function Event.addHandler(type, f)\
  local event = eventHandlers[type]\
  if not event then\
    event = {}\
    event.handlers = {}\
    eventHandlers[type] = event\
  end\
\
  local handler = {}\
  handler.event = type\
  handler.f = f\
  handler.enabled = true\
  table.insert(event.handlers, handler)\
  -- any way to retrieve key here for removeHandler ?\
  \
  return handler\
end\
\
function Event.removeHandler(h)\
  h.deleted = true\
  h.enabled = false\
  table.insert(removeQueue, h)\
end\
\
function Event.queueTimedEvent(name, timeout, event, args)\
  Event.addNamedTimer(name, timeout, false,\
    function()\
      os.queueEvent(event, args)\
    end\
  )\
end\
\
function Event.addNamedTimer(name, interval, recurring, f)\
  Event.cancelNamedTimer(name)\
  eventHandlers.namedTimers[name] = Event.addTimer(interval, recurring, f)\
end\
\
function Event.getNamedTimer(name)\
  return eventHandlers.namedTimers[name]\
end\
\
function Event.cancelNamedTimer(name)\
  local timer = Event.getNamedTimer(name)\
\
  if timer then\
    timer.enabled = false\
    timer.recurring = false\
  end\
end\
\
function Event.isTimerActive(timer)\
  return timer.enabled and\
    os.clock() < timer.start + timer.interval\
end\
\
function Event.addTimer(interval, recurring, f)\
  local timer = Event.addHandler('timer',\
    function(t, id)\
      if t.timerId ~= id then\
        return\
      end\
      if t.enabled then\
        t.fired = true\
        t.cf(t, id)\
      end\
      if t.recurring then\
        t.fired = false\
        t.start = os.clock()\
        t.timerId = os.startTimer(t.interval)\
      else\
        Event.removeHandler(t)\
      end\
    end\
  )\
  timer.cf = f\
  timer.interval = interval\
  timer.recurring = recurring\
  timer.start = os.clock()\
  timer.timerId = os.startTimer(interval)\
\
  return timer\
end\
\
function Event.removeTimer(h)\
  Event.removeHandler(h)\
end\
\
function Event.blockUntilEvent(event, timeout)\
  return Event.waitForEvent(event, timeout, os.pullEvent)\
end\
\
function Event.waitForEvent(event, timeout, pullEvent)\
  pullEvent = pullEvent or Event.pullEvent\
\
  local timerId = os.startTimer(timeout)\
  repeat\
    local e, p1, p2, p3, p4 = pullEvent()\
    if e == event then\
      return e, p1, p2, p3, p4\
    end \
  until e == 'timer' and id == timerId\
end\
\
function Event.heartbeat(timeout)\
  local function heart()\
    while true do\
      os.sleep(timeout)\
      os.queueEvent('heartbeat')\
    end \
  end\
  parallel.waitForAny(Event.pullEvents, heart)\
end\
\
function Event.pullEvents()\
  while true do\
    local e = Event.pullEvent()\
    if e == 'exitPullEvents' then\
      break\
    end\
  end\
end\
\
function Event.exitPullEvents()\
  os.queueEvent('exitPullEvents')\
end\
\
function Event.enableHandler(h)\
  table.insert(enableQueue, h)\
end\
\
function Event.pullEvent(eventType)\
  local e, p1, p2, p3, p4, p5 = os.pullEvent(eventType)\
\
  Logger.log('event', { e, p1, p2, p3, p4, p5 })\
\
  local event = eventHandlers[e]\
  if event then\
    for k,v in pairs(event.handlers) do\
      if v.enabled then\
        v.f(v, p1, p2, p3, p4, p5)\
      end\
    end\
    while #enableQueue > 0 do\
      table.remove(handlerQueue).enabled = true\
    end\
    while #removeQueue > 0 do\
      deleteHandler(table.remove(removeQueue))\
    end\
  end\
  \
  return e, p1, p2, p3, p4, p5\
end\
\
--Import \
_G.Message = { }\
\
local messageHandlers = {}\
\
function Message.addHandler(type, f)\
  table.insert(messageHandlers, {\
    type = type,\
    f = f,\
    enabled = true\
  })\
end\
\
function Message.removeHandler(h)\
  for k,v in pairs(messageHandlers) do\
	if v == h then\
      messageHandlers[k] = nil\
      break\
    end\
  end\
end\
\
Event.addHandler('rednet_message',\
  function(event, id, msg, distance)\
    if msg and msg.type then -- filter out messages from other systems\
      Logger.log('rednet_receive', id, msg.type)\
      for k,h in pairs(messageHandlers) do\
        if h.type == msg.type then\
-- should provide msg.contents instead of message - type is already known\
          h.f(h, id, msg, distance)\
        end\
      end\
    end\
  end\
)\
\
function Message.send(id, msgType, contents)\
  if id then\
    Logger.log('rednet_send', { tostring(id), msgType })\
    rednet.send(id, { type = msgType, contents = contents })\
  else\
    Logger.log('rednet_send', { 'broadcast', msgType })\
    rednet.broadcast({ type = msgType, contents = contents })\
  end\
end\
\
function Message.broadcast(t, contents)\
  Logger.log('rednet_send', { 'broadcast', t })\
  rednet.broadcast({ type = t, contents = contents })\
end\
\
function Message.waitForMessage(msgType, timeout, fromId)\
  local timerId = os.startTimer(timeout)\
  repeat\
    local e, id, msg, distance = Event.pullEvent()\
    if e == 'rednet_message' then\
      if msg and msg.type and msg.type == msgType then\
        if not fromId or id == fromId then\
          return e, id, msg, distance\
        end\
      end \
    end\
  until e == 'timer' and id == timerId\
end\
\
function Message.enableWirelessLogging()\
  local modem = Peripheral.isPresent('wireless_modem')\
  if modem then\
    if not rednet.isOpen(modem.side) then\
      Logger.log('message', 'enableWirelessLogging: opening modem')\
      rednet.open(modem.side)\
    end\
    Message.broadcast('logClient')\
    local _, id = Message.waitForMessage('logServer', 1)\
    if not id then\
      return false\
    end\
    Logger.log('message', 'enableWirelessLogging: Logging to ' .. id)\
    Logger.setWirelessLogging(id)\
    return true\
  end\
end\
\
--Import \
_G.Relay = { }\
\
Relay.stationId = nil\
\
function Relay.find(msgType, stationType)\
  while true do\
    Logger.log('relay', 'locating relay station')\
    Message.broadcast('getRelayStation', os.getComputerLabel())\
    local _, id = Message.waitForMessage('relayStation', 2)\
    if id then\
      Relay.stationId = id\
      return id\
    end\
  end\
end\
\
function Relay.register(...)\
  local types = { ... }\
  Message.send(Relay.stationId, 'listen', types)\
end\
\
function Relay.send(type, contents, toId)\
  local relayMessage = {\
    type = type,\
    contents = contents,\
    fromId = os.getComputerID()\
  }\
  if toId then\
    relayMessage.toId = toId\
  end\
  Message.send(Relay.stationId, 'relay', relayMessage)\
end\
\
--Import \
_G.UI = { }\
\
local function widthify(s, len)\
  if not s then\
    s = ' '\
  end\
  return string.lpad(string.sub(s, 1, len) , len, ' ')\
end\
\
function UI.setProperties(obj, args)\
  if args then\
    for k,v in pairs(args) do\
      obj[k] = v\
    end\
  end\
end\
\
function UI.setDefaultDevice(device)\
  UI.defaultDevice = device\
end\
\
function UI.bestDefaultDevice(...)\
  local termList = { ... }\
  for _,name in ipairs(termList) do\
    if name == 'monitor' then\
      if Util.hasDevice('monitor') then\
        UI.defaultDevice = UI.Device({ deviceType = 'monitor' })\
        return UI.defaultDevice\
      end\
    end\
  end\
  return UI.term\
end\
\
--[[-- Terminal for computer / advanced computer / monitor --]]--\
UI.Device = class.class()\
\
function UI.Device:init(args)\
\
  self.backgroundColor = colors.black\
  self.textColor = colors.white\
  self.textScale = 1\
\
  UI.setProperties(self, args)\
\
  if self.deviceType then\
    self.device = Peripheral.wrap({ type = self.deviceType })\
  end\
\
  if self.device.setTextScale then\
    self.device.setTextScale(self.textScale)\
  end\
\
  self.isColor = self.device.isColor()\
  if not self.isColor then\
    self.device.setBackgroundColor = function(...) end\
    self.device.setTextColor = function(...) end\
  end\
\
  self.width, self.height = self.device.getSize()\
end\
\
function UI.Device:displayCursor(x, y)\
  self.device.setCursorPos(x, y)\
end\
\
function UI.Device:write(x, y, text, bg, tc)\
  bg = bg or self.backgroundColor\
  tc = tc or self.textColor\
\
  self.device.setCursorPos(x, y)\
  self.device.setTextColor(tc)\
  self.device.setBackgroundColor(bg)\
  self.device.write(text)\
end\
\
function UI.Device:clear(bg)\
  bg = bg or self.backgroundColor\
  self.device.setBackgroundColor(bg)\
  self.device.clear()\
end\
\
function UI.Device:reset(bg)\
  self:clear(bg)\
  self.device.setCursorPos(1, 1)\
end\
\
UI.term = UI.Device({ device = term })\
UI.defaultDevice = UI.term\
\
--[[-- Glasses device --]]--\
UI.Glasses = class.class()\
function UI.Glasses:init(args)\
\
  local defaults = {\
    backgroundColor = colors.black,\
    textColor = colors.white,\
    textScale = .5,\
    backgroundOpacity = .5\
  }\
  defaults.width, defaults.height = term.getSize()\
\
  UI.setProperties(defaults, args)\
  UI.setProperties(self, defaults)\
\
  self.bridge = Peripheral.wrap({\
    type = 'openperipheral_glassesbridge',\
    method = 'addBox'\
  })\
  self.bridge.clear()\
\
  self.setBackgroundColor = function(...) end\
  self.setTextColor = function(...) end\
\
  self.t = { }\
  for i = 1, self.height do\
    self.t[i] = {\
      text = self.bridge.addText(0, 40+i*4, string.rep(' ', self.width+1), 0xffffff),\
      bg = { }\
    }\
    self.t[i].text.setScale(self.textScale)\
    self.t[i].text.setZ(1)\
  end\
end\
\
function UI.Glasses:setBackgroundBox(boxes, ax, bx, y, bgColor)\
  local colors = {\
    [ colors.black ] = 0x000000,\
    [ colors.brown ] = 0x7F664C,\
    [ colors.blue  ] = 0x253192,\
    [ colors.gray  ] = 0x272727,\
    [ colors.lime  ] = 0x426A0D,\
    [ colors.green ] = 0x2D5628,\
    [ colors.white ] = 0xFFFFFF\
  }\
\
  local function overlap(box, ax, bx)\
    if bx < box.ax or ax > box.bx then\
      return false\
    end\
    return true\
  end\
\
  for _,box in pairs(boxes) do\
    if overlap(box, ax, bx) then \
      if box.bgColor == bgColor then\
        ax = math.min(ax, box.ax)\
        bx = math.max(bx, box.bx)\
        box.ax = box.bx + 1\
      elseif ax == box.ax then\
        box.ax = bx + 1\
      elseif ax > box.ax then\
        if bx < box.bx then\
          table.insert(boxes, { -- split\
            ax = bx + 1,\
            bx = box.bx,\
            bgColor = box.bgColor\
          })\
          box.bx = ax - 1\
          break\
        else\
          box.ax = box.bx + 1\
        end\
      elseif ax < box.ax then\
        if bx > box.bx then\
          box.ax = box.bx + 1 -- delete\
        else\
          box.ax = bx + 1\
        end\
      end\
    end\
  end\
  if bgColor ~= colors.black then\
    table.insert(boxes, {\
      ax = ax,\
      bx = bx,\
      bgColor = bgColor\
    })\
  end\
\
  local deleted\
  repeat\
    deleted = false\
    for k,box in pairs(boxes) do\
      if box.ax > box.bx then\
        if box.box then\
          box.box.delete()\
        end\
        table.remove(boxes, k)\
        deleted = true\
        break\
      end\
      if not box.box then\
        box.box = self.bridge.addBox(\
          math.floor((box.ax - 1) * 2.6665),\
          40 + y * 4,\
          math.ceil((box.bx - box.ax + 1) * 2.6665),\
          4,\
          colors[bgColor],\
          self.backgroundOpacity)\
      else\
        box.box.setX(math.floor((box.ax - 1) * 2.6665))\
        box.box.setWidth(math.ceil((box.bx - box.ax + 1) * 2.6665))\
      end\
    end\
  until not deleted\
end\
\
function UI.Glasses:write(x, y, text, bg)\
\
  if x < 1 then\
    error(' less ', 6)\
  end\
  if y <= #self.t then\
    local line = self.t[y]\
    local str = line.text.getText()\
    str = str:sub(1, x-1) .. text .. str:sub(x + 1 + #text)\
    line.text.setText(str)\
    self:setBackgroundBox(line.bg, x, x + #text - 1, y, bg)\
UI.term:write(x, y, text, bg)\
  end\
end\
\
function UI.Glasses:clear(bg)\
  for i = 1, self.height do\
    self.t[i].text.setText('')\
  end\
end\
\
--[[-- Basic drawable area --]]--\
UI.Window = class.class()\
function UI.Window:init(args)\
  local defaults = {\
    UIElement = 'Window',\
    x = 1,\
    y = 1,\
    cursorX = 1,\
    cursorY = 1,\
    isUIElement = true\
  }\
\
  UI.setProperties(self, defaults)\
  UI.setProperties(self, args)\
\
  if self.parent then\
    self:setParent()\
  end\
end\
\
function UI.Window:setParent()\
  if not self.width then\
    self.width = self.parent.width - self.x + 1\
  end\
  if not self.height then\
    self.height = self.parent.height - self.y + 1\
  end\
\
  local children = self.children\
  for k,child in pairs(self) do\
    if type(child) == 'table' and child.isUIElement and not child.parent then\
      if not children then\
        children = { }\
      end\
      --self.children[k] = child\
      table.insert(children, child)\
    end\
  end\
  if children then\
    for _,child in pairs(children) do\
      if not child.parent then\
        child.parent = self\
        child:setParent()\
      end\
    end\
  end\
  self.children = children\
end\
\
function UI.Window:add(children)\
  UI.setProperties(self, children)\
  for k,child in pairs(children) do\
    if type(child) == 'table' and child.isUIElement and not child.parent then\
      if not self.children then\
        self.children = { }\
      end\
      self.children[k] = child\
      --table.insert(self.children, child)\
      child.parent = self\
      child:setParent()\
    end\
  end\
end\
\
function UI.Window:getCursorPos()\
  return self.cursorX, self.cursorY\
end\
\
function UI.Window:setCursorPos(x, y)\
  self.cursorX = x\
  self.cursorY = y\
end\
\
function UI.Window:setBackgroundColor(bgColor)\
  self.backgroundColor = bgColor\
end\
\
function UI.Window:draw()\
  self:clear(self.backgroundColor)\
  if self.children then\
    for k,child in pairs(self.children) do\
      child:draw()\
    end\
  end\
end\
\
function UI.Window:reset(bg)\
  self:clear(bg)\
  self:setCursorPos(1, 1)\
end\
\
function UI.Window:clear(bg)\
  self:clearArea(1, 1, self.width, self.height, bg)\
end\
\
function UI.Window:clearLine(y, bg)\
  local filler = string.rep(' ', self.width)\
  self:write(1, y, filler, bg)\
end\
\
function UI.Window:clearArea(x, y, width, height, bg)\
  local filler = string.rep(' ', width)\
  for i = 0, height-1 do\
    self:write(x, y+i, filler, bg)\
  end\
end\
\
function UI.Window:write(x, y, text, bg, tc)\
  bg = bg or self.backgroundColor\
  tc = tc or self.textColor\
  if y < self.height+1 then\
    self.parent:write(\
      self.x + x - 1, self.y + y - 1, tostring(text), bg, tc)\
  end\
end\
\
function UI.Window:displayCursor(x, y)\
  self.parent:displayCursor(self.x + x - 1, self.y + y - 1)\
end\
\
function UI.Window:centeredWrite(y, text, bg)\
  if #text >= self.width then\
    self:write(1, y, text, bg)\
  else\
    local space = math.floor((self.width-#text) / 2)\
    local filler = string.rep(' ', space + 1)\
    local str = filler:sub(1, space) .. text\
    str = str .. filler:sub(self.width - #str + 1)\
    self:write(1, y, str, bg)\
  end\
end\
\
function UI.Window:wrappedWrite(x, y, text, len, bg)\
  for k,v in pairs(Util.WordWrap(text, len)) do\
    self:write(x, y, v, bg)\
    y = y + 1\
  end\
  return y\
end\
\
function UI.Window:print(text, indent, len, bg)\
  indent = indent or 0\
  len = len or self.width - indent\
  if #text + self.cursorX > self.width then\
    for k,v in pairs(Util.WordWrap(text, len+1)) do\
      self:write(self.cursorX, self.cursorY, v, bg)\
      self.cursorY = self.cursorY + 1\
      self.cursorX = 1 + indent\
    end\
  else\
    self:write(self.cursorX, self.cursorY, text, bg)\
    self.cursorY = self.cursorY + 1\
    self.cursorX = 1\
  end\
end\
\
function UI.Window.setTextScale(scale)\
  self.scale = scale\
  self.parent.setTextScale(scale)\
end\
\
function UI.Window:emit(event)\
  local parent = self\
Logger.log('ui', self.UIElement .. ' emitting ' .. event.type)\
  while parent do\
    if parent.eventHandler then\
      if parent:eventHandler(event) then\
        return true\
      end\
    end\
    parent = parent.parent\
  end\
end\
\
function UI.Window:eventHandler(event)\
  return false\
end\
\
function UI.Window:setFocus(focus)\
  self.parent:setFocus(focus)\
end\
\
function UI.Window:getPreviousFocus(focused)\
  if self.children then\
    local k = Util.key(self.children, focused)\
    for k = k-1, 1, -1 do\
      if self.children[k].focus then\
        return self.children[k]\
      end\
    end\
  end\
end\
\
function UI.Window:getNextFocus(focused)\
  if self.children then\
    local k = Util.key(self.children, focused)\
    for k = k+1, #self.children do\
      if self.children[k].focus then\
        return self.children[k]\
      end\
    end\
  end\
end\
\
-- default drawing console on term\
UI.console = UI.Window({ parent = UI.term })\
\
--[[-- StringBuffer --]]--\
UI.StringBuffer = class.class()\
function UI.StringBuffer:init(bufSize)\
  self.bufSize = bufSize\
  self.buffer = {}\
end\
\
function UI.StringBuffer:insert(s, index)\
  table.insert(self.buffer, { index = index, str = s })\
end\
\
function UI.StringBuffer:append(s)\
  local str = self:get()\
  self:insert(s, #str)\
end\
\
-- pi -> getBeeParents -> Demonic -> special conditions\
function UI.StringBuffer:get()\
  local str = ''\
  for k,v in Util.spairs(self.buffer, function(a, b) return a.index < b.index end) do\
    str = str .. string.rep(' ', math.max(v.index - string.len(str), 0)) .. v.str\
  end\
  local len = string.len(str)\
  if len < self.bufSize then\
    str = str .. string.rep(' ', self.bufSize - len)\
  end\
  return str\
end\
\
function UI.StringBuffer:clear()\
  self.buffer = {}\
end\
\
--[[-- Pager --]]--\
UI.Pager = class.class()\
function UI.Pager:init(args)\
  local defaults = {\
    pages = { }\
  }\
  UI.setProperties(defaults, args)\
  UI.setProperties(self, defaults)\
\
  Event.addHandler('mouse_scroll', function(h, direction, x, y)\
    local event = self:pointToChild(self.currentPage, x, y)\
    local directions = {\
      [ -1 ] = 'up',\
      [  1 ] = 'down'\
    }\
    event.type = 'key'\
    event.key = directions[direction]\
    event.UIElement:emit(event)\
  end)\
\
  Event.addHandler('monitor_touch', function(h, button, x, y)\
    self:click(1, x, y)\
  end)\
\
  Event.addHandler('mouse_click', function(h, button, x, y)\
    self:click(button, x, y)\
  end)\
\
  Event.addHandler('char', function(h, ch)\
    self:emitEvent({ type = 'key', key = ch })\
  end)\
\
  Event.addHandler('key', function(h, code)\
    local ch = keys.getName(code)\
    -- filter out a through z as they will be get picked up\
    -- as char events\
    if ch and #ch > 1 then\
      if self.currentPage then\
        self:emitEvent({ type = 'key', key = ch })\
        if ch == 'f10' then\
          UI.displayTable(_G, 'Global Memory')\
        elseif ch == 'f9' then\
          UI.displayTable(getfenv(4), 'Local memory')\
        end\
      end\
    end\
  end)\
end\
\
function UI.Pager:emitEvent(event)\
  if self.currentPage and self.currentPage.focused then\
    return self.currentPage.focused:emit(event)\
  end\
end\
\
function UI.Pager:pointToChild(parent, x, y)\
  if parent.children then\
    for _,child in pairs(parent.children) do\
      if x >= child.x and x < child.x + child.width and\
         y >= child.y and y < child.y + child.height then\
        local c = self:pointToChild(child, x - child.x + 1, y - child.y + 1)\
        if c then\
          return c\
        end\
      end\
    end\
  end\
  return {\
    UIElement = parent,\
    x = x,\
    y = y\
  }\
end\
\
function UI.Pager:click(button, x, y)\
  if self.currentPage then\
\
    local function getClicked(parent, button, x, y)\
      if parent.children then\
        for _,child in pairs(parent.children) do\
          if x >= child.x and x < child.x + child.width and\
             y >= child.y and y < child.y + child.height and\
             not child.isShadow then\
            local c = getClicked(child, button, x - child.x + 1, y - child.y + 1)\
            if c then\
              return c\
            end\
          end\
        end\
      end\
      local events = { 'mouse_click', 'mouse_rightclick' }\
      return {\
        UIElement = parent,\
        type = events[button],\
        button = button,\
        x = x,\
        y = y\
      }\
    end\
\
    local clickEvent = getClicked(self.currentPage, button,\
      x - self.currentPage.x + 1,\
      y - self.currentPage.y + 1)\
\
    if clickEvent.UIElement.focus then\
      self.currentPage:setFocus(clickEvent.UIElement)\
    end\
    clickEvent.UIElement:emit(clickEvent)\
  end\
end\
\
function UI.Pager:addPage(name, page)\
  self.pages[name] = page\
end\
\
function UI.Pager:setPages(pages)\
  self.pages = pages\
end\
\
function UI.Pager:getPage(pageName)\
  local page = self.pages[pageName]\
\
  if not page then\
    error('Pager:getPage: Invalid page: ' .. tostring(pageName), 2)\
  end\
\
  return page\
end\
\
function UI.Pager:setPage(pageOrName)\
  local page = pageOrName\
\
  if type(pageOrName) == 'string' then\
    page = self.pages[pageOrName]\
  end\
\
  if page == self.currentPage then\
    page:draw()\
  else\
    if self.currentPage then\
      if self.currentPage.focused then\
        self.currentPage.focused.focused = false\
        self.currentPage.focused:focus()\
      end\
      self.currentPage:disable()\
      self.currentPage.enabled = false\
      page.previousPage = self.currentPage\
    end\
    self.currentPage = page\
    self.currentPage:reset(page.backgroundColor)\
    page.enabled = true\
    page:enable()\
    page:draw()\
    if self.currentPage.focused then\
      self.currentPage.focused.focused = true\
      self.currentPage.focused:focus()\
    end\
  end\
end\
\
function UI.Pager:getCurrentPage()\
  return self.currentPage\
end\
\
function UI.Pager:setPreviousPage()\
  if self.currentPage.previousPage then\
    local previousPage = self.currentPage.previousPage.previousPage\
    self:setPage(self.currentPage.previousPage)\
    self.currentPage.previousPage = previousPage\
  end\
end\
\
UI.pager = UI.Pager()\
\
--[[-- Page --]]--\
UI.Page = class.class(UI.Window)\
function UI.Page:init(args)\
  local defaults = {\
    UIElement = 'Page',\
    parent = UI.defaultDevice,\
    accelerators = { }\
  }\
  --if not args or not args.parent then\
    --self.parent = UI.defaultDevice\
  --end\
  \
  UI.setProperties(defaults, args)\
  UI.Window.init(self, defaults)\
\
  self.focused = self:findFirstFocus(self)\
  --if self.focused then\
    --self.focused.focused = true\
  --end\
end\
\
function UI.Page:enable()\
end\
\
function UI.Page:disable()\
end\
\
function UI.Page:draw()\
  UI.Window.draw(self)\
  --if self.focused then\
    --self:setFocus(self.focused)\
  --end\
end\
\
function UI.Page:findFirstFocus(parent)\
  if not parent.children then\
    return\
  end\
  for _,child in ipairs(parent.children) do\
    if child.children then\
      local c = self:findFirstFocus(child)\
      if c then\
        return c\
      end\
    end\
    if child.focus then\
      return child\
    end\
  end\
end\
\
function UI.Page:getFocused()\
  return self.focused\
end\
\
function UI.Page:focusFirst()\
  local focused = self:findFirstFocus(self)\
  if focused then\
    self:setFocus(focused)\
  end\
end\
\
function UI.Page:focusPrevious()\
\
  local parent = self.focused.parent\
  local child = self.focused\
  local focused\
\
  while parent do\
    focused = parent:getPreviousFocus(child)\
    if focused then\
      break\
    end\
    child = parent\
    parent = parent.parent\
    if not parent.getPreviousFocused then\
      break\
    end\
  end\
\
  if focused then\
    self:setFocus(focused)\
  end\
end\
\
function UI.Page:focusNext()\
\
  local parent = self.focused.parent\
  local child = self.focused\
  local focused\
\
  while parent do\
    focused = parent:getNextFocus(child)\
    if focused then\
      break\
    end\
    child = parent\
    parent = parent.parent\
    if not parent.getNextFocused then\
      break\
    end\
  end\
\
  if focused then\
    self:setFocus(focused)\
  end\
end\
\
function UI.Page:setFocus(child)\
  if not child.focus then\
    return\
    --error('cannot focus child ' .. child.UIElement, 2)\
  end\
\
  if self.focused and self.focused ~= child then\
    self.focused.focused = false\
    self.focused:focus()\
    self.focused = child\
  end\
\
  if not child.focused then\
    child.focused = true\
    self:emit({ type = 'focus_change', focused = child })\
  end\
\
  child:focus()\
end\
\
function UI.Page:eventHandler(event)\
\
  if self.focused then\
    if event.type == 'key' then\
      local acc =  self.accelerators[event.key]\
      if acc then\
        if self:eventHandler({ type = acc }) then\
          return true\
        end\
      end\
      local ch = event.key\
      if ch == 'down' or ch == 'enter' or ch == 'k' or ch == 'tab' then\
        self:focusNext()\
        return true\
      elseif ch == 'tab' then\
        --self:focusNextGroup()\
      elseif ch == 'up' or ch == 'j' then\
        self:focusPrevious()\
        return true\
      end\
    end\
  end\
end\
\
--[[-- GridLayout --]]--\
UI.GridLayout = class.class(UI.Window)\
function UI.GridLayout:init(args)\
  local defaults = {\
    UIElement = 'GridLayout',\
    x = 1,\
    y = 1,\
    textColor = colors.white,\
    backgroundColor = colors.black,\
    values = {},\
    columns = {}\
  }\
  UI.setProperties(defaults, args)\
  UI.Window.init(self, defaults)\
end\
\
function UI.GridLayout:setParent()\
  UI.Window.setParent(self)\
  self:adjustWidth()\
end\
\
function UI.GridLayout:adjustWidth()\
  if not self.width then\
    self.width = self:calculateWidth()\
  end\
  if self.autospace then\
    local width\
    for _,col in pairs(self.columns) do\
      width = 1\
      for _,row in pairs(self.t) do\
        local value = row[col[2]]\
        if value then\
          value = tostring(value)\
          if #value > width then\
            width = #value\
          end\
        end\
      end\
      col[3] = width\
    end\
\
    local colswidth = 0\
    for _,c in pairs(self.columns) do\
      colswidth = colswidth + c[3] + 1\
    end\
\
    local spacing = (self.width - colswidth - 1) \
    if spacing > 0 then\
      spacing = math.floor(spacing / (#self.columns - 1) )\
      for _,c in pairs(self.columns) do\
        c[3] = c[3] + spacing\
      end\
    end\
\
--[[\
    width = 1\
    for _,c in pairs(self.columns) do\
      width = c[3] + width + 1\
    end\
\
    if width < self.width then\
      local spacing = self.width - width\
      spacing = spacing / #self.columns\
      for i = 1, #self.columns  do\
        local col = self.columns[i]\
        col[3] = col[3] + spacing\
      end\
    elseif width > self.width then\
    end\
--]]\
  end\
end\
\
function UI.GridLayout:calculateWidth()\
  -- gutters on each side\
  local width = 2\
  for _,col in pairs(self.columns) do\
    width = width + col[3] + 1\
  end\
  return width - 1\
end\
\
function UI.GridLayout:drawRow(row, y)\
  local sb = UI.StringBuffer(self.width)\
  local x = 1\
  for _,col in pairs(self.columns) do\
\
    local value = row[col[2]]\
    if value then\
      sb:insert(string.sub(value, 1, col[3]), x)\
    end\
\
    x = x + col[3] + 1\
  end\
\
  local selected = index == self.index and self.selectable\
  if selected then\
    self:setSelected(row)\
  end\
\
  self.parent:write(\
    self.x, y, sb:get(), self.backgroundColor, self.textColor)\
end\
\
function UI.GridLayout:draw()\
\
  local size = #self.values\
  local startRow = self:getStartRow()\
  local endRow = startRow + self.height - 1\
  if endRow > size then\
    endRow = size\
  end\
\
  for i = startRow, endRow do\
    self:drawRow(self.values[i], self.y + i - 1)\
  end\
\
  if endRow - startRow < self.height - 1 then\
    self.parent:clearArea(\
      self.x, self.y + endRow, self.width, self.height - endRow, self.backgroundColor)\
  end\
end\
\
function UI.GridLayout:getStartRow()\
  return 1\
end\
\
--[[-- Grid --]]--\
UI.Grid = class.class(UI.Window)\
function UI.Grid:init(args)\
  local defaults = {\
    UIElement = 'Grid',\
    x = 1,\
    y = 1,\
    pageNo = 1,\
    index = 1,\
    inverseSort = false,\
    disableHeader = false,\
    selectable = true,\
    textColor = colors.white,\
    textSelectedColor = colors.white,\
    backgroundColor = colors.black,\
    backgroundSelectedColor = colors.green,\
    t = {},\
    columns = {}\
  }\
  UI.setProperties(defaults, args)\
  UI.Window.init(self, defaults)\
end\
\
function UI.Grid:setParent()\
  UI.Window.setParent(self)\
  self:adjustWidth()\
  if not self.pageSize then\
    if self.disableHeader then\
      self.pageSize = self.height\
    else\
      self.pageSize = self.height - 1\
    end\
  end\
end\
\
function UI.Grid:adjustWidth()\
  if self.autospace then\
    for _,col in pairs(self.columns) do\
      col[3] = #col[1]\
    end\
\
    for _,col in pairs(self.columns) do\
      for _,row in pairs(self.t) do\
        local value = row[col[2]]\
        if value then\
          value = tostring(value)\
          if #value > col[3] then\
            col[3] = #value\
          end\
        end\
      end\
    end\
\
    local colswidth = 1\
    for _,c in pairs(self.columns) do\
      colswidth = colswidth + c[3] + 1\
    end\
\
    local function round(num) \
      if num >= 0 then return math.floor(num+.5) \
       else return math.ceil(num-.5) end\
    end\
\
    local spacing = (self.width - colswidth) \
    if spacing > 0 then\
      spacing = spacing / (#self.columns - 1)\
      local space = 0\
      for k,c in pairs(self.columns) do\
        space = space + spacing\
        c[3] = c[3] + math.floor(round(space) / k)\
      end\
    end\
  end\
end\
\
function UI.Grid:setPosition(x, y)\
  self.x = x\
  self.y = y\
end\
\
function UI.Grid:setPageSize(pageSize)\
  self.pageSize = pageSize\
end\
\
function UI.Grid:setColumns(columns)\
  self.columns = columns\
end\
\
function UI.Grid:getTable()\
  return self.t\
end\
\
function UI.Grid:setTable(t)\
  self.t = t\
end\
\
function UI.Grid:setInverseSort(inverseSort)\
  self.inverseSort = inverseSort\
  self:drawRows()\
end\
\
function UI.Grid:setSortColumn(column)\
  self.sortColumn = column\
  for _,col in pairs(self.columns) do\
    if col[2] == column then\
      return\
    end\
  end\
  error('Grid:setSortColumn: invalid column', 2)\
end\
\
function UI.Grid:setSelected(row)\
  self.selected = row\
end\
\
function UI.Grid:getSelected()\
  return self.selected\
end\
\
function UI.Grid:focus()\
  self:draw()\
end\
\
function UI.Grid:draw()\
  if not self.disableHeader then\
    self:drawHeadings()\
  end\
  self:drawRows()\
end\
\
function UI.Grid:drawHeadings()\
\
  local sb = UI.StringBuffer(self.width)\
  local x = 1\
  for k,col in ipairs(self.columns) do\
    local width = col[3] + 1\
    sb:insert(col[1], x)\
    x = x + width\
  end\
  self.parent:write(self.x, self.y, sb:get(), colors.blue)\
end\
\
function UI.Grid:calculateWidth()\
  -- gutters on each side\
  local width = 2\
  for _,col in pairs(self.columns) do\
    width = width + col[3] + 1\
  end\
  return width - 1\
end\
\
function UI.Grid:drawRows()\
\
  local function sortM(a, b)\
    if a[self.sortColumn] and b[self.sortColumn] then\
      return a[self.sortColumn] < b[self.sortColumn]\
    end\
    return false\
  end\
\
  local function inverseSortM(a, b)\
    if a[self.sortColumn] and b[self.sortColumn] then\
      return a[self.sortColumn] > b[self.sortColumn]\
    end\
    return false\
  end\
\
  local sortMethod\
  if self.sortColumn then\
    sortMethod = sortM\
    if self.inverseSort then\
      sortMethod = inverseSortM\
    end\
  end\
\
  if self.index > Util.size(self.t) then\
    local newIndex = Util.size(self.t)\
    if newIndex <= 0 then\
      newIndex = 1\
    end\
    self:setIndex(newIndex)\
    if Util.size(self.t) == 0 then\
      y = 1\
      if not self.disableHeader then\
        y = y + 1\
      end\
      self:clearArea(1, y, self.width, self.pageSize, self.backgroundColor)\
    end\
    return\
  end\
\
  local startRow = self:getStartRow()\
  local y = self.y\
  local rowCount = 0\
  local sb = UI.StringBuffer(self.width)\
\
  if not self.disableHeader then\
    y = y + 1\
  end\
\
  local index = 1\
  for _,row in Util.spairs(self.t, sortMethod) do\
    if index >= startRow then\
      sb:clear()\
      if index >= startRow + self.pageSize then\
        break\
      end\
\
      --if not self.isColor then\
        if self.focused then\
        if index == self.index and self.selectable then\
          sb:insert('>', 0)\
        end\
        end\
      --end\
\
      local x = 1\
      for _,col in pairs(self.columns) do\
\
        local value = row[col[2]]\
        if value then\
          sb:insert(string.sub(value, 1, col[3]), x)\
        end\
\
        x = x + col[3] + 1\
      end\
\
      local selected = index == self.index and self.selectable\
      if selected then\
        self:setSelected(row)\
      end\
\
      self.parent:write(self.x, y, sb:get(),\
        self:getRowBackgroundColor(row, selected),\
        self:getRowTextColor(row, selected))\
\
      y = y + 1\
      rowCount = rowCount + 1\
    end\
    index = index + 1\
  end\
\
  if rowCount < self.pageSize then\
    self.parent:clearArea(self.x, y, self.width, self.pageSize-rowCount, self.backgroundColor)\
  end\
  term.setTextColor(colors.white)\
end\
\
function UI.Grid:getRowTextColor(row, selected)\
  if selected then\
    return self.textSelectedColor\
  end\
  return self.textColor\
end\
\
function UI.Grid:getRowBackgroundColor(row, selected)\
  if selected then\
    if self.focused then\
      return self.backgroundSelectedColor\
    else\
      return colors.lightGray\
    end\
  end\
  return self.backgroundColor\
end\
\
function UI.Grid:getIndex(index)\
  return self.index\
end\
\
function UI.Grid:setIndex(index)\
  if self.index ~= index then\
    if index < 1 then\
      index = 1\
    end\
    self.index = index\
    self:drawRows()\
  end\
end\
\
function UI.Grid:getStartRow()\
  return math.floor((self.index - 1)/ self.pageSize) * self.pageSize + 1\
end\
\
function UI.Grid:getPage()\
  return math.floor(self.index / self.pageSize) + 1\
end\
\
function UI.Grid:getPageCount()\
  local tableSize = Util.size(self.t)\
  local pc = math.floor(tableSize / self.pageSize)\
  if tableSize % self.pageSize > 0 then\
    pc = pc + 1\
  end\
  return pc\
end\
\
function UI.Grid:nextPage()\
  self:setPage(self:getPage() + 1)\
end\
\
function UI.Grid:previousPage()\
  self:setPage(self:getPage() - 1)\
end\
\
function UI.Grid:setPage(pageNo)\
  -- 1 based paging\
  self:setIndex((pageNo-1) * self.pageSize + 1)\
end\
\
function UI.Grid:eventHandler(event)\
\
  if event.type == 'mouse_click' then\
    local row = self:getStartRow() + event.y - 1\
    if not self.disableHeader then\
      row = row - 1\
    end\
    if row <= Util.size(self.t) then\
      self:setIndex(row)\
      self:emit({ type = 'key', key = 'enter' })\
      return true\
    end\
  elseif event.type == 'key' then\
    if event.key == 'enter' then\
      self:emit({ type = 'grid_select', selected = self.selected })\
      return false\
    elseif event.key == 'j' or event.key == 'down' then\
      self:setIndex(self.index + 1)\
    elseif event.key == 'k' or event.key == 'up' then\
      self:setIndex(self.index - 1)\
    elseif event.key == 'h' then\
      self:setIndex(self.index - self.pageSize)\
    elseif event.key == 'l' then\
      self:setIndex(self.index + self.pageSize)\
    elseif event.key == 'home' then\
      self:setIndex(1)\
    elseif event.key == 'end' then\
      self:setIndex(Util.size(self.t))\
    elseif event.key == 's' then\
      self:setInverseSort(not self.inverseSort)\
    else\
      return false\
    end\
    return true\
  end\
  return false\
end\
\
--[[-- ScrollingGrid  --]]--\
UI.ScrollingGrid = class.class(UI.Grid)\
function UI.ScrollingGrid:init(args)\
  local defaults = {\
    UIElement = 'ScrollingGrid',\
    scrollOffset = 1\
  }\
  UI.setProperties(self, defaults)\
  UI.Grid.init(self, args)\
end\
\
function UI.ScrollingGrid:drawRows()\
  UI.Grid.drawRows(self)\
  self:drawScrollbar()\
end\
\
function UI.ScrollingGrid:drawScrollbar()\
  local ts = Util.size(self.t)\
  if ts > self.pageSize then\
    term.setBackgroundColor(self.backgroundColor)\
    local sbSize = self.pageSize - 2\
    local sa = ts -- - self.pageSize\
    sa = self.pageSize / sa\
    sa = math.floor(sbSize * sa)\
    if sa < 1 then\
      sa = 1\
    end\
    if sa > sbSize then\
      sa = sbSize\
    end\
    local sp = ts-self.pageSize\
    sp = self.scrollOffset / sp\
    sp = math.floor(sp * (sbSize-sa + 0.5))\
\
    local x = self.x + self.width-1\
    if self.scrollOffset > 1 then\
      self.parent:write(x, self.y + 1, '^')\
    else\
      self.parent:write(x, self.y + 1, ' ')\
    end\
    local row = 0\
    for i = 0, sp - 1 do\
      self.parent:write(x, self.y + row+2, '|')\
      row = row + 1\
    end\
    for i = 1, sa do\
      self.parent:write(x, self.y + row+2, '#')\
      row = row + 1\
    end\
    for i = row, sbSize do\
      self.parent:write(x, self.y + row+2, '|')\
      row = row + 1\
    end\
    if self.scrollOffset + self.pageSize - 1 < Util.size(self.t) then\
      self.parent:write(x, self.y + self.pageSize, 'v')\
    else\
      self.parent:write(x, self.y + self.pageSize, ' ')\
    end\
  end\
end\
\
function UI.ScrollingGrid:getStartRow()\
  local ts = Util.size(self.t)\
  if ts < self.pageSize then\
    self.scrollOffset = 1\
  end\
  return self.scrollOffset\
end\
\
function UI.ScrollingGrid:setIndex(index)\
  if index < self.scrollOffset then\
    self.scrollOffset = index\
  elseif index - (self.scrollOffset - 1) > self.pageSize then\
    self.scrollOffset = index - self.pageSize + 1\
  end\
\
  if self.scrollOffset < 1 then\
    self.scrollOffset = 1\
  else\
    local ts = Util.size(self.t)\
    if self.pageSize + self.scrollOffset > ts then\
      self.scrollOffset = ts - self.pageSize + 1\
    end\
  end\
  UI.Grid.setIndex(self, index)\
end\
\
--[[-- Menu --]]--\
UI.Menu = class.class(UI.Grid)\
function UI.Menu:init(args)\
  local defaults = {\
    UIElement = 'Menu',\
    disableHeader = true,\
    columns = { { 'Prompt', 'prompt', 20 } },\
    t = args['menuItems']\
  }\
  UI.setProperties(defaults, args)\
  UI.Grid.init(self, defaults)\
  self.pageSize = #args.menuItems\
end\
\
function UI.Menu:setParent()\
  UI.Grid.setParent(self)\
  self.itemWidth = 1\
  for _,v in pairs(self.t) do\
    if #v.prompt > self.itemWidth then\
      self.itemWidth = #v.prompt\
    end\
  end\
  self.columns[1][3] = self.itemWidth\
\
  if self.centered then\
    self:center()\
  else\
    self.width = self.itemWidth + 2\
  end\
end\
\
function UI.Menu:center()\
  self.x = (self.width - self.itemWidth + 2) / 2\
  self.width = self.itemWidth + 2\
\
end\
\
function UI.Menu:eventHandler(event)\
  if event.type == 'key' then\
    if event.key and self.menuItems[tonumber(event.key)] then\
      local selected = self.menuItems[tonumber(event.key)]\
      self:emit({\
        type = selected.event or 'menu_select',\
        selected = selected\
      })\
      return true\
    elseif event.key == 'enter' then\
      local selected = self.menuItems[self.index]\
      self:emit({\
        type = selected.event or 'menu_select',\
        selected = selected\
      })\
      return true\
    end\
  elseif event.type == 'mouse_click' then\
    if event.y <= #self.menuItems then\
      UI.Grid.setIndex(self, event.y)\
      local selected = self.menuItems[self.index]\
      self:emit({\
        type = selected.event or 'menu_select',\
        selected = selected\
      })\
      return true\
    end\
  end\
  return UI.Grid.eventHandler(self, event)\
end\
\
--[[-- ViewportWindow --]]--\
UI.ViewportWindow = class.class(UI.Window)\
function UI.ViewportWindow:init(args)\
  local defaults = {\
    UIElement = 'ViewportWindow',\
    x = 1,\
    y = 1,\
    --width = console.width,\
    --height = console.height,\
    offset = 0\
  }\
  UI.setProperties(self, defaults)\
  UI.Window.init(self, args)\
  self.vpHeight = self.height\
end\
\
function UI.ViewportWindow:clear(bg)\
  self:clearArea(1, 1+self.offset, self.width, self.height+self.offset, bg)\
end\
\
function UI.ViewportWindow:write(x, y, text, bg)\
  local y = y - self.offset\
  if y > self.vpHeight then\
    self.vpHeight = y\
  end\
  if y  <= self.height and y > 0 then\
    UI.Window.write(self, x, y, text, bg)\
  end\
end\
\
function UI.ViewportWindow:setPage(pageNo)\
  self:setOffset((pageNo-1) * self.vpHeight + 1)\
end\
\
function UI.ViewportWindow:setOffset(offset)\
  local newOffset = math.max(0, math.min(math.max(0, offset), self.vpHeight-self.height))\
  if newOffset ~= self.offset then\
    self.offset = newOffset\
    self:clear()\
    self:draw()\
    return true\
  end\
  return false\
end\
\
function UI.ViewportWindow:eventHandler(event)\
\
  if ch == 'j' or ch == 'down' then\
    return self:setOffset(self.offset + 1)\
  elseif ch == 'k' or ch == 'up' then\
    return self:setOffset(self.offset - 1)\
  elseif ch == 'home' then\
    self:setOffset(0)\
  elseif ch == 'end' then\
    return self:setOffset(self.height-self.vpHeight)\
  elseif ch == 'h' then\
    return self:setPage(\
      math.floor((self.offset - self.vpHeight) / self.vpHeight))\
  elseif ch == 'l' then\
    return self:setPage(\
      math.floor((self.offset + self.vpHeight) / self.vpHeight) + 1)\
  else\
    return false\
  end\
  return true\
end\
  \
--[[-- ScrollingText --]]--\
UI.ScrollingText = class.class(UI.Window)\
function UI.ScrollingText:init(args)\
  local defaults = {\
    UIElement = 'ScrollingText',\
    x = 1,\
    y = 1,\
    backgroundColor = colors.black,\
    --height = console.height,\
    --width = console.width,\
    buffer = { }\
  }\
  UI.setProperties(defaults, args)\
  UI.Window.init(self, defaults)\
end\
\
function UI.ScrollingText:write(text)\
  if #self.buffer+1 >= self.height then\
    table.remove(self.buffer, 1)\
  end\
  table.insert(self.buffer, text)\
  self:draw()\
end\
\
function UI.ScrollingText:clear()\
  self.buffer = { }\
  self.parent:clearArea(self.x, self.y, self.width, self.height, self.backgroundColor)\
end\
\
function UI.ScrollingText:draw()\
  for k,text in ipairs(self.buffer) do\
    self.parent:write(self.x, self.y + k - 1, widthify(text, self.width), self.backgroundColor)\
  end\
end\
\
--[[-- TitleBar --]]--\
UI.TitleBar = class.class(UI.Window)\
function UI.TitleBar:init(args)\
  local defaults = {\
    UIElement = 'TitleBar',\
    height = 1,\
    backgroundColor = colors.brown,\
    title = ''\
  }\
  UI.setProperties(defaults, args)\
  UI.Window.init(self, defaults)\
end\
\
function UI.TitleBar:draw()\
  self:clearArea(1, 1, self.width, 1, self.backgroundColor)\
  local centered = math.ceil((self.width - #self.title) / 2)\
  self:write(1 + centered, 1, self.title, self.backgroundColor)\
  if self.previousPage then\
    self:write(self.width, 1, '*', self.backgroundColor, colors.black)\
  end\
  --self:write(self.width-1, 1, '?', self.backgroundColor)\
end\
\
function UI.TitleBar:eventHandler(event)\
  if event.type == 'mouse_click' then\
    if self.previousPage and event.x == self.width then\
      if type(self.previousPage) == 'string' or\
         type(self.previousPage) == 'table' then\
        UI.pager:setPage(self.previousPage)\
      else\
        UI.pager:setPreviousPage()\
      end\
      return true\
    end\
  end\
end\
\
--[[-- MenuBar --]]--\
UI.MenuBar = class.class(UI.Window)\
function UI.MenuBar:init(args)\
  local defaults = {\
    UIElement = 'MenuBar',\
    buttons = { },\
    height = 1,\
    backgroundColor = colors.lightBlue,\
    title = ''\
  }\
  UI.setProperties(defaults, args)\
  UI.Window.init(self, defaults)\
\
  if not self.children then\
    self.children = { }\
  end\
  local x = 1\
  for _,button in pairs(self.buttons) do\
    local buttonProperties = {\
      x = x,\
      width = #button.text + 2,\
      backgroundColor = colors.lightBlue,\
      textColor = colors.black\
    }\
    x = x + buttonProperties.width\
    UI.setProperties(buttonProperties, button)\
    local child = UI.Button(buttonProperties)\
    child.parent = self\
    table.insert(self.children, child)\
  end\
end\
\
--[[-- StatusBar --]]--\
UI.StatusBar = class.class(UI.GridLayout)\
function UI.StatusBar:init(args)\
  local defaults = {\
    UIElement = 'StatusBar',\
    backgroundColor = colors.gray,\
    columns = { \
      { '', 'status', 10 },\
    },\
    values = { },\
    status = { status = '' }\
  }\
  UI.setProperties(defaults, args)\
  UI.GridLayout.init(self, defaults)\
  self:setStatus(self.status)\
end\
\
function UI.StatusBar:setParent()\
  UI.GridLayout.setParent(self)\
  self.y = self.height\
  if #self.columns == 1 then\
    self.columns[1][3] = self.width\
  end\
end\
\
function UI.StatusBar:setStatus(status)\
  if type(status) == 'string' then\
    self.values[1] = { status = status }\
  else\
    self.values[1] = status\
  end\
end\
\
function UI.StatusBar:setValue(name, value)\
  self.status[name] = value\
end\
\
function UI.StatusBar:getValue(name)\
  return self.status[name]\
end\
\
function UI.StatusBar:timedStatus(status, timeout)\
  timeout = timeout or 3\
  self:write(2, 1, widthify(status, self.width-2), self.backgroundColor)\
  Event.addNamedTimer('statusTimer', timeout, false, function()\
    -- fix someday\
    if self.parent.enabled then\
      self:draw()\
    end\
  end)\
end\
\
function UI.StatusBar:getColumnWidth(name)\
  for _,v in pairs(self.columns) do\
    if v[2] == name then\
      return v[3]\
    end\
  end\
end\
\
function UI.StatusBar:setColumnWidth(name, width)\
  for _,v in pairs(self.columns) do\
    if v[2] == name then\
      v[3] = width\
      break\
    end\
  end\
end\
\
--[[-- ProgressBar --]]--\
UI.ProgressBar = class.class(UI.Window)\
function UI.ProgressBar:init(args)\
  local defaults = {\
    UIElement = 'ProgressBar',\
    progressColor = colors.lime,\
    backgroundColor = colors.gray,\
    height = 1,\
    progress = 0\
  }\
  UI.setProperties(self, defaults)\
  UI.Window.init(self, args)\
end\
\
function UI.ProgressBar:draw()\
  local progressWidth = math.ceil(self.progress / 100 * self.width)\
  if progressWidth > 0 then\
    self.parent:write(self.x, self.y, string.rep(' ', progressWidth), self.progressColor)\
  end\
  local x = self.x + progressWidth\
  progressWidth = self.width - progressWidth\
  if progressWidth > 0 then\
    self.parent:write(x, self.y, string.rep(' ', progressWidth), self.backgroundColor)\
  end\
end\
\
function UI.ProgressBar:setProgress(progress)\
  self.progress = progress\
end\
\
--[[-- VerticalMeter --]]--\
UI.VerticalMeter = class.class(UI.Window)\
function UI.VerticalMeter:init(args)\
  local defaults = {\
    UIElement = 'VerticalMeter',\
    meterColor = colors.lime,\
    height = 1,\
    percent = 0\
  }\
  UI.setProperties(defaults, args)\
  UI.Window.init(self, defaults)\
end\
\
function UI.VerticalMeter:draw()\
  local height = self.height - math.ceil(self.percent / 100 * self.height)\
  local filler = string.rep(' ', self.width)\
\
  for i = 1, height do\
    self:write(1, i, filler, self.backgroundColor)\
  end\
\
  for i = height+1, self.height do\
    self:write(1, i, filler, self.meterColor)\
  end\
end\
\
function UI.VerticalMeter:setPercent(percent)\
  self.percent = percent\
end\
\
--[[-- Button --]]--\
UI.Button = class.class(UI.Window)\
function UI.Button:init(args)\
  local defaults = {\
    UIElement = 'Button',\
    text = 'button',\
    focused = false,\
    backgroundColor = colors.gray,\
    backgroundFocusColor = colors.green,\
    height = 1,\
    width = 8,\
    event = 'button_press'\
  }\
  UI.setProperties(defaults, args)\
  UI.Window.init(self, defaults)\
end\
\
function UI.Button:draw()\
  local bg = self.backgroundColor\
  local ind = ' '\
  if self.focused then\
    bg = self.backgroundFocusColor\
    ind = '>'\
  end\
  self:clear(bg)\
  local text = ind .. self.text .. ' '\
  self:centeredWrite(1 + math.floor(self.height / 2), text, bg)\
end\
\
function UI.Button:focus()\
  self:draw()\
end\
\
function UI.Button:eventHandler(event)\
  if (event.type == 'key' and event.key == 'enter') or \
      event.type == 'mouse_click' then\
    self:emit({ type = self.event, button = self })\
    return true\
  end\
  return false\
end\
\
--[[-- TextEntry --]]--\
UI.TextEntry = class.class(UI.Window)\
function UI.TextEntry:init(args)\
  local defaults = {\
    UIElement = 'TextEntry',\
    value = '',\
    type = 'string',\
    focused = false,\
    backgroundColor = colors.lightGray,\
    backgroundFocusColor = colors.green,\
    height = 1,\
    width = 8,\
    limit = 6\
  }\
  UI.setProperties(defaults, args)\
  UI.Window.init(self, defaults)\
end\
\
function UI.TextEntry:setParent()\
  UI.Window.setParent(self)\
  if self.limit + 2 > self.width then\
    self.limit = self.width - 2\
  end\
end\
\
function UI.TextEntry:draw()\
  local bg = self.backgroundColor\
  if self.focused then\
    bg = self.backgroundFocusColor\
  end\
  self:write(1, 1, ' ' .. widthify(self.value, self.limit) .. ' ', bg)\
  if self.focused then\
    self:updateCursor()\
  end\
end\
\
function UI.TextEntry:updateCursor()\
  if not self.pos then\
    self.pos = #self.value\
  elseif self.pos > #self.value then\
    self.pos = #self.value\
  end\
  self:displayCursor(self.pos+2, 1)\
end\
\
function UI.TextEntry:focus()\
  self:draw()\
  if self.focused then\
    term.setCursorBlink(true)\
  else\
    term.setCursorBlink(false)\
  end\
end\
\
--[[\
  A few lines below from theoriginalbit\
  http://www.computercraft.info/forums2/index.php?/topic/16070-read-and-limit-length-of-the-input-field/\
--]]\
function UI.TextEntry:eventHandler(event)\
  if event.type == 'key' then\
    local ch = event.key\
    if ch == 'left' then\
      if self.pos > 0 then\
        self.pos = math.max(self.pos-1, 0)\
        self:updateCursor()\
      end\
    elseif ch == 'right' then\
      local input = self.value\
      if self.pos < #input then\
        self.pos = math.min(self.pos+1, #input)\
        self:updateCursor()\
      end\
    elseif ch == 'home' then\
      self.pos = 0\
      self:updateCursor()\
    elseif ch == 'end' then\
      self.pos = #self.value\
      self:updateCursor()\
    elseif ch == 'backspace' then\
      if self.pos > 0 then\
        local input = self.value\
        self.value = input:sub(1, self.pos-1) .. input:sub(self.pos+1)\
        self.pos = self.pos - 1\
        self:draw()\
        self:updateCursor()\
      end\
    elseif ch == 'delete' then\
      local input = self.value\
      if self.pos < #input then\
        self.value = input:sub(1, self.pos) .. input:sub(self.pos+2)\
        self:draw()\
        self:updateCursor()\
      end\
    elseif #ch == 1 then\
      local input = self.value\
      if #input < self.limit then\
        self.value = input:sub(1, self.pos) .. ch .. input:sub(self.pos+1)\
        self.pos = self.pos + 1\
        self:draw()\
        self:updateCursor()\
      end\
    else\
      return false\
    end\
    return true\
  end\
  return false\
end\
\
--[[-- Chooser --]]--\
UI.Chooser = class.class(UI.Window)\
function UI.Chooser:init(args)\
  local defaults = {\
    UIElement = 'Chooser',\
    choices = { },\
    nochoice = 'Select',\
    backgroundColor = colors.lightGray,\
    backgroundFocusColor = colors.green,\
    height = 1\
  }\
  UI.setProperties(defaults, args)\
  UI.Window.init(self, defaults)\
end\
\
function UI.Chooser:setParent()\
  if not self.width then\
    self.width = 1\
    for _,v in pairs(self.choices) do\
      if #v.name > self.width then\
        self.width = #v.name\
      end\
    end\
    self.width = self.width + 4\
  end\
  UI.Window.setParent(self)\
end\
\
function UI.Chooser:draw()\
  local bg = self.backgroundColor\
  if self.focused then\
    bg = self.backgroundFocusColor\
  end\
  local choice = Util.find(self.choices, 'value', self.value)\
  local value = self.nochoice\
  if choice then\
    value = choice.name\
  end\
  self:write(1, 1, '<', bg, colors.black)\
  self:write(2, 1, ' ' .. widthify(value, self.width-4) .. ' ', bg)\
  self:write(self.width, 1, '>', bg, colors.black)\
end\
\
function UI.Chooser:focus()\
  self:draw()\
end\
\
function UI.Chooser:eventHandler(event)\
  if event.type == 'key' then\
    if event.key == 'right' or event.key == 'space' then\
      local choice,k = Util.find(self.choices, 'value', self.value)\
      if k and k < #self.choices then\
        self.value = self.choices[k+1].value\
      else\
        self.value = self.choices[1].value\
      end\
      self:emit({ type = 'choice_change', value = self.value })\
      self:draw()\
      return true\
    elseif event.key == 'left' then\
      local choice,k = Util.find(self.choices, 'value', self.value)\
      if k and k > 1 then\
        self.value = self.choices[k-1].value\
      else\
        self.value = self.choices[#self.choices].value\
      end\
      self:emit({ type = 'choice_change', value = self.value })\
      self:draw()\
      return true\
    end\
  elseif event.type == 'mouse_click' then\
    if event.x == 1 then\
      self:emit({ type = 'key', key = 'left' })\
      return true\
    elseif event.x == self.width then\
      self:emit({ type = 'key', key = 'right' })\
      return true\
    end\
  end\
end\
\
--[[-- Text --]]--\
UI.Text = class.class(UI.Window)\
function UI.Text:init(args)\
  local defaults = {\
    UIElement = 'Text',\
    value = '',\
    height = 1\
  }\
  UI.setProperties(defaults, args)\
  UI.Window.init(self, defaults)\
end\
\
function UI.Text:setParent()\
  if not self.width then\
    self.width = #self.value\
  end\
  UI.Window.setParent(self)\
end\
\
function UI.Text:draw()\
  local value = self.value or ''\
  self:write(1, 1, widthify(value, self.width), self.backgroundColor)\
end\
\
--[[-- Form --]]--\
UI.Form = class.class(UI.Window)\
UI.Form.D = { -- display\
  static = UI.Text,\
  entry = UI.TextEntry,\
  chooser = UI.Chooser,\
  button = UI.Button\
}\
\
UI.Form.V = { -- validation\
  number = function(value)\
    return type(value) == 'number'\
  end\
}\
\
UI.Form.T = { -- data types\
  number = function(value)\
    return tonumber(value)\
  end\
}\
\
function UI.Form:init(args)\
  local defaults = {\
    UIElement = 'Form',\
    values = {},\
    fields = {},\
    columns = {\
      { 'Name', 'name', 20 },\
      { 'Values', 'value', 20 }\
    },\
    x = 1,\
    y = 1,\
    labelWidth = 20,\
    accept = function() end,\
    cancel = function() end\
  }\
  UI.setProperties(defaults, args)\
  UI.Window.init(self, defaults)\
  self:initChildren(self.values)\
end\
\
function UI.Form:setValues(values)\
  self.values = values\
  for k,child in pairs(self.children) do\
    if child.key then\
      child.value = self.values[child.key]\
      if not child.value then\
        child.value = ''\
      end\
    end\
  end\
end\
\
function UI.Form:initChildren(values)\
  self.values = values\
\
  if not self.children then\
    self.children = { }\
  end\
\
  for k,field in pairs(self.fields) do\
    if field.label then\
      self['label_' .. k] = UI.Text({\
        x = 1,\
        y = k,\
        width = #field.label,\
        value = field.label\
      })\
    end\
    local value\
    if field.key then\
      value = self.values[field.key]\
    end\
    if not value then\
      value = ''\
    end\
    value = tostring(value)\
    local width = #value\
    if field.limit then\
       width = field.limit + 2\
    end\
    local fieldProperties = {\
      x = self.labelWidth + 2,\
      y = k,\
      width = width,\
      value = value\
    }\
    UI.setProperties(fieldProperties, field)\
    local child = field.display(fieldProperties)\
    child.parent = self\
    table.insert(self.children, child)\
  end\
end\
\
function UI.Form:eventHandler(event)\
\
  if event.type == 'accept' then\
    for _,child in pairs(self.children) do\
      if child.key then\
        self.values[child.key] = child.value\
      end\
    end\
    return false\
  end\
\
  return false\
end\
\
--[[-- Dialog --]]--\
UI.Dialog = class.class(UI.Page)\
function UI.Dialog:init(args)\
  local defaults = {\
    x = 7,\
    y = 4,\
    width = UI.term.width-11,\
    height = 7,\
    backgroundColor = colors.lightBlue,\
    titleBar = UI.TitleBar({ previousPage = true }),\
    acceptButton = UI.Button({\
      text = 'Accept',\
      event = 'accept',\
      x = 5,\
      y = 5\
    }),\
    cancelButton = UI.Button({\
      text = 'Cancel',\
      event = 'cancel',\
      x = 17,\
      y = 5\
    }),\
    statusBar = UI.StatusBar(),\
  }\
  UI.setProperties(defaults, args)\
  UI.Page.init(self, defaults)\
end\
\
function UI.Dialog:eventHandler(event)\
  if event.type == 'cancel' then\
    UI.pager:setPreviousPage()\
  end\
  return UI.Page.eventHandler(self, event)\
end\
\
--[[-- Spinner --]]--\
UI.Spinner = class.class()\
function UI.Spinner:init(args)\
  local defaults = {\
    UIElement = 'Spinner',\
    timeout = .095,\
    x = 1,\
    y = 1,\
    c = os.clock(),\
    spinIndex = 0,\
    spinSymbols = { '-', '/', '|', '\\\\' }\
  }\
  defaults.x, defaults.y = term.getCursorPos()\
  defaults.startX = defaults.x\
  defaults.startY = defaults.y\
\
  UI.setProperties(self, defaults)\
  UI.setProperties(self, args)\
end\
\
function UI.Spinner:spin(text)\
  local cc = os.clock()\
  if cc > self.c + self.timeout then\
    term.setCursorPos(self.x, self.y)\
    local str = self.spinSymbols[self.spinIndex % #self.spinSymbols + 1]\
    if text then\
      str = str .. ' ' .. text\
    end\
    term.write(str)\
    self.spinIndex = self.spinIndex + 1\
    self.c = cc\
    os.sleep(0)\
  end\
end\
\
function UI.Spinner:stop(text)\
  term.setCursorPos(self.x, self.y)\
  local str = string.rep(' ', #self.spinSymbols)\
  if text then\
    str = str .. ' ' .. text\
  end\
  term.write(str)\
  term.setCursorPos(self.startX, self.startY)\
end\
\
--[[-- Table Viewer --]]--\
function UI.displayTable(t, title)\
\
  local resultPath = { }\
\
  local resultsPage = UI.Page({\
    parent = UI.term,\
    titleBar = UI.TitleBar(),\
    grid = UI.ScrollingGrid({\
      columns = { \
        { 'Name', 'name', 10 },\
        { 'Value', 'value', 10 }\
      },  \
      sortColumn = 'name',\
      pageSize = UI.term.height - 2,\
      y = 2,\
      width = UI.term.width,\
      height = UI.term.height - 3,\
      autospace = true\
    }),\
  })\
\
  function resultsPage:setResult(result, title)\
    local t = { }\
    if type(result) == 'table' then\
      for k,v in pairs(result) do\
        local entry = {\
          name = k,\
          value = tostring(v)\
        }\
        if type(v) == 'table' then\
          if Util.size(v) == 0 then\
            entry.value = 'table: (empty)'\
          else\
            entry.value = 'table'\
            entry.table = v\
          end\
        end\
        table.insert(t, entry)\
      end\
    else\
      table.insert(t, {\
        name = 'result',\
        value = tostring(result)\
      })\
    end\
    self.grid.sortColumn = 'Name'\
    self.grid.columns = { \
      { 'Name', 'name', 10 },\
      { 'Value', 'value', 10 }\
    }\
    self.grid.t = t\
    self.grid:adjustWidth()\
    if title then\
      self.titleBar.title = title\
    end\
  end\
\
  function resultsPage.grid:flatten()\
    self.columns = { }\
    local _,first = next(self.t)\
    for k in pairs(first.table) do\
      table.insert(self.columns, {\
        k, k, 1\
      })\
    end\
    local t = { }\
    for k,v in pairs(self.t) do\
      v.table.__key = v.name\
      t[v.name] = v.table\
    end\
    self.t = t\
    self.sortColumn = '__key'\
    self:adjustWidth()\
    self:draw()\
  end\
\
  function resultsPage.grid:eventHandler(event)\
    if event.type == 'key' then\
      local ch = event.key\
      if ch == 'enter' or ch == 'l' then\
        local nameValue = self:getSelected()\
        if nameValue.table then\
          if Util.size(nameValue.table) > 0 then\
            table.insert(resultPath, self.t)\
            resultsPage:setResult(nameValue.table)\
            self:setIndex(1)\
            self:draw()\
          end\
        end\
        return true\
      elseif ch == 'f' then\
        self:flatten()\
      elseif ch == 'h' then\
        if #resultPath > 0 then\
          self.t = table.remove(resultPath)\
          self.columns = { \
            { 'Name', 'name', 10 },\
            { 'Value', 'value', 10 }\
          }\
          self.sortColumn = 'Name'\
          self:adjustWidth()\
          self:draw()\
        else\
          UI.pager:setPreviousPage()\
        end\
        return true\
      elseif ch == 'q' then\
        UI.pager:setPreviousPage()\
        return true\
      end\
    end\
    return UI.Grid.eventHandler(self, event)\
  end\
\
  resultsPage:setResult(t, title or 'Table Viewer')\
  UI.pager:setPage(resultsPage)\
end\
\
--Import \
_G.TableDB = class.class()\
function TableDB:init(args)\
  local defaults = {\
    fileName = '',\
    dirty = false,\
    data = { },\
    tabledef = { },\
  }\
  UI.setProperties(defaults, args)\
  UI.setProperties(self, defaults)\
end\
\
function TableDB:load()\
  local table = Util.readTable(self.fileName)\
  if table then\
    self.data = table.data\
    self.tabledef = table.tabledef\
  end\
end\
\
function TableDB:add(key, entry)\
  if type(key) == 'table' then\
    key = table.concat(key, ':')\
  end\
  self.data[key] = entry\
  self.dirty = true\
end\
\
function TableDB:get(key)\
  if type(key) == 'table' then\
    key = table.concat(key, ':')\
  end\
  return self.data[key]\
end\
\
function TableDB:remove(key)\
  self.data[key] = nil\
  self.dirty = true\
end\
\
function TableDB:flush()\
  if self.dirty then\
    Util.writeTable(self.fileName, {\
      tabledef = self.tabledef,\
      data = self.data,\
    })\
    self.dirty = false\
  end\
end\
\
if turtle then\
--Import \
--[[\
Modes:\
 normal - oob functionality\
 pathfind - goes around blocks/mobs\
 destructive - destroys blocks\
 friendly - destructive and creates a 2 block walking passage (not implemented)\
\
Dig strategies:\
 none - does not dig or kill mobs\
 normal - digs and kills mobs\
 wasteful - digs and drops mined blocks and kills mobs\
 cautious - digs and kills mobs but will not destroy other turtles\
--]]\
\
_G.TL2 = { }\
\
TL2.actions = {\
  up = {\
    detect = turtle.detectUp,\
    dig = turtle.digUp,\
    move = turtle.up,\
    attack = turtle.attackUp,\
    place = turtle.placeUp,\
    suck = turtle.suckUp,\
    compare = turtle.compareUp,\
    side = 'top'\
  },\
  down = {\
    detect = turtle.detectDown,\
    dig = turtle.digDown,\
    move = turtle.down,\
    attack = turtle.attackDown,\
    place = turtle.placeDown,\
    suck = turtle.suckDown,\
    compare = turtle.compareDown,\
    side = 'bottom'\
  },\
  forward = {\
    detect = turtle.detect,\
    dig = turtle.dig,\
    move = turtle.forward,\
    attack = turtle.attack,\
    place = turtle.place,\
    suck = turtle.suck,\
    compare = turtle.compare,\
    side = 'front'\
  }\
}\
\
TL2.headings = {\
  [ 0 ] = { xd =  1, yd =  0, zd =  0, heading = 0 }, -- east\
  [ 1 ] = { xd =  0, yd =  1, zd =  0, heading = 1 }, -- south\
  [ 2 ] = { xd = -1, yd =  0, zd =  0, heading = 2 }, -- west\
  [ 3 ] = { xd =  0, yd = -1, zd =  0, heading = 3 }, -- north\
  [ 4 ] = { xd =  0, yd =  0, zd =  1, heading = 4 }, -- up\
  [ 5 ] = { xd =  0, yd =  0, zd = -1, heading = 5 }  -- down\
}\
\
TL2.namedHeadings = {\
  east  = 0,\
  south = 1,\
  west  = 2,\
  north = 3,\
  up    = 4,\
  down  = 5\
}\
\
_G.Point = { }\
-- used mainly to extract point specific info from a table\
function Point.create(pt)\
  return { x = pt.x, y = pt.y, z = pt.z }\
end\
\
function Point.subtract(a, b)\
  a.x = a.x - b.x\
  a.y = a.y - b.y\
  a.z = a.z - b.z\
end\
\
function Point.tostring(pt)\
  local str = string.format('x:%d y:%d z:%d', pt.x, pt.y, pt.z)\
  if pt.heading then\
    str = str .. ' heading:' .. pt.heading\
  end\
  return str\
end\
\
-- deprecated\
function TL2.createPoint(pt)\
  return Point.create(pt)\
end\
\
function TL2.pointToBox(pt, width, length, height)\
  return { ax = pt.x,\
           ay = pt.y,\
           az = pt.z,\
           bx = pt.x + width - 1,\
           by = pt.y + length - 1,\
           bz = pt.z + height - 1\
         }\
end\
\
function TL2.pointInBox(pt, box)\
  return pt.x >= box.ax and\
         pt.y >= box.ay and\
         pt.x <= box.bx and\
         pt.y <= box.by\
end\
\
function TL2.boxContain(boundingBox, containedBox)\
\
  local shiftX = boundingBox.ax - containedBox.ax\
  if shiftX > 0 then\
    containedBox.ax = containedBox.ax + shiftX\
    containedBox.bx = containedBox.bx + shiftX\
  end\
  local shiftY = boundingBox.ay - containedBox.ay\
  if shiftY > 0 then\
    containedBox.ay = containedBox.ay + shiftY\
    containedBox.by = containedBox.by + shiftY\
  end\
\
  shiftX = boundingBox.bx - containedBox.bx\
  if shiftX < 0 then\
    containedBox.ax = containedBox.ax + shiftX\
    containedBox.bx = containedBox.bx + shiftX\
  end\
  shiftY = boundingBox.by - containedBox.by\
  if shiftY < 0 then\
    containedBox.ay = containedBox.ay + shiftY\
    containedBox.by = containedBox.by + shiftY\
  end\
end\
\
function TL2.calculateTurns(ih, oh)\
  if ih == oh then\
    return 0\
  end\
  if (ih % 2) == (oh % 2) then\
    return 2\
  end\
  return 1\
end\
\
function TL2.calculateDistance(a, b)\
--[[\
  return math.sqrt(\
         math.pow(a.x - b.x, 2) + \
         math.pow(a.y - b.y, 2) +\
         math.pow(a.z - b.z, 2))\
--]]\
  return math.max(a.x, b.x) - math.min(a.x, b.x) + \
         math.max(a.y, b.y) - math.min(a.y, b.y) +\
         math.max(a.z, b.z) - math.min(a.z, b.z)\
end\
\
function TL2.calculateHeadingTowards(startPt, endPt, heading)\
  local xo = endPt.x - startPt.x\
  local yo = endPt.y - startPt.y\
\
  if heading == 0 and xo > 0 or \
     heading == 2 and xo < 0 or \
     heading == 1 and yo > 0 or \
     heading == 3 and yo < 0 then \
    -- maintain current heading\
    return heading\
  elseif heading == 0 and yo > 0 or \
         heading == 2 and yo < 0 or\
         heading == 1 and xo < 0 or\
         heading == 3 and xo > 0 then\
    -- right\
    return (heading + 1) % 4\
  elseif heading == 0 and yo < 0 or \
         heading == 2 and yo > 0 or\
         heading == 1 and xo < 0 or\
         heading == 3 and xo > 0 then\
    -- left\
    return (heading + 1) % 4\
  elseif yo == 0 and xo ~= 0 or\
         xo == 0 and yo ~= 0 then\
    -- behind\
    return (heading + 2) % 4\
  elseif endPt.z > startPt.z then\
    -- up\
    return 4\
  elseif endPt.z < startPt.z then\
    -- down\
    return 5\
  end\
  return heading\
end\
\
local function _attack(action)\
  if action.attack() then\
    Util.tryTimed(4,\
      function()\
        -- keep trying until attack fails\
        return not action.attack()\
      end)\
    return true\
  end\
  return false\
end\
\
local modes = {\
  normal = function(action)\
    return action.move()\
  end,\
\
  destructive = function(action, digStrategy)\
    while not action.move() do\
      if not _attack(action) then\
        if not digStrategy(action) then\
          return false\
        end\
      end\
  Logger.log('turtle', 'destructive move retry: ')\
    end\
    return true\
  end,\
\
}\
\
TL2.digStrategies = {\
  none = function(action)\
    return false\
  end,\
\
  normal = function(action)\
    if action.dig() then\
      return true\
    end\
    if not action.attack() then\
      return false\
    end\
    for i = 1, 50 do\
      if not action.attack() then\
        break\
      end\
    end\
    return true\
  end,\
\
  cautious = function(action)\
    if not TL2.isTurtleAt(action.side) then\
      return action.dig()\
    end\
    os.sleep(.5)\
    return not action.detect()\
  end,\
\
  wasteful = function(action)\
    -- why is there no method to get current slot ?\
    local slots = TL2.getInventory()\
\
-- code below should be done -- only reconcile if no empty slot\
-- taking the cautious approach for now\
--if not selectOpenSlot() then\
--return false\
--end\
\
    if action.detect() and action.dig() then\
      TL2.reconcileInventory(slots)\
      return true\
    end\
    TL2.reconcileInventory(slots)\
    return false\
  end\
}\
\
local state = {\
  x = 0,\
  y = 0,\
  z = 0,\
  slot = 1,  -- must track slot since there is no method to determine current slot\
             -- not relying on this for now (but will track)\
  heading = 0,\
  gps = false,\
  maxRetries = 100,\
  mode = modes.normal,\
  dig = TL2.digStrategies.normal\
}\
\
local memory = {\
  locations = {},\
  blocks = {}\
}\
\
function TL2.getState()\
  return state\
end\
\
function TL2.getMemory()\
  return memory\
end\
\
function TL2.select(slot)\
  state.slot = slot\
  turtle.select(slot)\
end\
\
function TL2.forward()\
  if not state.mode(TL2.actions.forward, state.dig) then\
    return false\
  end\
  state.x = state.x + TL2.headings[state.heading].xd\
  state.y = state.y + TL2.headings[state.heading].yd\
  return true\
end\
\
function TL2.up()\
  if state.mode(TL2.actions.up, state.dig) then\
    state.z = state.z + 1\
    return true\
  end\
  return false\
end\
\
function TL2.down()\
  if not state.mode(TL2.actions.down, state.dig) then\
    return false\
  end\
  state.z = state.z - 1\
  return true\
end\
\
function TL2.back()\
  if not turtle.back() then\
    return false\
  end\
  state.x = state.x - TL2.headings[state.heading].xd\
  state.y = state.y - TL2.headings[state.heading].yd\
  return true\
end\
\
function TL2.dig()\
  return state.dig(TL2.actions.forward)\
end\
\
function TL2.digUp()\
  return state.dig(TL2.actions.up)\
end\
\
function TL2.digDown()\
  return state.dig(TL2.actions.down)\
end\
\
function TL2.attack()\
  _attack(TL2.actions.forward)\
end\
\
function TL2.attackUp()\
  _attack(TL2.actions.up)\
end\
\
function TL2.attackDown()\
  _attack(TL2.actions.down)\
end\
\
local complexActions = {\
  up = {\
    detect = turtle.detectUp,\
    dig = TL2.digUp,\
    move = TL2.up,\
    attack = TL2.attackUp,\
    place = turtle.placeUp,\
    side = 'top'\
  },\
  down = {\
    detect = turtle.detectDown,\
    dig = TL2.digDown,\
    move = TL2.down,\
    attack = TL2.attackDown,\
    place = turtle.placeDown,\
    side = 'bottom'\
  },\
  forward = {\
    detect = turtle.detect,\
    dig = TL2.dig,\
    move = TL2.forward,\
    attack = TL2.attack,\
    place = turtle.place,\
    side = 'front'\
  }\
}\
\
local function _place(action, slot)\
  return Util.tryTimed(5,\
    function()\
      if action.detect() then\
        action.dig()\
      end\
      TL2.select(slot)\
      if action.place() then\
        return true\
      end\
      _attack(action) \
    end)\
end\
\
function TL2.place(slot)\
  return _place(complexActions.forward, slot)\
end\
\
function TL2.placeUp(slot)\
  return _place(complexActions.up, slot)\
end\
\
function TL2.placeDown(slot)\
  return _place(complexActions.down, slot)\
end\
\
function TL2.getModes()\
  return modes\
end\
\
function TL2.getMode()\
  return state.mode\
end\
\
function TL2.setMode(mode)\
  if not modes[mode] then\
    error('TL2.setMode: invalid mode', 2)\
  end\
  state.mode = modes[mode]\
end\
\
function TL2.setDigStrategy(digStrategy)\
  if not TL2.digStrategies[digStrategy] then\
    error('TL2.setDigStrategy: invalid strategy', 2)\
  end\
  state.dig = TL2.digStrategies[digStrategy]\
end\
\
function TL2.reset()\
  state.gxOff = state.gxOff - state.x\
  state.gyOff = state.gyOff - state.y\
  state.gzOff = state.gzOff - state.z\
  state.x = 0\
  state.y = 0\
  state.z = 0\
end\
\
function TL2.isTurtleAt(side)\
  local sideType = peripheral.getType(side)\
  return sideType and sideType == 'turtle'\
end\
\
function TL2.saveLocation()\
  return Util.shallowCopy(state)\
end\
\
function TL2.getNamedLocation(name)\
  return memory.locations[name]\
end\
\
function TL2.gotoNamedLocation(name)\
  local nl = memory.locations[name]\
  if nl then\
    return TL2.goto(nl.x, nl.y, nl.z, nl.heading)\
  end\
end\
\
function TL2.getStoredPoint(name)\
  return Util.readTable(name .. '.pt')\
end\
\
function TL2.gotoStoredPoint(name)\
  local pt = TL2.getStoredPoint(name)\
  if pt then\
    return TL2.gotoPoint(pt)\
  end\
end\
\
function TL2.storePoint(name, pt)\
  Util.writeTable(name .. '.pt', pt)\
end\
\
function TL2.storeCurrentPoint(name)\
  local ray = TL2.getPoint()\
  TL2.storePoint(name, ray)\
end\
\
function TL2.saveNamedLocation(name, x, y, z, heading)\
  if x then\
    memory.locations[name] = {\
      x = x,\
      y = y,\
      z = z,\
      heading = heading\
    }\
  else\
    memory.locations[name] = {\
      x = state.x,\
      y = state.y,\
      z = state.z,\
      heading = state.heading\
    }\
  end\
end\
\
function TL2.normalizeCoords(x, y, z, heading)\
  return\
      x - state.gxOff,\
      y - state.gyOff,\
      z - state.gzOff,\
      heading\
end\
\
function TL2.gotoLocation(nloc)\
  if nloc.gps then\
    return TL2.goto(\
      nloc.x - state.gxOff,\
      nloc.y - state.gyOff,\
      nloc.z - state.gzOff,\
      nloc.heading)\
  else\
    return TL2.goto(nloc.x, nloc.y, nloc.z, nloc.heading)\
  end\
end\
\
function TL2.turnRight()\
  TL2.setHeading(state.heading + 1)\
end\
\
function TL2.turnLeft()\
  TL2.setHeading(state.heading - 1)\
end\
\
function TL2.turnAround()\
  TL2.setHeading(state.heading + 2)\
end\
\
function TL2.getHeadingInfo(heading)\
  heading = heading or state.heading\
  return TL2.headings[heading]\
end\
\
function TL2.setNamedHeading(headingName)\
  local heading = TL2.namedHeadings[headingName]\
  if heading then \
    TL2.setHeading(heading)\
  end\
  return false\
end\
\
function TL2.getHeading()\
  return state.heading\
end\
\
function TL2.setHeading(heading)\
  if heading ~= state.heading then\
    while heading < state.heading do\
      heading = heading + 4\
    end\
    if heading - state.heading == 3 then\
      turtle.turnLeft()\
      state.heading = state.heading - 1\
    else\
      turns = heading - state.heading\
      while turns > 0 do\
        turns = turns - 1\
        state.heading = state.heading + 1\
        turtle.turnRight()\
      end\
    end\
\
    if state.heading > 3 then\
      state.heading = state.heading - 4\
    elseif state.heading < 0 then\
      state.heading = state.heading + 4\
    end\
  end\
end\
\
function TL2.gotoPoint(pt)\
  return TL2.goto(pt.x, pt.y, pt.z, pt.heading)\
end\
\
function TL2.goto(ix, iy, iz, iheading)\
\
  if TL2.gotoEx(ix, iy, iz, iheading) then\
    return true\
  end\
\
  local moved\
  repeat\
    local x, y, z = state.x, state.y, state.z\
\
    -- try going the other way\
    if (state.heading % 2) == 1 then\
      TL2.headTowardsX(ix)\
    else\
      TL2.headTowardsY(iy)\
    end\
\
    if TL2.gotoEx(ix, iy, iz, iheading) then\
      return true\
    end\
\
    if iz then\
      TL2.gotoZ(iz)\
    end\
\
    moved = x ~= state.x or y ~= state.y or z ~= state.z\
  until not moved\
\
  return false\
end\
\
-- z and heading are optional\
function TL2.gotoEx(ix, iy, iz, iheading)\
\
  -- determine the heading to ensure the least amount of turns\
  -- first check is 1 turn needed - remaining require 2 turns\
  if state.heading == 0 and state.x <= ix or \
     state.heading == 2 and state.x >= ix or \
     state.heading == 1 and state.y <= iy or \
     state.heading == 3 and state.y >= iy then \
    -- maintain current heading\
    -- nop\
  elseif iy > state.y and state.heading == 0 or \
         iy < state.y and state.heading == 2 or\
         ix < state.x and state.heading == 1 or\
         ix > state.x and state.heading == 3 then\
    TL2.turnRight()\
  else\
    TL2.turnLeft()\
  end\
\
  if (state.heading % 2) == 1 then\
    if not TL2.gotoY(iy) then return false end\
    if not TL2.gotoX(ix) then return false end\
  else\
    if not TL2.gotoX(ix) then return false end\
    if not TL2.gotoY(iy) then return false end\
  end\
\
  if iz then\
    if not TL2.gotoZ(iz) then return false end\
  end\
\
  if iheading then\
    TL2.setHeading(iheading)\
  end\
  return true\
end\
\
function TL2.headTowardsX(ix)\
  if state.x ~= ix then\
    if state.x > ix then\
      TL2.setHeading(2)\
    else\
      TL2.setHeading(0)\
    end\
  end\
end\
\
function TL2.headTowardsY(iy)\
  if state.y ~= iy then\
    if state.y > iy then\
      TL2.setHeading(3)\
    else\
      TL2.setHeading(1)\
    end\
  end\
end\
\
function TL2.headTowards(pt)\
  if state.x ~= pt.x then\
    TL2.headTowardsX(pt.x)\
  else\
    TL2.headTowardsY(pt.y)\
  end\
end\
\
function TL2.gotoX(ix)\
  TL2.headTowardsX(ix)\
\
  while state.x ~= ix do\
    if not TL2.forward() then\
      return false\
    end\
  end\
  return true\
end\
\
function TL2.gotoY(iy)\
  TL2.headTowardsY(iy)\
\
  while state.y ~= iy do\
    if not TL2.forward() then\
      return false\
    end\
  end\
  return true\
end\
\
function TL2.gotoZ(iz)\
  while state.z > iz do\
    if not TL2.down() then\
      return false\
    end\
  end\
  \
  while state.z < iz do\
    if not TL2.up() then\
      return false\
    end\
  end\
  return true\
end\
\
function TL2.emptySlots(dropAction)\
  dropAction = dropAction or turtle.drop\
  for i = 1, 16 do\
    TL2.emptySlot(i, dropAction)\
  end\
end\
\
function TL2.emptySlot(slot, dropAction)\
  dropAction = dropAction or turtle.drop\
  local count = turtle.getItemCount(slot)\
  if count > 0 then\
    TL2.select(slot)\
    dropAction(count)\
  end\
end\
\
function TL2.getSlots(slots)\
  slots = slots or { }\
  for i = 1, 16 do\
    slots[i] = { qty = turtle.getItemCount(i) }\
    slots[i].slotNo = i\
  end\
  return slots\
end\
\
function TL2.getFilledSlots(startSlot)\
  startSlot = startSlot or 1\
\
  local slots = { }\
  for i = startSlot, 16 do\
    local count = turtle.getItemCount(i)\
    if count > 0 then\
      slots[i] = {\
        qty    = turtle.getItemCount(i),\
        slotNo = i\
      }\
    end\
  end\
  return slots\
end\
\
-- deprecated\
function TL2.getInventory()\
  return TL2.getSlots()\
end\
\
function TL2.reconcileInventory(slots, dropAction)\
  dropAction = dropAction or turtle.drop\
  for i = 1, 16 do\
    local qty = turtle.getItemCount(i)\
    if qty > slots[i].qty then\
      TL2.select(i)\
      dropAction(qty-slots[i].qty)\
    end\
  end\
end\
\
function TL2.selectSlotWithItems(startSlot)\
  startSlot = startSlot or 1\
  for i = startSlot, 16 do\
    if turtle.getItemCount(i) > 0 then\
      TL2.select(i)\
      return i\
    end\
  end\
end\
\
function TL2.selectOpenSlot(startSlot)\
  return TL2.selectSlotWithQuantity(0, startSlot)\
end\
\
function TL2.selectSlotWithQuantity(qty, startSlot)\
  startSlot = startSlot or 1\
\
  for i = startSlot, 16 do\
    if turtle.getItemCount(i) == qty then\
      TL2.select(i)\
      return i\
    end\
  end\
end\
\
function TL2.getPoint()\
  return { x = state.x, y = state.y, z = state.z, heading = state.heading }\
end\
\
function TL2.setPoint(pt)\
  state.x = pt.x\
  state.y = pt.y\
  state.z = pt.z\
  if pt.heading then\
    state.heading = pt.heading\
  end\
end\
\
_G.GPS = { }\
function GPS.locate()\
  local pt = { }\
  pt.x, pt.z, pt.y = gps.locate(10)\
  if pt.x then\
    return pt\
  end\
end\
\
function GPS.isAvailable()\
  return Util.hasDevice(\"modem\") and GPS.locate()\
end\
\
function GPS.initialize()\
  --[[\
    TL2.getState().gps = GPS.getPoint()\
  --]]\
end\
\
function GPS.gotoPoint(pt)\
  --[[\
    local heading\
    if pt.heading then\
      heading = (pt.heading + state.gps.heading) % 4\
    end\
    return TL2.goto(\
      pt.x - state.gps.x,\
      pt.y - state.gps.y,\
      pt.z - state.gps.z,\
      heading)\
  --]]\
end\
\
function GPS.getPoint()\
  local ray = TL2.getPoint()\
 \
  local apt = GPS.locate()\
  if not apt then\
    error(\"GPS.getPoint: GPS not available\")\
  end\
\
  while not TL2.forward() do\
    TL2.turnRight()\
    if TL2.getHeading() == ray.heading then\
      error('GPS.getPoint: Unable to move forward')\
    end\
  end\
\
  local bpt = GPS.locate()\
  if not apt then\
    error(\"No GPS\")\
  end\
\
  if not TL2.back() then\
    error(\"GPS.getPoint: Unable to move back\")\
  end\
\
  if apt.x < bpt.x then\
    apt.heading = 0\
  elseif apt.y < bpt.y then\
    apt.heading = 1\
  elseif apt.x > bpt.x then\
    apt.heading = 2\
  else\
    apt.heading = 3\
  end\
\
  return apt\
end\
\
function GPS.storeCurrentPoint(name)\
  local ray = GPS.getPoint()\
  TL2.storePoint(name, ray)\
end\
  \
--[[\
  All pathfinding related follows\
\
  b = block\
  a = adjacent block\
  bb = bounding box\
  c = coordinates\
--]]\
local function addAdjacentBlock(blocks, b, dir, bb, a)\
  local key = a.x .. ':' .. a.y .. ':' .. a.z\
\
  if b.adj[dir] then\
    a = b.adj[dir]\
  else\
    local _a = blocks[key]\
    if _a then\
      a = _a\
    else\
      blocks[key] = a\
    end\
  end\
  local revDir = { 2, 3, 0, 1, 5, 4 }\
  b.adj[dir] = a\
  a.adj[revDir[dir+1]] = b\
--[[\
  -- too much time...\
  if dir == 4 and turtle.detectUp() then\
    a.blocked = true\
  elseif dir == 5 and turtle.detectDown() then\
    a.blocked = true\
  elseif dir == state.heading and turtle.detect() then\
    a.blocked = true\
--]]\
  if a.x < bb.ax or a.x > bb.bx or\
         a.y < bb.ay or a.y > bb.by or\
         a.z < bb.az or a.z > bb.bz then\
    a.blocked = true\
  end\
end\
\
local function addAdjacentBlocks(blocks, b, bb)\
  if not b.setAdj then\
    addAdjacentBlock(blocks, b, 0, bb,\
      { x = state.x+1, y = state.y  , z = state.z    , adj = {} })\
    addAdjacentBlock(blocks, b, 1, bb,\
      { x = state.x  , y = state.y+1, z = state.z    , adj = {} })\
    addAdjacentBlock(blocks, b, 2, bb,\
      { x = state.x-1, y = state.y  , z = state.z    , adj = {} })\
    addAdjacentBlock(blocks, b, 3, bb,\
      { x = state.x  , y = state.y-1, z = state.z    , adj = {} })\
    addAdjacentBlock(blocks, b, 4, bb,\
      { x = state.x  , y = state.y  , z = state.z + 1, adj = {} })\
    addAdjacentBlock(blocks, b, 5, bb,\
      { x = state.x  , y = state.y  , z = state.z - 1, adj = {} })\
  end\
  b.setAdj = true\
end\
\
local function getMovesTo(x, y, z)\
  local dest = { x = x, y = y, z = z }\
  return calculateMoves(state, dest, state.heading)\
end\
\
local function calculateMoves(p, dest, heading)\
  local d = calculateDistance(p, dest)\
print('bh: ' .. state.heading .. ' h: ' .. heading)\
  if state.heading ~= heading then\
    -- calculate the turns from current point to new point\
    d = d + calculateTurns(state.heading, heading)\
  end\
  local newHeading = calculateHeadingTowards(p, dest, heading)    \
  d = d + calculateTurns(heading, newHeading)\
print(pp(p))\
print(pp(dest))\
print(string.format('h:%d t:%d t2:%d d:%d nh:%d',\
  heading, calculateTurns(state.heading, heading),\
  calculateTurns(heading, newHeading), d, newHeading))\
  return d\
end\
\
local function calculateAdjacentBlockDistances(b, dest)\
  for k,a in pairs(b.adj) do\
    if not a.blocked then\
      --a.distance = calculateMoves(a, dest, k)\
      a.distance = TL2.calculateDistance(a, dest)\
    else\
      a.distance = 9000\
    end\
--print(string.format('%d: %f %d,%d,%d, %s', k, a.distance, a.x, a.y, a.z, tostring(a.blocked)))\
--read()\
  end\
 --  read()\
end\
\
local function blockedIn(b)\
  for _,a in pairs(b.adj) do\
    if not a.blocked then\
      return false\
    end\
  end\
  return true\
end\
\
local function pathfindMove(b)\
  for _,a in Util.spairs(b.adj, function(a, b) return a.distance < b.distance end) do\
\
    --print('shortest: ' .. pc(a) .. ' distance: ' .. a.distance)\
    if not a.blocked then\
      local success = TL2.moveTowardsPoint(a)\
      if success then\
        return a\
      end\
      a.blocked = true\
    end\
  end\
end\
\
local function rpath(blocks, block, dest, boundingBox)\
  \
  addAdjacentBlocks(blocks, block, boundingBox)\
  calculateAdjacentBlockDistances(block, dest)\
\
  block.blocked = true\
  repeat\
    local newBlock = pathfindMove(block)\
    if newBlock then\
      if state.x == dest.x and state.y == dest.y and state.z == dest.z then\
        block.blocked = false\
        return true\
      end\
      --[[\
      if goto then return true end\
      block = getCurrentBlock() (gets or creates block)\
      but this might - will - move us into a block we marked as blockedin\
      if block.blocked then\
        goto newBlock\
        block = getCurrentBlock() (gets or creates block)\
      end\
      maybe check if we have a clear line of sight to the destination\
      ie. keep traveling towards destination building up blocked blocks\
      as we encounter them (instead of adding all blocks on the path)\
      --]]\
      if rpath(blocks, newBlock, dest, boundingBox) then\
        block.blocked = false\
        return true\
      end\
      if not TL2.moveTowardsPoint(block) then\
        return false\
      end\
    end\
  until blockedIn(block)\
  return false\
end\
\
--[[\
  goto will traverse towards the destination until it is blocked\
  by something on the x, y, or z coordinate of the destination\
\
  pathfinding will attempt to find a way around the blockage\
\
  goto example:\
  . . >-X B D stuck behind block\
  . . | . B .\
  . . | . . .\
  S >-^B. . .\
\
  pathfind example:\
  . . >-v B D when goto fails, pathfinding kicks in\
  . . | |-B-|\
  . . | >---^\
  S >-^B. . .\
\
--]]\
function TL2.pathtofreely(ix, iy, iz, iheading)\
  local boundingBox = {\
      ax = -9000,\
      ay = -9000,\
      az = -9000,\
      bx = 9000,\
      by = 9000,\
      bz = 9000\
    }\
  return TL2.pathto(ix, iy, iz, iheading, boundingBox)\
end\
\
local function pathfind(ix, iy, iz, iheading, boundingBox)\
\
  local blocks = { } -- memory.blocks\
  local dest = { x = ix, y = iy, z = iz }\
  local block = { x = state.x, y = state.y, z = state.z, adj = {} }\
  local key = block.x .. ':' .. block.y .. ':' .. block.z\
\
  blocks[key] = block\
\
  if rpath(blocks, block, dest, boundingBox) then\
    if iheading then\
      TL2.setHeading(iheading)\
    end\
    return true\
  end\
\
  return false\
end\
\
function TL2.pathto(ix, iy, iz, iheading, boundingBox)\
  local start = { x = state.x, y = state.y, z = state.z }\
  if TL2.goto(ix, iy, iz, iheading) then\
    return true\
  end\
\
  if not iz then\
    iz = state.z\
  end\
\
  if not boundingBox then\
    boundingBox = {\
      ax = math.min(ix, start.x),\
      ay = math.min(iy, start.y),\
      az = math.min(iz, start.z),\
      bx = math.max(ix, start.x),\
      by = math.max(iy, start.y),\
      bz = math.max(iz, start.z),\
    }\
  end\
  return pathfind(ix, iy, iz, iheading, boundingBox)\
end\
\
function TL2.moveTowardsPoint(c)\
\
  if c.z > state.z then\
    return TL2.up()\
  elseif c.z < state.z then\
    return TL2.down()\
  end\
  TL2.headTowards(c)\
  return TL2.forward()\
end\
\
--Import \
--[[\
  turtle action chains and communications\
--]]\
_G.TLC = { }\
local __requestor\
\
local registeredActions = {\
  goto = function(args)\
    if args.mode then\
      TL2.setMode(args.mode)\
    end\
    if args.digStrategy then\
      TL2.setDigStrategy(args.digStrategy)\
    end\
    return TL2.pathto(args.x, args.y, args.z, args.heading)\
  end,\
\
  gotoZ = function(args)\
    if args.mode then\
      TL2.setMode(args.mode)\
    end\
    if args.digStrategy then\
      TL2.setDigStrategy(args.digStrategy)\
    end\
    return TL2.gotoZ(args.z)\
  end,\
\
  move = function(args)\
    local result = false\
    if args.mode then\
      TL2.setMode(args.mode)\
    end\
    if args.digStrategy then\
      TL2.setDigStrategy(args.digStrategy)\
    end\
    for i = 1, args.moves do\
      if args.subaction == \"u\" then\
        result = TL2.up()\
      elseif args.subaction == \"d\" then\
        result = TL2.down()\
      elseif args.subaction == \"f\" then\
        result = TL2.forward()\
      elseif args.subaction == \"r\" then\
        result = TL2.turnRight()\
      elseif args.subaction == \"l\" then\
        result = TL2.turnLeft()\
      elseif args.subaction == \"b\" then\
        result = TL2.back()\
      end \
      if not result then\
        return false\
      end\
    end \
    return result\
  end,\
\
--[[\
  pushState = function(action)\
    TL2.getState().saveLoc = TL2.saveLocation()\
    TL2.getState().saveLoc.dig = TL2.loc.dig\
    TL2.getState().saveLoc.mode = TL2.loc.mode\
  end,\
\
  popState = function(action)\
    local saveLoc = TL2.getState().saveLoc\
    TL2.gotoLocation(saveLoc)\
    TL2.loc.dig = saveLoc.dig\
    TL2.loc.mode = saveLoc.mode\
  end,\
--]]\
\
  reset = function(args)\
    TL2.getState().x = 0\
    TL2.getState().y = 0\
    TL2.getState().z = 0\
    return true\
  end,\
\
  shutdown = function(args)\
    os.shutdown()\
    -- for consistency :)\
    return true\
  end,\
\
  reboot = function(args)\
    os.reboot()\
    return true\
  end,\
\
  gotoNamedLocation = function(args)\
    return TL2.gotoNamedLocation(args.name)\
  end,\
\
  adjustLocation = function(args)\
    if args.x then\
      TL2.getState().x = TL2.getState().x + args.x\
    end\
    if args.y then\
      TL2.getState().y = TL2.getState().y + args.y\
    end\
    if args.z then\
      TL2.getState().z = TL2.getState().z + args.z\
    end\
    return true\
  end,\
\
  setLocation = function(args)\
    TL2.getState().x = args.x\
    TL2.getState().y = args.y\
    TL2.getState().z = args.z\
    if args.heading then\
      TL2.getState().heading = args.heading\
    end\
    return true\
  end,\
\
  status = function(args, action)\
    TLC.sendStatus(action.requestor)\
    return true\
  end\
}\
\
function TLC.sendStatus(requestor)\
  local state = TL2.getState()\
\
  state.name = os.getComputerLabel()\
  state.fuel = turtle.getFuelLevel()\
  TL2.getMemory().lastStatus = os.clock()\
\
  requestor = requestor or __requestor\
  Logger.log('turtle', '>> Status to ' .. tostring(requestor) .. ' of ' .. state.status)\
  if requestor then\
    Message.send(requestor, 'turtleStatus', state)\
  elseif not __requestor then\
    Message.broadcast('turtleStatus', state)\
  end\
end\
\
function TLC.registerAction(action, f)\
  registeredActions[action] = f\
end\
\
function TLC.performActions(actions)\
\
  local function performSingleAction(action)\
    local actionName = action.action\
    local actionFunction = registeredActions[actionName]\
\
    if not actionFunction then\
      Logger.log('turtle', 'Unknown turtle action: ' .. tostring(actionName))\
      Logger.log('turtle', action)\
      error('Unknown turtle action: ' .. tostring(actionName))\
    end\
    -- perform action\
    Logger.log('turtle', '<< Action: ' .. actionName)\
\
    if actionName == 'status' then\
      return actionFunction(action.args, action)\
    end\
\
    local state = TL2.getState()\
    local previousStatus = state.status\
    state.status = 'busy'\
    result = actionFunction(action.args, action)\
    state.status = 'idle'\
    return result\
  end\
\
  local chain = {}\
\
  local chainStart = TL2.getMemory().chainStart\
  if chainStart then\
    table.insert(chain, { action = chainStart })\
  end\
\
  for _,action in ipairs(actions) do\
    table.insert(chain, action)\
  end\
\
  local chainEnd = TL2.getMemory().chainEnd\
  if chainEnd then\
    table.insert(chain, { action = chainEnd })\
  end\
\
  for _,action in ipairs(chain) do\
    if not action.result then\
      action.result = performSingleAction(action)\
      if not action.result then\
        Logger.log('turtle', action)\
        Logger.log('turtle', '**Action failed')\
        if not action.retryCount then\
          action.retryCount = 1\
        else\
          action.retryCount = action.retryCount + 1\
        end\
        if action.retryCount < 3 then\
          -- queue action chain for another attempt\
          TL2.getState().status = 'busy'\
          os.queueEvent('turtleActions', actions)\
        end\
        return false\
      end\
    end\
  end\
  return true\
end\
\
function TLC.performAction(actionName, actionArgs)\
  return TLC.performActions({{ action = actionName, args = actionArgs }})\
end\
\
function TLC.actionChainStart(chainStart)\
  TL2.getMemory().chainStart = chainStart\
end\
\
function TLC.actionChainEnd(chainEnd)\
  TL2.getMemory().chainEnd = chainEnd\
end\
\
function TLC.sendAction(id, actionName, actionArgs)\
  local action = {\
    action = actionName,\
    args = actionArgs\
  }\
  Logger.log('turtle', '>>Sending to ' .. tostring(id) .. ' ' .. actionName)\
  Message.send(id, 'turtle', { action })\
end\
\
function TLC.sendActions(id, actions)\
  local str = ''\
  for _,v in pairs(actions) do\
    str = str .. ' ' .. v.action\
  end\
  Logger.log('turtle', '>>Sending to ' .. id .. str)\
  Message.send(id, 'turtle', actions)\
end\
\
function TLC.requestState(id)\
  Logger.log('turtle', '>>Requesting state from ' .. id)\
  Message.send(id, 'turtleState')\
end\
\
function TLC.setRole(role)\
  TL2.getState().role = role\
end\
\
--[[\
  The following method should only be executed once\
  a different strategy should be implemented to allow\
  this to be called multiple times\
--]]\
function TLC.pullEvents(role, hasaheart)\
  \
  TL2.getState().status = 'idle'\
  TL2.getState().role = role\
  TL2.getMemory().lastStatus = os.clock()\
\
  local function heartbeat()\
    while true do\
      os.sleep(5)\
      os.queueEvent('heartbeat')\
    end \
  end\
\
  Message.addHandler('turtleState',\
    function(h, id)\
__requestor = id\
      TLC.sendStatus(id)\
    end\
  )\
\
  Message.addHandler('turtle', \
    function(h, id, msg, distance)\
\
      local actions = msg.contents\
      for _,action in ipairs(actions) do\
        action.distance = distance\
        action.requestor = id\
      end\
      TLC.performActions(actions)\
    end\
  )\
\
  Event.addHandler('turtleActions',\
    function(h, actions)\
  TL2.getMemory().lastStatus = os.clock()\
      TLC.performActions(actions)\
    end\
  )\
\
  Message.addHandler('alive',\
    function(e, id, msg)\
      if TL2.getState().status ~= 'busy' then\
__requestor = id\
  TL2.getMemory().lastStatus = os.clock()\
        msg.type = \"isAlive\"\
        msg.contents = os.getComputerLabel()\
        rednet.send(id, msg)\
      end\
    end\
  )\
\
  if hasaheart then\
    Event.addHandler('heartbeat',\
      function()\
        local state = TL2.getState()\
        if state.status == 'idle' and\
           os.clock() > TL2.getMemory().lastStatus + 5 then\
          TLC.sendStatus()\
        end\
      end\
    )\
  end\
\
  parallel.waitForAny(Event.pullEvents, heartbeat)\
end\
\
--[[\
  all the following code does not belong in this file\
  should be located in it's own class file or moved\
--]]\
function TLC.condence(slot)\
  local iQty = turtle.getItemCount(slot)\
  for i = 1, 16 do\
    if i ~= slot then\
      local qty = turtle.getItemCount(i)\
      if qty > 0 then\
        turtle.select(i)\
        if turtle.compareTo(slot) then\
          turtle.transferTo(slot, qty)\
          iQty = iQty + qty\
          if iQty >= 64 then\
            break\
          end\
        end\
      end\
    end\
  end\
end\
\
-- from stock gps API\
local function trilaterate( A, B, C ) \
  local a2b = B.position - A.position\
  local a2c = C.position - A.position\
\
  if math.abs( a2b:normalize():dot( a2c:normalize() ) ) > 0.999 then\
    return nil \
  end \
\
  local d = a2b:length()\
  local ex = a2b:normalize( )\
  local i = ex:dot( a2c )\
  local ey = (a2c - (ex * i)):normalize()\
  local j = ey:dot( a2c )\
  local ez = ex:cross( ey )\
\
  local r1 = A.distance\
  local r2 = B.distance\
  local r3 = C.distance\
\
  local x = (r1*r1 - r2*r2 + d*d) / (2*d)\
  local y = (r1*r1 - r3*r3 - x*x + (x-i)*(x-i) + j*j) / (2*j)\
 \
  local result = A.position + (ex * x) + (ey * y)\
\
  local zSquared = r1*r1 - x*x - y*y \
  if zSquared > 0 then\
    local z = math.sqrt( zSquared )\
    local result1 = result + (ez * z)\
    local result2 = result - (ez * z)\
    \
    local rounded1, rounded2 = result1:round(), result2:round()\
    if rounded1.x ~= rounded2.x or rounded1.y ~= rounded2.y or rounded1.z ~= rounded2.z then\
      return rounded1, rounded2\
    else\
      return rounded1\
    end \
  end \
  return result:round()\
end\
\
local function narrow( p1, p2, fix )\
  local dist1 = math.abs( (p1 - fix.position):length() - fix.distance )\
  local dist2 = math.abs( (p2 - fix.position):length() - fix.distance )\
\
  if math.abs(dist1 - dist2) < 0.05 then\
    return p1, p2\
  elseif dist1 < dist2 then\
    return p1:round()\
  else\
    return p2:round()\
  end \
end\
\
-- end stock gps api\
\
TLC.tFixes = {}\
\
Message.addHandler('position', function(h, id, msg, distance)\
  local tFix = {\
    position = vector.new(msg.contents.x, msg.contents.z, msg.contents.y),\
    distance = distance\
  }\
  table.insert(TLC.tFixes, tFix)\
\
  if #TLC.tFixes == 4 then\
    Logger.log('turtle', 'trilaterating')\
    local pos1, pos2 = trilaterate(TLC.tFixes[1], TLC.tFixes[2], TLC.tFixes[3])\
    pos1, pos2 = narrow(pos1, pos2, TLC.tFixes[3])\
    if pos2 then\
      pos1, pos2 = narrow(pos1, pos2, TLC.tFixes[4])\
    end\
\
    if pos1 and pos2 then\
      print(\"Ambiguous position\")\
      print(\"Could be \"..pos1.x..\",\"..pos1.y..\",\"..pos1.z..\" or \"..pos2.x..\",\"..pos2.y..\",\"..pos2.z )\
    elseif pos1 then\
      Logger.log('turtle', \"Position is \"..pos1.x..\",\"..pos1.y..\",\"..pos1.z)\
      TLC.performAction('setLocation', {\
        x = pos1.x,\
        y = pos1.z,\
        z = pos1.y\
      })\
    else\
      print(\"Could not determine position\")\
    end\
  end\
end)\
\
function TLC.getDistance(id)\
  for i = 1, 10 do\
    rednet.send(id, { type = 'alive' })\
    local _, _, _, distance = Message.waitForMessage('isAlive', 1, id)\
    if distance then\
      Logger.log('turtle', 'distance: ' .. distance)\
      return distance\
    end\
  end\
end\
\
local function locate(id, d1, boundingBox)\
\
  local function checkBB(boundingBox)\
    if boundingBox then\
      local heading = TL2.headings[TL2.getState().heading]\
      local x = TL2.getState().x + heading.xd\
      local y = TL2.getState().y + heading.yd\
      if x < boundingBox.ax or x > boundingBox.bx or\
         y < boundingBox.ay or y > boundingBox.by then\
        return true\
      end\
    end\
    return false\
  end\
\
  if checkBB(boundingBox) then\
    TL2.turnAround()\
  end\
\
  TL2.forward()\
\
  local d2 = TLC.getDistance(id)\
  if not d2 then return end\
  if d2 == 1 then return d2 end\
\
  if d2 > d1 then\
    TL2.turnAround()\
  end\
\
  d1 = d2\
\
  while true do\
    if checkBB(boundingBox) then\
      break\
    end\
    TL2.forward()\
\
    d2 = TLC.getDistance(id)\
    if not d2 then return end\
    if d2 == 1 then return d2 end\
\
    if d2 > d1 then\
      TL2.back()\
      return d1\
    end\
    d1 = d2\
  end\
  return d2\
end\
\
function TLC.tracker(id, d1, nozcheck, boundingBox)\
\
  d1 = locate(id, d1, boundingBox)\
  if not d1 then return end\
\
  TL2.turnRight()\
\
  d1 = locate(id, d1, boundingBox)\
  if not d1 then return end\
\
  if math.floor(d1) == d1 then\
    local z = d1\
\
    if not nozcheck then\
      TL2.up()\
\
      d2 = TLC.getDistance(id)\
      if not d2 then return end\
\
      TL2.down()\
\
      z = TL2.getState().z + math.floor(d1)\
      if d1 < d2 then\
        z = TL2.getState().z - math.floor(d1)\
      end\
    end\
\
    return { x = TL2.getState().x, y = TL2.getState().y, z = z }\
  end\
end\
\
end\
",},[5]={["name"]="miningStatus.lua",["contents"]="os.loadAPI('apis.lua')\
\
Peripheral.wrap('wireless_modem')\
\
local bossId\
local state\
local status\
\
Logger.disable()\
\
local terminal = UI.term\
\
if Peripheral.isPresent('openperipheral_glassesbridge') then\
  terminal = UI.Glasses({\
    --height = 30,\
    --width = 40,\
    textScale = .5,\
  })\
elseif Peripheral.isPresent('monitor') then\
  terminal = UI.Device({\
    deviceType = 'monitor',\
    textScale = .5\
  })\
end\
\
local window = UI.Window({ parent = terminal })\
window:clear()\
\
statusPage = UI.Page({\
  parent = window,\
  titleBar = UI.TitleBar({\
    title = 'Mining Status'\
  }),\
  statusInfo = UI.Window({\
    totalHolesProgressBar = UI.ProgressBar({\
      y = 7,\
      x = 2,\
      width = window.width - 2\
    }),\
    chunkHolesProgressBar = UI.ProgressBar({\
      y = 10,\
      x = 2,\
      width = window.width - 2\
    }),\
  }),\
  statusBar = UI.StatusBar({\
    backgroundColor = colors.blue\
  })\
})\
\
--statusPage.titleBar:draw()\
\
if terminal.height > 17 then\
  statusPage:add({\
    logTitleBar = UI.TitleBar({\
      title = 'Log Messages',\
      y = 13\
    }),\
    scrollingText = UI.ScrollingText({\
      backgroundColor = colors.green,\
      y = 14,\
      height = terminal.height - 13\
    })\
  })\
\
  Message.addHandler('log', function(h, id, msg)\
    if bossId and id == bossId then\
      statusPage.scrollingText:write(os.clock() .. ' ' .. msg.contents)\
    end\
  end)\
\
  Message.addHandler('logClient', function(h, id)\
    Message.send(id, 'logServer')\
  end)\
end\
\
function statusPage.statusBar:draw()\
  if state then\
    self:setValue('status', state.status)\
  end\
  UI.StatusBar.draw(self)\
end\
\
function statusPage.statusInfo:draw()\
  if not state or not status then\
    return\
  end\
  if state.chunks ~= -1 then\
    local totalHoles = state.chunks * 52 -- roughly\
    local percentDone = state.holes * 100 / totalHoles\
    self.totalHolesProgressBar:setProgress(percentDone)\
    self:centeredWrite(8, string.format('Total: %d of ~%d holes (%d%%)',\
      state.holes, totalHoles, percentDone))\
  else\
    self:centeredWrite(8, string.format('Total holes: %d', state.holes))\
    self.totalHolesProgressBar:setProgress(Util.random(100))\
  end\
\
  local currentChunk = math.pow(state.diameter-2, 2) + state.chunkIndex + 1\
  if state.diameter == 1 then\
    currentChunk = 1\
  end\
  if state.chunks == -1 then\
    self:write(2, 3, string.format('Chunk   %d', currentChunk))\
  else\
    self:write(2, 3, string.format('Chunk   %d of %d', currentChunk, state.chunks))\
  end\
  self:write(2, 4, string.format('Miners  %d', status.count))\
\
  if state.depth ~= 9000 then\
    self:write(2, 5, string.format('Depth   %d', state.depth))\
  end\
\
  local totalHoles = 52 -- roughly\
  local holesRemaining = #state.locations\
  if holesRemaining > totalHoles then\
    totalHoles = holesRemaining\
  end\
  local percentDone = 100 - (holesRemaining * 100 / totalHoles)\
  self.chunkHolesProgressBar:setProgress(percentDone)\
  self:centeredWrite(11, string.format('Current Chunk: %d%%', percentDone))\
\
  self.chunkHolesProgressBar:draw()\
  self.totalHolesProgressBar:draw()\
end\
\
Message.addHandler('miningStatus', function(h, id, msg)\
  bossId = id\
  state = msg.contents.state\
  status = msg.contents.status\
  statusPage.statusInfo:draw()\
  statusPage.statusBar:draw()\
end)\
\
Event.addHandler('heartbeat', function()\
  Message.send(bossId, 'getMiningStatus')\
end)\
\
Event.addHandler('char', function()\
  Event.exitPullEvents()\
end)\
\
statusPage:draw()\
Message.broadcast('getMiningStatus')\
\
Event.heartbeat(5)\
\
window:clear()\
",},[6]={["name"]="tracker",["contents"]="os.loadAPI('apis.lua')\
\
Peripheral.wrap('wireless_modem')\
\
TL2.setMode('destructive')\
TL2.setDigStrategy('cautious')\
\
local boundingBox = {\
  ax = -64,\
  ay = -64,\
  bx = 256,\
  by = 64 \
}\
\
function locateTurtle()\
  local info = Util.tryTimes(1, function()\
    Message.broadcast('alive')\
     _,id,_,distance = Message.waitForMessage('isAlive', 3)\
    if id and distance then\
      return { id = id, distance = distance }\
    end\
  end)\
\
  if not info then\
    print('Nothing found')\
    return\
  end\
  print('Turtle distance: ' .. info.distance)\
\
  local pt = TLC.tracker(info.id, info.distance) --, false, boundingBox)\
  if pt then\
    -- miners start out 1 below boss plane\
    TL2.back()\
    TLC.sendActions(info.id, {\
      { action = 'setLocation', args = pt },\
      { action = 'gotoZ', args = {\
          z = 0,\
          digStrategy = 'cautious',\
          mode = 'destructive' }\
       }\
    })\
    print('Found turtle - calling to surface')\
    print('depth is ' .. pt.z)\
    Logger.debug('x: ' .. pt.x .. ' z: ' .. pt.y)\
    print('x: ' .. pt.x .. ' z: ' .. pt.y)\
    for i = 1, 8 do\
      TL2.turnRight()\
    end\
    return true\
  end\
end\
\
-- quick check to see if any are within current range\
Message.broadcast('alive')\
local _,id = Message.waitForMessage('isAlive', 3)\
\
if not id then\
  --TL2.gotoZ(120)\
  --TL2.gotoZ(TL2.getState().z - 4)\
end\
\
Message.enableWirelessLogging()\
\
i = 0\
repeat\
  TL2.goto(i*16, 0)\
  if locateTurtle() then\
    break\
  end\
  i = i + 1\
until i >= 6\
\
TL2.gotoZ(0)\
TL2.goto(0, 0, 0, 0)\
",},}

local directory = "swarm"
function setDirectory(directory)
  if not fs.exists(directory) then
    fs.makeDir(directory)
  end

  shell.setDir(directory)
end

function extractTableFile(ft, dir)
  --local file = io.open(dir .. '/' .. ft.name, "w")
  local file = io.open(ft.name, "w")
  if not file then
    error('failed to extract ', ft.name)
  end
  file:write(textutils.unserialize(ft.contents))
  file:close()
end

--print('Extracting files to : ' .. directory)

--setDirectory(directory)
for _,ft in pairs(fts) do
  print('extracting: ' .. ft.name)
  extractTableFile(ft, directory)
end

print('Extracted all files successfully')

shell.run(directory .. 'setup')
--shell.run('/' .. directory .. '/' .. directory .. 'setup')
--shell.setDir('/')
