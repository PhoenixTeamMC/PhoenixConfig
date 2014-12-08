#Dictionaries

#ComputerCraft
val computerBasic = <ComputerCraft:CC-Computer:0>;
val computerAdvanced = <ComputerCraft:CC-Computer:16384>;
val turtleBasic = <ComputerCraft:CC-Turtle>;
val turtleAdvanced = <ComputerCraft:CC-TurtleAdvanced>;
val tabletBasic =  <ComputerCraft:pocketComputer>;
val wirelessTabletBasic = <ComputerCraft:pocketComputer>.withTag({upgrade: 1});
val tabletAdvanced = <ComputerCraft:pocketComputer:1>;
val wirelessTabletAdvanced = <ComputerCraft:pocketComputer:1>.withTag({upgrade: 1});
val modemWired = <ComputerCraft:CC-Cable:1>;
val modemWireless = <ComputerCraft:CC-Peripheral:1>;
val monitorBasic = <ComputerCraft:CC-Peripheral:2>;
val monitorAdvanced = <ComputerCraft:CC-Peripheral:4>;
val networkCable = <ComputerCraft:CC-Cable>;
val diskDrive = <ComputerCraft:CC-Peripheral:0>;
val printer = <ComputerCraft:CC-Peripheral:3>;

##TE
#ingots
val ingotElectrum = <ThermalFoundation:material:71>;
val ingotInvar = <ThermalFoundation:material:72>;
val ingotSignalum = <ThermalFoundation:material:74>;
val ingotEnderium = <ThermalFoundation:material:76>;
val blockSignalum = <ThermalFoundation:Storage:10>;
#gears
val gearElectrum = <ThermalFoundation:material:135>;
val gearInvar = <ThermalFoundation:material:136>;
val gearSignalum = <ThermalFoundation:material:138>;
#Strongboxes
val strongboxHardened = <ThermalExpansion:Strongbox:2>;
val strongboxReinforced = <ThermalExpansion:Strongbox:3>;
#Capacitors
val capacitorHardened = <ThermalExpansion:capacitor:3>;
val capacitorRedstone = <ThermalExpansion:capacitor:4>;
val capacitorEnderium = <ThermalExpansion:capacitor:5>;
#Energy cells
val cellHardened = <ThermalExpansion:Cell:2>;
val cellRedstone = <ThermalExpansion:Cell:3>;
#etc
val cacheHardened = <ThermalExpansion:Cache:2>;
val tesseract = <ThermalExpansion:Tesseract>;

#Misc.
val MEInterface = <appliedenergistics2:tile.BlockInterface>;
val matrix = <ExtraUtilities:decorativeBlock1:12>;
val diamondTube = <Forestry:thermionicTubes:5>;
val PCB = <StevesCarts:ModuleComponents:16>;
val blockRedstone = <minecraft:redstone_block>;
val glass = <ore:blockGlass>;
val conduitBinder = <EnderIO:itemMaterial:1>;
val inkwell = <Thaumcraft:ItemInkwell>;

//-------------------------------
#Original recipes.
#recipes.addShaped(<ComputerCraft:CC-Computer:16384>, [[<minecraft:gold_ingot>, <appliedenergistics2:item.ItemMultiMaterial:23>, <minecraft:gold_ingot>], [<Forestry:chipsets:3>, <Forestry:thermionicTubes:5> ,<Forestry:chipsets:3>], [<minecraft:gold_ingot>, <ExtraUtilities:decorativeBlock2:4>, <minecraft:gold_ingot>]]);
#recipes.addShaped(<ComputerCraft:CC-Computer>, [[<minecraft:iron_ingot>, <appliedenergistics2:item.ItemMultiMaterial:23>, <minecraft:iron_ingot>], [<Forestry:chipsets>, <Forestry:thermionicTubes:5> ,<Forestry:chipsets:3>], [<minecraft:iron_ingot>, <minecraft:glass>, <minecraft:iron_ingot>]]);

