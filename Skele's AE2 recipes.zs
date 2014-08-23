//This MineTweaker/ModTweaker file was made using MineFactory Reloaded, Redstone Arsenal, Thermal Expansion, Applied Energistics 2, Mekanism, and Tinkers Construct

//new meteorite compass recipe
recipes.remove(<appliedenergistics2:tile.BlockSkyCompass>);
recipes.addShaped(<appliedenergistics2:tile.BlockSkyCompass>,
 [[<ThermalFoundation:material:71>, <ThermalExpansion:material:1>, <ThermalFoundation:material:71>],
  [<appliedenergistics2:item.ItemMultiMaterial>, <minecraft:compass>, <appliedenergistics2:item.ItemMultiMaterial>],
  [<ThermalFoundation:material:71>, <ThermalExpansion:material:1>, <ThermalFoundation:material:71>]]);

//new Quartz Glass recipe
recipes.remove(<appliedenergistics2:tile.BlockQuartzGlass>);
mods.mekanism.Infuser.addRecipe("OBSIDIAN", 200, <appliedenergistics2:item.ItemMultiMaterial> * 3, <appliedenergistics2:tile.BlockQuartzGlass> * 4);

//new Charger recipe
recipes.remove(<appliedenergistics2:tile.BlockCharger>);
recipes.addShaped(<appliedenergistics2:tile.BlockCharger>,
 [[<Mekanism:Ingot:4>, <appliedenergistics2:item.ItemMultiMaterial:12>, <ThermalFoundation:material:71>],
  [<Mekanism:ControlCircuit:1>, <ThermalExpansion:material:3>, null],
  [<Mekanism:Ingot:4>, <appliedenergistics2:item.ItemMultiMaterial:12>, <ThermalFoundation:material:71>]]);
  
//new Growth Accelerator Recipe
recipes.remove(<appliedenergistics2:tile.BlockQuartzGrowthAccelerator>);
recipes.addShaped(<appliedenergistics2:tile.BlockQuartzGrowthAccelerator>,
 [[<TConstruct:materials:15>, <ThermalExpansion:material:515>, <TConstruct:materials:15>],
  [<appliedenergistics2:item.ItemMultiMaterial:12>, <ThermalExpansion:Frame:7>, <appliedenergistics2:item.ItemMultiMaterial:12>],
  [<TConstruct:materials:15>, <ThermalExpansion:material:515>, <TConstruct:materials:15>]]);

//new Grinder Recipe
recipes.remove(<appliedenergistics2:tile.BlockGrinder>);
recipes.addShaped(<appliedenergistics2:tile.BlockGrinder>,
 [[<ThermalFoundation:material:136>, null, <ThermalFoundation:material:136>],
  [<appliedenergistics2:item.ItemMultiMaterial>, <MineFactoryReloaded:tile.mfr.machineblock>, <appliedenergistics2:item.ItemMultiMaterial>],
  [<MineFactoryReloaded:item.mfr.plastic.sheet>, <ThermalExpansion:material>, <MineFactoryReloaded:item.mfr.plastic.sheet>]]);
  
//new Incriber Recipe
recipes.remove(<appliedenergistics2:tile.BlockInscriber>);
recipes.addShaped(<appliedenergistics2:tile.BlockInscriber>,
 [[<ThermalFoundation:material:138>, <ThermalExpansion:material:2>, <Mekanism:Ingot:4>],
  [<MineFactoryReloaded:item.mfr.plastic.sheet>, <ThermalExpansion:material>, <Mekanism:ControlCircuit:2>],
  [<ThermalFoundation:material:138>, <ThermalExpansion:material:2>, <Mekanism:Ingot:4>]]);

//new Wireless Access Point Recipe
recipes.remove(<appliedenergistics2:tile.BlockWireless>);
recipes.addShaped(<appliedenergistics2:tile.BlockWireless>,
 [[<ThermalExpansion:material:1>, <appliedenergistics2:item.ItemMultiMaterial:41>, <ThermalExpansion:material:1>],
  [<appliedenergistics2:item.ItemMultiMaterial:23>, <appliedenergistics2:item.ItemMultiPart:56>, <appliedenergistics2:item.ItemMultiMaterial:23>],
  [<appliedenergistics2:tile.BlockSkyStone:1>, <Mekanism:TeleportationCore>, <appliedenergistics2:tile.BlockSkyStone:1>]]);
  
