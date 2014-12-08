print(<EnderIO:itemAlloy:4>.displayName); // prints the original name
<EnderIO:itemAlloy:4>.displayName = "Condium";

val enderConduit = <EnderIO:itemPowerConduit:2>;
val conduitBinder = <EnderIO:itemMaterial:1>;
val enderium = <ThermalFoundation:material:76>;

recipes.remove(enderConduit);

recipes.addShaped(enderConduit,[[conduitBinder, conduitBinder, conduitBinder], [enderium, enderium, enderium], [conduitBinder, conduitBinder, conduitBinder]]);