# *How costly is sex-biased dispersal?*
*Roger Shaw*  
*31 Aug 2015*

This description follows the ODD (Overview, Design concepts, and Details) protocol [1][1]

Full model explanation published in Shaw 2016 (not yet available online, permalink added when possible).

### Purpose

Most ecological theory assumes that all individuals are identical, or that their differences average out. However, this assumption is clearly violated in many or even most ecological systems, and the consequences of considering these differences remain largely unexplored. One particularly common form of variation between individuals are sex differences, and one ecologically important example of this could be sex-biased dispersal, in which males and females differ in their dispersal behavior. While sex-biased dispersal is extremely common in nature, and the theory behind its prevalence is relatively well-understood, the ecological consequences of this process have not been well-studied.

This model was designed to explore the ecological consequences of sex-biased dispersal, particularly in changing environments. How do these sex differences affect the persistence of populations over time?

### Entities, state variables, and scales

There will be two kinds of entities in this model: individuals, and patches of land which form a heterogeneous, discrete environment. Each patch of land has a suitability-score assigned to it. Each individual is either a male or female, possesses a health value. Each butterfly also has a location, which is the patch they are currently on.

Patch size and the length of one time step are not explicitly specified. Simulations will run until the entire population goes extinct.

### Process overview and scheduling

At each time step, butterflies will disperse to a different patch, at a distance drawn from a dispersal kernel for their sex. Once the dispersal phase has completed, individuals lose health if they are located in an unsuitable patch, and individuals with a health value less than zero then die, and are removed from the model.

If individuals of both sexes are present in a suitable patch, then randomly-mated pairs will produce offspring, who will each be randomly assigned a sex. Clutch sizes are density-dependent, to prevent exponential growth.

The above process of dispersal, selection, and reproduction repeats in each timestep.

At a set interval, randomly-chosen patches will change in suitability. The magnitude of this change, and the exact number of patches that will change at each step, can be varied. This strongly affects the selection process described above, and therefore the persistence of the whole population in the landscape.

### Design concepts

The *basic principle* behind this model is that sex-biased dispersal affects the opportunities for reproduction in different patches in a landscape. This is hypothesized to differ from systems in which dispersal is equal across all individuals, regardless of sex. These effects may be particularly evident when environments change, as previous strongholds for the population may be disrupted, with most survivors being of the more dispersive sex.

Though passive natural selection occurs on the traits of individuals, this does not influence the behavior of the individuals. There is no active *adaptation, learning, or sensing* involved in the model. Natural selection should produce similar results to those processes, but with simpler mechanics.

The only *interaction* between individuals is reproduction, which produces new individuals. There is no competition for resources in this model.

*Stochasticity* plays a large role in the model. It determines the initial locations of individuals, and the makeup of the entire landscape. Once the simulation is running, environmental change is forced on a random selection of patches.

Finally, the required *observations* for producing the model's results will come from plotting population size over time. The average population persistence time will be tracked.

### Initialization

The suitability-score of each patch is randomly determined. Individuals are distributed randomly across the landscape, and their sex is also determined randomly.

### Input Data

There is no input data that is read into the model while it runs.

### Submodels

The spread of the dispersal kernels for the two sexes are varied. This was hypothesized to affect the ability of individuals to find mating partners, and to furthermore find them in suitable patches. Differences between the dispersal kernels of the two sexes constitutes sex-biased dispersal, while equal dispersal occurs when their kernels are identical. All variables were held constant except for these dispersal kernels, and the affects on population persistence were measured.

In addition, a few further variables were measured, in order to offer some possible enlightenment into mechanisms. The sex ratio of each patch, the proportion of suitable patches that were occupied, and the proportion of unmated individuals of the population were all tracked, and a pseudo-equilibrium value was calculated and reported.

This protocol describes much of the workings of this model, but curious readers are welcome to explore the code of the model. A manuscript describing the results is also in prep.

[1]:	http://www.sciencedirect.com/science/article/pii/S0304380006002043 "A standard protocol for describing individual-based and agent-based models"