//new Quantum Ring Recipe
recipes.remove(<appliedenergistics2:tile.BlockQuantumRing>);
recipes.addShaped(<appliedenergistics2:tile.BlockQuantumRing>,
 [[<appliedenergistics2:item.ItemMultiMaterial:9>, <ThermalExpansion:Glass>, <appliedenergistics2:item.ItemMultiMaterial:9>],
  [<ThermalExpansion:Glass>, <ThermalExpansion:Frame:3>, <ThermalExpansion:Glass>],
  [<appliedenergistics2:item.ItemMultiMaterial:9>, <ThermalExpansion:Glass>, <appliedenergistics2:item.ItemMultiMaterial:9>]]);
  
//new Quantum Link Chamber Recipe
recipes.remove(<appliedenergistics2:tile.BlockQuantumLinkChamber>);
recipes.addShaped(<appliedenergistics2:tile.BlockQuantumLinkChamber>,
 [[<Mekanism:TeleportationCore>, <appliedenergistics2:tile.BlockQuartzGlass>, <Mekanism:TeleportationCore>],
  [<appliedenergistics2:tile.BlockQuartzGlass>, <ThermalExpansion:Frame:8>, <appliedenergistics2:tile.BlockQuartzGlass>],
  [<Mekanism:TeleportationCore>, <appliedenergistics2:tile.BlockQuartzGlass>, <Mekanism:TeleportationCore>]]);
  
//new Spactial Pylon Recipe
recipes.remove(<appliedenergistics2:tile.BlockSpatialPylon>);
recipes.addShaped(<appliedenergistics2:tile.BlockSpatialPylon>,
 [[<appliedenergistics2:tile.BlockQuartzGlass>, <appliedenergistics2:item.ItemMultiMaterial:32>, <appliedenergistics2:tile.BlockQuartzGlass>],
  [<appliedenergistics2:item.ItemMultiMaterial:32>, <ThermalExpansion:Frame:5>, <appliedenergistics2:item.ItemMultiMaterial:32>],
  [<appliedenergistics2:tile.BlockQuartzGlass>, <appliedenergistics2:item.ItemMultiMaterial:32>, <appliedenergistics2:tile.BlockQuartzGlass>]]);

//new Me Controller Recipe
recipes.remove(<appliedenergistics2:tile.BlockController>);
recipes.addShaped(<appliedenergistics2:tile.BlockController>,
 [[<appliedenergistics2:tile.BlockSkyStone:1>, <ThermalExpansion:material:1>, <appliedenergistics2:tile.BlockSkyStone:1>],
  [<appliedenergistics2:item.ItemMultiPart:76>, <Mekanism:ControlCircuit:3>, <appliedenergistics2:item.ItemMultiPart:76>],
  [<appliedenergistics2:tile.BlockSkyStone:1>, <ThermalExpansion:material:2>, <appliedenergistics2:tile.BlockSkyStone:1>]]);
  
//new Drive Recipe
recipes.remove(<appliedenergistics2:tile.BlockDrive>);
recipes.addShaped(<appliedenergistics2:tile.BlockDrive>,
 [[<appliedenergistics2:tile.BlockQuartz>, <appliedenergistics2:item.ItemMultiPart:56>, <appliedenergistics2:item.ItemMultiMaterial:9>],
  [<appliedenergistics2:item.ItemMultiMaterial:35>, <ThermalExpansion:Cache:3>, <appliedenergistics2:item.ItemMultiMaterial:35>],
  [<appliedenergistics2:item.ItemMultiMaterial:9>, <appliedenergistics2:item.ItemMultiPart:56>, <appliedenergistics2:tile.BlockQuartz>]]);
  
