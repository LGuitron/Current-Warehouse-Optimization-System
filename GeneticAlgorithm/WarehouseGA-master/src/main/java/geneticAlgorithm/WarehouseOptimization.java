package geneticAlgorithm;

//Engine
import org.jenetics.engine.Engine;
import org.jenetics.engine.EvolutionResult;
import org.jenetics.engine.limit;

//Classes
import org.jenetics.util.Factory;
import org.jenetics.Genotype;
import org.jenetics.EnumGene;
import org.jenetics.Chromosome;
import org.jenetics.Optimize;

//Selectors, alterers, mutators & scalers
import org.jenetics.PartiallyMatchedCrossover;
import org.jenetics.Alterer;
import org.jenetics.SwapMutator;
import org.jenetics.ExponentialScaler;
import org.jenetics.ExponentialRankSelector;

//Other
import java.util.ArrayList;
import java.time.Duration;

public class WarehouseOptimization
{   
    //Final optimization percentages//
    public static double timeOptPercent;
    public static double distOptPercent; 


    private static double eval(Genotype<EnumGene<Integer>> genotype) 
    {   
        return GenotypeCost.stateCost(genotype, GenotypeCost.reserveProductMapping) + GenotypeCost.rearrangementCost(genotype);
    }
    
    /////////////////////////////////RETURN STATS (SINGLE EXECUTION)/////////////////////////////////////////////////////
    public static String generateSolution(float crossProbability, float mutateProbability, int generationSize, String whType, int longPeriodFactor, int shortPeriodFactor, double epsilon, float similarity)
    {            
        InputInfo.productZone = whType;
        InputInfo.predix();
        //EvolutionStatistics<Double, DoubleMomentStatistics> evolveStats =  EvolutionStatistics.ofNumber();                                         //Final Stats
        
        final Factory<Genotype<EnumGene<Integer>>> WHstatesFactory = Genotype.of(WarehouseChromosome.ofInteger(0,GenotypeCost.productZones,similarity));    //Create factory of genotypes//
        
        //Build and execute genetic algorithm with hyperparameters//
        Engine<EnumGene<Integer>, Double> engine = Engine.builder(WarehouseOptimization::eval, WHstatesFactory)
                                                  .populationSize(generationSize)
                                                   .alterers(new PartiallyMatchedCrossover<>(crossProbability), new SwapMutator<>(mutateProbability))
                                                   .survivorsSelector(new ExponentialRankSelector<>())
                                                   .optimize(Optimize.MINIMUM).build();
        
        //Limit to population convergence and a max execution time of 48 hours//
        Genotype<EnumGene<Integer>> result = engine.stream()
                                             .limit(limit.byExecutionTime(Duration.ofHours(48)))
                                             .limit(limit.byFitnessConvergence(shortPeriodFactor*GenotypeCost.productZones, 
                                             longPeriodFactor*GenotypeCost.productZones,epsilon))
                                             .collect(EvolutionResult.toBestGenotype());
                                              
        
        //Optimization percentage calculations//
        Genotype<EnumGene<Integer>> initialState = Genotype.of(WarehouseChromosome.ofInteger(0,GenotypeCost.productZones,1.0f));
        double initialCost = GenotypeCost.stateCost(initialState, GenotypeCost.productMapping) + GenotypeCost.rearrangementCost(initialState);
        double finalCost = GenotypeCost.stateCost(result, GenotypeCost.productMapping) + GenotypeCost.rearrangementCost(result);
        timeOptPercent = 100*(initialCost-finalCost)/initialCost;       //Time directly optimized
        
        double distCost = GenotypeCost.stateCostD(initialState, GenotypeCost.productMapping) + GenotypeCost.rearrangementCostD(initialState);
        double distFCost = GenotypeCost.stateCostD(result, GenotypeCost.productMapping) + GenotypeCost.rearrangementCostD(result);
        distOptPercent = 100*(distCost - distFCost)/distCost;           //Distance indirectly optimized
        
        //Only upload a solution if it is better than the initial state//
        if(timeOptPercent>0)
            JsonResults.upload(result);
            
        return "Result: " + result + "\n\n";
    }
}

