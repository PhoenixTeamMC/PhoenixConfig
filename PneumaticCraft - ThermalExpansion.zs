//This script if for Minecraft version 1.7.10, and will not work in prior versions... probably
//Note these will require both PneumaticCraft and Thermal Expansion (obviously)
//but they also require Minetweaker AND Modtweaker.
//Created in the following versions. Probably works in later versions.
//Minetweaker version:3.0.8B
//Modtweaker version: 0.6-17
//This script doesn't change everything, and I may tweak it more in the future.
//Anyway, onto the code:

//Values
val CompressedIron = <PneumaticCraft:ingotIronCompressed>;
val ChamberWall = <PneumaticCraft:pressureChamberWall>;
val ChamberGlass = <PneumaticCraft:pressureChamberWall:6>;
val ChamberValve = <PneumaticCraft:pressureChamberValve>;
val AirCompressor = <PneumaticCraft:airCompressor>;
val Pipe = <PneumaticCraft:pressureTube>;
val Glass = <minecraft:glass>;
val Iron = <minecraft:iron_ingot>;
val RedstoneFurnace = <ThermalExpansion:Machine>;
val Pulverizer = <ThermalExpansion:Machine:1>;
val Sawmill = <ThermalExpansion:Machine:2>;
val Smelter = <ThermalExpansion:Machine:3>;
val MagmaCrucible = <ThermalExpansion:Machine:4>;
val FluidTransposer = <ThermalExpansion:Machine:5>;
val EnergeticInfuser = <ThermalExpansion:Machine:10>;
val MachineFrame = <ThermalExpansion:Frame>;
val PCB = <PneumaticCraft:printedCircuitBoard>;
val Furnace = <minecraft:furnace>;
val IronBlock = <minecraft:iron_block>;
val Redstone = <minecraft:redstone>;
val Steam = <liquid:steam>;
val Servo = <ThermalExpansion:material>;


//OreDict
val AnyFrame = <ore:thermalexpansion:machineFrame>;
val Plastic = <ore:Plastic>;
Plastic.add(<PneumaticCraft:plastic>);
Plastic.add(<PneumaticCraft:plastic:1>);
Plastic.add(<PneumaticCraft:plastic:2>);
Plastic.add(<PneumaticCraft:plastic:3>);
Plastic.add(<PneumaticCraft:plastic:4>);
Plastic.add(<PneumaticCraft:plastic:5>);
Plastic.add(<PneumaticCraft:plastic:6>);
Plastic.add(<PneumaticCraft:plastic:7>);
Plastic.add(<PneumaticCraft:plastic:8>);
Plastic.add(<PneumaticCraft:plastic:9>);
Plastic.add(<PneumaticCraft:plastic:10>);
Plastic.add(<PneumaticCraft:plastic:11>);
Plastic.add(<PneumaticCraft:plastic:12>);
Plastic.add(<PneumaticCraft:plastic:14>);
Plastic.add(<PneumaticCraft:plastic:15>);



//Remove Recipes
recipes.remove(ChamberWall);
recipes.remove(ChamberGlass);
recipes.remove(ChamberValve);
recipes.remove(Pipe);
recipes.remove(RedstoneFurnace);
recipes.remove(Pulverizer);
recipes.remove(Sawmill);
recipes.remove(Smelter);
recipes.remove(MagmaCrucible);
recipes.remove(FluidTransposer);
recipes.remove(EnergeticInfuser);
recipes.remove(MachineFrame);
recipes.remove(AirCompressor);
recipes.revome(Servo);



//Add crafting recipes
recipes.addShaped(Smelter,[[CompressedIron,Furnace,CompressedIron],[Redstone,IronBlock,Redstone],[<minecraft:gold_ingot>,Furnace,<minecraft:gold_ingot>]]);
recipes.addShaped(MagmaCrucible,[[<minecraft:lava_bucket>,<minecraft:lava_bucket>,<minecraft:lava_bucket>],[Redstone,IronBlock,Redstone],[CompressedIron,Redstone,CompressedIron]]);
recipes.addShaped(FluidTransposer,[[<minecraft:lava_bucket>,<minecraft:bucket>,<minecraft:water_bucket>],[Redstone,IronBlock,Redstone],[CompressedIron,Redstone,CompressedIron]]);
recipes.addShaped(EnergeticInfuser,[[Redstone,Plastic,Redstone],[Plastic,AnyFrame,Plastic],[Redstone,PCB,Redstone]]);
recipes.addShaped(Pipe * 6,[[CompressedIron,CompressedIron,CompressedIron],[Glass,Glass,Glass],[CompressedIron,CompressedIron,CompressedIron]]);
recipes.addShaped(Pulverizer,[[Plastic,<minecraft:diamond>,Plastic],[<ore:ingotTin>,AnyFrame,<ore:ingotTin>],[CompressedIron,Servo,CompressedIron]]);
recipes.addShaped(RedstoneFurnace,[[Plastic,Furnace,Plastic],[Plastic,AnyFrame,Plastic],[PCB,Servo,PCB]]);
recipes.addShaped(Sawmill,[[Plastic,<ThermalFoundation:material:136>,Plastic],[<ore:ingotCopper>,AnyFrame,<ore:ingotCopper>],[Servo,Redstone,Servo]]);

//Add Induction Smelter Recipes
mods.thermalexpansion.Smelter.addRecipe(2000, Iron, CompressedIron * 8, ChamberWall * 4, null, 10);
mods.thermalexpansion.Smelter.addRecipe(2000, Glass, CompressedIron * 8, ChamberGlass * 4, null, 10);
mods.thermalexpansion.Smelter.addRecipe(2000, Pipe, CompressedIron * 8, ChamberValve * 4, null, 10);


//Add Magma Crucible recipes
mods.thermalexpansion.Crucible.addRecipe(1000, <minecraft:water_bucket>, Steam * 450);
mods.thermalexpansion.Crucible.addRecipe(1000, <minecraft:potion>, Steam * 150);


//Add Fluid Transposer recipes
mods.thermalexpansion.Transposer.addFillRecipe(1000, Furnace, AirCompressor, Steam * 3000);


//Add Pressure Chamber recipes
mods.pneumaticcraft.Pressure.addRecipe([PCB*2, <PneumaticCraft:plastic:6>*4, Redstone*8, CompressedIron*2,Iron*2,<ThermalExpansion:material>*2], 2, [MachineFrame],true);


//Add Assembly Recipes
mods.pneumaticcraft.Assembly.addLaserRecipe(PCB, Servo);