//new Me Chest Recipe
recipes.remove(<appliedenergistics2:tile.BlockChest>);
recipes.addShaped(<appliedenergistics2:tile.BlockChest>,
 [[<ThermalFoundation:material:71>, <appliedenergistics2:item.ItemMultiPart:380>, <ThermalFoundation:material:71>],
  [<appliedenergistics2:item.ItemMultiPart:36>, <ThermalExpansion:Strongbox:3>, <appliedenergistics2:item.ItemMultiPart:36>],
  [<ThermalFoundation:material:69>, <appliedenergistics2:item.ItemMultiMaterial:12>, <ThermalFoundation:material:69>]]);

//new Me Interface Recipe
recipes.remove(<appliedenergistics2:tile.BlockInterface>);
recipes.addShaped(<appliedenergistics2:tile.BlockInterface>,
 [[<Mekanism:Ingot:4>, <appliedenergistics2:tile.BlockQuartzGlass>, <Mekanism:Ingot:4>],
  [<appliedenergistics2:item.ItemMultiMaterial:43>, <appliedenergistics2:item.ItemMultiMaterial:35>, <appliedenergistics2:item.ItemMultiMaterial:44>],
  [<Mekanism:Ingot:4>, <appliedenergistics2:tile.BlockQuartzGlass>, <Mekanism:Ingot:4>]]);
  
//new Cell Workbench Recipe
recipes.remove(<appliedenergistics2:tile.BlockCellWorkbench>);
recipes.addShaped(<appliedenergistics2:tile.BlockCellWorkbench>,
 [[<MineFactoryReloaded:item.mfr.plastic.sheet>, <appliedenergistics2:item.ItemMultiMaterial:23>, <MineFactoryReloaded:item.mfr.plastic.sheet>],
  [<TConstruct:materials:3>, <Mekanism:MachineBlock:13>, <TConstruct:materials:3>],
  [<TConstruct:materials:3>, <TConstruct:materials:3>, <TConstruct:materials:3>]]);
  
//new Dense Cable Recipe
recipes.remove(<appliedenergistics2:item.ItemMultiPart:76>);
recipes.addShaped(<appliedenergistics2:item.ItemMultiPart:76>,
 [[<minecraft:glowstone_dust>, <appliedenergistics2:item.ItemMultiPart:56>, <minecraft:redstone>],
  [<appliedenergistics2:item.ItemMultiPart:56>, <appliedenergistics2:item.ItemMultiMaterial:1>, <appliedenergistics2:item.ItemMultiPart:56>],
  [<minecraft:redstone>, <appliedenergistics2:item.ItemMultiPart:56>, <minecraft:glowstone_dust>]]);
  
//new Matter Considerer Recipe
recipes.remove(<appliedenergistics2:tile.BlockCondenser>);
recipes.addShaped(<appliedenergistics2:tile.BlockCondenser>,
 [[<TConstruct:materials:15>, <ThermalExpansion:Glass>, <TConstruct:materials:15>],
  [<ThermalExpansion:Glass>, <appliedenergistics2:item.ItemMultiMaterial:9>, <ThermalExpansion:Glass>],
  [<TConstruct:materials:15>, <ThermalExpansion:Glass>, <TConstruct:materials:15>]]);
  
//new Energy Cell Recipe
recipes.remove(<appliedenergistics2:tile.BlockEnergyCell>);
recipes.addShaped(<appliedenergistics2:tile.BlockEnergyCell>,
 [[<ThermalFoundation:material:71>, <RedstoneArsenal:material:64>, <ThermalFoundation:material:71>],
  [<RedstoneArsenal:material:64>, <ThermalExpansion:Frame:4>, <RedstoneArsenal:material:64>],
  [<ThermalFoundation:material:71>, <RedstoneArsenal:material:64>, <ThermalFoundation:material:71>]]);
  
//new Security Terminal Recipe
recipes.remove(<appliedenergistics2:tile.BlockSecurity>);
recipes.addShaped(<appliedenergistics2:tile.BlockSecurity>,
 [[<ThermalExpansion:material:16>, <appliedenergistics2:tile.BlockChest>, <ThermalExpansion:material:16>],
  [<appliedenergistics2:item.ItemMultiPart:56>, <appliedenergistics2:item.ItemMultiMaterial:38>, <appliedenergistics2:item.ItemMultiPart:56>],
  [<Mekanism:Ingot:4>, <appliedenergistics2:item.ItemMultiMaterial:24>, <Mekanism:Ingot:4>]]);
  
