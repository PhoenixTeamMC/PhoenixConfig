//Gendustry
val modulePower = <gendustry:PowerModule>;
val tankMutagen = <gendustry:MutagenTank>;
val moduleClimate = <gendustry:ClimateModule>;
val frameUpgrade = <gendustry:UpgradeFrame>;

//BuildCraft
val redstoneCompChipset = <BuildCraft|Silicon:redstoneChipset:6>;
val goldChipset = <BuildCraft|Silicon:redstoneChipset:2>;
val tank = <BuildCraft|Factory:tankBlock>;
val redstoneChipset = <BuildCraft|Silicon:redstoneChipset>;

//OreDict
val ingotBronze = <ore:ingotBronze>;
val ingotTin = <ore:ingotTin>;

//Minecraft
val redstone = <minecraft:redstone>;
val goldIngot = <minecraft:gold_ingot>;
val snowball = <minecraft:snowball>;
val powderBlaze = <minecraft:blaze_powder>;

//Recipes

recipes.remove(modulePower);
recipes.addShaped(modulePower, [[ingotBronze, goldIngot, ingotBronze], [ingotBronze, redstoneCompChipset, ingotBronze], [ingotBronze, goldIngot, ingotBronze]]);

recipes.remove(moduleClimate);
recipes.addShaped(moduleClimate, [[ingotBronze, powderBlaze, ingotBronze], [ingotBronze, goldChipset, ingotBronze], [ingotBronze, snowball, ingotBronze]]);

recipes.remove(tankMutagen);
recipes.addShaped(tankMutagen, [[ingotTin, ingotTin, ingotTin], [ingotTin, tank, ingotTin], [ingotTin, ingotTin, ingotTin]]);

recipes.remove(frameUpgrade);
recipes.addShaped(frameUpgrade, [[ingotTin, redstoneChipset, ingotTin], [redstoneChipset, goldChipset, redstoneChipset], [ingotTin, redstoneChipset, ingotTin]]);

//Keep this last.
print("Gendustry - BC Scripts Loaded.");
