# *ODD Protocols*
*Roger Shaw*  
*23 Feb 2014*

***
# Sex-biased dispersal and population persistence in changing landscapes


### Purpose

Most ecological theory assumes that all individuals are identical, or that their differences average out. However, this assumption is clearly violated in many or even most ecological systems, and the consequences of considering these differences remain largely unexplored. One particularly common form of variation between individuals are sex differences, and one ecologically important example of this could be sex-biased dispersal, in which males and females differ in their dispersal behavior. While sex-biased dispersal is extremely common in nature, and the theory behind its repeated evolution is relatively well-understood, the ecological consequences of this process have not been well-studied.

This model was designed to explore the ecological consequences of sex-biased dispersal, particularly in changing environments. How do these sex differences affect the persistence of populations over time? If environments change, how do these sex differences affect the ability of population to recover?

###Entities, state variables, and scales

There will be two kinds of entities in this model: butterflies, and patches of land which form a heterogeneous, discrete environment. Each patch of land has an environmental value assigned to it, which I will arbitrary call ‘rainfall’. Each butterfly is either a male or female, possesses a ‘health’ value, and also a trait value which I will arbitrary call ‘nectar-need’. Each butterfly also has a location, which is the patch they are currently on.

Patch size and the length of one time step are not specified. Simulations will run until the population dynamics have stabilized. Trial runs may later be used to set a fixed simulation length.

###Process overview and scheduling

At each time step, butterflies will disperse to a different patch, at a distance according to their sex (whether it is males or females that disperse further will be the subject of sub-models). Once the dispersal phase has completed, natural selection will occur, in that the nectar-need of each butterfly will be compared with the rainfall of the patch they are in. If this difference lies outside of an acceptable limit, the butterfly will lose health, otherwise health will remain stable.

If individuals of both sexes are present in a patch, then randomly-mated pairs will produce 10 offspring, who will each be randomly assigned a sex, and whose nectar-need will be drawn randomly from within a range set by its parents' trait values. Rare mutations may occur to produce individuals with extreme trait values, in order to prevent the population from converging upon a mean trait value.

The above process of dispersal, selection, and reproduction repeats in each timestep.

A small number of randomly-chosen patches will change in rainfall at the beginning of each timestep. The magnitude of this change, and the exact number of patches that will change at each step, will be varied. This strongly affects the selection process described above, and therefore the persistence of the whole population in the landscape.

###Design concepts

The *basic principle* behind this model is that sex-biased dispersal affects the opportunities for reproduction in different patches in a landscape. It also affects the mixing of traits within and across these patches. Both of these are hypothesized to differ from systems in which dispersal is equal across all individuals, regardless of sex. These effects may be particularly evident when environments change, as previous strongholds for the population may be disrupted, with most survivors being of the more dispersive sex.

But how would these sub-models differ? *Emergently*, these processes would affect populations' ability to bounce back from environmental change, and their long-term stability and resilience.

Though passive natural selection occurs on the traits of individuals, this does not influence the behavior of the individuals. There is no active *adaptation, learning, or sensing* involved in the model. Natural selection should produce similar results to those processes, but with simpler mechanics.

The only *interaction* between individuals is reproduction, which produces new individuals with intermediate traits. There is no competition for resources in this model.

*Stochasticity* plays a large role in the model. It determines the initial traits and locations of individuals, and the makeup of the entire landscape. Once the simulation is running, environmental change is forced on a random selection of patches. The traits of butterfly offspring are randomly determined, though within the bounds of their parents' traits. Rare mutational events may be required, in order to maintain high genetic variation.

Finally, the required *observations* for producing the model's results will come from plotting population size over time. The average population persistence time will be tracked.

###Initialization

###Input Data

###Submodels