//new Glass Cable Recipe
recipes.remove(<appliedenergistics2:item.ItemMultiPart:16>);
recipes.addShaped(<appliedenergistics2:item.ItemMultiPart:16> * 5,
 [[<appliedenergistics2:tile.BlockQuartzGlass>, <MineFactoryReloaded:item.mfr.plastic.sheet>, <appliedenergistics2:tile.BlockQuartzGlass>],
  [<appliedenergistics2:item.ItemMultiMaterial:7>, <appliedenergistics2:item.ItemMultiPart:140>, <appliedenergistics2:item.ItemMultiMaterial:7>],
  [<appliedenergistics2:tile.BlockQuartzGlass>, <MineFactoryReloaded:item.mfr.plastic.sheet>, <appliedenergistics2:tile.BlockQuartzGlass>]]);
  
recipes.addShaped(<appliedenergistics2:item.ItemMultiPart:16> * 5,
 [[<appliedenergistics2:tile.BlockQuartzGlass>, <MineFactoryReloaded:item.mfr.plastic.sheet>, <appliedenergistics2:tile.BlockQuartzGlass>],
  [<appliedenergistics2:item.ItemMultiMaterial:12>, <appliedenergistics2:item.ItemMultiPart:140>, <appliedenergistics2:item.ItemMultiMaterial:12>],
  [<appliedenergistics2:tile.BlockQuartzGlass>, <MineFactoryReloaded:item.mfr.plastic.sheet>, <appliedenergistics2:tile.BlockQuartzGlass>]]);
  
//new Covered Cable Recipe
recipes.remove(<appliedenergistics2:item.ItemMultiPart:36>);
recipes.addShaped(<appliedenergistics2:item.ItemMultiPart:36>,
 [[<MineFactoryReloaded:item.mfr.plastic.sheet>, <MineFactoryReloaded:item.mfr.plastic.sheet>, <MineFactoryReloaded:item.mfr.plastic.sheet>],
  [<MineFactoryReloaded:item.mfr.plastic.sheet>, <appliedenergistics2:item.ItemMultiPart:16>, <MineFactoryReloaded:item.mfr.plastic.sheet>],
  [<MineFactoryReloaded:item.mfr.plastic.sheet>, <MineFactoryReloaded:item.mfr.plastic.sheet>, <MineFactoryReloaded:item.mfr.plastic.sheet>]]);
  
//new Smart Cable Recipe
recipes.remove(<appliedenergistics2:item.ItemMultiPart:56>);
recipes.addShaped(<appliedenergistics2:item.ItemMultiPart:56> * 3,
 [[<Mekanism:Ingot:3>, <minecraft:redstone>, <Mekanism:Ingot:3>],
  [<appliedenergistics2:item.ItemMultiPart:36>, <appliedenergistics2:item.ItemMultiPart:36>, <appliedenergistics2:item.ItemMultiPart:36>],
  [<Mekanism:Ingot:3>, <minecraft:redstone>, <Mekanism:Ingot:3>]]);

//new 1K Storage Recipe
recipes.remove(<appliedenergistics2:item.ItemBasicStorageCell.1k>);
recipes.addShaped(<appliedenergistics2:item.ItemBasicStorageCell.1k>,
 [[<appliedenergistics2:tile.BlockQuartzGlass>, <minecraft:redstone>, <appliedenergistics2:tile.BlockQuartzGlass>],
  [<minecraft:redstone>, <appliedenergistics2:item.ItemMultiMaterial:35>, <minecraft:redstone>],
  [<Mekanism:Ingot:4>, <Mekanism:Ingot:4>, <Mekanism:Ingot:4>]]);
  
