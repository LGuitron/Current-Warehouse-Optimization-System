package geneticAlgorithm;

import static java.lang.String.format;
import static org.jenetics.internal.util.bit.getAndSet;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlList;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.adapters.XmlAdapter;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

import org.jenetics.internal.math.base;
import org.jenetics.internal.util.Equality;
import org.jenetics.internal.util.Hash;
import org.jenetics.internal.util.array;
import org.jenetics.internal.util.bit;
import org.jenetics.internal.util.jaxb;
import org.jenetics.internal.util.require;

import org.jenetics.util.ISeq;
import org.jenetics.util.IntRange;
import org.jenetics.util.MSeq;
import org.jenetics.util.Seq;
import org.jenetics.EnumGene;
import org.jenetics.AbstractChromosome;
import org.jenetics.Gene;

import java.util.Random;

public final class WarehouseChromosome<T>
	extends AbstractChromosome<EnumGene<T>>
	implements Serializable
{

	private static final long serialVersionUID = 2L;

	private ISeq<T> _validAlleles;
    private float _minSimilarity;
	
	// Private primary constructor.
	private WarehouseChromosome(
		final ISeq<EnumGene<T>> genes,
		final Boolean valid
	) {
		super(genes);

		assert !genes.isEmpty();
		_validAlleles = genes.get(0).getValidAlleles();
		_valid = valid;
	}

	public WarehouseChromosome(final ISeq<EnumGene<T>> genes) {
		this(genes, null);
	}

	public ISeq<T> getValidAlleles() {
		return _validAlleles;
	}

	@Override
	public boolean isValid() {
		if (_valid == null) {
			final byte[] check = bit.newArray(_validAlleles.length());
			_valid = _genes.forAll(g -> !getAndSet(check, g.getAlleleIndex()));
		}

		return _valid;
	}

	@Override
	public WarehouseChromosome<T> newInstance() {
		return of(_validAlleles, length(), _minSimilarity);
	}

	@Override
	public WarehouseChromosome<T> newInstance(final ISeq<EnumGene<T>> genes) {
		return new WarehouseChromosome<>(genes);
	}

	@Override
	public int hashCode() {
		return Hash.of(getClass())
				.and(super.hashCode())
				.value();
	}

	@Override
	public boolean equals(final Object obj) {
		return Equality.of(this, obj).test(super::equals);
	}

	@Override
	public String toString() {
		return _genes.asList().stream()
			.map(g -> g.getAllele().toString())
			.collect(Collectors.joining("|"));
	}

	//////////////////////Main generation function//////////////////////////
	public static <T> WarehouseChromosome<T> of(
		final ISeq<? extends T> alleles,
		final int length, final float minSimilarity
	) {
		require.positive(length);
		if (length > alleles.size()) {
			throw new IllegalArgumentException(format(
				"The sub-set size must be be greater then the base-set: %d > %d",
				length, alleles.size()
			));
		}
        
        //Generate ordered chromosome//
		final int[] subset = new int[length];     
		for(int i=0;i<length;i++)
            subset[i]=i;
		
		Random random = new Random();
		float similarity = minSimilarity + (1.0f-minSimilarity)*random.nextFloat();     //Random similarity between minSimilarity and 1
        int swapAmount = (int)(length*(1.0f-similarity)/2.0f); 
        boolean[] swapped = new boolean[length];
        
		//Swap genes until similarity value is achieved//
		int swapCount = 0;
		
		//If 7 attempts are failed consecutively end the loop//
		int consFailedAttempts = 0;
		while(swapCount<swapAmount)
		{
            int index1 = random.nextInt(length);
            int index2 = random.nextInt(length);
            
            //Swap if both elements are unswapped and have different products//
            if(!swapped[index1] && !swapped[index2] &&  GenotypeCost.productMapping[index1]!=GenotypeCost.productMapping[index2])
            {
                swap(subset,index1,index2);
                swapped[index1]=true;
                swapped[index2]=true;
                swapCount++;
                consFailedAttempts = 0;
            }
            else
            {
                consFailedAttempts++;
                if(consFailedAttempts==7)
                    break;
            }
		}
        final ISeq<EnumGene<T>> genes = IntStream.of(subset)
			.mapToObj(i -> EnumGene.<T>of(i, alleles))
			.collect(ISeq.toISeq());
		
		return new WarehouseChromosome<>(genes, true);
	}
    ////////////////////////////////////////////////////////////////////////

	public static WarehouseChromosome<Integer>
	ofInteger(final int start, final int end, final float minSimilarity) {
		if (end <= start) {
			throw new IllegalArgumentException(format(
				"end <= start: %d <= %d", end, start
			));
		}

		return ofInteger(IntRange.of(start, end), end - start, minSimilarity);
	}

	public static WarehouseChromosome<Integer>
	ofInteger(final IntRange range, final int length, final float minSimilarity) {
		return of(
			range.stream()
				.mapToObj(i -> i)
				.collect(ISeq.toISeq()),
			length, minSimilarity
		);
	}

	/* *************************************************************************
	 *  Java object serialization
	 * ************************************************************************/

	private void writeObject(final ObjectOutputStream out)
		throws IOException
	{
		out.defaultWriteObject();

		out.writeObject(_validAlleles);
		for (EnumGene<?> gene : _genes) {
			out.writeInt(gene.getAlleleIndex());
		}
	}
	
	///////////////////////////////////////OTHER FUNCTIONS///////////////////////////////////
	private static void swap(int[] arr, int a, int b)
	{
        int temp = arr[a];
        arr[a] = arr[b];
        arr[b] = temp;
	}
}