#Basic computer
recipes.remove(computerBasic);
recipes.addShaped(computerBasic, [[ingotInvar, ingotInvar, ingotInvar], [monitorBasic, PCB, ingotInvar], [ingotInvar, cellHardened, ingotInvar]]);

#Advanced computer
recipes.remove(computerAdvanced);
recipes.addShaped(computerAdvanced, [[ingotElectrum, ingotElectrum, ingotElectrum], [monitorAdvanced, PCB, ingotElectrum], [ingotElectrum, cellRedstone, ingotElectrum]]);

#Basic turtle
recipes.remove(turtleBasic);
recipes.addShaped(turtleBasic, [[ingotInvar, ingotInvar, ingotInvar], [monitorBasic, matrix, strongboxHardened], [gearInvar, MEInterface, gearInvar]]);

#Advanced turtle
recipes.remove(turtleAdvanced);
recipes.addShaped(turtleAdvanced, [[ingotElectrum, ingotElectrum, ingotElectrum], [monitorAdvanced, matrix, strongboxReinforced], [gearElectrum, MEInterface, gearElectrum]]);

#Basic monitor
recipes.remove(monitorBasic);
recipes.addShaped(monitorBasic * 4, [[ingotInvar, ingotInvar, ingotInvar], [ingotInvar, glass, ingotInvar], [ingotInvar, ingotInvar, ingotInvar]]);

#Advanced monitor
recipes.remove(monitorAdvanced);
recipes.addShaped(monitorAdvanced * 4, [[ingotElectrum, ingotElectrum, ingotElectrum], [ingotElectrum, glass, ingotElectrum], [ingotElectrum, ingotElectrum, ingotElectrum]]);

#Wired modem
recipes.remove(modemWired);
recipes.addShaped(modemWired * 4, [[networkCable, networkCable, networkCable], [networkCable, computerBasic, networkCable], [networkCable, networkCable, networkCable]]);

#Network cables
recipes.remove(networkCable);
recipes.addShaped(networkCable * 16, [[conduitBinder, conduitBinder, conduitBinder], [ingotSignalum, ingotSignalum, ingotSignalum], [conduitBinder, conduitBinder, conduitBinder]]);

#Wireless modem
recipes.remove(modemWireless);
recipes.addShaped(modemWireless * 4, [[ingotEnderium, modemWired, ingotEnderium], [modemWired, blockSignalum, modemWired], [ingotEnderium, modemWired, ingotEnderium]]);

#Basic tablet
recipes.remove(tabletBasic);
recipes.addShaped(tabletBasic, [[ingotInvar, diamondTube, ingotInvar], [ingotInvar, monitorBasic, ingotInvar], [ingotInvar, capacitorHardened, ingotInvar]]);

#Advanced tablet
recipes.remove(tabletAdvanced);
recipes.addShaped(tabletAdvanced, [[ingotElectrum, diamondTube, ingotElectrum], [ingotElectrum, monitorAdvanced, ingotElectrum], [ingotElectrum, capacitorRedstone, ingotElectrum]]);

#Wireless tablet
recipes.addShaped(wirelessTabletBasic, [[gearSignalum, tesseract, gearSignalum], [ingotInvar, monitorBasic, ingotInvar], [ingotInvar, matrix, ingotInvar]]);

#Advanced wireless tablet
recipes.addShaped(wirelessTabletAdvanced, [[gearSignalum, tesseract, gearSignalum], [ingotElectrum, monitorAdvanced, ingotElectrum], [ingotElectrum, matrix, ingotElectrum]]);

#Disk drive
recipes.remove(diskDrive);
recipes.addShaped(diskDrive, [[ingotInvar, ingotInvar, ingotInvar], [ingotInvar, ingotSignalum, ingotInvar], [ingotInvar, cacheHardened, ingotInvar]]);

#Printer
recipes.remove(printer);
recipes.addShaped(printer, [[ingotInvar, ingotInvar, ingotInvar], [ingotInvar, gearSignalum, ingotInvar], [ingotInvar, inkwell, ingotInvar]]);