//new 4K Storage Recipe
recipes.remove(<appliedenergistics2:item.ItemBasicStorageCell.4k>);
recipes.addShaped(<appliedenergistics2:item.ItemBasicStorageCell.4k>,
 [[<appliedenergistics2:tile.BlockQuartzGlass>, <minecraft:glowstone_dust>, <appliedenergistics2:tile.BlockQuartzGlass>],
  [<minecraft:glowstone_dust>, <appliedenergistics2:item.ItemMultiMaterial:36>, <minecraft:glowstone_dust>],
  [<TConstruct:materials:15>, <TConstruct:materials:15>, <TConstruct:materials:15>]]);
  
//new 16K Storage Recipe
recipes.remove(<appliedenergistics2:item.ItemBasicStorageCell.16k>);
recipes.addShaped(<appliedenergistics2:item.ItemBasicStorageCell.16k>,
 [[<appliedenergistics2:tile.BlockQuartzGlass>, <appliedenergistics2:item.ItemMultiMaterial:8>, <appliedenergistics2:tile.BlockQuartzGlass>],
  [<appliedenergistics2:item.ItemMultiMaterial:8>, <appliedenergistics2:item.ItemMultiMaterial:37>, <appliedenergistics2:item.ItemMultiMaterial:8>],
  [<Mekanism:Ingot>, <Mekanism:Ingot>, <Mekanism:Ingot>]]);
  
//new 64K Storage Recipe
recipes.remove(<appliedenergistics2:item.ItemBasicStorageCell.64k>);
recipes.addShaped(<appliedenergistics2:item.ItemBasicStorageCell.64k>,
 [[<appliedenergistics2:tile.BlockQuartzGlass>, <RedstoneArsenal:material>, <appliedenergistics2:tile.BlockQuartzGlass>],
  [<RedstoneArsenal:material>, <appliedenergistics2:item.ItemMultiMaterial:38>, <RedstoneArsenal:material>],
  [<ThermalFoundation:material:76>, <ThermalFoundation:material:76>, <ThermalFoundation:material:76>]]);
  
  //new 2^3 Spacial Recipe
recipes.remove(<appliedenergistics2:item.ItemSpatialStorageCell.2Cubed>);
recipes.addShaped(<appliedenergistics2:item.ItemSpatialStorageCell.2Cubed>,
 [[<appliedenergistics2:tile.BlockQuartzGlass>, <minecraft:glowstone_dust>, <appliedenergistics2:tile.BlockQuartzGlass>],
  [<minecraft:glowstone_dust>, <appliedenergistics2:item.ItemMultiMaterial:32>, <minecraft:glowstone_dust>],
  [<TConstruct:materials:15>, <TConstruct:materials:15>, <TConstruct:materials:15>]]);
  
//new 16^3 Spacial Recipe
recipes.remove(<appliedenergistics2:item.ItemSpatialStorageCell.16Cubed>);
recipes.addShaped(<appliedenergistics2:item.ItemSpatialStorageCell.16Cubed>,
 [[<appliedenergistics2:tile.BlockQuartzGlass>, <appliedenergistics2:item.ItemMultiMaterial:8>, <appliedenergistics2:tile.BlockQuartzGlass>],
  [<appliedenergistics2:item.ItemMultiMaterial:8>, <appliedenergistics2:item.ItemMultiMaterial:33>, <appliedenergistics2:item.ItemMultiMaterial:8>],
  [<Mekanism:Ingot>, <Mekanism:Ingot>, <Mekanism:Ingot>]]);
  
//new 128^3 Spacial Recipe
recipes.remove(<appliedenergistics2:item.ItemSpatialStorageCell.128Cubed>);
recipes.addShaped(<appliedenergistics2:item.ItemSpatialStorageCell.128Cubed>,
 [[<appliedenergistics2:tile.BlockQuartzGlass>, <RedstoneArsenal:material>, <appliedenergistics2:tile.BlockQuartzGlass>],
  [<RedstoneArsenal:material>, <appliedenergistics2:item.ItemMultiMaterial:34>, <RedstoneArsenal:material>],
  [<ThermalFoundation:material:76>, <ThermalFoundation:material:76>, <ThermalFoundation:material:76>]]);
